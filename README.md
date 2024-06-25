# my nixos config

## Installation

### NixOS (System + Home Manager)

{{ TODO }}

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
