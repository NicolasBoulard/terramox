#!/bin/bash
echo -e "\e[38;5;32m#######################################\e[0m"
echo -e "\e[38;5;32mLogged as: \t\e[0m$(whoami)@$(hostname)"
echo -e "\e[38;5;32mIP address: \t\e[0m$(hostname -I | awk '{print $1}')"
echo -e "\e[38;5;32mUptime: \t\e[0m$(uptime -p | sed 's/up //g')"