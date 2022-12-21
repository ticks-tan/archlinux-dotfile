#! /bin/bash

## cmd
shell=/bin/bash
## 用户根目录
home=$HOME
## 包管理工具
pm_tool="pacman"
## 包安装命令(后有空格!)
pm_install="pacman -S "
## 包卸载工具
pm_uninstall="pacman -Rns "

## 网络检查超时
timeout=7
## Github检查地址
website="github.com"
## 各个Github仓库链接，如果有镜像可以在这里
## powerline字体
powerline_font="https://github.com/powerline/fonts.git"
# neovim最低版本(插件要求)
nvim_min_version="0.7.2"

## 加载工具函数
source ./scripts/tools.sh

# 设置当前脚本目录
MROOT=`get_real_path`

## 显示菜单
function show_menu() {
	echo "=========== ArchLinux Dotfile =========="
	echo ">> 1. 安装字体(Powerline Maple) <Linux>"
	echo ">> 2. 美化终端PS显示 <Linux bash>"
	echo ">> 3. 配置nvim(美化+LSP) <Linux>"
	echo ">> 4. 配置有用的命令别名 <Linux>"
	echo ">> 5. 配置sway <ArchLinux>"
	echo ">> 6. 配置终端alacritty <Linux>"
	echo ">> 99. 更新工具(git pull)"
	echo ">> 0. 退出脚本"
	echo ">> 当前工作目录：`get_real_path`"
	echo "========================================"
}

## 检查前置软件包
function check_prepare() {
	should_install=""
	dprint ">> 检查Git <<"
	if ! check_cmd git; then
		wprint ">>> 未发现git, 添加到待安装列表\n"
		should_install = $should_install"git "
	fi
	dprint ">> 检查curl <<"
	if ! check_cmd curl; then
		wprint ">>> 未发现curl，添加到待安装列表\n"
		should_install = $should_install"curl "
	fi
	dprint ">> 检查zip <<"
	if ! check_cmd zip; then
		wprint ">>> 未发现zip，添加到安装列表\n"
		should_install = $should_install"zip "
	fi
	if [ -z "$should_install" ]; then
		return 0
	else
		dprint ">> 安装未满足软件包 <<\n"
		if ! `${pm_install}${should_install}`; then
			eprint ">>> 安装失败！\n"
			return 1
		fi
	fi
	return 0
}


## 安装 PowerLine 字体
function install_powerline_font() {
	if [ -e "${MROOT}/tmp/powerline-font" ]; then
		dprint ">> 检查到缓存文件，跳过下载！\n"
		if [ -e "${MROOT}/tmp/powerline_font/installed.txt" ]; then
			wprint ">> 检查到已安装文件，跳过安装！\n"
			return 0
		else
			$shell ${MROOT}/tmp/powerline-font/install.sh
			touch ${MROOT}/tmp/powerline-font/installed.txt
			sprint ">>> 安装成功！\n"
			return 0
		fi
	fi
	dprint ">> 检查github连通性 <<\n"
	if check_github ; then
		dprint ">> 下载字体 <<\n"
		if git clone ${powerline_font} ${MROOT}/tmp/powerline-font ; then
			$shell ${MROOT}/tmp/powerline-font/install.sh
			touch ${MROOT}/tmp/powerline-font/installed.txt
			sprint ">>> 安装成功！\n"
			return 0
		else
			eprint ">>> 下载失败，取消安装！\n"
		fi
	else
		eprint ">>> Github无法访问，取消安装！\n"
	fi
	return 1
}

function menu_config_fonts()
{
	dprint ">> 安装Powerline字体"
	install_powerline_font

	dprint ">> 安装Maple字体"

}


## 安装 bash-ps1
function menu_bash_ps1() {
	if [ -e "${home}/.bash-ps1.sh" ]; then
		wprint ">>> 已安装bash-ps1，跳过安装！\n"
		return 0
	else
		dprint ">> 拷贝文件并添加配置 <<\n"
		cp ${MROOT}/config/bash/.bash-ps1.sh ${home}/
		if [ -e "${home}/.bash-ps1.sh" ]; then
			echo -e "## set bash-ps1\nsource ${home}/.bash-ps1.sh\n" >> ${home}/.bashrc
			sprint ">>> 安装成功，稍后重新打开终端即可看到效果\n"
		else
			eprint ">>> 拷贝失败！\n"
			return 1
		fi
	fi
	return 0
}

## 配置nvim
source ./scripts/set_nvim.sh

## 配置 sway
source ./scripts/sway.sh

## 配置 Alacritty
function menu_config_alacritty()
{
	dprint ">> 开始配置Alacritty"
	if [ ! -e "${MROOT}/config/alacritty/alacritty.yml" ]; then
		eprint ">>> 配置文件丢失，停止配置"
		return 1
	fi
	if [ -e "${home}/.config/alacritty/alacritty.yml" ]; then
		wprint ">>> 发现本地配置文件，开始备份"
		cp ${home}/.config/alacritty/alacritty.yml ${home}/.config/alacritty/alacritty.yml.bak
	fi
	mkdir -p ${home}/.config/alacritty
	cp ${MROOT}/config/alacritty/alacritty.yml ${home}/.config/alacritty/
	sprint ">> 配置完成！"
	return 0
}

# 设置别名
function menu_config_alias() {
	if [ ! -e "${MROOT}/config/bash/.command-alias.sh" ]; then
		eprint ">>> 别名文件丢失，跳过配置！\n"
		return 1
	fi
	if [ -e "${home}/.command-alias.sh" ]; then
		wprint ">> 发现本地别名文件，是否替换(是[Y/y]，否(N/n)<默认>): "
		read flag
		if [[ "$flag" != "Y" && "$flag" != "y" ]]; then
			wprint ">>> 你选择不替换，跳过配置！\n"
			return 0
		fi
	fi
	sprint ">> 拷贝配置文件 <<\n"
	if ! cp ${MROOT}/config/bash/.command-alias.sh ${home}/ ; then
		eprint ">>> 拷贝配置文件失败！\n"
		return 2
	fi
	grep -w -q "source .*\.command-alias.sh" "${home}/.bashrc" || echo -e "# config alias\nsource ${home}/.command-alias.sh" >> ${home}/.bashrc
	sprint ">>> 配置完成，别名如下：\n"
	cat ${home}/.command-alias.sh
	echo "======================================"
	return 0
}

# 更新工具
function menu_update() {
	dprint ">> 执行 git pull <<\n"
	if ! git pull ; then
		eprint ">>> 更新失败×_×！\n"
		return 1
	fi
	sprint ">>> 脚本更新成功，将在3s后关闭！\n"
	sleep 3s
	exit 0
	return 0
}

# 进入脚本根目录
cd "$(dirname ${0})"

## 检查包管理工具
if ! check_cmd ${pm_tool} ; then
	wprint ">> 检测到系统似乎没有使用 ${pm_tool} 作为包管理工具！\n"
	dprint ">> 请输入系统包管理工具安装命令(default:${pm_install})："
	read pm_install
	dprint ">> 请输入系统包管理工具卸载命令(default:${pm_uninstall}): "
	read pm_uninstall
fi

if ! check_prepare ; then
	eprint ">>> 某些软件包没有安装，无法继续使用！\n"
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
		menu_config_fonts
	elif [ "$flag" == "2" ]; then
		menu_bash_ps1
	elif [ "$flag" == "3" ]; then
		menu_config_nvim
	elif [ "$flag" == "4" ]; then
		menu_config_alias
	elif [ "$flag" == "5" ]; then
		menu_config_sway
	elif [ "$flag" == "6" ]; then
		menu_config_alacritty
	elif [ "$flag" == "99" ]; then
		menu_update
	else
		eprint ">>> 输入错误\n"
	fi
	pause
done

exit 0

