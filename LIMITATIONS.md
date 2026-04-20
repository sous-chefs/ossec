# Limitations

This cookbook currently installs OSSEC HIDS packages from the Atomicorp archive
paths used in the legacy cookbook, not from a first-party Chef workflow.
Current upstream OSSEC documentation also supports source builds, and that
source-install path is the safest fallback when packaged artifacts are missing
or lagging.

## Package Availability

### APT (Debian/Ubuntu)

- Repository base URL used by the cookbook:
  `https://updates.atomicorp.com/channels/atomic/<platform>`
- Current cookbook GPG key:
  `https://www.atomicorp.com/RPM-GPG-KEY.atomicorp.txt`
- Current cookbook layout logic:
  - Ubuntu 20.04+ and Debian 11+ use `codename/<arch>/`
  - older releases use the legacy `codename` + `main` layout

Verified Atomicorp archive trees on 2026-04-15:

- Ubuntu trees present: `xenial`, `bionic`, `focal`, `jammy`, `noble`
- Debian trees present: `buster`, `bullseye`, `bookworm`, `trixie`

Verified package artifacts on 2026-04-15:

- Ubuntu 20.04 `focal`: OSSEC 4.0.0 agent/server packages observed for
  `amd64` and `arm64`
- Ubuntu 22.04 `jammy`: OSSEC 4.0.0 agent/server packages observed for
  `amd64` and `arm64`
- Ubuntu 24.04 `noble`: OSSEC 4.0.0 agent/server packages observed for
  `amd64` and `arm64`

Vendor support documentation currently lists:

- Debian 11 / 12 / 13: `x86_64`, `aarch64/ARM64`
- Ubuntu 20 / 22 / 24: `x86_64`, `aarch64/ARM64`

Practical limitation:

- The archive still exposes older distro trees, but those should not be treated
  as support commitments
- Ubuntu 18.04 and 20.04 remain available in the archive, but 18.04 is ESM-only
  and 20.04 standard support ended on 2025-05-31
- Debian 13 package metadata currently requires a compatibility fallback in this
  cookbook: the Atomicorp signing path is not accepted by current apt policy, so
  the cookbook enables `trusted=yes` for Debian 13 only to keep installs working

### DNF/YUM (RHEL family / Amazon / Fedora)

- Repository base URL used by the cookbook:
  - RHEL-family / Fedora:
    `https://updates.atomicorp.com/channels/atomic/centos/$releasever/$basearch`
  - Amazon Linux:
    `https://updates.atomicorp.com/channels/atomic/amazon/<major>/$basearch`
- Current cookbook GPG key:
  `https://www.atomicorp.com/RPM-GPG-KEY.atomicorp.txt`

Verified Atomicorp archive trees on 2026-04-15:

- `centos/9` and `centos/10` trees exist
- `amazon/2023` tree exists
- `fedora/43` tree exists
- `rocky/9` tree exists

Verified package artifacts on 2026-04-15:

- EL9: OSSEC 4.0.0 agent/server packages observed for `x86_64` and `aarch64`
- EL10: OSSEC 4.0.0 agent/server packages observed for `x86_64`
- Amazon Linux 2023: OSSEC 4.0.0 agent/server packages observed for `x86_64`
- Fedora 43: OSSEC 4.0.0 agent/server packages observed for `x86_64`
- Rocky 9 mirrors the EL9 package naming and artifacts

Vendor support documentation currently lists:

- Amazon Linux 2 / 2023: `x86_64`, `aarch64/ARM64`
- Oracle Linux 7 / 8 / 9: `x86_64`, `aarch64/ARM64`, `PPC`, `S390`
- RHEL / Rocky 8 / 9 / 10: `x86_64`, `aarch64/ARM64`, `PPC`, `S390`
- CentOS 5 / 6 / 7: `x86_64`

Practical limitation:

- Fedora repo artifacts exist, but Fedora is not called out in the current
  Atomic OSSEC support table
- AlmaLinux is not explicitly listed in current Atomicorp support docs; treat it
  as uncommitted even if EL-compatible packages may work
- The cookbook's hard-coded `centos/$releasever/$basearch` path is a legacy
  abstraction across EL-style systems, not a guarantee of explicit vendor test
  coverage for every clone
- Amazon Linux 2023 requires its own `amazon/2023/$basearch` repository path;
  the generic EL/CentOS path does not resolve current Amazon packages reliably

### Zypper (SUSE)

- The free Atomicorp mirror only shows very old openSUSE trees (`12.3`, `13.1`)
- Current upstream OSSEC source-build docs still mention OpenSuse build
  dependencies, but the Atomic package path should be treated as legacy-only

Practical limitation:

- openSUSE package support is not current for this cookbook's package-install
  path
- openSUSE Leap 15.x should not remain in `metadata.rb` or Kitchen just because
  a generic Dokken image exists

## Architecture Limitations

- The legacy cookbook only maps Debian-family architectures to `amd64` and
  `arm64`
- Ubuntu `focal`, `jammy`, and `noble` package artifacts were directly verified
  for both `amd64` and `arm64`
- EL9 package artifacts were directly verified for both `x86_64` and `aarch64`
- EL10 package artifacts were directly verified for `x86_64` in-session
- Vendor support docs claim broader RPM coverage for Oracle and RHEL/Rocky
  (`PPC`, `S390`), but this cookbook does not model or test those architectures

## Source / Compiled Installation

Current upstream OSSEC 4.x build path requires source-build dependencies when
packages are unavailable or unsuitable.

### Build Dependencies

- `Debian / Ubuntu`: `build-essential`, `make`, `zlib1g-dev`, `libpcre2-dev`,
  `libevent-dev`, `libssl-dev`, `libsystemd-dev`, `libsqlite3-dev`
- `RHEL / CentOS / Fedora / Amazon`: `zlib-devel`, `pcre2-devel`, `make`,
  `gcc`, `sqlite-devel`, `openssl-devel`, `libevent-devel`, `systemd-devel`
- `OpenSuse`: `zlib-devel`, `pcre2-devel`, optional `postgresql-devel`,
  optional `mysql-devel`

### Build-Time Notes

- OSSEC 3.4+ expects system PCRE2 by default (`PCRE2_SYSTEM=yes`) unless you
  stage the bundled source manually
- upstream also expects system zlib by default unless `ZLIB_SYSTEM=no` is used
- `libevent` is required for `ossec-agentd` and `ossec-maild`
- source builds are the fallback when Atomicorp archive coverage and the desired
  target platform diverge

## Known Issues

- The cookbook README still describes a source-install workflow, while the
  current implementation installs Atomicorp-hosted packages; migration work
  should make that distinction explicit
- The free Atomicorp `atomic` repositories behave like archive mirrors; package
  presence alone should not be interpreted as a current support statement
- `centos-7`, `centos-stream-8`, `debian-10`, `scientific`, and openSUSE legacy
  paths are not appropriate targets for a current support matrix
- Ubuntu 18.04 is ESM-only, Ubuntu 20.04 is beyond standard support, and Debian
  11 is close to LTS end; prefer newer current releases when trimming support

## Sources

- Atomicorp package support docs:
  - <https://docs.atomicorp.com/AEO/agents/requirements/index.html>
- Atomicorp archive trees:
  - <https://updates.atomicorp.com/channels/atomic/ubuntu/dists/>
  - <https://updates.atomicorp.com/channels/atomic/debian/dists/>
  - <https://updates.atomicorp.com/channels/atomic/centos/>
  - <https://updates.atomicorp.com/channels/atomic/amazon/>
  - <https://updates.atomicorp.com/channels/atomic/fedora/>
  - <https://updates.atomicorp.com/channels/atomic/opensuse/>
- Atomicorp mirror index:
  - <https://updates.atomicorp.com/channels/mirrorlist/atomic/>
- GPG key and installer assets:
  - <https://www.atomicorp.com/RPM-GPG-KEY.atomicorp.txt>
  - <https://updates.atomicorp.com/installers/>
- Upstream OSSEC installation requirements:
  - <https://www.ossec.net/docs/docs/manual/installation/installation-requirements.html>
- Upstream OSSEC package install docs:
  - <https://www.ossec.net/docs/docs/manual/installation/installation-package.html>
- Upstream OSSEC source install docs:
  - <https://www.ossec.net/docs/docs/manual/installation/install-source.html>
- Lifecycle references:
  - <https://endoflife.date/ubuntu>
  - <https://endoflife.date/debian>
  - <https://endoflife.date/centos>
  - <https://endoflife.date/centos-stream>
  - <https://endoflife.date/amazon-linux>
  - <https://endoflife.date/rhel>
  - <https://endoflife.date/rocky-linux>
  - <https://endoflife.date/oracle-linux>
  - <https://endoflife.date/fedora>
  - <https://endoflife.date/opensuse>
  - <https://scientificlinux.org/category/uncategorized/scientific-linux-end-of-life/>
