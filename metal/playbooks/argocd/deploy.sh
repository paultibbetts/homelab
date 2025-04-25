#!/bin/bash
pip3 install -r requirements.txt
ansible-galaxy install -r requirements.yaml
ansible-playbook main.yaml -K
