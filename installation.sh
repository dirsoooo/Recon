#!/usr/bin/env bash

VERSION="$(curl -s https://golang.org/dl/ | grep 'toggleVisible' | cut -d '<' -f2- | cut -d '>' -f1 | awk '{print $3}' | cut -d '=' -f2- | tr -d '"' | head -n 1 | cut -d 'o' -f2-)"
ARCH="amd64"
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

bannerInstall() {
	tool=$1
	echo -e "\n\033[1;32m====== Installing $tool ======\033[m"
}


os() {
	echo -e "What is your operating system?"
	echo -e "Type\n\033[1;32m1\033[m for Arch or BlackArch\n\033[1;32m2\033[m for Kali\n\033[1;32m3\033[m for Ubuntu or another Debian based\n\033[1;32m4\033[m for Parrot"
	echo -e -n "> "
	read os
	if [ "$os" == "1" ]; then
		os="arch"
	elif [ "$os" == "2" ]; then
		os="kali"
	elif [ "$os" == "3" ]; then
		os="debian"
	elif [ "$os" == "4" ]; then
		os="parrot"
	else
		echo "Error."
		exit
	fi
}


update() {
	echo -e "\033[1;32m====== Updating your system ======\033[m"
	if [ "$os" == "arch" ]; then
		sudo pacman -Syyuu
	else
		sudo apt-get update -y
		sudo apt-get upgrade -y
		sudo apt-get autoremove -y
		sudo apt clean
	fi
}


installGo() {
	if command -v go version >/dev/null ; then
		echo -e "\033[1;32m[+] Go is already installed!\033[m"
	else
		bannerInstall Go
		if [ "$os" == "arch" ]; then
			sudo pacman -S go
		elif [ "$os" == "kali" ]; then
			sudo apt install golang -y
		else
			sudo apt install golang-go -y
		fi
	fi

	if ! command -v go version >/dev/null;then
		wget "https://golang.org/dl/go${VERSION}.linux-{$ARCH}.tar.gz" -o $SCRIPTPATH/go${VERSION}.linux-${ARCH}.tar.gz
		tar -C $HOME -xf "go${VERSION}.linux-${ARCH}.tar.gz"
		rm -f $SCRIPTPATH/go${VERSION}.linux-${ARCH}.tar.gz
	fi
	if command -v go version >/dev/null;then
		echo -e "\033[1;32m[+] Go installed!\033[m"
	else
		echo -e "\033[1;31m[-] An error occurred when trying to install Golang :(\033[m"
		exit
	fi
	export GOPATH=$HOME/go
	export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
}


installGoTools() {
	bannerInstall "Go tools"
	bannerInstall "Assetfinder"
	go get -u github.com/tomnomnom/assetfinder
	bannerInstall "Subfinder"
	GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
	bannerInstall "Httprobe"
	go get -u github.com/tomnomnom/httprobe
	bannerInstall "Httpx"
	GO111MODULE=on go get -v github.com/projectdiscovery/httpx/cmd/httpx
	bannerInstall "Nuclei"
	GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
	nuclei -update-templates
	bannerInstall "Hakrawler"
	go get github.com/hakluke/hakrawler
	bannerInstall "Waybackurls"
	go get github.com/tomnomnom/waybackurls
	bannerInstall "Ffuf"
	go get -u github.com/ffuf/ffuf
	bannerInstall "Dalfox"
	GO111MODULE=on go get -v github.com/hahwul/dalfox/v2
	bannerInstall "Anti-burl"
	go get -u github.com/tomnomnom/hacks/anti-burl
	bannerInstall "Anew"
	go get -u github.com/tomnomnom/anew
	bannerInstall "Qsreplace"
	go get -u github.com/tomnomnom/qsreplace
	bannerInstall "Gf"
	go get -u github.com/tomnomnom/gf
	bannerInstall "Gospider"
	go get -u github.com/jaeles-project/gospider
	bannerInstall "Subjack"
	go get github.com/haccer/subjack
	bannerInstall "Dnsx"
	GO111MODULE=on go get -v github.com/projectdiscovery/dnsx/cmd/dnsx
	bannerInstall "Gxss"
	go get -u github.com/KathanP19/Gxss
	bannerInstall "Metabigor"
	GO111MODULE=on go get github.com/j3ssie/metabigor
	bannerInstall "Cf-check"
	go get -u github.com/dwisiswant0/cf-check
	bannerInstall "Naabu"
	if [ "$os" == "kali" ] || [ "$os" == "debian" ] || [ "$os" == "parrot" ]; then
		sudo apt install -y libpcap-dev
	fi
	GO111MODULE=on go get -v github.com/projectdiscovery/naabu/v2/cmd/naabu
	bannerInstall "Filter-Resolved"
	go get github.com/tomnomnom/hacks/filter-resolved
	if [ -e /usr/local/go/bin ]; then
		sudo mv $HOME/go/bin/* /usr/local/go/bin
	else
		sudo mv $HOME/go/bin/* /usr/local/bin
	fi
}


installGit() {
	if command -v git >/dev/null ; then
		echo -e "\033[1;32m[+] Git is already installed!\033[m"
	else
		bannerInstall "Git"
		if [ "$os" == "arch" ]; then
			sudo pacman -S git
		else
			sudo apt install git -y
		fi
		if ! command -v git >/dev/null ; then
			echo -e "\033[1;31m[-] An error occurred when trying to install Git :(\033[m"
			exit
		else
			echo -e "\033[1;32m[+] Git installed!\033[m"
		fi
	fi
}


installGitCloneTools() {
	[[ ! -d $SCRIPTPATH/tools ]] && mkdir $SCRIPTPATH/tools 2>/dev/null
	cd $SCRIPTPATH/tools
	bannerInstall "EyeWitness"
	git clone https://github.com/FortyNorthSecurity/EyeWitness.git
	pip3 install python-Levenshtein
	bannerInstall "FavFreak"
	git clone https://github.com/devanshbatham/FavFreak.git
	pip3 install -r $SCRIPTPATH/tools/FavFreak/requirements.txt
	bannerInstall "GitHub Search"
	git clone https://github.com/gwen001/github-search.git
	pip3 install -r $SCRIPTPATH/tools/github-search/requirements2.txt
	bannerInstall "ParamSpider"
	git clone https://github.com/devanshbatham/ParamSpider.git
	pip3 install -r $SCRIPTPATH/tools/ParamSpider/requirements.txt
	bannerInstall "XSStrike"
	git clone https://github.com/s0md3v/XSStrike.git
	pip3 install -r $SCRIPTPATH/tools/XSStrike/requirements.txt
	bannerInstall "SubDomainizer"
	if [ "$os" == "arch" ]; then
		sudo pacman -S wget --needed
	fi
	wget https://raw.githubusercontent.com/nsonaniya2010/SubDomainizer/master/SubDomainizer.py
	wget https://raw.githubusercontent.com/nsonaniya2010/SubDomainizer/master/requirements.txt
	pip3 install -r $SCRIPTPATH/tools/requirements.txt
	rm $SCRIPTPATH/tools/requirements.txt 2>/dev/null
	cd $SCRIPTPATH
}


installPip() {
	if command -v pip3 >/dev/null ; then
		echo -e "\033[1;32m[+] Pip is already installed!\033[m"
	else
		bannerInstall "Pip"
		if [ "$os" == "arch" ]; then
			sudo pacman -S python-pip
		else
			sudo apt install python3-pip -y
		fi
		if command -v pip3 >/dev/null ; then
			echo -e "\033[1;32m[+] Pip installed!\033[m"
		else
			echo -e "\033[1;31m[-] An error occurred when trying to install Pip :(\033[m"
			exit
		fi
	fi
}


installFindomain() {
	bannerInstall "Findomain"
	wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux
	chmod +x $SCRIPTPATH/findomain-linux
	sudo mv $SCRIPTPATH/findomain-linux /usr/local/bin/findomain
}


installKnockpy() {
	bannerInstall "Knockpy"
	git clone https://github.com/guelfoweb/knock.git
	cd $SCRIPTPATH/knock
	sudo python3 setup.py install
	sudo rm -rf $SCRIPTPATH/knock
	[[ -d $SCRIPTPATH/knockpy.egg-info ]] && sudo rm -rf $SCRIPTPATH/knockpy.egg-info
	cd $SCRIPTPATH
}


installTools() {
	echo -e "\033[1;32m=== Installing tools ===\033[m"
	if [ "$os" == "arch" ]; then
		echo -e -n "Is your operating system BlackArch? If not, I will add his repositories to facilitate the installation[Y/n]"
		read res
		if [ "$res" == "" ]; then
			resp="Y"
		else
			if [ "$res" == "n" ]; then
				bannerInstall "BlackArch repositories"
				curl -O https://blackarch.org/strap.sh -o $SCRIPTPATH/strap.sh
				echo 95b485d400f5f289f7613fe576f4a3996aabed62 strap.sh | sha1sum -c
				chmod +x $SCRIPTPATH/strap.sh
				sudo $SCRIPTPATH/strap.sh
				sudo pacman -Syu
				rm -f $SCRIPTPAATH/strap.sh
			fi
		fi
		sudo pacman -S --needed python3 python-pip go amass sublist3r findomain dnsenum masscan nmap wafw00f dnsrecon assetfinder subfinder httprobe httpx nuclei hakrawler waybackurls dalfox metabigor dnsx ffuf subjack gospider python-shodan figlet lolcat
		installKnockpy
	elif [ "$os" == "kali" ]; then
		sudo apt install sublist3r figlet lolcat -y
		installFindomain
		installKnockpy
	else
		installFindomain
		sudo apt install masscan nmap wafw00f dnsrecon figlet lolcat -y
		if [ "$os" == "debian" ]; then
			sudo apt install snap -y
			snap install amass
		else
			sudo apt install amass -y
		fi
		sudo apt install python3-shodan -y
		installKnockpy
		bannerInstall "Sublist3r"
		git clone https://github.com/aboul3la/Sublist3r.git
		cd $SCRIPTPATH/Sublist3r
		sudo python3 setup.py install
		sudo rm -rf $SCRIPTPATH/Sublist3r
	fi
}

installWordlists() {
	bannerInstall "Wordlists"
	[[ ! -d $SCRIPTPATH/wordlists ]] && mkdir $SCRIPTPATH/wordlists
	wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt -O $SCRIPTPATH/wordlists/all.txt
	wget https://raw.githubusercontent.com/v0re/dirb/master/wordlists/common.txt -O $SCRIPTPATH/wordlists/common.txt
	wget https://raw.githubusercontent.com/v0re/dirb/master/wordlists/big.txt -O $SCRIPTPATH/wordlists/big.txt
	wget https://raw.githubusercontent.com/v0re/dirb/master/wordlists/small.txt -O $SCRIPTPATH/wordlists/small.txt
}


os
update
installPip
installGit
installGo
installGoTools
installGitCloneTools
installTools
installWordlists

echo -e "\033[1;32m[+] Done\033[m"
