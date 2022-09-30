--
-- nvim快捷键配置
-- 1. keymap(模式，快捷键，动作，参数)
-- 2. nmap(快捷键，动作): 定义普通模式下的快捷键
-- 3. imap(快捷键，动作): 定义插入模式下快的捷键
-- 4. cmap(快捷键，动作): 定义命令模式下快的捷键
--

-- 默认参数
local default_opt = {noremap = true, silent = true}
-- 默认LeaderKey
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.api.nvim_set_keymap

local nmap = function(key, cmd)
		keymap('n', key, cmd, default_opt)
end

local imap = function(keys)
		keymap('i', key, cmd, default_opt)
end

local cmap = function(keys)
		keymap('c', key, cmd, default_opt)
end

-- 设置快捷键
-- 快速移动
nmap('<C-u>', '5k')		-- 向上移动5行
nmap('<C-d>', '5j')		-- 向下移动5行
nmap('<A-<>', '^')		-- 移动到行首
nmap('<A->>', '$')		-- 移动到行尾
-- 分屏相关
nmap('sh', ':sp<CR>')		-- 水平分屏
nmap('sv', ':vsp<CR>')		-- 垂直分屏
nmap('sc', '<C-w>c')		-- 关闭当前分屏
nmap('so', '<C-w>o')		-- 关闭其他分屏
nmap('<A-h>', '<C-w>h')		-- 移动到左边屏幕
nmap('<A-l>', '<C-w>l')		-- 移动到右边屏幕
nmap('<A-k>', '<C-w>k')		-- 移动到上边屏幕
nmap('<A-j>', '<C-w>j')		-- 移动到下边屏幕
-- 插件快捷键
nmap('<A-t>', ':NvimTreeToggle<CR>')	-- 切换显示目录树
nmap('<C-h>', ':BufferLineCyclePrev<CR>')	-- bufferline向前切换(循环，可鼠标点击)
nmap('<C-l>', ':BufferLineCycleNext<CR>')	-- bufferline向后切换(循环，可鼠标点击)

local keyBind = {}

-- nvim-cmp补全快捷键
keyBind.cmpbind = function(cmp)
	return {
		-- 上一个
		['<C-k>'] = cmp.mapping.select_prev_item(),
		-- 下一个
		['<C-j>'] = cmp.mapping.select_next_item(),
		-- 取消补全
		['<C-,>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close()
		}),
		-- 确认补全
		['<CR>'] = cmp.mapping.confirm({
			select = true,
			behavior = cmp.ConfirmBehavior.Replace
		}),
		-- 上翻页
		['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
		['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
	}
end

return keyBind
