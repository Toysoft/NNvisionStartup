import json
import os
import docker
from crontab import CronTab
from docker.errors import APIError


# FIRST PART IS TO RUN THE GOOD CONTAINER VERSION ----------------------------------------------------------------------
# get the version of the image to run
def update_docker(docker_conf):
    # test if container nnvision is running
    client = docker.from_env()
    # test if container nnvision is running
    if not client.containers.list(filters={'name': 'nnvision'+str(docker_conf['docker_version'])}):
        # stop all containers
        for c in client.containers.list():
            c.stop()
        client.containers.prune()
        # test if image is existing
        try:
            client.images.get('roboticia/nnvision_jetson_nano:'+str(docker_conf['docker_version']))
        except docker.errors.ImageNotFound:
            # pull the image
            client.login(username='nnvisionpull',
                         password='jouvenciaprotecia69',
                         email='dockerpull@roboticia.com',
                         registry='https://index.docker.io/v1/')
            client.images.pull("roboticia/nnvision_jetson_nano:"+str(docker_conf['docker_version']))
        # run nnvision
        client.containers.run(
            "roboticia/nnvision_jetson_nano:"+str(docker_conf['docker_version']),
            restart_policy={"Name": "on-failure"},
            entrypoint='/NNvision/python_client/start.sh',
            name='nnvision'+str(docker_conf['docker_version']),
            network_mode='host',
            runtime='nvidia',
            environment=["NVIDIA_VISIBLE_DEVICES=all", "NVIDIA_DRIVER_CAPABILITIES=compute,utility,video"],
            volumes={'/home/nnvision/conf': {'bind': '/NNvision/python_client/settings',
                                             'mode': 'rw'},
                     '/usr/src/jetson_multimedia_api': {'bind': '/usr/src/jetson_multimedia_api',
                                                        'mode': 'rw'},
                     'nn_camera': {'bind': '/NNvision/python_client/camera',
                                   'mode': 'rw'},
                     '/proc/device-tree/chosen': {'bind': '/NNvision/uuid',
                                                  'mode': 'rw'},
                     },
            detach=True,
                              )
        # clean unused images
        client.images.prune()


# SECOND PART IS TO CHECK IF REBOOT ------------------------------------------------------------------------------------
def reboot(docker_conf):
    if docker_conf['reboot']:
        os.system('sudo reboot')


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


if __name__ == "__main__":
    conf = {'docker_version': 1.0, 'reboot': False}
    try:
        with open("conf/docker.json") as version:
            conf = json.load(version)
    except FileNotFoundError:
        pass
    update_docker(conf)
    reboot(conf)
    install_update_docker_cron()
