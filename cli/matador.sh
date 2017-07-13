#!/usr/bin/env bash

cd $HOME/MaTaDoR/cli

install() {
	    cd tg
		sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
		sudo apt-get install g++-4.7 -y c++-4.7 -y
		sudo apt-get update
		sudo apt-get upgrade
		sudo apt-get install libreadline-dev -y libconfig-dev -y libssl-dev -y lua5.2 -y liblua5.2-dev -y lua-socket -y lua-sec -y lua-expat -y libevent-dev -y make unzip git redis-server autoconf g++ -y libjansson-dev -y libpython-dev -y expat libexpat1-dev -y
		sudo apt-get install screen -y
		sudo apt-get install tmux -y
		sudo apt-get install libstdc++6 -y
		sudo apt-get install lua-lgi -y
		sudo apt-get install libnotify-dev -y
		wget https://valtman.name/files/telegram-cli-1222
		mv telegram-cli-1222 tgcli
		chmod +x tgcli
		cd ..
		chmod +x bot
		chmod +x tg
}

function print_logo() {
	echo -e "\033[38;5;600m" 
	echo -e "  __  __      _____     ____        ____  "
	echo -e " |  \/  | __ |_   _|_ _|  _ \  ___ |  _ \ "
	echo -e " | |\/| |/ _  || |/ _  | | | |/ _ \| |_) | "
	echo -e " |_|  |_|\__,_||_|\__,_|____/ \___/|_| \_\ "
	echo -e "\n\e[36m"
}

function logo_play() {
    declare -A txtlogo
    seconds="0.010"
    txtlogo[1]="  __  __      _____     ____        ____ "
    txtlogo[2]=" |  \/  | __ |_   _|_ _|  _ \  ___ |  _ \ "
    txtlogo[3]=" | |\/| |/ _  || |/ _  | | | |/ _ \| |_) | "
    txtlogo[4]=" |_|  |_|\__,_||_|\__,_|____/ \___/|_| \_\ "
    printf "\033[38;5;600m\t"
    for i in ${!txtlogo[@]}; do
        for x in `seq 0 ${#txtlogo[$i]}`; do
            printf "${txtlogo[$i]:$x:1}"
            sleep $seconds
        done
        printf "\n\t"
    done
    printf "\n"
}

if [ "$1" = "install" ]; then
  install
  else

if [ ! -f ./tg/tgcli ]; then
    echo "tg not found"
    echo "Run $0 install"
    exit 1
 fi


   print_logo
   echo -e "\033[38;5;208m"
   echo -e "  __  __       _     ____  _ ____        ___ "
   echo -e " |  \/  | __ _| |__ |  _ \(_)  _ \ ___  / _ \ "
   echo -e " | |\/| |/ _  | '_ \| | | | | |_) / _ \| | | | "
   echo -e " | |  | | (_| | | | | |_| | |  _ < (_) | |_| | "
   echo -e " |_|  |_|\__,_|_| |_|____/|_|_| \_\___/ \___/ "
   echo -e "\033[0;00m"
   echo -e "\e[36m"
   logo_play
   #./tg/tgcli -s ./bot/bot.lua -l 1 -E $@
   ./tg/tgcli -s ./bot/bot.lua $@
fi
