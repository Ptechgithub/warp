#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
purple='\033[0;35m'
cyan='\033[0;36m'
white='\033[0;37m'
rest='\033[0m'

root_access() {
    # Check if the script is running as root
    if [ "$EUID" -ne 0 ]; then
        echo "This script requires root access. please run as root."
        exit 1
    fi
}

detect_distribution() {
    # Detect the Linux distribution
    local supported_distributions=("ubuntu" "debian" "centos" "fedora")
    
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [[ "${ID}" = "ubuntu" || "${ID}" = "debian" || "${ID}" = "centos" || "${ID}" = "fedora" ]]; then
            pm="apt"
            [ "${ID}" = "centos" ] && pm="yum"
            [ "${ID}" = "fedora" ] && pm="dnf"
        else
            echo "Unsupported distribution!"
            exit 1
        fi
    else
        echo "Unsupported distribution!"
        exit 1
    fi
}

check_dependencies() {
    root_access
    detect_distribution

    local dependencies=("curl" "gnupg" "iptables")
    
    for dep in "${dependencies[@]}"; do
        if ! command -v "${dep}" &> /dev/null; then
            sudo "${pm}" update -y
            echo "${dep} is not installed. Installing..."
            sudo "${pm}" install "${dep}" -y
        fi
    done
}

Install_wgcf() {
    curl -fsSL git.io/wgcf.sh | bash
}

WGCF_conf="/etc/wireguard/wgcf.conf"
Profile_conf="/etc/warp/wgcf-profile.conf"
Wgcf_account="/etc/warp/wgcf-account.toml"
IPv4_addr=$(hostname -I | awk '{print $1}')
IPv6_addr=$(hostname -I | awk '{ for(i=1;i<=NF;i++) if($i~/^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{1,4}$/) {print $i; exit} }')
TestIPv4_1='1.0.0.1'
TestIPv4_2='9.9.9.9'
TestIPv6_1='2606:4700:4700::1001'
TestIPv6_2='2620:fe::fe'
CF_Trace_URL='https://www.cloudflare.com/cdn-cgi/trace'
Warp_ipv4=$(curl -s4 ${CF_Trace_URL} --connect-timeout 2 | grep ip | cut -d= -f2)
Warp_ipv6=$(curl -s6 ${CF_Trace_URL} --connect-timeout 2 | grep ip | cut -d= -f2)
WireGuard_Peer_Endpoint_IP4='162.159.192.1'
WireGuard_Peer_Endpoint_IP6='2606:4700:d0::a29f:c001'
WireGuard_Peer_Endpoint_IPv4="${WireGuard_Peer_Endpoint_IP4}:2408"
WireGuard_Peer_Endpoint_IPv6="[${WireGuard_Peer_Endpoint_IP6}]:2408"
WireGuard_Peer_Endpoint_Domain='engage.cloudflareclient.com:2408'
WireGuard_Peer_AllowedIPs_IPv4='0.0.0.0/0'
WireGuard_Peer_AllowedIPs_IPv6='::/0'
WireGuard_Peer_AllowedIPs_DualStack='0.0.0.0/0,::/0'
SysInfo_OS_Ver_major="$(rpm -E '%{rhel}')"

install_cloudflare_warp_packages() {
    os=$(uname -s)

    if [ "$os" == "Linux" ]; then
        if [ -f /etc/os-release ]; then
            source /etc/os-release
            if [ "$ID" == "ubuntu" ] || [ "$ID" == "debian" ]; then
                curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
                echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
                sudo apt update -y
                sudo apt install cloudflare-warp -y
                sudo apt install iproute2 openresolv -y
                sudo apt install wireguard-tools -y
            elif [ "$ID" == "centos" ]; then
                curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | sudo tee /etc/yum.repos.d/cloudflare-warp.repo
                sudo yum update -y
                yum install epel-release -y || yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-${SysInfo_OS_Ver_major}.noarch.rpm -y
                sudo yum install cloudflare-warp -y
                yum install iproute wireguard-tools -y
            else
                echo "ERROR: This operating system is not supported."
                exit 1
            fi
        else
            echo "ERROR: /etc/os-release not found. Unable to determine the operating system."
            exit 1
        fi
    else
        echo "ERROR: This script is intended for Linux systems only."
        exit 1
    fi
}

Register_NEW_Account() {
    mkdir /etc/warp
    cd /etc/warp
    while [[ ! -f wgcf-account.toml ]]; do
        Install_wgcf
        echo "Cloudflare WARP Account registration in progress..."
        yes | wgcf register
        sleep 5
    done
}

Generate_WireGuard_profile() {
    wgcf generate
}

Read_WGCF_Profile() {
    PrivateKey=$(cat ${Profile_conf} | grep ^PrivateKey | cut -d= -f2- | awk '$1=$1')
    Address=$(cat ${Profile_conf} | grep ^Address | cut -d= -f2- | awk '$1=$1' | sed ":a;N;s/\n/,/g;ta")
    PublicKey=$(cat ${Profile_conf} | grep ^PublicKey | cut -d= -f2- | awk '$1=$1')
}

Get_MTU() {
    echo "Getting the best MTU value for WireGuard..."
    MTU_Preset=1500
    MTU_Increment=10
    if [[ ${IPv4Status} = off && ${IPv6Status} = on ]]; then
        CMD_ping='ping6'
        MTU_TestIP_1="${TestIPv6_1}"
        MTU_TestIP_2="${TestIPv6_2}"
    else
        CMD_ping='ping'
        MTU_TestIP_1="${TestIPv4_1}"
        MTU_TestIP_2="${TestIPv4_2}"
    fi
    while true; do
        if ${CMD_ping} -c1 -W1 -s$((${MTU_Preset} - 28)) -Mdo ${MTU_TestIP_1} >/dev/null 2>&1 || ${CMD_ping} -c1 -W1 -s$((${MTU_Preset} - 28)) -Mdo ${MTU_TestIP_2} >/dev/null 2>&1; then
            MTU_Increment=1
            MTU_Preset=$((${MTU_Preset} + ${MTU_Increment}))
        else
            MTU_Preset=$((${MTU_Preset} - ${MTU_Increment}))
            if [[ ${MTU_Increment} = 1 ]]; then
                break
            fi
        fi
        if [[ ${MTU_Preset} -le 1360 ]]; then
            echo "MTU is set to the lowest value."
            MTU_Preset='1360'
            break
        fi
    done
    Get_MTU=$((${MTU_Preset} - 80))
    echo "WireGuard MTU: ${Get_MTU}"
}

Generate_Wgcf_config() {
    [ -d "/etc/wireguard" ] || mkdir -p "/etc/wireguard"
    Read_WGCF_Profile
    Get_MTU
    echo "WireGuard profile generation in progress..."
    cat <<EOF >${WGCF_conf}
[Interface]
PrivateKey = ${PrivateKey}
Address = ${Address}
DNS = 8.8.8.8,8.8.4.4,2001:4860:4860::8888,2001:4860:4860::8844
MTU = ${Get_MTU}
EOF
    case $user_choice in
	    1)
	        AllowedIP=${WireGuard_Peer_AllowedIPs_IPv4}
	        End=${WireGuard_Peer_Endpoint_IPv4}
	        IPv4_Global_srcIP
	        ;;
	    2)
	        AllowedIP=${WireGuard_Peer_AllowedIPs_IPv6}
	        End=${WireGuard_Peer_Endpoint_IPv6}
	        IPv6_Global_srcIP
	        ;;
	    3)
	        AllowedIP=${WireGuard_Peer_AllowedIPs_DualStack}
	        End=${WireGuard_Peer_Endpoint_Domain}
	        IPv4_Global_srcIP
            IPv6_Global_srcIP
	        ;;
	    *)
	        echo "Invalid choice. Please choose 1, 2, 3, or 0."
	        ;;
	esac
    Generate_Wgcf_config_Peer
}

IPv4_Global_srcIP() {
    cat <<EOF >>${WGCF_conf}
PostUp = ip -4 rule add from ${IPv4_addr} lookup main prio 18
PostDown = ip -4 rule delete from ${IPv4_addr} lookup main prio 18
EOF
}

IPv6_Global_srcIP() {
    cat <<EOF >>${WGCF_conf}
PostUp = ip -6 rule add from ${IPv6_addr} lookup main prio 18
PostDown = ip -6 rule delete from ${IPv6_addr} lookup main prio 18
EOF
}

Generate_Wgcf_config_Peer() {
    cat <<EOF >>${WGCF_conf}

[Peer]
PublicKey = ${PublicKey}
AllowedIPs = ${AllowedIP}
Endpoint = ${End}
EOF
}


Install() {
    echo -e "${cyan}----------------------------------${rest}"
    echo -e "${yellow}Install warp on:${rest}"
	echo -e "${purple}1) ${green}IPV4${rest}"
	echo -e "${purple}2) ${green}IPV6${rest}"
	echo -e "${purple}3) ${green}Both [IPV4 & IPV6]${rest}"
	
	read -p "Choose an option: " user_choice
	check_dependencies
    Install_wgcf
    install_cloudflare_warp_packages
    Register_NEW_Account
    Generate_WireGuard_profile
    Generate_Wgcf_config
    (crontab -l ; echo "0 4 * * * systemctl restart wg-quick@wgcf;systemctl restart warp-svc") | sort - | uniq - | crontab -
    systemctl enable --now wg-quick@wgcf
    echo "Please Wait ..."
	sleep 1
    echo ""
    echo -e "${cyan}----------------------------------${rest}"
    WireGuard_Status
    echo -e "${cyan}----------------------------------${rest}"
    echo ""
}

Uninstall() {
    if sudo systemctl is-enabled --quiet wg-quick@wgcf.service; then
        echo "Uninstalling . . ."
	    apt purge cloudflare-warp -y > /dev/null 2>&1
	    yum purge cloudflare-warp -y > /dev/null 2>&1
	    rm -f /etc/apt/sources.list.d/cloudflare-client.list /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg > /dev/null 2>&1
	    rm -f /etc/yum.repos.d/cloudflare-warp.repo > /dev/null 2>&1
	    rm -rf /etc/warp
	    rm -rf /etc/wireguard
	    systemctl stop wg-quick@wgcf
	    systemctl disable wg-quick@wgcf
	    echo -e "${green}Uninstallation completed successfully.${rest}"
	    read -p "Please press [Enter] to reboot the server or press [Ctrl+C] to cancel." userInput
	    [ -z "$userInput" ] && reboot
	else
	    echo "Warp is not installed."
	fi
}

Warp_plus() {
    echo -e "${cyan}----------------------------------${rest}"
    read -p "Enter Warp[+] License Key: " new_license
    echo -e "${cyan}----------------------------------${rest}"
    echo -e "${yellow}Install warp ${purple}+ ${yellow}on:${rest}"
	echo -e "${purple}1) ${green}IPV4${rest}"
	echo -e "${purple}2) ${green}IPV6${rest}"
	echo -e "${purple}3) ${green}Both [IPV4 & IPV6]${rest}"
	
	read -p "Choose an option: " user_choice
    check_dependencies
    Install_wgcf
    install_cloudflare_warp_packages
    Register_NEW_Account
	sed -i "s/\(license_key = \).*/\1'${new_license}'/" "wgcf-account.toml"
	wgcf update
	Generate_WireGuard_profile
	Generate_Wgcf_config
	(crontab -l ; echo "0 4 * * * systemctl restart wg-quick@wgcf;systemctl restart warp-svc") | sort - | uniq - | crontab -
    systemctl enable wg-quick@wgcf
    systemctl start wg-quick@wgcf
    echo ""
    echo -e "${cyan}----------------------------------${rest}"
    WireGuard_Status
    echo -e "${cyan}----------------------------------${rest}"
    echo ""
}

Check_WARP_WireGuard_Status() {
    WARP_IPv4_Status=$(curl -s4 ${CF_Trace_URL} --connect-timeout 2 | grep warp | cut -d= -f2)
    WARP_IPv6_Status=$(curl -s6 ${CF_Trace_URL} --connect-timeout 2 | grep warp | cut -d= -f2)

    if [[ ${WARP_IPv4_Status} = on ]]; then
        echo -e "${cyan}IPV4: ${purple}WARP  --> ${yellow}${Warp_ipv4}${rest}"
    elif [[ ${WARP_IPv4_Status} = plus ]]; then
        echo -e "${cyan}IPV4: ${purple}WARP+ --> ${yellow}${Warp_ipv4}${rest}"
    else
        echo -e "${cyan}IPv4: Normal (off)${rest}"
    fi

    if [[ ${WARP_IPv6_Status} = on ]]; then
        echo -e "${cyan}IPV6: ${purple}WARP --> ${yellow}${Warp_ipv6}${rest}"
    elif [[ ${WARP_IPv6_Status} = plus ]]; then
        echo -e "${cyan}IPV6: ${purple}WARP+ --> ${yellow}${Warp_ipv6}${rest}"
    else
        echo -e "${cyan}IPV6: Normal (off)${rest}"
    fi
}

WireGuard_Status() {
    WARP_IPv4_Status=$(curl -s4 ${CF_Trace_URL} --connect-timeout 2 | grep warp | cut -d= -f2)
    WARP_IPv6_Status=$(curl -s6 ${CF_Trace_URL} --connect-timeout 2 | grep warp | cut -d= -f2)

    if [[ ${WARP_IPv4_Status} = on ]]; then
        echo -e "${cyan}IPV4: ${purple}WARP${rest}"
    elif [[ ${WARP_IPv4_Status} = plus ]]; then
        echo -e "${cyan}IPV4: ${purple}WARP+${rest}"
    else
        echo -e "${cyan}IPv4: Normal (off)${rest}"
    fi

    if [[ ${WARP_IPv6_Status} = on ]]; then
        echo -e "${cyan}IPV6: ${purple}WARP ${rest}"
    elif [[ ${WARP_IPv6_Status} = plus ]]; then
        echo -e "${cyan}IPV6: ${purple}WARP+${rest}"
    else
        echo -e "${cyan}IPV6: Normal (off)${rest}"
    fi
}


clear
echo "********************************"
Check_WARP_WireGuard_Status
echo "********************************" 
echo -e "${yellow}By --> Peyman * Github.com/Ptechgithub *${rest}"
echo ""
echo -e "${green}Select an option${rest}: ${rest}"
echo -e "${purple}1) ${green}Install WARP${rest}"
echo -e "${purple}2) ${green}Install [WARP${purple} +${green}]${rest}"
echo -e "${purple}3) ${red}Uninstall${rest}"
echo -e "${purple}0) ${yellow}Exit${rest}"
read -p "Enter your choice: " choice
case "$choice" in
    1)
        Install
        ;;
    2)
        Warp_plus
        ;;
    3)
        echo "Exiting..."
        Uninstall
        ;;
    0)
        exit
        ;;
    *)
        echo "Invalid choice. Please select a valid option."
        ;;
esac