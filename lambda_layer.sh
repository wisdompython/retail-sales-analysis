#!/bin/bash

python3 -m venv venv
source venv/bin/activate
pip install requests
mkdir -p python
cp -r venv/lib python/
deactivate
