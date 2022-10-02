
-- 设置别名，方便书写
local Plug = vim.fn['plug#']

-- 关于插件具体配置，参考 https://github.com/xx/xxx
-- 例如：nvim目录树：https://github.com/kyazdani42/nvim-tree.lua

vim.call('plug#begin')
-- vim 中文文档
Plug 'yianwillis/vimcdoc'
-- nvim 彩色图标
Plug 'kyazdani42/nvim-web-devicons'	-- optional(icon support)
-- nvim 目录树
Plug 'kyazdani42/nvim-tree.lua'
-- 命令行选择多行时高亮显示
Plug 'winston0410/cmd-parser.nvim'
Plug 'winston0410/range-highlight.nvim'
-- nvim tab line
Plug 'romgrk/barbar.nvim'
-- 快速替换
Plug 'tpope/vim-surround'
-- 括号补全
Plug 'jiangmiao/auto-pairs'
-- 代码补全
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
-- For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'onsails/lspkind-nvim'
-- LSP 客户端自动配置
Plug 'williamboman/mason.nvim'
-- Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
-- 底部状态栏
-- Plug('romgrk/barbar.nvim', { branch = 'fix/303' })
-- 主题(tokyonight)
Plug('folke/tokyonight.nvim', { branch = 'main' })
-- 类似vscode的项目编译方案
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
-- 自动生成ctags
Plug 'ludovicchabant/vim-gutentags'

vim.call('plug#end')
