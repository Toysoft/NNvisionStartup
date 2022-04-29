sudo apt update
export DEBIAN_FRONTEND=noninteractive
sudo  apt install -y nano curl python3-testresources

## Get pip : https://pip.pypa.io/en/stable/installing/ ##############################
curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py
sudo python3 get-pip.py
#------------------------------------------------------------------------------------

# INSTALL MINIMAL DEPENDENCIES ############################################################
sudo pip3 install docker python-crontab


########## swapoff
if ! grep "swapoff -a" /etc/systemd/nvzramconfig.sh
then
    sudo -- bash -c 'echo "swapoff -a" >> /etc/systemd/nvzramconfig.sh'
fi

######### give reboot privilege ###############
sudo -- bash -c 'echo "nnvision ALL=(root) NOPASSWD: /sbin/reboot" >  /etc/sudoers.d/reboot_privilege'

######### give patch privilege ###############
sudo -- bash -c 'echo "nnvision ALL=(root) NOPASSWD: /home/nnvision/conf/" >  /etc/sudoers.d/patch_privilege'

######### give nnvision docker permission ###############
sudo -- bash -c "usermod -aG docker nnvision"

######### deactivate graphics mode ######################
sudo systemctl set-default multi-user.target

#########
mkdir /home/nnvision/conf
touch /home/nnvision/conf/settingslocal.py
echo "
INIT_PASS = 'jznsjoa3z54d'
SERVER_WS = 'wss://dev.protecia.com/'
SERVER = 'https://dev.protecia.com/'
" >/home/nnvision/conf/settingslocal.py

touch /home/nnvision/conf/__init__.py
