#!/bin/bash
######################
## 配置nvim脚本
######################

# 判断neovim版本号
function nvim_version_check() {
	version=$(nvim --version | grep NVIM | awk -Fv '{ print $2 }')
	if [ "v${version}" != "v" ]; then
		if [ "$(echo "${version} ${1}" | tr " " "\n" | sort -V | head -n 1)" != "$1" ]; then
			eprint ">> 当前neovim版本为: ${version}，要求最低版本号为：${1}\n"
			return 1
		fi
	else
		return 1
	fi
	return 0
}

## 配置nvim
function menu_config_nvim() {
	# 检查neovim是否存在
	dprint ">> 检查neovim是否安装 <<\n"
	if ! check_cmd nvim ; then
		eprint ">>> 未检测到neovim，请提前安装 neovim !\n"
		return 1
	fi
	# 检查nvim版本是否达到要求
	dprint ">> 检查nvim版本要求 <<\n"
	if ! nvim_version_check ${nvim_min_version} ; then
		return 1
	fi
	dprint ">> 检查原有配置 <<\n"
	if [[ -e "${home}/.config/nvim/init.lua" || -e "${home}/.config/nvim/init.vim" ]]; then
		wprint ">> 检查到已有neovim配置，是否需要备份原有配置使用新的配置?\n"
		dprint ">> 请选择(使用新配置[Y/y]<默认>,使用原配置[N/n])："
		read flag
		if [[ "n${flag}" == "nN" || "n${flag}" == "nn" ]]; then
			wprint ">>> 使用原配置，跳过新配置！\n"
			return 0
		fi
		dprint ">>> 使用新配置，开始备份旧配置. . .\n"
		mkdir -p ${MROOT}/tmp/neovim-back
		cp -r ${home}/.config/nvim ${MROOT}/tmp/neovim-back/
		cp -r ${home}/.local/share/nvim ./tmp/neovim-back/
		zip -r -q ${MROOT}/tmp/neovim-back-`date "+%Y-%m-%d-%H-%M-%S"`.zip ${MROOT}/tmp/neovim-back/
		rm -r ${MROOT}/tmp/neovim-back/
		sprint ">>> 备份完成！\n"
	fi
	dprint ">> 检查Github连通性 <<\n"
	if ! check_github ; then
		eprint ">>> Github无法连接，取消配置！\n"
		return 2
	fi
	if [ ! -e "${home}/.local/share/nvim/site/autoload/plug.vim" ]; then
		dprint ">> 安装neovim插件管理工具 <<\n"
		if ! $shell -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' ; then
			eprint ">>> 安装插件工具失败，停止配置！\n"
			return 3
		fi
	fi
	if [ -e "${MROOT}/config/nvim" ]; then
		dprint ">> 拷贝配置文件 <<\n"
		if [ -e "${home}/.config/nvim" ]; then
			rm -r ${home}/.config/nvim && cp -r ${MROOT}/config/nvim "${home}/.config/"
		else
			dprint ">>> 创建配置文件目录. . .\n"
			mkdir -p "${home}/.config/nvim" && cp -r ${MROOT}/config/nvim "${home}/.config/"
		fi
	else
		eprint ">>> 配置文件丢失，停止配置 !\n"
		return 4
	fi
	dprint ">>> 将在5s后打开neovim安装插件并启用！\n"
	dprint ">>> 如果下载插件出现问题，请使用 [:qa] 退出下载并在之后打开 neovim 后普通模式下手动执行[:PlugInstall]来安装插件！\n"
	sleep 5
	nvim -c ":PlugInstall" -c ":qa"
	sprint ">>> 插件安装完成！\n"
	lsp_server=" "
	dprint ">> 是否安装C/C++ LSP Server 用作代码补全(是[Y/y]，否[N/n]<默认>): "
	read flag
	if [[ "$flag" == "Y" || "$flag" == "y" ]]; then
		lsp_server="${lsp_server} clangd"
	fi
	dprint ">> 是否安装Lua LSP Server(是[Y/y]<默认>，否[N/n]): "
	read flag
	if [[ "$flag" != "N" && "$flag" != "n" ]]; then
		lsp_server="${lsp_server} lua-language-server"
	fi
	dprint ">> 是否安装Rust LSP Server(是[Y/y]，否[N/n]<默认>): "
	read flag
	if [[ "$flag" == "Y" || "$flag" == "y" ]]; then
		lsp_server="${lsp_server} rust-analyzer"
	fi
	wprint ">>> 将在7s打开nvim安装LSP Server，务必等待安装完成后输入[:qa]来退出nvim继续执行脚本！\n"
	wprint ">>> 第一次打开文件会提示错误，请忽略！\n"
	sleep 7s
	nvim -c ":MasonInstall ${lsp_server}"
	lsp_bin="${home}/.local/share/nvim/mason/bin"
	dprint ">> 将LSP Server添加到环境变量 <<\n"
	if [ -e "${home}/.bashrc" ]; then
		grep -w -q "export PATH=.*\.local/share/nvim/mason/bin" "${home}/.bashrc" || echo -e "# set mason lsp server\nexport PATH=\$PATH:${lsp_bin}" >> "${home}/.bashrc"
	else
		wprint ">>> 未发现bashrc文件，无法添加，你可以稍后自行将[$lsp_bin]添加到环境变量！\n"
	fi
	sprint ">>> LSP Server安装完成，你可以在普通模式下使用[:Mason]查看更多信息！\n"
	sprint "====================================================\n"
	sprint ">> 所有配置文件在[${home}/.config/nvim/lua/]文件夹下\n"
	sprint ">> 如有备份，备份文件在 [${MROOT}/tmp/neovim-back-xxx.zip]\n"
	sprint "基础配置[basic.lua]，快捷键配置[keybingings.lua]\n"
	sprint "插件安装[plugins.lua]，插件配置[plugin-config.lua + plugins/*.lua]\n"
	sprint "LSP配置[lsp/init.lua + lsp/<lsp-client>.lua]\n"
	sprint "====================================================\n"
	return 0
}
