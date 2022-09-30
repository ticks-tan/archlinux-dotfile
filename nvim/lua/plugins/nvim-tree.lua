vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

local ok, nvim_tree = pcall(require, 'nvim-tree')
if not ok then
	print("load nvim-tree error !")
else
	nvim_tree.setup()
end
