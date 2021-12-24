ARG GO_VERSION=1.17

FROM --platform=$BUILDPLATFORM crazymax/goreleaser-xx:edge AS goreleaser-xx
FROM --platform=$BUILDPLATFORM pratikimprowise/upx AS upx
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine AS base
COPY --from=goreleaser-xx / /
COPY --from=upx / /
RUN apk --update add --no-cache git bash
WORKDIR /src

FROM base AS vendored
RUN --mount=type=bind,target=.,rw \
  --mount=type=cache,target=/go/pkg/mod \
  go mod tidy && go mod download

FROM vendored AS build
ARG TARGETPLATFORM
RUN --mount=type=bind,source=.,target=/src,rw \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/go/pkg/mod \
  goreleaser-xx --debug \
    --name "tarrer" \
    --dist "/out" \
    --artifacts="bin" \
    --artifacts="archive" \
    --snapshot="no" \
    --main="."

FROM vendored AS slim
ARG TARGETPLATFORM
RUN --mount=type=bind,source=.,target=/src,rw \
  --mount=type=cache,target=/root/.cache \
  --mount=type=cache,target=/go/pkg/mod \
  goreleaser-xx --debug \
    --main="." \
    --dist="/out" \
    --snapshot="no" \
    --artifacts="bin" \
    --artifacts="archive" \
    --ldflags="-s -w" \
    --flags="-trimpath" \
    --name="tarrer_slim" \
    --post-hooks="sh -cx 'upx --ultra-brute --best /usr/local/bin/tarrer_slim || true'"

FROM scratch AS artifact
COPY --from=build /out /
COPY --from=slim /out /
