return {
	nvimcmp = function(lsp, cap)
		lsp.clangd.setup({
			capabilities = cap,
		})
	end
}

