let programming_filetypes = [ 
    \ 'Dockerfile', 
    \ 'bash', 
    \ 'c', 
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

call plug#begin('~/.local/share/nvim/plugged')
Plug 'AndrewRadev/linediff.vim'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', 'for': programming_filetypes,  }
Plug 'cespare/vim-toml'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
Plug 'inkarkat/vcscommand.vim'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'jackguo380/vim-lsp-cxx-highlight', { 'for': programming_filetypes, }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale', { 'for': programming_filetypes, }
Plug 'zxqfl/tabnine-vim', { 'for': programming_filetypes + [ 'text', 'markdown', 'conf' ], }
call plug#end()

set background=dark

" enable mouse support
set mouse=a

" allow modified buffers in the background
set hidden

" set clipboard=unnamedplus

" Doesn't work in termina
" " yank to clipboard (via
" " http://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html)
" if has("clipboard")
"   set clipboard=unnamed " copy to the system clipboard

"   if has("unnamedplus") " X11 support
"     set clipboard+=unnamedplus
"   endif
" endif

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
autocmd FileType c,cpp,go,sh setlocal number

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
" BEGIN LanguageClient-neovim
" ===
            " \ 'javascript': ['javascript-typescript-stdio'],
            " \ 'javascript': ['flow', 'lsp'],
            " \ 'javascript.jsx': ['flow', 'lsp'],
            " Requires: npm install -g typescript typescript-language-server
            " \ 'javascript': ['typescript-language-server', '--stdio'],
            
let g:LanguageClient_serverCommands = {
            \ 'c': ['ccls', '--log-file=/tmp/ccls.log'],
            \ 'cpp': ['ccls', '--log-file=/tmp/ccls.log'],
            \ 'go': ['gopls'],
            \ 'html': ['html-languageserver', '--stdio'],
            \ 'javascript': ['typescript-language-server', '--stdio'],
            \ 'rust': ['rustup', 'run', 'stable', 'rls'],
            \ 'sh': ['bash-language-server', 'start']
            \ }

" let g:LanguageClient_rootMarkers = {
"             \ 'javascript': ['.flowconfig', 'package.json'],
"             \ }

" synchronous call, slow
" set completefunc=LanguageClient#complete

let g:LanguageClient_selectionUI='location-list'
let g:LanguageClient_fzfContextMenu=0

function LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <buffer> <silent> <C-]>      :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer> <silent> <C-w><C-]> :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
        nnoremap <buffer> <silent> <Leader>rw :call LanguageClient#textDocument_rename()<CR>
        nnoremap <buffer> <silent> <Leader>rf :call LanguageClient#textDocument_references({'includeDeclaration': v:false})<CR>
        nnoremap <buffer> <silent> <Leader>rh :call LanguageClient#textDocument_documentHighlight()<CR>
        nnoremap <buffer> <silent> H          :call LanguageClient#textDocument_documentHighlight()<CR>
        nnoremap <buffer> <silent> K          :call LanguageClient#textDocument_hover()<CR>
    endif
endfunction

function LC_C_maps()
    if filereadable($HOME . '/.config/nvim/ccls.json')
        let g:LanguageClient_loadSettings = 1
        let g:LanguageClient_settingsPath = $HOME . '/.config/nvim/ccls.json'
    endif
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <buffer> <silent> <Leader>rF :call LanguageClient#findLocations({'method':'$ccls/call'})<CR>
        " nnoremap <buffer> <silent> <Leader>rF :call LanguageClient#cquery_callers<CR>
        " nnoremap <buffer> <silent> <Leader>rv :call LanguageClient#cquery_vars<CR>
    endif
endfunction

autocmd FileType * call LC_maps()
autocmd FileType c,cpp call LC_C_maps()

" " fix nvim issues [https://github.com/autozimu/LanguageClient-neovim/issues/269#issuecomment-520157389]:
" let diagnosticsDisplaySettings={
"   \       '1': {
"   \           'name': 'Error',
"   \           'texthl': 'ALEError',
"   \           'signText': 'X',
"   \           'signTexthl': 'ALEErrorSign',
"   \       },
"   \       '2': {
"   \           'name': 'Warning',
"   \           'texthl': 'ALEWarning',
"   \           'signText': '!',
"   \           'signTexthl': 'ALEWarningSign',
"   \       },
"   \       '3': {
"   \           'name': 'Information',
"   \           'texthl': 'ALEInfo',
"   \           'signText': 'i',
"   \           'signTexthl': 'ALEInfoSign',
"   \       },
"   \       '4': {
"   \           'name': 'Hint',
"   \           'texthl': 'ALEInfo',
"   \           'signText': 'h',
"   \           'signTexthl': 'ALEInfoSign',
"   \       },
"   \  }
" let g:LanguageClient_diagnosticsDisplay=diagnosticsDisplaySettings

" ===
" END LanguageClient-neovim
" ===

" ===
" BEGIN ALE
" ===
" set c/cpp linters, disable ale for Java
let g:ale_linters = {
            \ 'bash': ['shellcheck'],
            \ 'c': ['clangtidy'],
            \ 'cpp': ['clangtidy'],
            \ 'go': ['golint'],
            \ 'javascript': ['standard'],
            \ 'rust': ['cargo'],
            \ 'sh': ['shellcheck'],
            \ }

let g:ale_fixers = {
            \ 'c': ['clang-format'],
            \ 'cpp': ['clang-format'],
            \ 'go': ['gofmt'],
            \ 'javascript': ['standard'],
            \ 'rust': ['rustfmt'],
            \ }

" put ale in the quickfix
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" enable go format on save
autocmd FileType go,rust,javascript let b:ale_fix_on_save = 1

" " Enable ale autocompletion
" let g:ale_completion_enabled = 1

" autocmd Filetype c,cpp nnoremap <C-]> :ALEGoToDefinition<CR>
" autocmd Filetype c,cpp nnoremap <leader>r :ALEFindReferences<CR>

nnoremap <leader>f :ALEFix<CR>

" ===
" END ALE
" ===

" ===
" BEGIN YCM / TabNine
" ===
" Provides completion for all file types. See also ~/Library/Preferences/TabNine

" Close the preview window after completion
let g:ycm_autoclose_preview_window_after_completion = 1

" disable YCM diagnostics in favor of languageserver diagnostics
let g:ycm_show_diagnostics_ui = 0

" ===
" END YCM
" ===

" ===
" BEGIN linediff
" ===

xnoremap <leader>l :Linediff<CR>

" ===
" END linediff
" ===
