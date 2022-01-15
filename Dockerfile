ARG GO_VERSION=1.17

FROM --platform=$BUILDPLATFORM crazymax/goreleaser-xx:latest AS goreleaser-xx
FROM --platform=$BUILDPLATFORM pratikimprowise/upx:3.96 AS upx
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine AS base
COPY --from=goreleaser-xx / /
COPY --from=upx / /
ENV CGO_ENABLED=0
ENV GO111MODULE=auto
RUN apk --update add --no-cache git bash gcc musl-dev
WORKDIR /src

FROM base AS vendored
RUN --mount=type=bind,target=.,rw \
  --mount=type=cache,target=/go/pkg/mod \
  go mod tidy && go mod download

FROM vendored AS bin
ARG TARGETPLATFORM
RUN --mount=type=bind,source=.,target=/src,rw \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/go/pkg/mod \
  goreleaser-xx --debug \
    --name="tarrer" \
    --main="." \
    --dist="/out" \
    --artifacts="bin" \
    --artifacts="archive" \
    --snapshot="no"

FROM scratch as fat
COPY --from=bin /usr/local/bin/tarrer /usr/local/bin/tarrer
ENTRYPOINT ["/usr/local/bin/tarrer"]

FROM vendored AS bin-slim
ARG TARGETPLATFORM
RUN --mount=type=bind,source=.,target=/src,rw \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/go/pkg/mod \
  goreleaser-xx --debug \
    --name="tarrer-slim" \
    --ldflags="-s -w" \
    --flags="-trimpath" \
    --main="." \
    --dist="/out" \
    --artifacts="bin" \
    --artifacts="archive" \
    --snapshot="no" \
    --post-hooks="sh -c 'upx -v --ultra-brute --best -o /usr/local/bin/{{ .ProjectName }}{{ .Ext }} || true' "

FROM scratch as slim
COPY --from=bin-slim /usr/local/bin/tarrer-slim /usr/local/bin/tarrer
ENTRYPOINT ["/usr/local/bin/tarrer"]

## get binary out
### non slim binary
FROM scratch AS artifact
COPY --from=bin /out /
###

### slim binary
FROM scratch AS artifact-slim
COPY --from=bin-slim /out /
###

### All binaries
FROM scratch AS artifact-all
COPY --from=bin /out /
COPY --from=bin-slim /out /
###
##
