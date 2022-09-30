-- 配置说明：
-- vim.o.xxx	vim常规配置
-- vim.wo.xxx	vim窗口作用域相关设置
-- vim.bo.xxx	vim缓冲区作用域相关设置
-- vim.g.xxx	vim全局变量，一般用于设置插件需要的变量
-- vim.opt.xxx	相当于vimscript中的set xxx

-- set utf-8
vim.g.encodeing = "UTF-8"
vim.o.fileencoding = 'utf-8'
-- 显示行号
vim.wo.number = true
-- vim.wo.relativenumber = true
-- 高亮当前行
vim.wo.cursorline = true
vim.wo.signcolumn = "yes"
-- 缩进
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autointent = 'yes'
vim.o.shiftround = true
-- 搜索大小写不敏感（除非包含大写）
vim.o.ignorecase = true
vim.o.smartcase = true
-- 命令行高度
vim.o.cmdheight = 1
-- 当文件被外部修改后重新加载
vim.o.autoread = true
vim.bo.autoread = true
-- 取消自动折行
vim.o.wrap = false
vim.wo.wrap = false
-- 行尾可移动到下一行
vim.o.whichwrap = 'b,s,<,>,[,],h,l'
-- 支持鼠标
vim.o.mouse = 'a'
-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.swapfile = false
-- 自动补全默认选中
vim.g.completeopt = "menu,menuone,noselect"
-- 终端颜色支持
vim.o.termguicolors = true
vim.opt.termguicolors = true
-- 补全增强
vim.o.wildmenu = true
-- 补全最多显示10行
vim.o.pumheight = 10
