#! /bin/bash

## cmd
shell=/bin/bash
## 用户根目录
home=$HOME
## 包安装命令
pm_install="apt-get install "
## 包卸载工具
pm_uninstall="apt-get uninstall"
## 编译nvim前置软件包，详情可到 
## [https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source]
## 查看
nvim_build_prepare="make ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen"

## 网络检查超时
timeout=7
## Github检查地址
website="github.com"
## 各个Github仓库链接，如果有镜像可以在这里
## powerline字体
powerline_font="https://github.com/powerline/fonts.git"
## neovim源码
nvim_source="https://github.com/neovim/neovim"
nvim_build_type="Release"
nvim_install_prefix="/usr/local"


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

## 输出错误信息
function eprint() {
	if [ "p${1}" != "p" ]; then
		echo -n -e "\x1b[38;2;255;30;30m${1}\x1b[0m"
	fi
}
function dprint() {
	if [ "p${1}" != "p" ]; then
		echo -n -e "\x1b[38;2;101;163;240m${1}\x1b[0m"
	fi
}
function wprint() {
	if [ "p${1}" != "p" ]; then
		echo -n -e "\x1b[38;2;243;185;24m${1}\x1b[0m"
	fi
}
function sprint() {
	if [ "p${1}" != "p" ]; then
		echo -n -e "\x1b[38;2;66;186;120m${1}\x1b[0m"
	fi
}

## 显示菜单
function show_menu() {
	echo "=========== Linux Code Config =========="
	echo ">> 1. 安装PowerLine字体(可以显示图标字符，避免某些插件不能显示)."
	echo ">> 2. 安装bash-powerline终端PS显示(简洁好看)."
	echo ">> 3. 安装nvim(源码安装)."
	echo ">> 4. 配置nvim(美化+LSP)."
	echo ">> 0. 退出脚本."
	echo "========================================"
}

## 检查前置软件包
function check_prepare() {
	should_install=""
	dprint "检查Git. . ."
	if ! check_cmd git; then
		wprint "未发现git, 添加到待安装列表\n"
		should_install = $should_install"git "
	fi
	dprint "检查curl. . ."
	if ! check_cmd curl; then
		wprint "未发现curl，添加到待安装列表\n"
		should_install = $should_install"curl "
	fi
	dprint "检查zip"
	if ! check_cmd zip; then
		wprint "未发现zip，添加到安装列表\n"
		should_install = $should_install"zip "
	fi
	if [ -z "$should_install" ]; then
		return 0
	else
		dprint "安装未满足软件包. . .\n"
		if ! `${pm_install}${should_install}`; then
			eprint "安装失败！\n"
			return 1
		fi
	fi
	return 0
}

## 安装 PowerLine 字体
function menu_powerline_font() {
	if [ -e "./tmp/powerline-font" ]; then
		dprint "检查到缓存文件，跳过下载！\n"
		if [ -e "./tmp/powerline_font/installed.txt" ]; then
			wprint "检查到已安装文件，跳过安装！\n"
			return 0
		else
			$shell ./tmp/powerline-font/install.sh
			touch ./tmp/powerline-font/installed.txt
			sprint "安装成功！\n"
			return 0
		fi
	fi
	dprint "检查github连通性. . .\n"
	if check_github ; then
		dprint "下载字体. . .\n"
		if git clone ${powerline_font} ./tmp/powerline-font ; then
			$shell ./tmp/powerline-font/install.sh
			touch ./tmp/powerline-font/installed.txt
			sprint "安装成功！\n"
			return 0
		else
			eprint "下载失败，取消安装！\n"
		fi
	else
		eprint "Github无法访问，取消安装！\n"
	fi
	return 1
}
## 安装 bash-powerline
function menu_bash_powerline() {
	if [ -e "${home}/.bash-powerline.sh" ]; then
		wprint "已安装bash-powerline，跳过安装！\n"
		return 0
	else
		dprint "拷贝文件并添加配置. . .\n"
		cp ./.bash-powerline.sh ${home}/
		if [ -e "${home}/.bash-powerline.sh" ]; then
			echo -e "## set bash-powerline\nsource ${home}/.bash-powerline.sh\n" >> ${home}/.bashrc
			sprint "安装成功，稍后重新打开终端即可看到效果\n"
		else
			eprint "拷贝失败！\n"
			return 1
		fi
	fi
	return 0
}

## 源码安装nvim
function menu_install_nvim() {
	if check_cmd nvim ; then
		wprint "检查到系统已安装nvim！\n是否要卸载系统nvim源码编译最新nvim？ \n"
		wprint "卸载原系统nvim可能会破坏某些软件依赖，请谨慎选择，出现问题概不负责！！！\n"
		wprint "请选择(卸载[Y/y]，不卸载[N/n]<默认>): "
		read flag
		if [[ "n${flag}" == "ny" || "n${flag}" == "nY" ]]; then
			dprint "你选择了卸载，正在卸载. . .\n"
			if ! $pm_uninstall neovim ; then
				eprint "卸载失败，跳过安装！\n"
				return 1
			fi
		else
			sprint "你选择了不卸载，跳过安装！\n"
			return 0
		fi
	fi
	dprint "安装依赖. . .\n"
	if ! $pm_install $nvim_build_prepare ; then
		eprint "安装依赖软件包失败，停止后续步骤！\n"
		return 2
	fi
	dprint "检查github网络连通. . .\n"
	if ! check_github ; then
		eprint "Github连接失败，停止后续步骤！\n"
		return 3
	fi
	update=""
	if [ -e "./tmp/neovim" ]; then
		dprint "检测到缓存文件，跳过下载源码！\n"
		update="1"
	else
		dprint "下载nvim最新源码. . .\n"
		if ! git clone ${nvim_source} ./tmp/neovim ; then
			eprint "下载源码失败，停止后续步骤！\n"
			return 4
		fi
	fi
	workdir=`pwd`
	dprint "进入 ${workdir}/tmp/neovim. . .\n"
	cd ${workdir}/tmp/neovim
	if [ "0${update}" == "01" ]; then
		dprint "从远程更新源码. . .\n"
		if ! git fetch master ; then
			eprint "无法更新源码，停止后续步骤！\n"
			dprint "退出目录. . .\n"
			cd ${workdir}
			return 11
		fi
	fi
	dprint "切换到最新稳定分支. . .\n"
	if ! git checkout stable ; then
		eprint "切换分支失败，停止后续步骤！\n"
		dprint "退出目录. . .\n"
		cd ${workdir}
		return 5
	fi
	dprint "开始编译. . .\n"
	if ! make CMAKE_BUILD_TYPE=${nvim_build_type} ; then
		eprint "编译失败，停止安装！\n"
		dprint "退出目录. . .\n"
		cd ${workdir}
		return 6
	fi
	sprint "编译完成，开始安装，路径为：[${nvim_install_prefix}]！\n"
	if ! sudo make CMAKE_INSTALL_PREFIX=${nvim_install_prefix} install ; then
		eprint "安装失败=_= ！\n"
		dprint "退出目录. . .\n"
		cd ${workdir}
		return 7
	fi
	dprint "退出目录. . .\n"
	cd ${workdir}
	sprint "安装成功！版本信息如下：\n"
	nvim --version
	return 0
}

## 配置nvim
function menu_config_nvim() {
	if [[ -e "${home}/.config/nvim/init.lua" || -e "${home}/.config/nvim/init.vim" ]]; then
		wprint "检查到已有neovim配置，是否需要备份原有配置使用新的配置?\n"
		dprint "请选择(使用新配置[Y/y]<默认>,使用原配置[N/n])："
		read flag
		if [[ "n${flag}" == "nN" || "n${flag}" == "nn" ]]; then
			wprint "使用原配置，跳过新配置！\n"
			return 0
		fi
		dprint "使用新配置，备份旧配置. . .\n"
		mkdir ./tmp/neovim-back
		cp -r ${home}/.config/nvim ./tmp/neovim-back/
		cp -r ${home}/.local/share/nvim ./tmp/neovim-back/
		zip -r -q ./tmp/neovim-back-`date "+%Y-%m-%d-%H-%M-%S"`.zip ./tmp/neovim-back/
		rm -r ./tmp/neovim-back/
		dprint "备份完成！\n"
	fi
	dprint "检查Github连通性. . .\n"
	if ! check_github ; then
		eprint "Github无法连接，取消配置！\n"
		return 1
	fi
	dprint "安装neovim插件管理工具. . ."
	if ! $shell -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' ; then
		eprint "安装插件工具失败，停止配置！\n"
		return 2
	fi
	if [ -e "./nvim" ]; then
		dprint "拷贝配置文件. . ."
		rm -r ${home}/.config/nvim && cp -r ./nvim ${home}/.config/
	else
		eprint "配置文件丢失，停止配置. . .\n"
		return 3
	fi
	dprint "将在5s打开neovim安装插件并启用，第一次启动会提示模块加载失败，请忽略！\n"
	dprint "如果下载插件出现问题，请在之后打开neovim后普通模式下手动执行[:PlugInstall]来安装插件！\n"
	sleep 5
	nvim -c ":PlugInstall" -c ":qa"
	sprint "安装完成！\n"
	sprint "所有配置文件在[${home}/.config/nvim/lua/]文件夹下\n"
	sprint "基础配置[basic.lua]，快捷键配置[keybingings.lua]\n"
	sprint "插件安装[plugins.lua]，插件配置[plugin-config.lua + plugins/*.lua]\n"
	sprint "LSP配置[lsp/init.lua + lsp/<lsp-client>.lua]\n"
	return 0
}



if ! check_prepare ; then
	eprint "前置条件未满足，无法继续使用!\n"
	pause
	exit 1
fi

while true
do
	clear
	show_menu
	read -p ">> 请输入(数字): " flag
	if [ "$flag" == "0" ]; then
		break
	elif [ "$flag" == "1" ]; then
		menu_powerline_font
	elif [ "$flag" == "2" ]; then
		menu_bash_powerline
	elif [ "$flag" == "3" ]; then
		menu_install_nvim
	elif [ "$flag" == "4" ]; then
		menu_config_nvim
	else
		eprint "输入错误\n"
	fi
	pause
done

exit 0

