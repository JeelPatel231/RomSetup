echo "Enter Azure Credentials"
read -p 'Username: ' uservar
read -p 'VM-Name: ' myVM
read -p 'ResourceGroup: ' myResourceGroup
read -p 'HardDisk : ' hdd

echo "Installing XFCE4 DE"
sudo apt-get update
sudo apt-get -y install xfce4
sudo apt-get -y install xrdp
sudo systemctl enable xrdp
echo xfce4-session >~/.xsession
sudo service xrdp restart
sudo passwd $uservar

echo "Setting up CLI"
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli
az login
az vm open-port --resource-group $myResourceGroup --name $myVM --port 3389

echo "Installing Prerequisites"
sudo apt-get install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev gedit python-pip -y

echo "Installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

echo "Installing and configuring REPO"
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
source ~/.profile

echo "Setting up Externel disk"
sudo mkdir /mnt/hdd
sudo mkfs.ext4 /dev/$hdd
sudo mount -t ext4 /dev/$hdd /mnt/hdd
echo "GOOD TO GO!!"
