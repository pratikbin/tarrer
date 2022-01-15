# tarrer

Dumb br, bz2, zip, gz, lz4, sz, xz, zstd extractor

> Motivation: I can't find xz utilities for tar in alpine so created Aall-In-One...

## Run

`tarrer <archive path> <dest dir path>`

## Docker

```Dockerfile
FROM docker.io/pratikbalar/tarrer:latest as tarrer
FROM alpine:latest
COPY --from=tarrer / /
RUN tarrer test.tar.xz
```

## Release

There are several variant of binaries you can see in releses

- OS/Aarch
  - linux/amd64
  - linux/386
  - linux/arm/v5
  - linux/arm/v6
  - linux/arm/v7
  - linux/arm64
  - linux/ppc64le
  - linux/riscv64
  - linux/s390x
  - linux/mips64le
  - linux/mips64
  - windows/amd64
  - windows/arm64
  - windows/386
  - darwin/amd64
  - darwin/arm64
  - freebsd/amd64

- Varient
  - `tarrer_*` binary
    - `tarrer_*.tar.gz` archived binary
  - `tarrer-trim_*` binary that built with `-trimpath -ldflags "-s -w"`
    - `tarrer-trim_*.tar.gz` archived binary
  - `tarrer-slim_*` binary that built with `-trimpath -ldflags "-s -w"` and some of them compressed with [UPX](https://github.com/upx/upx)
    - `tarrer-slim_*.tar.gz` archived binary

- Checksum
  - `*.sha256` SHA checksum of that binary `*`
  - `*.tar.gz.sha256` SHA checksum of archive `*`

> > tarrer-slim binaries are built with flags `-trimpath -ldflags "-s -w"` and compressed with [UPX](https://github.com/upx/upx) which can lead to unexpected memory behavior or in Windows systems this may recognize as malicious.

### Thanks to

- [mholt/archiver](https://github.com/mholt/archiver)
- [crazy-max/goreleaser-xx](https://github.com/crazy-max/goreleaser-xx)

---

**May the Source Be With You**
