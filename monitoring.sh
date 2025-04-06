#!/bin/bash
#if [ "$(id -u)" -ne 0 ]; then
#    exit 1
#fi
kernel_name=$(uname -s 2>/dev/null);
node_name=$(uname -n 2>/dev/null)
kernel_release=$(uname -r 2>/dev/null);
kernel_version=$(uname -v 2>/dev/null);
hardware_name=$(uname -m 2>/dev/null);
operating_system=$(uname -o 2>/dev/null);
tcp_connections=$(netstat -t 2>/dev/null | grep -iwc "established" 2>/dev/null);
logged_users=$(users 2>/dev/null | tr ' ' '\n' 2>/dev/null | sort 2>/dev/null | uniq 2>/dev/null | wc -l 2>/dev/null);
logical_address=$(hostname -I 2>/dev/null);
physical_address=$(ip addr 2>/dev/null | grep -iw "ether" 2>/dev/null | awk '{print $2}' 2>/dev/null);
physical_cpu=$(grep -wi "physical id" /proc/cpuinfo 2>/dev/null | wc -l 2>/dev/null);
virtual_cpu=$(grep -wi "processor" /proc/cpuinfo 2>/dev/null | wc -l 2>/dev/null);
cpu_load=$(mpstat 2>/dev/null | tail -n 1 2>/dev/null | awk '{print 100-$NF}' 2>/dev/null);
disk=$(df -BM --total 2>/dev/null | grep -iw "total" 2>/dev/null | awk '{printf("%d/%dGb(%d%%)"),$3,$2/1024, $5}' 2>/dev/null);
ram=$(free --mega 2>/dev/null | grep -iw "Mem" 2>/dev/null | awk '{printf("%d/%dMB (%.2f%%)", $3, $2, $3/$2*100)}' 2>/dev/null);
last_boot=$(who -b 2>/dev/null | awk '{print $3, $4, $5}' 2>/dev/null);
lvm_status=$(lsblk 2>/dev/null | grep -iwq "lvm" 2>/dev/null && echo -n "yes" || echo -n "no" 2>/dev/null);
sudo_cmds=$(journalctl -q 2>/dev/null | grep -i "COMM" 2>/dev/null | wc -l 2>/dev/null);
cy=$(echo -e "\033[3;36m");
ye=$(echo -e "\033[38;5;214m");
br=$(echo -e "\033[1;33m");
db=$(echo -e "\033[38;5;94m");
wh=$(echo -e "\033[0;37m");
re=$(echo -e "\033[0m");
message="
$ye------------------------------------------------------------------------------------------------------------------------------------------$re
$db=$br=$ye=$cy IMFORMATIONS OF SYSTEM $ye=$br=$db=$re
$ye------------------------------------------------------------------------------------------------------------------------------------------$re
$db>$br>$ye>$cy Architecture of sytsem  : $wh $kernel_name $node_name $kernel_release $kernel_version $hardware_name $operating_system $re
$db>$br>$ye>$cy Physical CPU            : $wh $physical_cpu $re
$db>$br>$ye>$cy Virtual CPU             : $wh $virtual_cpu $re
$db>$br>$ye>$cy Memory Usage            : $wh $ram $re
$db>$br>$ye>$cy Disk Usage              : $wh $disk $re
$db>$br>$ye>$cy CPU load                : $wh $cpu_load% $re
$db>$br>$ye>$cy Last boot               : $wh $last_boot $re
$db>$br>$ye>$cy LVM status use          : $wh $lvm_status $re
$db>$br>$ye>$cy Connections TCP         : $wh $tcp_connections Established $re
$db>$br>$ye>$cy User log                : $wh $logged_users Logged $re
$db>$br>$ye>$cy Network Addresses       : $wh IP $logical_address MAC ($physical_address) $re
$db>$br>$ye>$cy Sudo commands           : $wh $sudo_cmds Cmd $re
$ye---------------------------------------------------------------------------------------------------------------------------------------$re
";
all_terminals=$(who | awk '{print $2}'| wc -l);
lists_of_terminals=$(who | awk '{print $2}');
number_of_line=1;
while [ $all_terminals -ne 0 ]; do
    me=$(whoami);
    terminal=$(who | awk '{print $2}' | sort | uniq | sed -n "${number_of_line}p");
    hname=$(hostname);
    tmnl=$(who -m | grep "$me" | awk '{print $2}');
    datetime=$(date | awk '{print $1, $2, $3, $4, $7}');
    number_of_line=$((number_of_line + 1));
    all_terminals=$((all_terminals - 1));
    echo -e "\n$ye Boradcast message from $me@$hname ($tmnl) ($datetime) :$re\n" > "/dev/$terminal" 2>/dev/null;
    echo -e "$message" > "/dev/$terminal" 2>/dev/null;
done
