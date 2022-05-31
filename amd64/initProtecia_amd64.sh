sudo apt update
export DEBIAN_FRONTEND=noninteractive
sudo  apt install -y nano curl python3-testresources python3-distutils autossh

## Get pip : https://pip.pypa.io/en/stable/installing/ ##############################
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
#------------------------------------------------------------------------------------

# INSTALL MINIMAL DEPENDENCIES ############################################################
sudo pip3 install docker python-crontab psutil


########## swapoff
if ! grep "vm.swappiness=1" /etc/sysctl.conf
then
    sudo -- bash -c 'echo "vm.swappiness=1" >> /etc/sysctl.conf'
fi

######### give reboot privilege ###############
sudo -- bash -c 'echo "nnvision ALL=(root) NOPASSWD: /sbin/reboot" >  /etc/sudoers.d/reboot_privilege'

######### give nnvision docker permission ###############
sudo -- bash -c "groupadd docker"
sudo -- bash -c "usermod -aG docker nnvision"

######## nvidia-docker ##########
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

#########
mkdir /home/nnvision/conf
touch /home/nnvision/conf/settingslocal.py
echo "
INIT_PASS = 'gOX8983zqQg'
SERVER_WS = 'wss://dev.protecia.com/'
SERVER = 'https://dev.protecia.com/'
" >/home/nnvision/conf/settingslocal.py

#########
mkdir /home/nnvision/uuid
touch /home/nnvision/uuid/uuid
echo "
zepofkpzoekfpozkcvzeopkbfgklsvd
" >/home/nnvision/uuid/uuid

touch /home/nnvision/conf/__init__.py
