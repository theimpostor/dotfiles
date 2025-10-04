-- plugin setup
local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')
Plug('editorconfig/editorconfig-vim')
Plug('folke/tokyonight.nvim')
Plug('github/copilot.vim')
Plug('hedyhli/outline.nvim') -- code outline window
Plug('inkarkat/vim-ingo-library') -- needed for vim-mark
Plug('inkarkat/vim-mark') -- highlight multiple words with different colors
Plug('mileszs/ack.vim')
Plug('junegunn/fzf', { ['dir'] = '~/.fzf', ['do'] = './install --all' })
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

-- -- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
-- local tree_sitter_filetypes = {
--     'bash',
--     'c',
--     'cmake',
--     'cpp',
--     'diff',
--     'dockerfile',
--     'gitcommit',
--     'gitignore',
--     'go',
--     'gomod',
--     'gosum',
--     'gotmpl',
--     'gowork',
--     'groovy',
--     'html',
--     'java',
--     'javadoc',
--     'javascript',
--     'lua',
--     'markdown_inline',
--     'markdown',
--     'python',
--     'query',
--     'rust',
--     'sql',
--     'ssh_config',
--     'toml',
--     'typescript',
--     'vim',
--     'vimdoc',
--     'yaml',
-- }
--
-- require('nvim-treesitter').install(tree_sitter_filetypes)
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = tree_sitter_filetypes,
--   callback = function()
--       vim.treesitter.start()
--   end,
-- })

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

vim.lsp.enable('bashls')
vim.lsp.enable('clangd')
vim.lsp.enable('cmake')
-- vim.lsp.enable('copilot')
vim.lsp.enable('docker_language_server')
vim.lsp.enable('golangci_lint_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('jsonls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('ruff')
vim.lsp.enable('ts_ls')
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





-- OLD init.vim
--
-- call plug#begin(stdpath('data') . '/plugged')
-- Plug 'AndrewRadev/linediff.vim'
-- Plug 'cespare/vim-toml'
-- Plug 'dense-analysis/ale', { 'for': [ 'bash', 'go', 'javascript', 'sh', 'perl', ] }
-- Plug 'editorconfig/editorconfig-vim'
-- Plug 'elzr/vim-json'
-- Plug 'github/copilot.vim'
-- Plug 'inkarkat/vim-ingo-library'
-- Plug 'inkarkat/vim-mark'
-- Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
-- Plug 'majutsushi/tagbar'
-- Plug 'mileszs/ack.vim'
-- Plug 'neovim/nvim-lspconfig'
-- Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
-- Plug 'ojroques/vim-oscyank' " OSC52 (hterm/chromeOS) yank to clipboard support
-- Plug 'tpope/vim-commentary'
-- Plug 'tpope/vim-fugitive'
-- Plug 'tpope/vim-repeat'
-- Plug 'tpope/vim-surround'
-- Plug 'tpope/vim-unimpaired'
-- Plug 'vim-airline/vim-airline'
-- call plug#end()
--
-- if $COLORTERM=='truecolor'
--     set termguicolors
-- endif
--
-- " undo nvim default behavior change
-- nnoremap Y Y
--
-- " neovim lsp config
-- " full list here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- lua << EOF
-- local nvim_lsp = require('lspconfig')
--
-- -- updatetime is milliseconds before cursorhold events fire, and also how often swap file is written
-- vim.o.updatetime = 1000
--
-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--     local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--     local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
--
--     -- Mappings.
--     local opts = { noremap=true, silent=true }
--
--     -- enable line number for lsp filetypes
--     vim.wo.number = true
--
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--     buf_set_keymap('n', '<Leader>rw', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--     buf_set_keymap('n', '<Leader>rf', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--     buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--     buf_set_keymap('n', '<C-p>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
--     buf_set_keymap('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
--
--     buf_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr()')
--     buf_set_keymap('n', '<Leader>=', 'gqq', opts)
--     buf_set_keymap('x', '<leader>f', 'gq', opts)
--     buf_set_keymap('n', '<Leader>F', 'mfvi}gq`f', opts)
--
--     -- https://www.reddit.com/r/neovim/comments/nwjyg3/comment/h1a1794/
--     -- for highlighting to work... https://github.com/neovim/nvim-lspconfig/issues/379
--     if client.supports_method('textDocument/documentHighlight') then
--         buf_set_keymap('n', 'H', '<cmd>lua vim.lsp.buf.document_highlight()<CR>', opts)
--         vim.api.nvim_exec([[
--             hi LspReferenceRead cterm=bold gui=bold ctermbg=red guibg=Purple
--             hi LspReferenceText cterm=bold gui=bold ctermbg=red guibg=Purple
--             hi LspReferenceWrite cterm=bold gui=bold ctermbg=red guibg=Purple
--         ]], false)
--         vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
--         vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
--         vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
--     end
-- end
--
-- local servers = { 'bashls', 'clangd', 'cmake', 'cssls', 'dockerls', 'gopls', 'html', 'jsonls', 'perlls', 'vimls', 'yamlls' }
-- for _, lsp in ipairs(servers) do
--     nvim_lsp[lsp].setup {
--         on_attach = on_attach,
--     }
-- end
-- nvim_lsp.tsserver.setup{
--     on_attach = on_attach,
--     init_options = {
--         preferences = {
--             disableSuggestions = true
--         }
--     }
-- }
--
-- -- lsp use location list instead of quickfix list
-- local on_references = vim.lsp.handlers["textDocument/references"]
-- vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
--     on_references, {
--         loclist = true,
--     }
-- )
--
-- -- treesitter stuff
-- require'nvim-treesitter.configs'.setup {
--     ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
--     sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
--     -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
--     highlight = {
--         enable = true,              -- false will disable the whole extension
--         -- disable = { "c", "rust" },  -- list of language that will be disabled
--         -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--         -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--         -- Using this option may slow down your editor, and you may see some duplicate highlights.
--         -- Instead of true it can also be a list of languages
--         additional_vim_regex_highlighting = false,
--     },
--     incremental_selection = {
--         enable = true,
--         keymaps = {
--             -- normal mode keymaps
--             init_selection = '<CR>',
--             scope_incremental = '<CR>',
--             node_incremental = '<TAB>',
--             node_decremental = '<S-TAB>',
--         }
--     }
-- }
--
-- EOF
--
-- set background=dark
--
-- " enable mouse support
-- set mouse=a
--
-- " allow modified buffers in the background
-- set hidden
--
-- " enable persistent undo
-- set undofile
--
-- " highlight search term
-- set hlsearch
--
-- " case insensitive searches...
-- set ignorecase
--
-- " ...unless the search string has upper case
-- set smartcase
--
-- " don't wrap long lines in the middle of a word
-- set linebreak
--
-- " indent / tab width
-- set shiftwidth=4
-- set tabstop=4
--
-- " use spaces instead of tabs
-- set expandtab
--
-- " center search results - https://vim.fandom.com/wiki/Keep_your_cursor_centered_vertically_on_the_screen
-- " toggle scrolloff setting
-- nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>
--
-- " chmod +x current file
-- " https://unix.stackexchange.com/questions/102455/make-script-executable-from-vi-vim
-- nnoremap <Leader>x :! chmod +x %<CR><CR>
--
-- " Easier location list navigation
-- nnoremap <C-J> :lprev<CR>
-- nnoremap <C-K> :lnext<CR>
--
-- " Search for visually selected text (http://vim.wikia.com/wiki/Search_for_visually_selected_text)
-- xnoremap // y/\V<C-R>"<CR>
--
-- " delete selected text to 'blackhole' register, then paste
-- xnoremap p "_dp
-- xnoremap P "_dP
--
-- " In normal Vim Q switches you to Ex mode, which is almost never what you want. Instead, we’ll have it repeat the last macro you used, which makes using macros a lot more pleasant.
-- nnoremap Q @@
--
-- " " Normally Vim rerenders the screen after every step of the macro, which looks weird and slows the execution down. With this change it only rerenders at the end of the macro.
-- " set lazyredraw
--
-- " Editing macros:
-- " https://www.hillelwayne.com/vim-macro-trickz
--
--
-- " use indent of 2 for yaml and markdown
-- autocmd Filetype yaml,markdown set sw=2 ts=2
--
-- " initialize the generateUUID function here and map it to a local command
-- function GenerateUUID()
--     py3 << EOF
-- import uuid
-- import vim
-- # output a uuid to the vim variable for insertion below
-- vim.command("let generatedUUID = \"%s\"" % str(uuid.uuid4()))
-- EOF
--     " insert the python generated uuid into the current cursor's position
--     :execute "normal i" . generatedUUID . ""
-- endfunction
-- noremap <Leader>u :call GenerateUUID()<CR>
--
-- " adjust commentstring for c
-- autocmd FileType c,cpp setlocal commentstring=//\ %s
--
--
-- nnoremap <leader>s :FZF<CR>
--
-- " ===
-- " BEGIN oscyank
-- " ===
-- vnoremap <leader>c :OSCYank<CR>
--
-- " You can also use the OSCYank operator:
-- " like so for instance:
-- " <leader>oip  " copy the inner paragraph
-- nmap <leader>o <Plug>OSCYank
-- " ===
-- " END oscyank
-- " ===
--
--
-- " ===
-- " BEGIN Ack
-- " ===
-- " Use ag with ack.vim plugin
-- if executable('rg')
--     let g:ackprg = 'rg --vimgrep --sort path'
-- elseif executable('ag')
--     let g:ackprg = 'ag --vimgrep'
-- endif
--
-- " Search word under cursor with ack.vim (ag)
-- " !: don't immediately open first result
-- nnoremap <leader>a :LAck!<CR>
-- nnoremap <leader>gg :LAck
-- nnoremap <leader>ga :LAckAdd
-- nnoremap <leader>gs :LAck "ssh todo"<CR>
-- " ===
-- " END Ack
-- " ===
--
-- " ===
-- " BEGIN TagBar
-- " ===
-- " TagBar activation
-- nnoremap <leader>t :TagbarToggle<CR>
-- " ===
-- " END TagBar
-- " ===
--
-- " ===
-- " BEGIN vim-airline
-- " ===
-- let g:airline_powerline_fonts = 1
-- " ===
-- " END vim-airline
-- " ===
--
-- " ===
-- " BEGIN ALE
-- " ===
-- " set c/cpp linters, disable ale for Java
-- let g:ale_linters = {
--             \ 'bash': ['shellcheck'],
--             \ 'go': ['govet'],
--             \ 'javascript': ['standard'],
--             \ 'sh': ['shellcheck'],
--             \ 'perl': ['perl']
--             \ }
--
-- let g:ale_fixers = {
--             \ 'go': ['gofmt'],
--             \ 'javascript': ['standard'],
--             \ }
--
-- " put ale in the quickfix
-- let g:ale_set_loclist = 0
-- let g:ale_set_quickfix = 1
--
-- " Only run linters named in ale_linters settings.
-- let g:ale_linters_explicit = 1
--
-- " enable go format on save
-- autocmd FileType go,javascript let b:ale_fix_on_save = 1
--
-- " nnoremap <leader>f :ALEFix<CR>
-- " ===
-- " END ALE
-- " ===
--
-- " ===
-- " BEGIN linediff
-- " ===
-- xnoremap <leader>l :Linediff<CR>
-- " ===
-- " END linediff
-- " ===
