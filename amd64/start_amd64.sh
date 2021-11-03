#!/bin/bash
docker run  -it --entrypoint /bin/bash --gpus=all --name nnvision --net=host \
            -e NVIDIA_VISIBLE_DEVICES=all \
            -e NVIDIA_DRIVER_CAPABILITIES=compute,utility,video  \
            -v /home/nnvision/conf:/NNvision/python_client/conf \
            -v nn_camera:/NNvision/python_client/camera \
            -v /home/nnvision/uuid:/NNvision/uuid \
            --rm roboticia/nnvision_client_amd64:1.0
