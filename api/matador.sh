#!/usr/bin/env bash

cd $HOME/MaTaDoR/api

install() {
		sudo apt-get update
		sudo apt-get upgrade
sudo apt-get install lua5.1 luarocks lua-socket lua-sec redis-server curl 
sudo luarocks install oauth 
sudo luarocks install redis-lua 
sudo luarocks install lua-cjson 
sudo luarocks install ansicolors 
sudo luarocks install serpent 
}

update() {
	git pull
}

green() {
  printf '\e[1;32m%s\n\e[0;39;49m' "$@"
}

if [ "$1" = "install" ]; then
	
	install
elif [ "$1" = "update" ]; then
	
	update
	exit 1
else
	green "MaTaDoR Api Bot running..."
	#sudo service redis-server restart
	lua ./bot/bot.lua
fi
