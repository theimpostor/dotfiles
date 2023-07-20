" fzf managed by homebrew, use plugin from there
set rtp+=/usr/local/opt/fzf
nnoremap <leader>s :FZF<CR>

call plug#begin(stdpath('data') . '/plugged')
Plug 'AndrewRadev/linediff.vim'
Plug 'cespare/vim-toml'
Plug 'dense-analysis/ale', { 'for': [ 'bash', 'go', 'html', 'css', 'javascript', 'sh', 'perl', 'cmake', 'dockerfile' ] }
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'inkarkat/vcscommand.vim'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'preservim/tagbar'
Plug 'mileszs/ack.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ojroques/nvim-osc52' " OSC52 (hterm/chromeOS) yank to clipboard support
Plug 'towolf/vim-helm'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'vim-airline/vim-airline'
call plug#end()

if $COLORTERM=='truecolor'
    set termguicolors
endif

" undo nvim default behavior change
nnoremap Y Y

" neovim lsp config
" full list here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
lua << EOF
-- vim.lsp.set_log_level("debug")

local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')

-- updatetime is milliseconds before cursorhold events fire, and also how often swap file is written
vim.o.updatetime = 1000

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- enable line number for lsp filetypes
    vim.wo.number = true

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<Leader>rw', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<Leader>rf', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-p>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    buf_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr()')
    buf_set_keymap('n', '<Leader>=', 'gqq', opts)
    buf_set_keymap('x', '<leader>f', 'gq', opts)
    buf_set_keymap('n', '<Leader>F', 'mfvi}gq`f', opts)

    -- https://www.reddit.com/r/neovim/comments/nwjyg3/comment/h1a1794/
    -- for highlighting to work... https://github.com/neovim/nvim-lspconfig/issues/379
    if client.supports_method('textDocument/documentHighlight') then
        buf_set_keymap('n', 'H', '<cmd>lua vim.lsp.buf.document_highlight()<CR>', opts)
        vim.api.nvim_exec([[
            hi LspReferenceRead cterm=bold gui=bold ctermbg=red guibg=Purple
            hi LspReferenceText cterm=bold gui=bold ctermbg=red guibg=Purple
            hi LspReferenceWrite cterm=bold gui=bold ctermbg=red guibg=Purple
        ]], false)
        vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
        vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
        vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
    end
end

-- Add additional capabilities supported by nvim-cmp
capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = { 'bashls', 'clangd', 'cmake', 'cssls', 'dockerls', 'html', 'jsonls', 'perlls', 'vimls' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end
nvim_lsp.yamlls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        yaml = {
            -- BUG: https://github.com/redhat-developer/yaml-language-server/pull/859
            keyOrdering = false
        }
    }
}
nvim_lsp.gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = {
                shadow = true,
                unusedparams = true,
            },
            staticcheck = true,
        }
    }
}

nvim_lsp.tsserver.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        preferences = {
            disableSuggestions = true
        }
    }
}

-- nvim_lsp.groovyls.setup{
--     on_attach = on_attach,
--     capabilities = capabilities,
--     cmd = { "java", "-jar", "/Users/shoda/.local/groovy-language-server/build/libs/groovy-language-server-all.jar" },
-- }

nvim_lsp.jdtls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = util.root_pattern(
            '.project', -- eclipse
            'build.xml', -- Ant
            'pom.xml', -- Maven
            'settings.gradle', -- Gradle
            'settings.gradle.kts', -- Gradle
            'build.gradle',
            'build.gradle.kts'
    ) or vim.fn.getcwd()
}

-- lsp use location list instead of quickfix list
local on_references = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
    on_references, {
        loclist = true,
    }
)

-- treesitter stuff
require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", or a list of languages
    sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
    -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = { "bash", "make", "diff" },  -- list of language that will be disabled
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            -- normal mode keymaps
            init_selection = '<CR>',
            scope_incremental = '<CR>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
        }
    }
}

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
    },
    sources = {
        { name = 'cmp_tabnine' },
        { name = 'nvim_lsp' },
    },
}
EOF

set background=dark

" enable mouse support
set mouse=a

" allow modified buffers in the background
set hidden

" enable persistent undo
set undofile

" highlight search term
set hlsearch

" case insensitive searches...
set ignorecase

" ...unless the search string has upper case
set smartcase

" don't wrap long lines in the middle of a word
set linebreak

" indent / tab width
set shiftwidth=4
set tabstop=4

" use spaces instead of tabs
set expandtab

" center search results - https://vim.fandom.com/wiki/Keep_your_cursor_centered_vertically_on_the_screen
" toggle scrolloff setting
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

" chmod +x current file
" https://unix.stackexchange.com/questions/102455/make-script-executable-from-vi-vim
nnoremap <Leader>x :! chmod +x %<CR><CR>

" Easier location list navigation
nnoremap <C-J> :lprev<CR>
nnoremap <C-K> :lnext<CR>

" Search for visually selected text (http://vim.wikia.com/wiki/Search_for_visually_selected_text)
xnoremap // y/\V<C-R>"<CR>

" delete selected text to 'blackhole' register, then paste
xnoremap p "_dp
xnoremap P "_dP

" In normal Vim Q switches you to Ex mode, which is almost never what you want. Instead, we’ll have it repeat the last macro you used, which makes using macros a lot more pleasant.
nnoremap Q @@

" Normally Vim rerenders the screen after every step of the macro, which looks weird and slows the execution down. With this change it only rerenders at the end of the macro.
set lazyredraw

" Editing macros:
" https://www.hillelwayne.com/vim-macro-trickz

" let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

" use indent of 2 for yaml and markdown
autocmd Filetype yaml,markdown set sw=2 ts=2

" initialize the generateUUID function here and map it to a local command
function GenerateUUID()
    py3 << EOF
import uuid
import vim
# output a uuid to the vim variable for insertion below
vim.command("let generatedUUID = \"%s\"" % str(uuid.uuid4()))
EOF
    " insert the python generated uuid into the current cursor's position
    :execute "normal i" . generatedUUID . ""
endfunction
noremap <Leader>u :call GenerateUUID()<CR>

" adjust commentstring for c
autocmd FileType c,cpp setlocal commentstring=//\ %s

" https://vi.stackexchange.com/a/456
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()


" abbreviations TODO move to project
autocmd FileType c,cpp iabbrev <buffer> TO   TIBEX_OK(e)
autocmd FileType c,cpp iabbrev <buffer> TNO  TIBEX_NOT_OK(e)
autocmd FileType c,cpp iabbrev <buffer> TA   TIB_ARGS(e)
autocmd FileType c,cpp iabbrev <buffer> TAI  TIB_ARGS_IGNR_EX(e)
autocmd FileType c,cpp iabbrev <buffer> TAP  TIB_ARG_PUBLIC(ep)
autocmd FileType c,cpp iabbrev <buffer> TAD  TIB_ARGS_DECL(e)
autocmd FileType c,cpp iabbrev <buffer> TADI TIB_ARGS_DECL_IGNR_EX(e)

" templates
" https://vimtricks.com/p/automated-file-templates/
autocmd BufNewFile *.sh 0r !curl -fsSL https://raw.githubusercontent.com/theimpostor/templates/main/bash/template.sh
autocmd BufNewFile main.c 0r !curl -fsSL https://raw.githubusercontent.com/theimpostor/templates/main/c/main.c
autocmd BufNewFile main.go 0r !curl -fsSL https://raw.githubusercontent.com/theimpostor/templates/main/go/main.go

" set textwidth to 80 for markdown
" https://thoughtbot.com/blog/wrap-existing-text-at-80-characters-in-vim
autocmd BufRead,BufNewFile *.md setlocal textwidth=80

autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy

" ===
" BEGIN oscyank
" ===

lua << EOF
-- vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
vim.keymap.set('n', '<leader>c', [[<cmd>lua require('osc52').copy(vim.fn.expand('%:p'))<CR>]], { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
vim.keymap.set('x', '<leader>c', require('osc52').copy_visual)
EOF
" ===
" END oscyank
" ===

" ===
" BEGIN vcscommand
" ===
nnoremap <leader>vd :VCSVimDiff<CR>
" ===
" END vcscommand
" ===

nnoremap <leader>s :FZF<CR>

" ===
" BEGIN Ack
" ===
" Use ag with ack.vim plugin
if executable('ackprg')
    let g:ackprg = 'ackprg'
elseif executable('rg')
    let g:ackprg = 'rg --vimgrep --sort path'
elseif executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" Search word under cursor with ack.vim (ag)
" !: don't immediately open first result
nnoremap <leader>a :LAck!<CR>
nnoremap <leader>gg :LAck 
nnoremap <leader>ga :LAckAdd 
nnoremap <leader>gs :LAck "ssh todo"<CR>
" ===
" END Ack
" ===

" ===
" BEGIN TagBar
" ===
" TagBar activation
nnoremap <leader>t :TagbarToggle<CR>
" ===
" END TagBar
" ===

" ===
" BEGIN vim-airline
" ===
let g:airline_powerline_fonts = 1
" ===
" END vim-airline
" ===

" ===
" BEGIN ALE
" ===
" set c/cpp linters, disable ale for Java
let g:ale_linters = {
            \ 'bash': ['shellcheck'],
            \ 'cmake': ['cmakelint'],
            \ 'dockerfile': ['hadolint'],
            \ 'go': ['govet'],
            \ 'javascript': ['standard'],
            \ 'sh': ['shellcheck'],
            \ 'perl': ['perl']
            \ }

let g:ale_fixers = {
            \ 'go': ['gofmt'],
            \ 'javascript': ['standard'],
            \ }

" put ale in the quickfix
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" enable go format on save
autocmd FileType go,javascript let b:ale_fix_on_save = 1
" autocmd FileType javascript let b:ale_fix_on_save = 1

" nnoremap <leader>f :ALEFix<CR>
" ===
" END ALE
" ===

" ===
" BEGIN linediff
" ===
xnoremap <leader>l :Linediff<CR>
" ===
" END linediff
" ===
