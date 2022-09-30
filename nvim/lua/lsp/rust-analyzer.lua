return {
	nvimcmp = function(lsp, cap)
		lsp.rust_analyzer.setup({
			capabilities = cap,
		})
	end
}
