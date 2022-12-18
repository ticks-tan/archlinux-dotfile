#!/bin/bash
####################
## 脚本工具函数
###################

## 按任意键继续
function get_char() {
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2>/dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}

function pause() {
	echo -n "按任意键继续. . ."
	ch=`get_char`
}

## 获取脚本文件所在目录
function get_real_path() {
	cur_dir="$(pwd)"
	cd "$(dirname "${0}")"
	p="$(pwd)"
	cd "${cur_dir}"
	echo "$p"
}

## 检查Github网络连通
function check_github() {
	if curl -m ${timeout} -I -o /dev/null -s ${website}; then
		return 0
	fi
	return 1
}

## 检查命令存在
function check_cmd(){
	if command -v $1 > /dev/null; then
		return 0
	fi
	return 1
}

## 输出error信息
function eprint() {
	if [ "p${1}" != "p" ]; then
		echo -n -e "\x1b[38;2;255;30;30m${1}\x1b[0m"
	fi
}
## 输出debug信息
function dprint() {
	if [ "p${1}" != "p" ]; then
		echo -n -e "\x1b[38;2;101;163;240m${1}\x1b[0m"
	fi
}
## 输出warn信息
function wprint() {
	if [ "p${1}" != "p" ]; then
		echo -n -e "\x1b[38;2;243;185;24m${1}\x1b[0m"
	fi
}
## 输出success信息
function sprint() {
	if [ "p${1}" != "p" ]; then
		echo -n -e "\x1b[38;2;66;186;120m${1}\x1b[0m"
	fi
}


