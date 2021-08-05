# NNvisionStartup
initial setup for jetson Nano

Requirement :
`pip3 install docker`
`pip3 install python-crontab`


Give the rebbot privilege :
sudo visudo -f /etc/sudoers.d/reboot_privilege

add line :

nnvision ALL=(root) NOPASSWD: /sbin/reboot

