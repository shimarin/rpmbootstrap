# rpmbootstrap
Bootstrap RPM-based Linux distribution

`rpmbootstrap` is a tool for installing RPM packages with automatic dependency resolution into a target root directory, similar to `debootstrap` for Debian-based systems.

## Requirements

- g++ with C++20 support
- libxml2
- libcurl
- [argparse](https://github.com/p-ranav/argparse)
- `rpm` command (for installation)
- `gunzip` command (for `.gz` decompression)
- `zstd` command (for `.zst` decompression)

## Build

```sh
make
```

To install:

```sh
make install DESTDIR=/usr/local
```

## Usage

```
rpmbootstrap [OPTIONS] <base-url> <root_dir> <packages...>
```

### Arguments

| Argument | Description |
|---|---|
| `base-url` | Base URL of the RPM repository (e.g., a mirror URL ending with `/`) |
| `root_dir` | Root directory to bootstrap into (must already exist) |
| `packages` | One or more package names to install |

### Options

| Option | Description |
|---|---|
| `-x`, `--dependency-exclude <NAME>` | Exclude a dependency from being resolved and installed. Can be specified multiple times. |
| `--no-signature` | Do not check package signatures when installing RPMs |

## How It Works

1. Fetches `repodata/repomd.xml` from the given base URL
2. Locates and downloads the primary package metadata (`primary.xml.gz`)
3. Parses package dependency information for the current machine architecture
4. Resolves dependencies recursively for the specified packages
5. Downloads required RPM files to `<root_dir>/tmp/rpmbootstrap/`
6. Installs them using `rpm -Uvh --force -r <root_dir>`
7. Removes the temporary working directory

## Example

Bootstrap a minimal AlmaLinux 9 system into `./rootfs`:

```sh
mkdir rootfs
rpmbootstrap https://repo.almalinux.org/almalinux/9/BaseOS/x86_64/os/ ./rootfs bash coreutils
```

To exclude a dependency (e.g., skip installing `systemd` when it would otherwise be pulled in):

```sh
rpmbootstrap -x systemd https://repo.almalinux.org/almalinux/9/BaseOS/x86_64/os/ ./rootfs bash
```
