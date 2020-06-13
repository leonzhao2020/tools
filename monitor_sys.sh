#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	Description: Parse yaml files
#	Version: v0.1 
#	Date: 2020-06-02
#	Modified by: Leon <leonzhao2020@outlook.com>
#	Blog: 
#=================================================

####################################################################################################
#                                        Tecmint_monitor.sh                                        #
# Written for Tecmint.com for the post www.tecmint.com/linux-server-health-monitoring-script/      #
# If any bug, report us in the link below                                                          #
# Free to use/edit/distribute the code below by                                                    #
# giving proper credit to Tecmint.com and Author                                                   #
#                                                                                                  #
####################################################################################################

# clear the screen
clear

unset tcolor os architecture kernelrelease internalip externalip nameserver loadaverage

while getopts iv name
do
        case $name in
        # -i, install the script to /usr/bin/
          i)iopt=1;;
          v)vopt=1;;
          *)echo "Invalid arg";;
        esac
done

if [[ ! -z $iopt ]]
then
{
wd=$(pwd)
basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
su -c "cp $scriptname /usr/bin/monitor_sys && chmod a+x /usr/bin/monitor_sys" root && echo "Congratulations! Script Installed, now run monitor Command" || echo "Installation failed"
}
fi

if [[ ! -z $vopt ]]
then
{
echo -e "tecmint_monitor version 0.1\nDesigned by Tecmint.com\nReleased Under Apache 2.0 License"
}
fi

if [[ $# -eq 0 ]]
then
{


# Define Variable tcolor for change the font color of key names
tcolor=$(tput sgr0)

# Check if connected to Internet or not
ping -c 1 google.com &> /dev/null && echo -e '\E[32m'"Internet: $tcolor Connected" || echo -e '\E[32m'"Internet: $tcolor Disconnected"

# Check OS Type
os=$(uname -o)
echo -e '\E[32m'"Operating System Type :" $tcolor $os

# Check OS Release Version and Name
cat /etc/os-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' > /tmp/osrelease
echo -n -e '\E[32m'"OS Name :" $tcolor  && awk -F '=' '/^NAME=/{ print $NF }' /tmp/osrelease
echo -n -e '\E[32m'"OS Version :" $tcolor && awk -F '=' '/^VERSION/{ print $NF }' /tmp/osrelease

# Check Architecture
architecture=$(uname -m)
echo -e '\E[32m'"Architecture :" $tcolor $architecture

# Check Kernel Release
kernelrelease=$(uname -r)
echo -e '\E[32m'"Kernel Release :" $tcolor $kernelrelease

# Check hostname
echo -e '\E[32m'"Hostname :" $tcolor $HOSTNAME

# Check Internal IP
internalip=$(hostname -I)
echo -e '\E[32m'"Internal IP :" $tcolor $internalip

# Check External IP
externalip=$(curl -s ipecho.net/plain;echo)
echo -e '\E[32m'"External IP : $tcolor "$externalip

# Check DNS
nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
echo -e '\E[32m'"Name Servers :" $tcolor $nameservers 

# Check Logged In Users
who>/tmp/who
echo -e '\E[32m'"Logged In users :" $tcolor && cat /tmp/who 

# Check RAM and SWAP Usages
free -h | grep -v + > /tmp/ramcache
echo -e '\E[32m'"Ram Usages :" $tcolor
cat /tmp/ramcache | grep -v "Swap"
echo -e '\E[32m'"Swap Usages :" $tcolor
cat /tmp/ramcache | grep -v "Mem"

# Check Disk Usages
df -h| grep 'Filesystem\|/dev/sda*' > /tmp/diskusage
echo -e '\E[32m'"Disk Usages :" $tcolor 
cat /tmp/diskusage

# Check Load Average
loadaverage=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')
echo -e '\E[32m'"Load Average :" $tcolor $loadaverage "(last 1m, 5m, and 15 minutes)"

# Check vmstat for IO, Memory performance
echo -e '\E[32m'"Running vmstat, please wait couple of seconds" $tcolor
echo -e '\E[32m'"vmstate Output :" $tcolor
vmstat 5 2


# Check System Uptime
tecuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
echo -e '\E[32m'"System Uptime Days/(HH:MM) :" $tcolor $tecuptime







# Unset Variables
unset tcolor os architecture kernelrelease internalip externalip nameserver loadaverage

# Remove Temporary Files
rm /tmp/osrelease /tmp/who /tmp/ramcache /tmp/diskusage
}
fi
shift $(($OPTIND -1))
