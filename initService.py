import json
import os
import docker
from crontab import CronTab
from docker.errors import APIError
import logging
from pathlib import Path
from subprocess import call
from datetime import datetime

logging.basicConfig(level=logging.WARNING)


# FIRST PART IS TO RUN THE GOOD CONTAINER VERSION ----------------------------------------------------------------------
# get the version of the image to run
def update_docker(docker_conf):
    # test if container nnvision is running
    client = docker.from_env()
    # test if container nnvision is running
    if not client.containers.list(filters={'name': 'nnvision'+str(docker_conf['docker_version'])}):
        logging.warning('good container is not running')

        # test if image is existing
        try:
            client.images.get('roboticia/nnvision_jetson_nano:'+str(docker_conf['docker_version']))
            logging.warning(f'image {"roboticia/nnvision_jetson_nano:"+str(docker_conf["docker_version"])} is OK')
        except docker.errors.ImageNotFound:
            # pull the image
            logging.warning(f'Pulling the image {str(docker_conf["docker_version"])}')
            client.login(username='nnvisionpull',
                         password='jouvenciaprotecia69',
                         email='dockerpull@roboticia.com',
                         registry='https://index.docker.io/v1/')
            client.images.pull("roboticia/nnvision_jetson_nano:"+str(docker_conf['docker_version']))

        # stop all containers
        for c in client.containers.list():
            c.stop()
        client.containers.prune()

        # run nnvision
        client.containers.run(
            "roboticia/nnvision_jetson_nano:"+str(docker_conf['docker_version']),
            restart_policy={"Name": "on-failure"},
            entrypoint='/NNvision/python_client/start.sh',
            name='nnvision'+str(docker_conf['docker_version']),
            network_mode='host',
            runtime='nvidia',
            environment=["NVIDIA_VISIBLE_DEVICES=all", "NVIDIA_DRIVER_CAPABILITIES=compute,utility,video"],
            volumes={'/home/nnvision/conf': {'bind': '/NNvision/python_client/conf',
                                             'mode': 'rw'},
                     '/usr/src/jetson_multimedia_api': {'bind': '/usr/src/jetson_multimedia_api',
                                                        'mode': 'rw'},
                     'nn_camera': {'bind': '/NNvision/python_client/camera',
                                   'mode': 'rw'},
                     '/proc/device-tree/chosen': {'bind': '/NNvision/uuid',
                                                  'mode': 'rw'},
                     '/home/nnvision/NNvisionStartup': {'bind': '/NNvision/boitier/NNvisionStartup',
                                                        'mode': 'rw'},
                     '/etc/cron.d': {'bind': '/NNvision/crontab',
                                     'mode': 'rw'}
                     },
            detach=True,
                              )
        # clean unused images
        client.images.prune()
    logging.warning('good container is running Noting special to do')


# SECOND PART IS TO CHECK IF REBOOT ------------------------------------------------------------------------------------
def check_force_reboot():
    try:
        with open("/home/nnvision/conf/conf.json") as conf_file:
            list_conf = json.load(conf_file)
        for dict_conf in list_conf:
            key = dict_conf['key']
            with open(f'/home/nnvision/conf/ping_{key}.json', 'r') as f:
                ping = json.load(f)
            delta_time = datetime.utcnow() - datetime.strptime(ping['last'], '%Y-%m-%d %H:%M:%S')
            logging.warning(f'delta time is {delta_time.total_seconds()}')
            if delta_time.total_seconds() > 500:
                logging.warning('reboot --> yes')
                os.system('sudo reboot')
    except (FileNotFoundError, json.decoder.JSONDecodeError):
        logging.warning('can not find the docker.json file')
        pass


def reboot(docker_conf):
    logging.warning('enter reboot')
    if docker_conf['reboot']:
        logging.warning('reboot --> yes')
        os.system('sudo reboot')
    else:
        logging.warning('reboot --> no')


# THIRD PART IS TO INSTALL CRON (only important for first run, in case of change manually remove the installed cron) ---
def install_update_docker_cron():
    cron = CronTab(user=True)
    if not any(cron.find_command('initService')):
        cmd = "sleep 200 && cd /home/nnvision/NNvisionStartup && "
        cmd += 'python3 /home/nnvision/NNvisionStartup/initService.py'
        cmd += " > /home/nnvision/cron_service.log 2>&1&"
        job = cron.new(command=cmd)
        job.minute.every(2)
        cron.write()


def install_reboot_midnight_cron():
    cron = CronTab(user=True)
    if not any(cron.find_command('reboot')):
        cmd = "/home/nnvision/reboot.sh "
        cmd += " > /home/nnvision/cron_reboot.log 2>&1&"
        job = cron.new(command=cmd)
        job.every().dom()
        cron.write()


def apply_host_patch():
    dir1 = Path('/home/nnvision/')
    patch_already_applied = [file.name.split('.')[0] for file in dir1.iterdir() if file.name.endswith('.ok')]
    dir2 = Path('/home/nnvision/conf/')
    patch = [file for file in dir2.iterdir() if file.name.startswith('patch')]
    need_reboot = False
    for p in patch:
        if p.name.split('.')[0] not in patch_already_applied:
            call('sudo '+str(p), shell=True)
            need_reboot = True
    if need_reboot:
        os.system('sudo reboot')


if __name__ == "__main__":
    conf = {'docker_version': 2.1, 'reboot': False}
    try:
        with open("../conf/docker.json") as version:
            conf = json.load(version)
    except FileNotFoundError:
        logging.warning('can not find the docker.json file')
        pass
    update_docker(conf)
    apply_host_patch()
    reboot(conf)
    install_update_docker_cron()
    install_reboot_midnight_cron()
    check_force_reboot()
