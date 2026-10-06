export HISTCONTROL=ignoreboth:erasedups

declare -A _PATH=(
  [bin]="$HOME/.local/bin"
  [bun]="$HOME/.bun/bin"
)

export PATH="$PATH:$(IFS=:; echo "${_PATH[*]}")"

timestamp() {
  date -u +'%Y-%m-%d %H:%M:%S UTC±00:00'
}

tailscale() {
  if ! type -fp tailscale > /dev/null; then
    yes | curl -fsSL https://github.com/bropines/tailscale-termux-cli/raw/main/remote-install.sh | bash
  fi
  command tailscale "$@"
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

mkcert() {
  if ! type -fp mkcert > /dev/null; then
    (
      mkdir -p "${_PATH[bin]}" && cd "${_PATH[bin]}"
      curl -L -o mkcert https://dl.filippo.io/mkcert/latest?for=linux/arm64
      chmod +x mkcert 2>/dev/null
    ) >&1 2>&2
  fi
  command tailscale "$@"
}
