# -*- coding: utf-8 -*-
"""
Created on Fri Jun  5 19:31:50 2020

@author: julien
"""

import socket
import time
import psutil
import subprocess

# CONF for the tunnel
ip = "dev.jouvencia.net"
port_redirect = 40777
retry = 3
delay = 2
timeout = 3
user = "tunnel"
port_ssh = 2223
local_host = "localhost"
local_port = "22"


def is_open(ip, port):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(timeout)
        try:
                s.connect((ip, int(port)))
                s.shutdown(socket.SHUT_RDWR)
                return True
        except:
                return False
        finally:
                s.close()


def check_host(ip, port):
        ipup = False
        for i in range(retry):
                if is_open(ip, port):
                        ipup = True
                        break
                else:
                        time.sleep(delay)
        return ipup


if not check_host(ip, port_redirect):
    print(ip, 'is DOWN')
    for proc in psutil.process_iter():
        # check whether the process name matches
        if 'ssh' in proc.name() and 'sshd' not in proc.name():
            for string in proc.cmdline():
                if str(port_redirect) in string:
                    try:
                        proc.kill()
                        print(f'Killing the ssh process {proc.name()}')
                    except psutil.AccessDenied:
                        print(f'can not kill the ssh process {proc.name()}')
                        pass
    command = f"./ssh_tunnel_safe.sh {port_ssh} {port_redirect} {local_host} {local_port} {user} {ip}"
    print("command is:", command)
    subprocess.call(command, shell=True)

    print("tunnel launched")

else:
    print("tunnel is OK")
