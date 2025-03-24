#!/bin/bash

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
# mkdir -p python
# cp -r venv/lib python/
# deactivate
