variable "GORELEASER_XX_BASE" {
  default = "crazymax/goreleaser-xx:edge"
}

target "_commons" {
  args = {
    GORELEASER_XX_BASE = GORELEASER_XX_BASE
  }
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["_commons"]
  tags = ["xx-hello:local"]
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/arm64",
    "linux/ppc64le",
    "linux/s390x"
  ]
}

target "artifact" {
  inherits = ["_commons"]
  target = "artifact"
  output = ["./dist"]
}

target "artifact-all" {
  inherits = ["artifact"]
  platforms = [
    "linux/amd64",
    "linux/386",
    "linux/arm/v5",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/arm64",
    "linux/ppc64le",
    "linux/riscv64",
    "linux/s390x",
    "windows/amd64",
    "windows/arm64",
    "windows/386",
    "darwin/amd64",
    "darwin/arm64",
    "freebsd/amd64",
  ]
}
