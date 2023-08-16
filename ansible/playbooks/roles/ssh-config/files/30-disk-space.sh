#!/bin/bash
total_disk=$(df -BG --total | awk '/^total/{print $2}' | awk '{print substr($0, 1, length($0)-1)}')
used_disk=$(df -BG --total | awk '/^total/{print $3}' | awk '{print substr($0, 1, length($0)-1)}')
free_disk=$(df -BG --total | awk '/^total/{print $4}' | awk '{print substr($0, 1, length($0)-1)}')
bar_len=20

used_slots=$(($used_disk * $bar_len / $total_disk))
free_slots=$(($bar_len - $used_slots))

bar="["
for ((i=0; i<$used_slots; i++)); do
    bar+="\e[38;5;196m=\e[0m"
done

for ((i=0; i<$free_slots; i++)); do
    bar+="\e[38;5;34m=\e[0m"
done
bar+="]"

echo -e "\e[38;5;32mDisk: \t\t\e[0mused: \e[38;5;196m${used_disk}G\e[0m, free: \e[38;5;34m${free_disk}G\e[0m, total: ${total_disk}G\e[0m"
echo -e "\t\t${bar} $((used_disk * 100 / total_disk))%"
