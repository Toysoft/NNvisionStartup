cd jetson-ffmpeg
make -j4
make install
ldconfig

cd ffmpeg
make -j4
make install
ldconfig

cd darknet
make -j4
ldconfig