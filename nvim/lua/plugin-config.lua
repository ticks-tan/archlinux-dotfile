require('tools')
-- 开启web图标(美化)
Load_Module('plugins/nvim-web-devicons')
-- 快速替换
Load_Module('plugins/nvim-surround')
-- 配置主题
vim.cmd[[colorscheme tokyonight-storm]]
-- 目录树(nvim-tree)
Load_Module('plugins/nvim-tree')
-- tab栏(bufferline)
Load_Module('plugins/nvim-bufferline')
-- 加载状态栏
Load_Module('plugins/lualine')
-- 区间高亮
Load_Module('plugins/range-highlight')

-- 配置LSP和补全
-- Load_Module('lsp')
Load_Module('lsp')

-- 项目编译
Load_Module('plugins/asynctask')

