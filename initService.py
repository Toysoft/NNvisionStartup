import json
import docker
from docker.errors import APIError, TLSParameterError


# FIRST PART IS TO RUN THE GOOD CONTAINER VERSION ----------------------------------------------------------------------

# get the version of the image to run
try:
    with open("conf/docker.json") as version:
        docker_conf = json.load(version)
except FileNotFoundError:
    # default version
    docker_conf = {'docker_version': 1.0}


# test if container nnvision is running
client = docker.from_env()
# test if container nnvision is running
if not client.containers.list(filters={'name': 'nnvision'+str(docker_conf['docker_version'])}):
    client.containers.prune()
    # test if image is existing
    try:
        image = client.images.get('roboticia/nnvision_jetson_nano:'+str(docker_conf['docker_version']))
    except docker.errors.ImageNotFound:
        # pull the image
        client.login(username='nnvisionpull',
                     password='jouvenciaprotecia69',
                     email='dockerpull@roboticia.com',
                     registry='https://index.docker.io/v1/')
        client.images.pull("roboticia/nnvision_jetson_nano:"+str(docker_conf['docker_version']))
    client.containers.run("roboticia/nnvision_jetson_nano:"+str(docker_conf['docker_version']),
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
                                  })


# SECOND PART IS TO CHECK IF REBOOT ------------------------------------------------------------------------------------



# THIRD PART IS TO INSTALL CRON (only first run) -----------------------------------------------------------------------



