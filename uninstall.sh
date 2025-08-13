#!/bin/bash

# © 2025 白崎 木葉

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

master() {
	echo -e "${CYAN}${BOLD}==== cfmt Uninstaller ====${NC}"
	echo
	echo -e "${CYAN}This uninstaller will use root privileges to uninstall cfmt on your PC.${NC}"
	printf "${CYAN}Accept? "
	read uninstall
	echo -e "${NC}"

	case ${uninstall} in
	yes | y)

		if [[ -f "/usr/bin/cfmt" ]]; then
			echo -e "${YELLOW}${ARROW} Request sudo...${NC}"
			if ! sudo -v; then
				echo -e "${RED}${ARROW} Failed to request sudo${NC}"
				exit 1
			fi
			if ! run_cmd_on_root rm /usr/bin/cfmt; then
				echo -e "${RED}${CROSS} Failed to install cfmt${NC}"
				echo
				exit 1
			fi
			echo -e "${GREEN}Uninstallation finished!${NC}"
			echo
			exit
		else
			echo -e "${RED}${CROSS} cfmt not installed!${NC}"
			echo
			exit 1
		fi
		;;
	*)
		echo -e "${RED}${CROSS} Uninstallation canceled.${NC}"
		echo
		exit 1
		;;
	esac
}

master
