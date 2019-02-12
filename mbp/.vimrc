" fzf plugin
set rtp+=/usr/local/opt/fzf
nnoremap <leader>s :FZF<CR>

" vundle begin
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'elzr/vim-json'
" cd ~/.vim/bundle/LanguageClient-neovim && ./install.sh
" Plugin 'autozimu/LanguageClient-neovim'
" Plugin 'junegunn/fzf'
" Plugin 'ntpeters/vim-better-whitespace'
" Plugin 'w0rp/ale'
" vim +GoUpdateBinaries
" Plugin 'fatih/vim-go'
Plugin 'mileszs/ack.vim'
" Plugin 'zxqfl/tabnine-vim'
" cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer --go-completer
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'leafgarland/typescript-vim'
" Plugin 'lyuts/vim-rtags'
Plugin 'towolf/vim-helm'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'majutsushi/tagbar'
" Plugin 'file:///Users/shoda/src/vim-helm'
" Plugin 'pangloss/vim-javascript'
" Plugin 'posva/vim-vue'
" Plugin 'pboettch/vim-cmake-syntax'
" Plugin 'file://' . $HOME . '/src/lldb', { 'rtp': '/utils/vim-lldb' }
" Plugin 'file:///usr/local/opt/fzf/plugin/fzf.vim'
" Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'mustache/vim-mustache-handlebars'
" Plugin 'tfnico/vim-gradle'
" Plugin 'mojo.vim'
" Plugin 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
" see set ft=haproxy autocommand
" Plugin 'haproxy'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" vundle end

" set background=dark

" enable mouse support
set mouse=a

" allow modified buffers in the background
set hidden

" yank to clipboard (via
" http://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html)
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

" create dir if it doesn't exist
if !isdirectory($HOME . "/.vim/backup")
    call mkdir($HOME . "/.vim/backup", "p", 0700)
endif
 " extra slash means same filename open in diff dir won't conflict
set backupdir=~/.vim/backup//

if !isdirectory($HOME . "/.vim/swap")
    call mkdir($HOME . "/.vim/swap", "p", 0700)
endif
set directory=~/.vim/swap//

if !isdirectory($HOME . "/.vim/undo")
    call mkdir($HOME . "/.vim/undo", "p", 0700)
endif
set undodir=~/.vim/undo//

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

" Easier location list navigation
nnoremap <C-J> :lprev<CR>
nnoremap <C-K> :lnext<CR>

" Turn off trailing whitespace highlights from ntpeters/vim-better-whitespace
" Use {Enable,Toggle}Whitespace to enable.
" autocmd VimEnter * DisableWhitespace

" Search for visually selected text (http://vim.wikia.com/wiki/Search_for_visually_selected_text)
xnoremap // y/\V<C-R>"<CR>

" delete selected text to 'blackhole' register, then paste
xnoremap p "_dp
xnoremap P "_dP

" Use ag with ack.vim plugin
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Search word under cursor with ack.vim (ag)
" !: don't immediately open first result
nnoremap <leader>a :LAck!<CR>

" ===
" BEGIN ALE
" ===
" javascript/go: error linting, formatting
" c: static analysis / formatting

" set c/cpp linters, disable ale for Java
let g:ale_linters = {'c': ['clangtidy'], 'cpp': ['clangtidy'], 'java': []}
" let g:ale_linters = {'c': ['cquery'], 'cpp': []}
" let g:ale_linters = {'c': [], 'cc': [], 'cpp': [], 'java': []}

" " use clang-tidy defaults instead of enabling EVERYTHING
" let g:ale_c_clangtidy_checks = []

let g:ale_fixers = { 'javascript': ['standard'], 'go': ['gofmt'], 'c': ['clang-format'] }

" put ale in the quickfix
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" " Only run linters named in ale_linters settings.
" let g:ale_linters_explicit = 1

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

" YCM shortcuts
nnoremap <leader>yg :YcmCompleter GoTo<CR>
nnoremap <leader>yd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>yr :YcmCompleter GoToReferences<CR>
nnoremap <leader>yt :YcmCompleter GetType<CR>
nnoremap <leader>yc :YcmCompleter GetDoc<CR>

" Close the preview window after completion
let g:ycm_autoclose_preview_window_after_completion = 1

" disable YCM diagnostics in favor of languageserver diagnostics
let g:ycm_show_diagnostics_ui = 0

" ===
" END YCM
" ===

" ===
" BEGIN vim-go
" ===
" go: provides jump to definition, symbol rename, compile error/warning,
" completion

" vim-go shortcuts
autocmd FileType go nmap <leader>gg  <Plug>(go-def)
autocmd FileType go nmap <leader>gf  <Plug>(go-referrers)
autocmd FileType go nmap <leader>gF  <Plug>(go-callstack))
autocmd FileType go nmap <leader>rf  <Plug>(go-referrers)
autocmd FileType go nmap <leader>rF  <Plug>(go-callers))

" Automatic identifier highlighting
let g:go_auto_sameids = 1

" " configure vim-go to use quickfix instead of location, since ALE use location
" " list
" let g:go_list_type = "quickfix"

" ===
" END vim-go
" ===

autocmd Filetype yaml,markdown set sw=2 ts=2

fu! GenerateUUID()

py3 << EOF
import uuid
import vim

# output a uuid to the vim variable for insertion below
vim.command("let generatedUUID = \"%s\"" % str(uuid.uuid4()))

EOF

" insert the python generated uuid into the current cursor's position
:execute "normal i" . generatedUUID . ""

endfunction

"initialize the generateUUID function here and map it to a local command
noremap <Leader>u :call GenerateUUID()<CR>

" " use rtags for tag shortcuts
" autocmd Filetype c,cpp nnoremap <C-]> :call rtags#JumpTo(g:SAME_WINDOW)<CR>
" autocmd Filetype c,cpp autocmd BufWritePost,FileWritePost,FileAppendPost <buffer> call rtags#ReindexFile()
" " autocmd Filetype c nnoremap <C-[> :call rtags#FindRefs()<CR>

" abbreviations TODO move to project
autocmd FileType c iabbrev <buffer> TO  TIBEX_OK(e)
autocmd FileType c iabbrev <buffer> TNO TIBEX_NOT_OK(e)
autocmd FileType c iabbrev <buffer> TA  TIB_ARGS(e)
autocmd FileType c iabbrev <buffer> TAI TIB_ARGS_IGNR_EX(e)
autocmd FileType c iabbrev <buffer> TAP TIB_ARG_PUBLIC(ep)

autocmd FileType c iabbrev <buffer> cL checkpointList
autocmd FileType c iabbrev <buffer> cp checkpoint
autocmd FileType c iabbrev <buffer> cps checkpoints
autocmd FileType c iabbrev <buffer> tdgcp _tibdgCheckpoint
autocmd FileType c iabbrev <buffer> tdgcpl _tibdgCheckpointList

" adjust commentstring for c
autocmd FileType c setlocal commentstring=//\ %s

" format file
" normal mode whole file formatting provided by ALE
autocmd Filetype c,cpp xnoremap <Leader>f :py3f /usr/local/opt/llvm/share/clang/clang-format.py<CR>
autocmd Filetype c,cpp xnoremap <Leader>F :py3f /usr/local/opt/llvm/share/clang/clang-format.py<CR>
" format function
autocmd Filetype c,cpp nnoremap <Leader>F [[v][:py3f /usr/local/opt/llvm/share/clang/clang-format.py<CR><C-O><C-O>

" TagBar activation
nnoremap <leader>t :TagbarToggle<CR>

" ===
" BEGIN LanguageClient-neovim
" ===
" C/CPP/sh: provides jump to definition, symbol rename, compile error/warning
" highlighting

" let g:LanguageClient_serverCommands = {
"             \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
"             \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
"             \ }

if filereadable($HOME . '/.vim/.ccls.json')
    let g:LanguageClient_loadSettings = 1
    let g:LanguageClient_settingsPath = $HOME . '/.vim/.ccls.json'
endif

let g:LanguageClient_serverCommands = {
            \ 'cpp': ['ccls', '--log-file=/tmp/ccls.log'],
            \ 'c': ['ccls', '--log-file=/tmp/ccls.log'],
            \ 'sh': ['bash-language-server', 'start']
            \ }
" set completefunc=LanguageClient#complete
let g:LanguageClient_selectionUI='location-list'
let g:LanguageClient_fzfContextMenu=0

function LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <buffer> <silent> <C-]> :call LanguageClient#textDocument_definition()<CR>
        nnoremap <buffer> <silent> <Leader>rw :call LanguageClient#textDocument_rename()<CR>
        nnoremap <buffer> <silent> <Leader>rf :call LanguageClient#textDocument_references()<CR>

        nnoremap <buffer> <silent> <Leader>rF :call LanguageClient#findLocations({'method':'$ccls/call'})<CR>
        nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>

        " currently fails with: 'Vim(let):E117: Unknown function: nvim_win_get_buf'
        " nnoremap <buffer> <silent> <Leader>rh :call LanguageClient#textDocument_documentHighlight()<CR>

        " nnoremap <buffer> <silent> <Leader>rF :call LanguageClient#cquery_callers<CR>
        " nnoremap <buffer> <silent> <Leader>rv :call LanguageClient#cquery_vars<CR>
        " nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
        " nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
    endif
endfunction

autocmd FileType * call LC_maps()

" ===
" END LanguageClient-neovim
" ===

