# my nixos config

Despite the generalized documentation, this configuration is built and
maintained only for my personal use.

Not everything is done "the Nix way". However, Nix provides me with the ability
to spin up my personal/development environments on any of my systems
with minimal effort, whether NixOS, Debian/other, and WSL2 or bare metal.

## Installation

### NixOS (System + Home Manager)

These instructions should be roughly the same for NixOS-WSL and pure NixOS.

#### Install NixOS

##### WSL2

Download and import a NixOS tarball into WSL2.
I used [this one](https://github.com/LGUG2Z/nixos-wsl-starter/releases) but I think it's also possible to [build your own](https://nix-community.github.io/NixOS-WSL/building.html).

```sh
wsl --import <distro-name> <install-path> <tarball-path>
```

##### Setup the configuration

In NixOS, clone the repo:

```sh
nix-shell -p git --run 'git clone https://github.com/nomnivore/nixcfg ~/nixcfg'
cd ~/nixcfg
```

Switch to the new configuration:

```sh
sudo nixos-rebuild switch --flake .#nixos
```

As an alternative, you can also use this command to build from the remote repo:

```sh
sudo nixos-rebuild switch --flake github:nomnivore/nixcfg#nixos
```

`#nixos` can be substituted with another flake output to build a different system, or omitted to match your system's hostname.

**If you're on WSL2, you'll need to run these commands instead:**

```sh
sudo nixos-rebuild boot --flake .#nixos
```

In PowerShell:

```sh
wsl -t <distro-name>
wsl -d <distro-name> --user root exit
wsl -t <distro-name>
```

Then in NixOS, copy over the config repo and remove the default user directory:

```sh
cd ~
cp -r /home/nixos/nixcfg ~/nixcfg
sudo rm -rf /home/nixos
```

ref: <https://nix-community.github.io/NixOS-WSL/how-to/change-username.html>

All done! ✨

### Other distros (Home Manager)

Tested to work on Ubuntu/Debian, but should work on nearly any distro.

#### Install Nix

Install Nix according to these instructions: <https://nix.dev/install-nix>

You may need to ensure you have `curl` and `xz-utils` to run the install script.

Debian with APT:

```sh
sudo apt-get install curl xz-utils
```

On WSL2 with `systemd` enabled:

```sh
curl -L https://nixos.org/nix/install | sh -s -- --daemon \
&& exec $SHELL
```

You can verify the installation by running:

```sh
nix --version
```

#### Install Home Manager

[Official Instructions](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone)

Add the channel for home-manager that matches the version in `flake.nix`:

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
nix-channel --update
```

Install:

```sh
nix-shell '<home-manager>' -A install
```

#### Clone and switch

Clone the repo:

```sh
nix-shell -p git --run 'git clone https://github.com/nomnivore/nixcfg ~/nixcfg'
cd ~/nixcfg
```

Use Home Manager to switch to the desired user environment:

```sh
home-manager switch --flake .#USER \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes
```

The build/install process may take some time and unpack over 10GB of data.

You might need to change your default shell for the best experience:

```sh
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
exec zsh
```

All done! ✨
