local res, lualine = pcall(require, 'lualine')
if res then
	lualine.setup {
		options = { theme = 'material' }
	}
end

