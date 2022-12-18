-- 开启web图标(美化)
require('plugins.nvim-web-devicons')
-- 快速替换
require('plugins.nvim-surround')
-- 配置主题
vim.cmd[[colorscheme tokyonight-storm]]
-- 目录树(nvim-tree)
require('plugins.nvim-tree')
-- tab栏(bufferline)
require('plugins.nvim-barbar')
-- 加载状态栏
require('plugins.lualine')
-- 区间高亮
require('plugins.range-highlight')

-- 配置LSP和补全
-- require('lsp')
require('lsp')

-- 项目编译
require('plugins.asynctask')
-- 自动生成tags
require("plugins.nvim-gutentags")
