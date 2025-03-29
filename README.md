# Linux Setup Scripts

This repository contains a collections of scripts that I use to set up my personal Kali Linux environments.

## How to Use

Clone the repository

```bash
git clone https://github.com/garretpatten/kali-setup-scripts.git
```

Checkout the root of the project

```bash
cd kali-setup-scripts
```

Update submodules

```bash
git submodule update --init --remote --recursive src/dotfiles/
```

Make the scripts executable

```bash
chmod +x src/scripts/*.sh
```

Run the master script

```bash
bash src/scripts/master.sh
```

## Configurations

- Alacritty
- Git
- Firewall
- Neovim
- System
- Tmux
- Vim
- Z Shell

## Downloads

### Payload Lists

- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings)
- [SecLists](https://github.com/danielmiessler/SecLists)

## Installations

### Development

- docker
- docker-compose
- gh
- neovim
- nod
- npm
- nvm
- Postman
- python
- pip
- semgrep
- shellcheck

### Fonts

- Awesome Terminal Fonts
- Fira Code Fonts
- Meslo Nerd Fonts
- Powerline Fonts (and Symbols)

### General CLI Tools

- bat
- curl
- eza
- fastfetch
- fdfind
- git
- htop
- jq
- ripgrep
- tmux
- vim
- wget

### Media

- Brave
- Spotify
- VLC

### Security

- 1Password
- clamscan
- op
- openvpn
- OWASP ZAP
- Proton VPN
- Signal Messenger

### Shell

- Alacritty
- oh-my-posh
- zsh
- Zsh Auto Suggestions
- Zsh Syntax Highlighting

## Maintainers

[@garretpatten](https://github.com/garretpatten/)

*For questions, bug reports, or feature requests, please open an issue on this repository or contact the maintainer directly.*

## License
This project is licensed under the [MIT License](./LICENSE).
