return {
	"R-nvim/R.nvim",
	lazy = false,
	-- version = "~0.1.0",
	config = function()
		-- Create the config variable
		local opts = {
			-- Use radian instead of base R
			R_app = "radian",
			R_cmd = "R", -- Important: Must be "R" not "radian" for compatibility

			-- Set environment for radian to use its own Python
			hook = {
				on_filetype = function()
					vim.env.RADIAN_PYTHON = vim.fn.expand("~/.local/share/uv/tools/radian/bin/python")

					-- Make terminal background transparent
					vim.api.nvim_create_autocmd("TermOpen", {
						pattern = "*radian*",
						callback = function()
							vim.wo.winhl = "Normal:Normal"
						end,
					})
				end,
			},

			-- R options - radian doesn't use traditional R args
			R_args = {},

			-- Proper quit command for radian
			-- R_quit_command = "q()",
			-- Console configuration
			min_editor_width = 72,
			rconsole_width = 80,
			rconsole_height = 00,
			-- Disable object browser auto-start (optional)
			objbr_auto_start = false,
			-- Auto start R REPL on .R file open
			auto_start = "on startup",
			-- Syntax highlighting - disable to use radian's colors
			hl_term = false,
			-- Bracketed paste mode (disable if seeing weird 00~ codes)
			bracketed_paste = true,
			parenblock = true,
			pdfviewer = "open",
		}
		-- Setup the plugin
		require("r").setup(opts)
		-- Disable snippets for R files - only show LSP completions
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "r", "rmd", "quarto" },
			callback = function()
				local cmp = require("cmp")
				cmp.setup.buffer({
					sources = {
						{ name = "nvim_lsp" },
						{ name = "cmp_r" },
						{ name = "buffer" },
						{ name = "path" },
						-- Note: luasnip is NOT included here for R files
					},
				})
			end,
		})
		-- Optional: Custom keybindings
		-- These will ONLY be set when opening R files (buffer-local)
		-- Using <Space>r prefix to avoid conflicts with other keymaps
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "r", "rmd", "quarto" },
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				local keymap_opts = { buffer = bufnr, silent = true, noremap = true }
				-- Start/Stop R
				vim.keymap.set(
					"n",
					"<Leader>rs",
					"<Plug>RStart",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Start R" })
				)
				vim.keymap.set(
					"n",
					"<Leader>rq",
					"<Plug>RClose",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Quit R" })
				)
				-- Send code to R (most used - keep simple)
				vim.keymap.set(
					"n",
					"<Leader>rr",
					"<Plug>RDSendLine",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Send line" })
				)
				vim.keymap.set(
					"v",
					"<Leader>rr",
					"<Plug>RSendSelection",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Send selection" })
				)
				vim.keymap.set(
					"n",
					"<Leader>rf",
					"<Plug>RSendFile",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Send file" })
				)
				vim.keymap.set(
					"n",
					"<Leader>rp",
					"<Plug>RDSendParagraph",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Send paragraph" })
				)
				vim.keymap.set(
					"n",
					"<Leader>rb",
					"<Plug>RSendMBlock",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Send code block" })
				)
				-- R help and documentation
				vim.keymap.set(
					"n",
					"<Leader>rh",
					"<Plug>RHelp",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Help" })
				)
				-- Object browser
				vim.keymap.set(
					"n",
					"<Leader>ro",
					"<Cmd>ROBToggle<CR>",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Toggle object browser" })
				)
				-- Clear console
				vim.keymap.set(
					"n",
					"<Leader>rc",
					"<Cmd>RClearConsole<CR>",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] Clear console" })
				)
				-- View dataframe/object
				vim.keymap.set(
					"n",
					"<Leader>rv",
					"<Plug>RViewDF",
					vim.tbl_extend("force", keymap_opts, { desc = "[R] View dataframe" })
				)
			end,
		})
	end,
}
