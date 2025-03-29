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
