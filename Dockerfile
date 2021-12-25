ARG GO_VERSION=1.17

FROM --platform=$BUILDPLATFORM crazymax/goreleaser-xx:edge AS goreleaser-xx
FROM --platform=$BUILDPLATFORM pratikimprowise/upx AS upx
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine AS base
COPY --from=goreleaser-xx / /
COPY --from=upx / /
RUN apk --update add --no-cache git bash gcc musl-dev
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

FROM vendored AS trim
ARG TARGETPLATFORM
# XX_CC_PREFER_STATIC_LINKER prefers ld to lld in ppc64le and 386.
ENV XX_CC_PREFER_STATIC_LINKER=1
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
    --name="tarrer-trim"

FROM vendored AS slim
ARG TARGETPLATFORM
# XX_CC_PREFER_STATIC_LINKER prefers ld to lld in ppc64le and 386.
ENV XX_CC_PREFER_STATIC_LINKER=1
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
    --name="tarrer-slim" \
    --post-hooks="sh -cx 'upx --ultra-brute --best /usr/local/bin/tarrer-slim || true'"

FROM scratch AS artifact
COPY --from=build /out /
COPY --from=trim /out /
COPY --from=slim /out /
