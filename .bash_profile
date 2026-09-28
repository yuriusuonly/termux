#!/usr/bin/bash

export HISTCONTROL=ignoreboth:erasedups

declare -A _PATH=(
  [code]="$HOME/.code/bin"
  [bun]="$HOME/.bun/bin"
)

export PATH="$PATH:$(IFS=:; echo "${_PATH[*]}")"

penguin() {
  if ! type -fp proot-distro > /dev/null; then
    apt install -y proot-distro
    proot-distro install \
      -a aarch64 \
      -n penguin \
      ubuntu
    proot-distro clear-cache
  fi
  proot-distro login \
    --no-link2symlink \
    --shared-home \
    --shared-tmp \
    --hostname penguin \
    --user root \
    penguin "$@"
}

useradd() {
  IFS=':' read -r name _ <<< "$1"
  command useradd \
    --create-home \
    --skel /dev/null \
    --groups audio,video \
    --shell /usr/bin/bash \
    --comment "${name^}" \
    "$name"
  echo "$1" | chpasswd
}

timestamp() {
  date -u +'%Y-%m-%d %H:%M:%S UTC±00:00'
}

micro() {
  if ! type -fp micro > /dev/null; then
    apt update -y && apt install -y micro
  fi
  command micro "$@"
}

curl() {
  if ! type -fp curl > /dev/null; then
    apt update -y && apt install -y curl
  fi
  command curl "$@"
}

git() {
  if ! type -fp git > /dev/null; then
    apt update -y && apt install -y git
  fi
  command git "$@"
}

bsdtar() {
  if ! type -fp bsdtar > /dev/null; then
    apt update -y && apt install -y libarchive-tools
  fi
  command bsdtar "$@"
}

code() {
  if ! type -fp code > /dev/null; then
    apt update -y && apt install -y ca-certificates
    update-ca-certificates
    (
      mkdir -p "${_PATH[code]}" && cd "${_PATH[code]}"
      curl -L "https://update.code.visualstudio.com/latest/cli-linux-arm64/stable" \
        | bsdtar -xf -
      chmod +x code 2> /dev/null
    ) >&1 2>&2
  fi
  command code "$@"
}

bun() {
  if ! type -fp bun > /dev/null; then
    (
      mkdir -p "${_PATH[bun]}" && cd "${_PATH[bun]}"
      curl -sL "https://api.github.com/repos/oven-sh/bun/releases/latest" \
        | grep "browser_download_url" \
        | grep "bun-linux-aarch64-android.zip" \
        | cut -d '"' -f4 \
        | xargs curl -L \
        | bsdtar -xf - --strip-components=1
      chmod +x bun 2>/dev/null
    ) >&1 2>&2
  fi
  command bun "$@"
}
