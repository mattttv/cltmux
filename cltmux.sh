#!/bin/bash
#set -o xtrace
function help() {
    echo "usage: $0 \"host1 host2 ... hostn\""
    echo "exit"
    exit 1
}

if [ -z "$1"  ]; then
    help
fi
IFS=' ' read -r -a hosts <<< "$1"
echo "amount of hosts: ${#hosts[@]}"
full="false"
todo_hosts=""
con_hosts_counter=0
for host in "${hosts[@]}"
do
    if [ $full == "false" ];then
        tmux splitw -l 1 "ssh $host"
        if [ 1 -eq $? ]; then
            echo "no more room while executing $host"
            full="true"
            #ssh "$host"
        else
            echo "OK: opened terminal for $host"
            con_hosts_counter=$((con_hosts_counter+1))
            tmux select-pane -t 1
        fi    
    else
        todo_hosts="$todo_hosts $host"     
    fi
done
tmux set-window-option synchronize-panes on
echo ""
echo "connected with $con_hosts_counter hosts"
todo_hosts_counter=$((${#hosts[@]}-$con_hosts_counter))
echo "$todo_hosts_counter remaining hosts: \"$todo_hosts\""
