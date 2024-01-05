#!/bin/bash

apt update
apt install $(cat ./apt_pkgs.txt)
