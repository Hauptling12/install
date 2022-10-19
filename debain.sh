#!/bin/bash
sudo apt install ufw fail2ban openssh-server git curl p7zip maim lshw ncdu -y
echo "are you running a laptop (y/n)"
read laptop
if [[ "$laptop" == "y" ]];
# shellcheck disable=SC2086
    sudo apt install tlp powertop
    mkdir $HOME/build
    cd $HOME/build
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    cd auto-cpufreq && sudo ./auto-cpufreq-installer

echo "server (y/n)"
read server
if [[ "$server" == "n" ]];
    sudo apt install mpv x11-common xauth xorg xserver-common xserver-xorg
    curl -L https://nixos.org/nix/install | sh
    nix-env -iA nixpkgs.neovim nixpkgs.haskellPackages.xmonad nixpkgs.haskellPackages.xmonad-contrib nixpkgs.haskellPackages.xmonad-extras
    nix-env -iA nixpkgs.haskellPackages.xmobar

wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg

sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

sudo apt update

sudo apt install librewolf -y

sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

sudo systemctl enable fail2ban
sudo systemctl start fail2ban

git clone https://github.com/Hauptling12/dotfiles
