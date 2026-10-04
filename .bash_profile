export HISTCONTROL=ignoreboth:erasedups

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

tailscale() {
  if ! type -fp tailscale > /dev/null; then
    yes | curl -fsSL https://github.com/bropines/tailscale-termux-cli/raw/main/remote-install.sh | bash
  fi
  command tailscale "$@"
}
