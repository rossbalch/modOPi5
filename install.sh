#!/bin/bash -e

set -x

#Install Dependancies
sudo apt-get -y install virtualenv python3-pip python3-dev git build-essential libasound2-dev libjack-jackd2-dev liblilv-dev libjpeg-dev zlib1g-dev cmake debhelper dh-autoreconf dh-python gperf intltool ladspa-sdk libarmadillo-dev libasound2-dev libavahi-gobject-dev libavcodec-dev libavutil-dev libbluetooth-dev libboost-dev libeigen3-dev libfftw3-dev libglib2.0-dev libglibmm-2.4-dev libgtk2.0-dev libgtkmm-2.4-dev libjack-jackd2-dev libjack-jackd2-dev liblilv-dev liblrdf0-dev libsamplerate0-dev libsigc++-2.0-dev libsndfile1-dev libsndfile1-dev libzita-convolver-dev libzita-resampler-dev lv2-dev p7zip-full python3-all python3-setuptools libreadline-dev zita-alsa-pcmi-utils hostapd dnsmasq iptables python3-smbus python3-dev liblo-dev libzita-alsa-pcmi-dev 

#Install Python Dependancies
sudo pip3 install pyserial==3.0 pystache==0.5.4 aggdraw==1.3.11 scandir backports.shutil-get-terminal-size
sudo pip3 install pycrypto
sudo pip3 install tornado==4.3
sudo pip3 install Pillow==8.4.0
sudo pip3 install cython

#Install Mod Software
mkdir /home/orangepi/.lv2
mkdir /home/orangepi/data
mkdir /home/orangepi/data/.pedalboards
mkdir /home/orangepi/data/user-files
cd /home/orangepi/data/user-files
mkdir "Speaker Cabinets IRs"
mkdir "Reverb IRs"
mkdir "Audio Loops"
mkdir "Audio Recordings"
mkdir "Audio Samples"
mkdir "Audio Tracks"
mkdir "MIDI Clips"
mkdir "MIDI Songs"
mkdir "Hydrogen Drumkits"
mkdir "SF2 Instruments"
mkdir "SFZ Instruments"

#Jack2
pushd $(mktemp -d) && git clone https://github.com/moddevices/jack2.git
pushd jack2
./waf configure
./waf build
sudo ./waf install

#Browsepy
pushd $(mktemp -d) && git clone https://github.com/moddevices/browsepy.git
pushd browsepy
sudo pip3 install ./

#Mod-host
pushd $(mktemp -d) && git clone https://github.com/moddevices/mod-host.git
pushd mod-host
make -j 4
sudo make install

#Mod-ui
pushd $(mktemp -d) && git clone https://github.com/moddevices/mod-ui.git
pushd mod-ui
chmod +x setup.py
cd utils
make
cd ..
sudo ./setup.py install

#Create Services
sudo cp *.service /usr/lib/systemd/system/
sudo ln -sf /usr/lib/systemd/system/browsepy.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/jack.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/mod-host.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/mod-ui.service /etc/systemd/system/multi-user.target.wants
