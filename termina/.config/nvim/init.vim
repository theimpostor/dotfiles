let programming_filetypes = [ 
    \ 'Dockerfile', 
    \ 'bash', 
    \ 'c', 
    \ 'cmake',
    \ 'cpp', 
    \ 'go', 
    \ 'html', 
    \ 'javascript', 
    \ 'python', 
    \ 'rust', 
    \ 'sh', 
    \ 'vim', 
    \ 'yaml',
    \ ]

call plug#begin(stdpath('data') . '/plugged')
Plug 'AndrewRadev/linediff.vim'
Plug 'cespare/vim-toml'
Plug 'dense-analysis/ale', { 'for': programming_filetypes, }
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'github/copilot.vim'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ojroques/vim-oscyank' " OSC52 (hterm/chromeOS) yank to clipboard support
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
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
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

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
    vim.api.nvim_set_option('updatetime', 1000)
    vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
  end
end

local servers = { 'bashls', 'clangd', 'cmake', 'cssls', 'dockerls', 'gopls', 'html', 'jsonls', 'perlls', 'vimls', 'yamlls' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
    }
end
nvim_lsp.tsserver.setup{
    on_attach = on_attach,
    init_options = {
        preferences = {
            disableSuggestions = true
        }
    }
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
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
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

EOF

set background=dark

" enable mouse support
set mouse=a

" allow modified buffers in the background
set hidden

" Doesn't work in termina
" " yank to clipboard (via
" " http://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html)
" if has("clipboard")
"   set clipboard=unnamed " copy to the system clipboard

"   if has("unnamedplus") " X11 support
"     set clipboard+=unnamedplus
"   endif
" endif

vnoremap <leader>c :OSCYank<CR>

" You can also use the OSCYank operator:
" like so for instance:
" <leader>oip  " copy the inner paragraph
nmap <leader>o <Plug>OSCYank

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

" " Normally Vim rerenders the screen after every step of the macro, which looks weird and slows the execution down. With this change it only rerenders at the end of the macro.
" set lazyredraw

" https://www.hillelwayne.com/vim-macro-trickz
" Undoing mistakes
" If you’re recording a macro and make a mistake, don’t start over. Instead, undo it and keep going normally. Once you’re finished with the macro, press "qp to paste it to an empty line, remove the mistaken keystrokes and the undo, and copy it back in with "qy$. Since macros are just keystrokes in a register, this is sufficient the fix whatever you broke.

" Warning: Don’t leave undos in your macro. If you undo in a macro to correct a mistake, always be sure to manually remove the mistake and the undo from the macro. In replay mode, an undo will undo the entire macro up until that point, erasing all of your hard work and bleeding the macro out into the rest of your text.

" Manually adjusting macros
" If after rerunning a macro you discover it has a small mistake, make the adjustments on the stored macro string. F.ex if you wrote dw when you actually meant dW, no reason to rerecord the entire macro.

" Sometimes you want to add a special character or a chord. Maybe you need to add a return or switch windows with c_W or something, there are plenty of different reasons. If you inspect a register with a chord, you might see something like ^M for <CR>. But manually adding in ^M won’t work: Vim will interpret that as ^ (beginning of line) followed by M (go to middle of screen).

" To add special characters, switch to insert mode and press c_V followed by the chord or character. This inserts the terminal code instead of the actual code. If c_V is used for pasting, you can usually use c_Q instead.

" Warning: If you have your own maps, the macro will replay them. Normally this is good, except that it will skip any timeouts you have. For example, I have inoremap jk <esc> to quickly exit insert mode. If I do qqij<wait a second>k<esc>q, I’d expect @q to insert the string jk into my code. But since it didn’t record the wait, it will instead exit insert mode.

" Start with a guard prefix
" The more deterministic the macro, the better. If possible we always want to start in the same relative position with respect to what we’re modifying. Usually that means starting the macro off with a ^ so you’re at the beginning of the line.

" End with a setup suffix
" If you plan to run the macro a lot, end with a suffix that places the cursor where you want the next macro to begin. A common one here is j to go to the next line.

" Useful macro commands
" A lot of stuff that isn’t too useful in everyday vimming becomes really handy when you’re embedding it in a macro.

" Marks
" m[a-z] sets a mark in a given file, '[a-z] jumps to the line, and `[a-z] jumps to the exact position in the line you set the mark. You can use this to set up macros, or track state in the middle of a macro. These marks are local to the file.

" Warning: If you’re manipulating marks or registers in a macro, this will override your existing setup. Either use dedicated “state” markisters or do what I do and be apathetic.

" Example: `adiw`bviwp`aP. Swaps the words under marks a and b.

" Example: o**Warning:** <esc>'add''pkJ Grab a bullet point in your “Gotchas” section you created and move it to a different section as a warning. I probably should have done it the other way around (putting the mark where I wanted to place the warning instead of on the warning it self), but too late for that now!

" File Marks
" This is the same as [a-z] except it’s global: if you’re in a different file, 'A will switch to the file with the given mark. Unsurprisingly, it’s useful for macros spanning multiple files or keeping a slush buffer.

" Example: yy'AGp<c_o><c_o>. Copy to the line to your ‘A file and return to the original position.

" Registers
" You can save and load from registers in the middle of a macro, which gives you the same stateful benefits as file marks. You can also assign to new registers with :let @[a-z]= .... In insert mode, you can paste a register with <c_R>[a-z].

" Example: :let @a=@a+1<CR>iconsole.log(<c_R>a);<esc> Adds a console.log with increasing numbers.

" Example: mayyp`aDjv^r<space>. Split on column.

" abcd =>  ab
"            cd
" Visuals
" Most commands in visual mode exit to normal/insert, so you lose your selection. You can get it back with gv. You can also switch between ends of a selection with o.

" Example: A|<esc>gvohA|<esc>. Add pipes around a selection like a poor man’s vim-surround. You could also do c||<esc>""P instead, but that doesn’t demonstrate visual reselection.

" Conditionals
" If you need a conditional in your macro you should probably be writing a function instead. For very simple conditionals, though, you can probably get away with a “fail fast”. If one of the commands in a macro would cause an error, execution of the macro stops. Possible errors are dy (y isn’t a valid movement) or f, followed by a character not on the line.

" Example: ]}k$hf,x. removes a trailing comma of the last entry in a json object. If there is no trailing comma, does nothing. An alternative is ]}k:s/,$/<cr> if you don’t want to have a fail-fast.

" Recursive Macros
" Macros are best for simple ad-hoc repetitive edits. If you need something more sophisticated, consider using

" A function (:h 41), or
" An external filter (:h !), or
" A regex-based global/substitute (:h :[sgv], :h regex), or
" A snippet plugin, or
" …
" Look Vim has a lot of cool techniques for mass edits, and while macros are powerful, writing recursive macros usually means you picked the wrong tool for the job. But if you want to try recursive macros, this is a pretty decent guide. Although I think they chose the wrong tool. I probably would have done :s!\v(\d\d)/(\d\d)/(\d+)!& : \1-\2\-\3 instead.


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
    :execute "normal i" . generatedUUID . ""
endfunction
noremap <Leader>u :call GenerateUUID()<CR>

" adjust commentstring for c
autocmd FileType c,cpp setlocal commentstring=//\ %s

" enable line numbers for some file types
autocmd FileType bash,c,cpp,go,javascript,perl,sh setlocal number

nnoremap <leader>s :FZF<CR>

" ===
" BEGIN Ack
" ===
" Use ag with ack.vim plugin
if executable('rg')
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

" " Enable ale autocompletion
" let g:ale_completion_enabled = 1

" autocmd Filetype c,cpp nnoremap <C-]> :ALEGoToDefinition<CR>
" autocmd Filetype c,cpp nnoremap <leader>r :ALEFindReferences<CR>

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
