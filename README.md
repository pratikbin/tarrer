# tarrer

Dumb br, bz2, zip, gz, lz4, sz, xz, zstd extractor

## Run

`tarrer <archive path> <dest dir path>`

> > tarrer_slim binaries are built with flags `-trimpath -ldflags "-s -w"` and compressed with [UPX](https://github.com/upx/upx) so Windows systems may recognize this as malicious.


## Release

Artifacts/Binaries in releases are available in...

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
  - windows/amd64
  - windows/arm64
  - windows/386
  - darwin/amd64
  - darwin/arm64
  - freebsd/amd64

- Varient
  - `tarrer_*` binary
  - `tarrer_slim_*` binary that built with flags `-trimpath -ldflags "-s -w"` and some of them compressed with [UPX](https://github.com/upx/upx) (Windows systems may recognize this as malicious)
  - `tarrer_slim_*.tar.gz` archived binary

- Checksum
  - `*.sha256` SHA checksum of that binary `*`
  - `*.tar.gz.sha256` SHA checksum of archive `*`

> That makes `122` artifacts in release

### Thanks to

- [mholt/archiver](https://github.com/mholt/archiver)
- [crazy-max/goreleaser-xx](https://github.com/crazy-max/goreleaser-xx)

---

**May the Source Be With You**
