cd jetson-ffmpeg
git apply ffmpeg_nvmpi.patch
./configure --enable-nvmpi --enable-nonfree --enable-shared --enable-gpl --enable-libx264 --cc="gcc -fPIC"
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