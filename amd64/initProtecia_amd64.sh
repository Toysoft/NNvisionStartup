sudo apt update
export DEBIAN_FRONTEND=noninteractive
sudo  apt install -y nano curl python3-testresources python3-distutils

## Get pip : https://pip.pypa.io/en/stable/installing/ ##############################
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
#------------------------------------------------------------------------------------

# INSTALL MINIMAL DEPENDENCIES ############################################################
sudo pip3 install docker python-crontab


########## swapoff
if ! grep "vm.swappiness=1" /etc/sysctl.conf
then
    sudo -- bash -c 'echo "vm.swappiness=1" >> /etc/sysctl.conf'
fi

######### give reboot privilege ###############
sudo -- bash -c 'echo "nnvision ALL=(root) NOPASSWD: /sbin/reboot" >  /etc/sudoers.d/reboot_privilege'

######### give nnvision docker permission ###############
sudo -- bash -c "usermod -aG docker nnvision"

#########
mkdir /home/nnvision/conf
touch /home/nnvision/conf/settingslocal.py
echo "
INIT_PASS = 'gOX8983zqQg'
SERVER_WS = 'wss://dev.protecia.com/'
SERVER = 'https://dev.protecia.com/'
" >/home/nnvision/conf/settingslocal.py

touch /home/nnvision/conf/__init__.py
