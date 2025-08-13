#!/bin/bash

# これはAIに書かせてない
# 私が書いたので堂々と著作権表記できる
#
# © 2025 白崎 木葉
#
#
# 見る人が見たら発狂しそうなコードしてる

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'
readonly BOLD='\033[1m'

readonly CHECK="✓"
readonly CROSS="✗"
readonly ARROW="→"

no_root=0

if [[ "$EUID" -ne 0 ]]; then
	echo -e "${YELLOW}${ARROW} Not running on root. using sudo...${NC}"
	echo
	no_root=1
fi

run_cmd_on_root() {
	echo -e "${YELLOW}${ARROW} ${BOLD}${CYAN}$@"
	if [[ "$no_root" -eq 1 ]]; then
		sudo $@
	else
		$@
	fi

	return $?
}

check_installed() {
	if [[ -f "/usr/bin/cfmt" ]]; then
		echo -e "${YELLOW}${BOLD}${ARROW}${NC}${YELLOW} cfmt is already installed!${NC}"
		printf "${YELLOW}Would you like to reinstall?${NC} "
		read -n1 val
		echo
		if [[ ! "$val" =~ ^(yes|y)$ ]]; then
			echo -e "${RED}${CROSS} Installation canceled.${NC}"
			echo
			exit 1
		fi
	fi
}

check_depends() {
	echo -e "${YELLOW}${ARROW} Checking dependencies${NC}"
	local depends=("tree" "clang-format")
	for p in ${depends[@]}; do
		if ! command -v "$p" >/dev/null; then
			echo -e "${RED}${CROSS} $p is not installed!${NC}"
			echo -e "${RED}Please install $p and retry install script!${NC}"
			echo
			exit 1
		else
			echo -e "${GREEN}${CHECK} $($p --version | head -n1)${NC}"
		fi

	done
}

master() {
	echo -e "${CYAN}${BOLD}==== cfmt Installer ====${NC}"
	echo
	echo -e "${CYAN}This installer will use root privileges to install cfmt on your PC.${NC}"
	printf "${CYAN}Accept? "
	read install
	echo -e "${NC}"

	case ${install} in
	yes | y)
		check_installed
		check_depends
		echo -e "${YELLOW}${ARROW} Request sudo...${NC}"
		if ! sudo -v; then
			echo -e "${RED}${ARROW} Failed to request sudo${NC}"
			exit 1
		fi
		if [[ -f "cfmt" ]]; then
			if ! run_cmd_on_root install -Dm755 ./cfmt /usr/bin; then
				echo -e "${RED}${CROSS} Failed to install cfmt${NC}"
				echo
				exit 1
			fi
			echo -e "${GREEN}Installation finished!${NC}"
			echo -e "Run \`cfmt <directory>\` to format files!"
			echo
			exit
		fi
		;;
	*)
		echo -e "${RED}${CROSS} Installation canceled.${NC}"
		echo
		exit 1
		;;
	esac
}

master
