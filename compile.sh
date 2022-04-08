cd jetson-ffmpeg
cmake .
make -j4
make install
ldconfig
sleep 2

cd ../ffmpeg
git apply ffmpeg_nvmpi.patch
./configure --enable-nvmpi --enable-nonfree --enable-shared --enable-gpl --enable-libx264 --cc="gcc -fPIC"
make -j4
make install
ldconfig
sleep 2

cd ../darknet
make -j4
ldconfig