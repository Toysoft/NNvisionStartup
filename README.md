# NNvisionStartup
initial setup for jetson Nano


`sudo apt update 
sudo apt install python3-pip `

Requirement :
`pip3 install docker python-crontab`


Give the rebbot privilege :
sudo visudo -f /etc/sudoers.d/reboot_privilege

add line :

nnvision ALL=(root) NOPASSWD: /sbin/reboot

