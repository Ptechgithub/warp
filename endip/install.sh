#!/bin/bash

#colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
white='\033[0;37m'
rest='\033[0m'

case "$(uname -m)" in
	x86_64 | x64 | amd64 )
	    cpu=amd64
	;;
	i386 | i686 )
        cpu=386
	;;
	armv8 | armv8l | arm64 | aarch64 )
        cpu=arm64
	;;
	armv7l )
        cpu=arm
	;;
	* )
	echo "The current architecture is $(uname -m), not supported"
	exit
	;;
esac

cfwarpIP() {
    if [[ ! -f "$PREFIX/bin/warpendpoint" ]]; then
        echo "Downloading warpendpoint program"
        if [[ -n $cpu ]]; then
            curl -L -o warpendpoint -# --retry 2 https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/$cpu
            cp warpendpoint $PREFIX/bin
            chmod +x $PREFIX/bin/warpendpoint
        fi
    fi
}

endipv4(){
	n=0
	iplist=100
	while true
	do
		temp[$n]=$(echo 162.159.192.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.96.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.97.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.98.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo 188.114.99.$(($RANDOM%256)))
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
	done
	while true
	do
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.192.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.193.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 162.159.195.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.96.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.97.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.98.$(($RANDOM%256)))
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo 188.114.99.$(($RANDOM%256)))
			n=$[$n+1]
		fi
	done
}

endipv6(){
	n=0
	iplist=100
	while true
	do
		temp[$n]=$(echo [2606:4700:d0::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
		temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
		n=$[$n+1]
		if [ $n -ge $iplist ]
		then
			break
		fi
	done
	while true
	do
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo [2606:4700:d0::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
			n=$[$n+1]
		fi
		if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
		then
			break
		else
			temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2)))])
			n=$[$n+1]
		fi
	done
}

generate() {
  if ! command -v wgcf &>/dev/null; then
    echo -e "${purple}*********************${rest}"
    echo -e "${green}Downloading the required file ...${rest}"
    wget https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/wgcf -P "$PREFIX/bin"
    chmod +x "$PREFIX/bin/wgcf"
  fi
  
  echo -e "${purple}*********************${rest}"
  echo -e "${green}Generating please wait ...${rest}"
  wgcf register --accept-tos
  echo -e "${blue}***********************${rest}"
  wgcf generate
  rm wgcf-account.toml >/dev/null 2>&1
  
  echo ""
  echo -e "${purple}************************************${rest}"
  echo -e "${green}   👇Here is WireGuard Config👇${rest}"
  echo -e "${purple}************************************${rest}"
  cat wgcf-profile.conf
  echo -e "${purple}************************************${rest}"
}

endipresult() {
    echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u > ip.txt
    ulimit -n 102400
    chmod +x warpendpoint >/dev/null 2>&1
    if command -v warpendpoint &>/dev/null; then
        warpendpoint
   else
        ./warpendpoint
    fi
    
    clear
    cat result.csv | awk -F, '$3!="timeout ms" {print} ' | sort -t, -nk2 -nk3 | uniq | head -11 | awk -F, '{print "Endpoint "$1" Packet Loss Rate "$2" Average Delay "$3}'
    Endip_v4=$(cat result.csv | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+" | head -n 1)
    Endip_v6=$(cat result.csv | grep -oE "\[.*\]:[0-9]+" | head -n 1)
    delay=$(cat result.csv | grep -oE "[0-9]+ ms|timeout" | head -n 1)
    echo ""
    echo -e "${green}Results Saved in result.csv${rest}"
    echo ""
    if [ "$Endip_v4" ]; then
        echo -e "${purple}************************************${rest}"
        echo -e "${purple}*           ${yellow}Best IPv4:Port${purple}         *${rest}"
        echo -e "${purple}*                                  *${rest}"
        echo -e "${purple}*          ${cyan}$Endip_v4${purple}     *${rest}"
        echo -e "${purple}*           ${cyan}Delay: ${green}[$delay]        ${purple}*${rest}"
        echo -e "${purple}************************************${rest}"
    elif [ "$Endip_v6" ]; then
        echo -e "${purple}********************************************${rest}"
        echo -e "${purple}*          ${yellow}Best [IPv6]:Port                ${purple}*${rest}"
        echo -e "${purple}*                                          *${rest}"
        echo -e "${purple}* ${cyan}$Endip_v6${purple} *${rest}"
        echo -e "${purple}*           ${cyan}Delay: ${green}[$delay]               ${purple}*${rest}"
        echo -e "${purple}********************************************${rest}"
    else
        echo -e "${red} No valid IP addresses found.${rest}"
    fi
    rm warpendpoint >/dev/null 2>&1
    rm -rf ip.txt
    exit
}

clear
echo -e "${cyan}By --> Peyman * Github.com/Ptechgithub * ${rest}"
echo ""
echo -e "${purple}*********************${rest}"
echo -e "${purple}* ${green}Endpoint Scanner ${purple} *${rest}"
echo -e "${purple}*********************${rest}"
echo -e "${purple}[1] ${blue}Preferred${green} IPV4${purple}  * ${rest}"
echo -e "${purple}                    *${rest}"
echo -e "${purple}[2] ${blue}Preferred${green} IPV6${purple}  * ${rest}"
echo -e "${purple}                    *${rest}"
echo -e "${purple}[3] ${green}Get Warp Config${purple} *${rest}"
echo -e "${purple}                    *${rest}"
echo -e "${purple}[${red}0${purple}] Exit            *${rest}"
echo -e "${purple}*********************${rest}"
echo -en "${cyan}Enter your choice: ${rest}"
read -r choice
case "$choice" in
    1)
        echo -e "${purple}*********************${rest}"
        cfwarpIP
        endipv4
        endipresult
        Endip_v4
        ;;
    2)
        echo -e "${purple}*********************${rest}"
        cfwarpIP
        endipv6
        endipresult
        Endip_v6
        ;;
    3)
        generate
        ;;
    0)
        echo -e "${purple}*********************${rest}"
        echo -e "${cyan}By 🖐${rest}"
        exit
        ;;
    *)
        echo -e "${yellow}********************${rest}"
        echo "Invalid choice. Please select a valid option."
        ;;
esac