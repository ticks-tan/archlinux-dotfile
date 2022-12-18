return {
	nvimcmp = function(lsp, cap)
		lsp.sumneko_lua.setup({
			capabilities = cap,
		})
	end
}
