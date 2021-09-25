sudo apt update
export DEBIAN_FRONTEND=noninteractive
sudo  apt install -y nano curl

## Get pip : https://pip.pypa.io/en/stable/installing/ ##############################
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
#------------------------------------------------------------------------------------

# INSTALL MINIMAL DEPENDENCIES ############################################################
sudo pip3 install docker python-crontab


########## swapoff
sudo -- bash -c 'echo "swapoff -a" >> /etc/systemd/nvzramconfig.sh'


######### give reboot privilege ###############
sudo -- bash -c 'echo "nnvision ALL=(root) NOPASSWD: /sbin/reboot" >  /etc/sudoers.d/reboot_privilege'

#########
mkdir /home/nnvision/conf
touch /home/nnvision/conf/settingslocal.py
echo "
INIT_PASS = 'gOX8983zqQg'
SERVER_WS = 'wss://mdm.jouvencia.net/'
SERVER = 'https://mdm.jouvencia.net/'
" >/home/nnvision/conf/settingslocal.py

touch /home/nnvision/conf/__init__.py
