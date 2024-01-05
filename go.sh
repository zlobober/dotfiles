#!/bin/bash

./apt_repos.sh
./apt.sh
./kubectl.sh
./vim.sh

echo -e "\
TODO: \n
  * merge .bashrc by hand
"
