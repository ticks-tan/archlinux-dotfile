local res, icons = pcall(require, 'nvim-web-devicons')
if res then
	icons.setup {
		color_icons = true,
		default = true,
	}
end
