-- 项目根目录标志
vim.g.gutentags_project_root = {'.root', '.git', '.project'}
-- tags文件后缀
vim.g.gutentags_ctags_tagfile = '.tags'
-- tags文件生成目录
vim.opt.vim_tags = vim.fn.expand('~/.cache/guten_tags')
vim.g.gutentags_cache_dir = vim.opt.vim_tags

-- 目录不存在则创建
if not vim.fn.isdirectory(vim.opt.vim_tags) then
	os.execute("mkdir -p "..vim.opt.vim_tags)
end

vim.g.gutentags_ctags_extra_args = {'--fields=+niazS', '--extra=+q', '--c++-kinds=+pxI', '--c-kinds=+px'}

