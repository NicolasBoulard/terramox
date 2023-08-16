#!/bin/bash
last_login=$(last -1 -F | awk 'NR==1 {print $4, $5, $6, $7}' | xargs -I{} date -d "{} UTC+2" +"%d/%m/%Y %H:%M:%S")
echo -e "\e[38;5;32mLast login: \t\e[0m${last_login}"