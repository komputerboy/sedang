#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.me/ip);
echo "Checking VPS"
IZIN=$( curl https://raw.githubusercontent.com/SSHSEDANG4/sshsedang/main/kota/ipvps | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${green}Permission Accepted...${NC}"
else
echo -e "${red}Permission Denied!${NC}";
echo "Only For Premium Users"
exit 0
fi
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/var/lib/premium-script/data-user-sstp")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "Name : Delete SSTP Account" 
		echo "=============================="| lolcat
		echo "You have no existing clients!"
		exit 1
	fi

	echo ""
	echo " Name : Delete SSTP Account"
	echo " ==============================" | lolcat
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ===============================" | lolcat
	echo "     No  Expired   User"
	grep -E "^### " "/var/lib/premium-script/data-user-sstp" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Pilih salah satu[1]: " CLIENT_NUMBER
		else
			read -rp "Pilih salah satu [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
Client=$(grep -E "^###" /var/lib/premium-script/data-user-sstp | cut -d ' ' -f 2-3 | sed -n "$CLIENT_NUMBER"p)
user=$(grep -E "^###" /var/lib/premium-script/data-user-sstp | cut -d ' ' -f 2 | sed -n "$CLIENT_NUMBER"p)
exp=$(grep -E "^###" /var/lib/premium-script/data-user-sstp | cut -d ' ' -f 3 | sed -n "$CLIENT_NUMBER"p)
sed -i "/^### $user $exp/d" /var/lib/premium-script/data-user-sstp
sed -i '/^'"$user"'/d' /home/sstp/sstp_account
clear
echo " SSTP Account Has Been Successfully Deleted" | lolcat
echo " ============================"
echo " Client Name : $user"
echo " Expired On  : $exp"
echo " ============================"
echo " Script By SSH SEDANG NETWORK" 
