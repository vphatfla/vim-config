echo "--------Apt-get update"

sudo apt-get update

echo "--------Install git"

sudo apt-get install git

echo "--------Installing zsh"

sudo apt-get install zsh

echo "--------Install oh my zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "--------Install plugins for zsh"

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

echo "--------Configre ~/.zshrc"

ZSHRC="$HOME/.zshrc"
NEW_PLUGINS="plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)"

[[ ! -f "$ZSHRC" ]] && { echo "--------Error: .zshrc not found"; exit 1; }

LINE_NUM=$(grep -n "^plugins=" "$ZSHRC" | cut -d: -f1)

if [[ -n "$LINE_NUM" ]]; then
    sed -i "${LINE_NUM}s/.*/$NEW_PLUGINS/" "$ZSHRC"
    echo "--------✅ Replaced plugins line at line $LINE_NUM"
else
    echo "--------❌ No plugins line found in .zshrc"
    exit 1
fi

source ~/.zshrc

echo "--------Install docker"

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
