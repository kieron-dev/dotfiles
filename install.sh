#!/bin/bash

set -euxo pipefail

sudo add-apt-repository -y ppa:intel-opencl/intel-opencl

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F9FDA6BED73CDC22
cat <<EOF | sudo tee /etc/apt/sources.list.d/dell.list
deb http://dell.archive.canonical.com/updates/ focal-dell public
# deb-src http://dell.archive.canonical.com/updates/ focal-dell public

deb http://dell.archive.canonical.com/updates/ focal-oem public
# deb-src http://dell.archive.canonical.com/updates/ focal-oem public

deb http://dell.archive.canonical.com/updates/ focal-somerville public
# deb-src http://dell.archive.canonical.com/updates/ focal-somerville public

deb http://dell.archive.canonical.com/updates/ focal-somerville-bulbasaur public
# deb-src http://dell.archive.canonical.com/updates focal-somerville-bulbasaur public
EOF

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E

cat <<EOF | sudo tee /etc/apt/sources.list.d/dropbox.list
deb https://linux.dropbox.com/ubuntu trusty main
EOF

sudo apt-get update
sudo apt-get upgrade -y

sudo apt -y install \
  cowsay \
  fortune \
  tmux \
  tmux-plugin-manager \
  keepassxc \
  git \
  stow \
  curl \
  build-essential \
  ripgrep \
  nfs-common \
  glabels \
  npm \
  libfprint-2-tod1-goodix \
  oem-somerville-meta \
  oem-somerville-bulbasaur-meta \
  tlp-config \
  dropbox \
  zsh \
  direnv \
  gimp \
  imagemagick \
  python3-pip \
  intel-opencl-icd

wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb
sudo apt install nvim-linux64.deb
rm nvim-linux64.deb

snap install sweethome3d-homedesign

sudo npm i -g bash-language-server
sudo npm i -g prettier
go install mvdan.cc/sh/v3/cmd/shfmt@latest

pushd $HOME/dotfiles
git pull
stow nvim
# nvim --headless +PlugInstall +q
stow tmux
stow git
stow zsh
popd

python3 -m pip install --user --upgrade pynvim

# fonts
temp=$(mktemp -d)
trap "rm -rf $temp" EXIT
pushd $temp
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip >font.zip
unzip font.zip
mkdir -p $HOME/.local/share/fonts/droid-nerd
cp *.?tf $HOME/.local/share/fonts/droid-nerd
fc-cache -fv
popd

# tweaks
gsettings set org.gnome.desktop.input-sources xkb-options "['shift:both_capslock','caps:ctrl_modifier']"
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'gb')]"
gsettings set org.gnome.desktop.interface monospace-font-name "DroidSansMono Nerd Font 11"
gsettings set org.gnome.desktop.interface cursor-blink false

rm -rf $HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/
pushd $temp
curl -sL https://extensions.gnome.org/extension-data/dash-to-dockmicxgx.gmail.com.v71.shell-extension.zip >dash-to-dock.zip
unzip dash-to-dock.zip -d $HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/
popd
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true

#golang
sudo rm -rf /usr/local/go
curl -sL https://go.dev/dl/go1.17.4.linux-amd64.tar.gz | sudo tar -C /usr/local -xzf -

if grep -qv "/usr/local/go/bin" $HOME/.bashrc; then
  echo export PATH=$PATH:/usr/local/go/bin >>$HOME/.bashrc
fi
go install github.com/onsi/ginkgo/ginkgo@latest
go install golang.org/x/tools/gopls@latest

rm -rf $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc --skip-chsh
git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
chsh -s "$(command -v zsh)"
