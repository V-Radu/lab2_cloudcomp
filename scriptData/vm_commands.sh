#!/bin/bash
rm -rf lab2

mkdir lab2
cd lab2
sudo apt-get update
sudo apt-get install python3
sudo apt-get install python3-pip
sudo pip3 install virtualenv
virtualenv myVEN
source myVEN/bin/activate
ls -l -a
sleep 5

pip install Flask
git clone "https://github.com/V-Radu/lab2_cloudcomp.git"
mv lab2_cloudcomp/server.py server.py

export FLASK_APP=server.py
flask run --host=0.0.0.0 --port=8080



