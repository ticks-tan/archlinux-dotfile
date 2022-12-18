#! /bin/bash /bin/sh

## Linux命令别名设置
# -- ls 简化
alias ls='ls --color=auto'
alias ll='ls -ahl --color=auto'
# -- 不要使用vi
alias vi='vim'

# -- git status 简化
alias git-status='git status -sb'
# -- git log 美化
alias git-log="git log --all --graph --pretty=format:'%Cgreen%h%Creset - %C(yellow)%s%Creset%n          <%cn %ce> %Cgreen%cr%Creset'"
# -- wget 支持断点下载
alias wget='wget -c'
# -- 使用openssl产生指定位数的随机密码
alias genpasswd='openssl rand -base64'
# -- ping 命令限制次数为5，默认无限次
alias ping='ping -c 5'
# -- 返回上级目录
alias ..='cd ..'
alias ...='cd ../..'
# -- neofetch
alias systeminfo='neofetch'

