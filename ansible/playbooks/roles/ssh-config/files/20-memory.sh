#!/bin/bash
total_mem=$(free -m | awk '/^Mem:/{print $2}')
used_mem=$(free -m | awk '/^Mem:/{print $3}')
free_mem=$(free -m | awk '/^Mem:/{print $4}')
bar_len=20

used_slots=$(($used_mem * $bar_len / $total_mem))
free_slots=$(($bar_len - $used_slots))

bar="["
for ((i=0; i<$used_slots; i++)); do
    bar+="\e[38;5;202m=\e[0m"
done

for ((i=0; i<$free_slots; i++)); do
    bar+="\e[38;5;34m=\e[0m"
done
bar+="]"

echo -e "\e[38;5;32mMemory: \t\e[0mused: \e[38;5;202m${used_mem}M\e[0m, free: \e[38;5;34m${free_mem}M\e[0m, total: ${total_mem}M\e[0m"
echo -e "\t\t${bar} $((used_mem * 100 / total_mem))%"
