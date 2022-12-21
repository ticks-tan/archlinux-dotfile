#!/bin/bash

## sway config

apps="<sway swaybg swayidle swayimg waybar clipman mako> [alacritty bemenu]"


function menu_config_sway()
{
	dprint ">> 为保证sway配置完整，请确保安装以下软件包：\n"
	sprint "${apps}"
	has="0"

	if [ ! -e "${MROOT}/config/sway/sway/config" ]; then
		eprint ">>> 配置文件丢失，跳过配置！\n"
		return 1
	fi
	if [ -e "${home}/.config/sway/config" ]; then
		wprint ">> 发现本地配置文件，备份后开始配置"
		hs="1"
		cp ${home}/.config/sway/config ${home}/.config/sway/config.bak
	fi
	mkdir -p ${home}/.config/sway
	cp ${MROOT}/config/sway/sway/config ${home}/.config/sway/config
	dprint ">> 开始配置 waybar 状态栏"
	if [ ! -e "${MROOT}/config/sway/waybar/config.jsonc" ]; then
		eprint ">>> 配置文件丢失，停止配置!"
		if [ "1" == "${has}" ]; then
			cp ${home}/.config/sway/config.bak ${home}/.config/sway/config
		fi
		return 1
	fi
	has="0"
	if [ -e "${home}/.config/waybar/config.jsonc" ]; then
		has="1"
		wprint ">> 发现本地配置文件，开始备份"
		mkdir -p ${home}/.config/waybar/back
		cp -r ${home}/.config/waybar/config.jsonc ${home}/.config/waybar/style.css ${home}/.config/waybar/back/
		
	fi
	mkdir -p ${home}/.config/waybar
	cp -r ${MROOT}/config/waybar ${home}/.config/waybar
	dprint ">> 开始配置 mako 通知后台守护"
	if [ ! -e "${MROOT}/config/mako/config" ]; then
		eprint ">>> 配置文件丢失，停止配置"
		if [ "1" == "has" ]; then
			rm ${home}/.config/waybar/jsonc ${home}/.config/waybar/style.css
			mv ${home}/.config/waybar/back/** ${home}/.config/waybar/
			rm -r ${home}/.config/waybar/back
		else
			rm -r ${home}/.config/waybar
		fi
	fi
	if [ -e "${home}/.config/mako/config" ]; then
		wprint ">>> 发现本地配置文件，开始备份"
		cp ${home}/.config/mako/config ${home}/.config/mako/config.bak
	fi
	mkdir -p ${home}/.config/mako
	cp -r ${MROOT}/config/mako ${home}/.config/mako

	sprint ">> 配置完成！"
	return 0
}

