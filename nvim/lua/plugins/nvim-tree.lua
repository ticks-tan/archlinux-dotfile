-- vim.g.loaded = 1
-- vim.g.loaded_netrwPlugin = 1

local ok, nvim_tree = pcall(require, 'nvim-tree')
if not ok then
	print("load nvim-tree error !")
else
	nvim_tree.setup({
		sort_by = "case_sensitive",
		view = {
			adaptive_size = true,
			mappings = {
				list = {
					{ key = "u", action = "dir_up" },
				},
			},
		},
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = true,
		},
    })
end
