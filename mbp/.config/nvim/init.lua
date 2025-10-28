-- plugin setup
vim.opt.runtimepath:append('/usr/local/opt/fzf')

local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')
Plug('editorconfig/editorconfig-vim')
Plug('folke/tokyonight.nvim')
Plug('github/copilot.vim')
Plug('hedyhli/outline.nvim') -- code outline window
Plug('inkarkat/vim-ingo-library') -- needed for vim-mark
Plug('inkarkat/vim-mark') -- highlight multiple words with different colors
Plug('mileszs/ack.vim')
Plug('neovim/nvim-lspconfig')
Plug('nvim-lualine/lualine.nvim')
Plug('nvim-tree/nvim-web-devicons') -- required for lualine.nvim
Plug('nvim-treesitter/nvim-treesitter', { ['branch'] = 'main', ['do'] = ':TSUpdate' })
Plug('p00f/clangd_extensions.nvim')
Plug('RRethy/vim-illuminate') -- highlight other uses of the word under the cursor
Plug('tpope/vim-commentary')
Plug('tpope/vim-fugitive')
Plug('tpope/vim-obsession')
Plug('tpope/vim-repeat')
Plug('tpope/vim-surround')
Plug('tpope/vim-unimpaired')
vim.call('plug#end')

-- vim.lsp.set_log_level("debug")
-- vim.lsp.set_log_level("trace")

-- enable line numbers
vim.opt.number = true

-- highlight search term
vim.opt.hlsearch = true

-- case insensitive searches...
vim.opt.ignorecase = true

-- ...unless the search string has upper case
vim.opt.smartcase = true

-- don't wrap long lines in the middle of a word
vim.opt.linebreak = true

-- indent / tab width
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- use spaces instead of tabs
vim.opt.expandtab = true

--  enable persistent undo
vim.opt.undofile = true

-- lots of undo
vim.opt.undolevels = 10000

-- center search results - https://vim.fandom.com/wiki/Keep_your_cursor_centered_vertically_on_the_screen
-- toggle scrolloff setting
vim.keymap.set("n", "<Leader>zz", function()
    vim.opt.scrolloff = 999 - vim.opt.scrolloff:get()
end)

-- Search for visually selected text (http://vim.wikia.com/wiki/Search_for_visually_selected_text)
-- - Binds // in Visual mode via vim.keymap.set("x", "//", [[y/\V<C-R>=escape(@", '\/')<CR><CR>]]).
-- - y copies the current visual selection into the unnamed register, preserving the text for reuse.
-- - /\V starts a forward search in “very nomagic” mode so every character is literal unless escaped explicitly.
-- - <C-R>=escape(@", '\/')<CR> runs a Vimscript expression right on the command line: escape() takes the yanked text in @" and prefixes any / or \ with \, so the search pattern isn’t prematurely terminated.
-- - The final <CR> executes the completed search command, jumping to the next exact match of the highlighted text.
vim.keymap.set("x", "//", [[y/\V<C-R>=escape(@", '\/')<CR><CR>]])

-- -- delete selected text to "blackhole" register, then paste
-- vim.keymap.set("x", "p", [["_dp]])
-- vim.keymap.set("x", "P", [["_dP]])

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>", { desc = "Quickfix next" })
vim.keymap.set("n", "<C-j>", "<cmd>cprevious<CR>", { desc = "Quickfix previous" })

-- show diagnostics inline
vim.diagnostic.config({ virtual_text = true })

vim.keymap.set("n", "<leader>s", ":FZF<CR>")

-- copy the current filename to the system clipboard
vim.keymap.set("n", "<leader>c", ':let @+ = expand("%:p")<CR>', { desc = "Copy current filename to system clipboard" })
vim.keymap.set("x", "<leader>c", '"+y', { desc = "Copy selection to system clipboard" })
vim.keymap.set("n", "<leader>v", '"+p', { desc = "Paste from system clipboard" })

vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting with escape in normal mode" })

-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local tree_sitter_filetypes = {
    'bash',
    'c',
    'cmake',
    'cpp',
    'diff',
    -- 'dockerfile',
    'gitcommit',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'gotmpl',
    'gowork',
    'groovy',
    'html',
    'java',
    'javadoc',
    'javascript',
    'lua',
    'markdown_inline',
    'markdown',
    'python',
    'query',
    'rust',
    'sql',
    'ssh_config',
    'toml',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
}

require('nvim-treesitter').install(tree_sitter_filetypes)
vim.api.nvim_create_autocmd('FileType', {
  pattern = tree_sitter_filetypes,
  callback = function()
      vim.treesitter.start()
  end,
})

require('lualine').setup({
  options = {
    theme = 'tokyonight',
  },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      },
      {
        'nvim_treesitter#statusline',
      },
    },
  },
})

-- For VIM lua configuration
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

-- vim.lsp.enable('copilot')
-- vim.lsp.enable('docker_compose_language_service')
-- vim.lsp.enable('dockerls')
vim.lsp.enable('bashls')
vim.lsp.enable('clangd')
vim.lsp.enable('cmake')
vim.lsp.enable('docker_language_server')
vim.lsp.enable('golangci_lint_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('jsonls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('ruff')
vim.lsp.enable('ts_ls')

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('GoFormatOnSave', { clear = true }),
  pattern = '*.go',
  callback = function(args)
    vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 2000 })
  end,
})
vim.lsp.enable('yamlls')

-- https://neovim.io/doc/user/lsp.html#_global-defaults
-- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
-- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
-- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
-- "grr" is mapped in Normal mode to vim.lsp.buf.references()
-- "grt" is mapped in Normal mode to vim.lsp.buf.type_definition()
-- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
-- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()
-- "an" and "in" are mapped in Visual mode to outer and inner incremental selections, respectively, using vim.lsp.buf.selection_range()

if vim.fn.executable('ackprg') == 1 then
  vim.g.ackprg = 'ackprg'
elseif vim.fn.executable('rg') == 1 then
  vim.g.ackprg = 'rg --vimgrep --sort path --max-columns 240 --max-columns-preview'
elseif vim.fn.executable('ag') == 1 then
  vim.g.ackprg = 'ag --vimgrep'
end

vim.keymap.set('n', '<leader>a', ':Ack!<CR>')
vim.keymap.set('n', '<leader>gg', ':Ack ')
vim.keymap.set('n', '<leader>ga', ':AckAdd ')
vim.keymap.set('n', '<leader>gs', ':Ack "ssh todo"<CR>')

vim.api.nvim_create_user_command('Ctag', function(opts)
  local cmd = string.format('Ack -tc -sFw %s', vim.fn.shellescape(opts.args))
  vim.cmd(cmd)
end, { nargs = 1 })

require("outline").setup({})
vim.keymap.set('n', '<leader>t', '<cmd>Outline<CR>')

-- https://vimtricks.com/p/automated-file-templates/
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.sh",
    command = "0r !curl -fsSL https://raw.githubusercontent.com/theimpostor/templates/main/bash/template.sh",
})
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "main.c",
    command = "0r !curl -fsSL https://raw.githubusercontent.com/theimpostor/templates/main/c/main.c",
})
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "main.go",
    command = "0r !curl -fsSL https://raw.githubusercontent.com/theimpostor/templates/main/go/main.go",
})
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.py",
    command = "0r !curl -fsSL https://raw.githubusercontent.com/theimpostor/templates/refs/heads/main/python/template.py",
})

-- https://vi.stackexchange.com/a/456
function TrimWhitespace()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
end
vim.api.nvim_create_user_command("TrimWhitespace", TrimWhitespace, {})

-- inkarkat/vim-mark settings
-- https://github.com/inkarkat/vim-mark?tab=readme-ov-file#configuration
-- default: 6 colors
-- extended: up to 18 colors
-- maximum: 27, 58, or even 77 colors, depending on the number of available colors
vim.g.mwDefaultHighlightingPalette = "extended"

-- Activate folke/tokyonight.nvim
vim.cmd('colorscheme tokyonight')
