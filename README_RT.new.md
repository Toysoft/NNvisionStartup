# Finish action to build nnvision image after running Dockerfile_nano_xavier

## 1 - Clone the python_client repo

    git clone https://github.com/Protecia/python_client.git
    git checkout total_async

## 2 - Compile tkDNN

    cd tkDNN/tests/darknet/cfg/
cp the cfg file of your custom_yolo in this folder

    cd ../names/

cp your custom_yolo.names file inside this folder

    cd ..
    mkdir weights
    cd weights
cp your custom_yolo.weights file here

    cd ..
here duplicate the yolo4.cpp and rename it with your custom_yolo name
open this file with nano and edited like this

 edit yolo4.cpp 

```
bin_path = custom_yolo
cfg_path = / 
names_path = /
```



Exit nano

    cd ../.. 

(you should be in tkDNN folder)

    mkdir build
    cd build
    cmake ..
    make -j4

mkdir a folder and name it as in the yolo_custom.cpp (the name you first replace in this file)

    cd ..

should be again in /tkDNN folder

    git clone https://git.hipert.unimore.it/fgatti/darknet.git

### if certificate fail :
    apt install --reinstall ca-certificates
    
### recompile darknet using tkDNN

    cd darknet
    make
    mkdir layers debug
    ./darknet export <path-to-cfg-file> <path-to-weights> layers

mv folders layers and debug inside the /tkDNN/build/custom_name/
go back to /tkDNN/build/
you should see an executable file called “test_<custom_name>”
launch it with the command:
./ test_<custom_name>

This will create the engine .rt file corresponding to your model.

It is a bit strange but a successfull process should end with an aborting message. If the .rt file is in the build folder then it’s ok.

By default this will create an engine with FP32 weights
In case you wanted to use FP16 (which will reduce the memory consumption)

First rm all the *.rt file (or move it elsewhere)
In the build folder:

    export TKDNN_MODE=FP16
    ./test_<custom_name>
To work, you just need the .rt file, the darknet.RT.so librairie and of course the wrapper python (darknet_RT.py)






