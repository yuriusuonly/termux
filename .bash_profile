export HISTCONTROL=ignoreboth:erasedups

timestamp() {
  date -u +'%Y-%m-%d %H:%M:%S UTC±00:00'
}

tailscale() {
  if ! type -fp tailscale > /dev/null; then
    yes | curl -fsSL https://github.com/bropines/tailscale-termux-cli/raw/main/remote-install.sh | bash
  fi
  command tailscale "$@"
}
