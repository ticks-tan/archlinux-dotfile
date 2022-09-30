require('tools')
local mason = Load_Module('mason')
if mason then
	mason.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗"
			}
		}
	})
end

local cmp = Load_Module('cmp')
local lspkind = Load_Module('lspkind')
if cmp and lspkind then
	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn['vsnip#anonymous'](args.body)
			end,
		},
		windows = {},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' }
		}, {
			{ name = 'buffer' },
			{ name = 'path' }
		}),
		mapping = require('keybindings').cmpbind(cmp),
		formatting = {
			format = lspkind.cmp_format({
				with_text = true,
				maxwidth = 50,
				before = function(entry, item)
					item.menu = '['..string.upper(entry.source.name)..']'
					return item
				end
			})
		}
	})

	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' }
		}
	})

	cmp.setup.cmdline(':', {
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
			{ name = 'cmdline' }
		})
	})
end

local cap = Load_Module('cmp_nvim_lsp')
local lsp = Load_Module('lspconfig')
if cap and lsp then
	cap = cap.update_capabilities(vim.lsp.protocol.make_client_capabilities())
	-- 设置clangd
	require('lsp/clangd').nvimcmp(lsp, cap)
	-- 设置rust
	require('lsp/rust-analyzer').nvimcmp(lsp, cap)
	-- 设置lua
	require('lsp/lua_lsp').nvimcmp(lsp, cap)
end
