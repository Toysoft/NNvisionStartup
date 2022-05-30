# Finish action to build nnvision image after running Dockerfile_nano_xavier

## 1 - Compile Darknet, ffmpeg and jetson-ffmpeg

Start the base container :

    bash start_compile.sh

When in the container launch the compile script :

    bash compile.sh

## 2 - Clone the python_client repo

    git clone https://github.com/Protecia/python_client.git


## 3 - Add the ssh key on the server

    ssh-keygen -t rsa
    ssh-copy-id -i ~/.ssh/id_rsa.pub -p 2223 tunnel@dev.protecia.com
    ssh-copy-id -i ~/.ssh/id_rsa.pub -p 2223 tunnel@mdm.jouvencia.net

It is recommended to make a saved image at this point :

    docker commit nnvision roboticia/nnvision_jetson_nano:2.1

Restart using the start.sh script

    bash start.sh 2.1

## 4 - Compile tkDNN

### 1 - Get the files
Using gdown is a nice way to get files from google drive : 

    git clone https://github.com/jouvencia/tkDNN.git # if not already done in dockerfile
    pip3 install gdown

   
Get the cfg file 

    cd tkDNN/tests/darknet/cfg/    
    gdown --id 1zEPgDcjKaqOSzLOs-aI0ZfQwhjSlzGG8 --output room_detector.cfg
    
Get the names files

    cd tkDNN/tests/darknet/names/
    gdown --id 1tPB8BwRFi1LHId02aGJjGxsrb9w5zHCW --output room_detector.names

Make the .cpp code to build the engine. yolo4_room_detector.cpp is an example
and is already in the Jouvencia tkDNN repo. Here are the lines you should adapt to your case :

```
bin_path = custom_yolo
cfg_path = / 
names_path = /
```

Now make your weights folder

    cd tkDNN/tests/darknet
    mkdir weights
    cd weights
    gdown --id 1UiyYYi9jjjDpPOxqGcNLLB-yWL32-joo --output room_detector.weights

###2 - Compile the tkDNN

You should be in tkDNN folder.

    mkdir build
    cd build
    cmake ..
    make -j4

Now, it is neccessary to clone a fork from darknet to export the darknet weight
to a special format needed by tkDNN. This Darknet can be compiled to use
CPU because it is only to export weights.

    git clone https://git.hipert.unimore.it/fgatti/darknet.git

#### if certificate fail :
    apt install --reinstall ca-certificates
    
#### compile darknet cpu mode

    cd darknet
    make -j4
    mkdir layers debug

You have to make the folder for the weights :

    mkdir /NNvision/tkDNN/build/room_detector/debug/
    mkdir /NNvision/tkDNN/build/room_detector/layers/

Use the script darknet_weight_to_tkDNN.sh <cfg> <weights> to make and copy
the weights to the rights location (tkDNN/build/<custom_yolo>/).
The script have to be launch from the darknet folder. 

    bash ../../darknet_weight_to_tkDNN.sh room_detector.cfg room_detector.weights

you should see an executable file called “test_<custom_name>”
Notice that to build on Jetson Nano in fp32 you need 4Gb of swap memory.
launch it with the command:

    ./test_yolo4_room_detector

This will create the engine .rt file corresponding to your model.

It is a bit strange but a successfull process should end with an aborting message. If the .rt file is in the build folder then it’s ok.

By default this will create an engine with FP32 weights
In case you wanted to use FP16 (which will reduce the memory consumption)
Build on fp16 is possible with about 3.5Gb RAM and 0Gb swap.

First rm all the *.rt file (or move it elsewhere)
In the build folder:

    export TKDNN_MODE=FP16
    ./test_<custom_name>
To work, you just need the .rt file, the darknet.RT.so librairie and of course the wrapper python (darknet_RT.py)







