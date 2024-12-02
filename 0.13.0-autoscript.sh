#!/bin/bash
LOG_FILE="/var/log/story_node_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

printGreen() {
    echo -e "\033[32m$1\033[0m"
}

printLine() {
    echo "------------------------------"
}

# Function to print the node logo
function printNodeLogo {
    echo -e "\033[32m"
    echo "          
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
█████████████████████████████████████                          █████████████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
██████████████████████████████             █             █            ██████████████████████████████
████████████████████████████           █████             ████           ████████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ███████            ██████          ███████████████████████████
████████████████████████████          ██████████         ██████          ███████████████████████████
████████████████████████████          █████████████      ██████          ███████████████████████████
████████████████████████████             █████████████     ████          ███████████████████████████
████████████████████████████          █     █████████████     █          ███████████████████████████
████████████████████████████          █████     ████████████             ███████████████████████████
████████████████████████████          ██████       ████████████          ███████████████████████████
████████████████████████████          ██████          █████████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████            ████             ███            ████████████████████████████
██████████████████████████████                                        ██████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
█████████████████████████████████████                           ████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
Hazen Network Solutions 2024 All rights reserved."
    echo -e "\033[0m"
}

# Show the node logo
printNodeLogo

# User confirmation to proceed
echo -n "Type 'yes' to start the installation Story v0.13.0 and press Enter: "
read user_input

if [[ "$user_input" != "yes" ]]; then
  echo "Installation cancelled."
  exit 1
fi

# Function to print in green
printGreen() {
  echo -e "\033[32m$1\033[0m"
}

printGreen "Starting installation..."
sleep 1

printGreen "If there are any, clean up the previous installation files"

sudo systemctl stop story story-geth
sudo systemctl disable story story-geth
sudo rm -rf /etc/systemd/system/story.service
sudo rm -rf /etc/systemd/system/story-geth.service
sudo rm $(which story)
sudo rm $(which story-geth)
sudo rm -rf $HOME/.story
sed -i "/story_/d" $HOME/.bash_profile
sed -i "/story-geth_/d" $HOME/.bash_profile

# Update packages and install dependencies
printGreen "1. Updating and installing dependencies..."
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# User inputs
read -p "Enter your MONIKER: " MONIKER
echo 'export MONIKER='$MONIKER
read -p "Enter your PORT (2-digit): " PORT
echo 'export PORT='$PORT

# Setting environment variables
echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile
echo "export STORY_CHAIN_ID=\"odyssey\"" >> $HOME/.bash_profile
echo "export STORY_PORT=$PORT" >> $HOME/.bash_profile
source $HOME/.bash_profile

printLine
echo -e "Moniker:        \e[1m\e[32m$MONIKER\e[0m"
echo -e "Chain ID:       \e[1m\e[32m$STORY_CHAIN_ID\e[0m"
echo -e "Node custom port:  \e[1m\e[32m$STORY_PORT\e[0m"
printLine
sleep 1

# Install Go
printGreen "2. Installing Go..." && sleep 1
cd $HOME
VER="1.23.0"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=\$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin

# Version check
echo $(go version) && sleep 1

# Download Prysm protocol binary
printGreen "3. Downloading Story binary and setting up..." && sleep 1
cd $HOME
rm -rf story
wget -O story https://github.com/piplabs/story/releases/download/v0.13.0/story-linux-amd64
chmod +x story
mkdir -p $HOME/.story/story/cosmovisor/genesis/bin
mv $HOME/story $HOME/.story/story/cosmovisor/genesis/bin
sudo ln -sf $HOME/.story/story/cosmovisor/genesis $HOME/.story/story/cosmovisor/current -f
sudo ln -sf $HOME/.story/story/cosmovisor/current/bin/story /usr/local/bin/story -f

# Create geth service file
printGreen "6. Creating geth service file..." && sleep 1
sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
[Unit]
Description=Story Geth daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/go/bin/geth --odyssey --syncmode full --http --http.api eth,net,web3,engine --http.vhosts '*' --http.addr 0.0.0.0 --http.port ${STORY_PORT}545 --authrpc.port ${STORY_PORT}551 --ws --ws.api eth,web3,net,txpool --ws.addr 0.0.0.0 --ws.port ${STORY_PORT}546
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF


# Create service file
printGreen "6. Creating story service file..." && sleep 1
sudo tee /etc/systemd/system/story.service > /dev/null << EOF
[Unit]
Description=story node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start --home $HOME/.story/story
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=${HOME}/.story/story"
Environment="DAEMON_NAME=story"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:~/.story/story/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF


# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable story story-geth

# Initialize the node
printGreen "7. Initializing the node..."
story init --moniker $MONIKER --network ${$STORY_CHAIN_ID}

# Download genesis and addrbook files
printGreen "8. Downloading genesis and addrbook..."
wget -O $HOME/.story/story/config/genesis.json https://raw.githubusercontent.com/hazennetworksolutions/story/refs/heads/main/genesis.json
wget -O $HOME/.story/story/config/addrbook.json  https://raw.githubusercontent.com/hazennetworksolutions/story/refs/heads/main/addrbook.json

# Configure gas prices and ports
printGreen "9. Configuring custom ports and gas prices..." && sleep 1
sed -i.bak -e "s%:1317%:${STORY_PORT}317%g;
s%:8551%:${STORY_PORT}551%g" $HOME/.story/story/config/story.toml

# Configure P2P and ports
sed -i.bak -e "s%:26658%:${STORY_PORT}658%g;
s%:26657%:${STORY_PORT}657%g;
s%:26656%:${STORY_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${STORY_PORT}656\"%;
s%:26660%:${STORY_PORT}660%g" $HOME/.story/story/config/config.toml

# Set up seeds and peers
printGreen "10. Setting up peers and seeds..." && sleep 1
SEEDS="434af9dae402ab9f1c8a8fc15eae2d68b5be3387@story-testnet-seed.itrocket.net:29656"
PEERS="c2a6cc9b3fa468624b2683b54790eb339db45cbf@story-testnet-peer.itrocket.net:26656,fe36782944fdcb79b787a9bbc539ad901552dcd3@184.174.33.116:26656,16b98ab14c106c6dbb26d21beb6b77b6e611fe32@135.181.212.253:2010,54a2735f0a96a3a6eec089652c1aa8f899d5769a@195.7.5.165:26656,6adbd1e974d6bb1c353aabbc7abef72c81e536f5@44.235.196.208:26656,0a1d42bfd13f2b28feae6fe0c11d9ab96a7aed49@109.199.103.157:26656,c312062c3cccf1e20d39f68dd47ccce60fcb90bf@62.84.190.55:26656,aeb9eb80a126f20e9542a7657a7ec517c0483cac@38.242.237.197:26656,9fcc9d93426f7acba2b8498296aacb5dd0320438@57.129.49.172:52656,b9f40f7f0afbb6f5d855535a6824caaf91da00a2@212.47.65.128:26656,d7bd9c076ed06cc6ddaf40cf29ed9cbd7696d50c@194.163.148.243:26656,b6477609bc38045ed5e7df5fbf74edd3944d3d34@43.133.45.40:26656,363b71824f52093037d2b1de69fcb5cebf5d3058@37.60.234.0:656,5b9fa60c70693002791c13beea41fd590fac1da9@65.108.234.158:26636,45e497fdcdf954567c0ff0f220291cb0221236f0@77.237.234.158:26656,01c3ad391364738fc45ecdb9fc6cd1f7b59f3251@38.242.218.19:26656,5f3d13f7d0196073ddd229d10369a5e7fed99559@45.159.222.124:26656,7140598b3ad132261ccbfd1af679284c49035e13@195.26.241.251:26656,9f429c4f6cdeabfdfa413c061a4c4e42d1ce2f3f@65.108.121.227:12156,5c965ca3eb4c64275f086f879cad93cf09ee2ca1@213.199.47.253:656,73aafbaefe85e64a3eb0c6e23b3935bc308d77db@142.132.135.125:20656,ee7d3922f4efeb9d6f5be07c6b75b17defd19f59@109.123.247.31:26656,7a6068313c4f605681dd35b35ad483f59862d46e@62.84.176.216:26656,37ba37de71201615f6698ae243bdeabf5288ae7c@161.97.136.165:26656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.story/story/config/config.toml

# Pruning Settings
printGreen "12. Setting up pruning config..." && sleep 1
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.story/story/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.story/story/config/config.toml

# Download the snapshot
# printGreen "12. Downloading snapshot and starting node..." && sleep 1





# Start the node
printGreen "13. Starting the node..."
sudo systemctl restart story-geth && sleep 5 && sudo systemctl restart story

# Check node status
printGreen "14. Checking node status..."
sudo journalctl -u story -u story-geth -f -o cat

# Verify if the node is running
if systemctl is-active --quiet story; then
  echo "The node is running successfully! Logs can be found at /var/log/story_node_install.log"
else
  echo "The node failed to start. Logs can be found at /var/log/story_node_install.log"
fi
