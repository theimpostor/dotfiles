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
" Plugin 'ntpeters/vim-better-whitespace'
Plugin 'w0rp/ale'
Plugin 'fatih/vim-go'
Plugin 'mileszs/ack.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'leafgarland/typescript-vim'
Plugin 'lyuts/vim-rtags'
Plugin 'towolf/vim-helm'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'majutsushi/tagbar'
" Plugin 'file:///Users/shoda/src/vim-helm'
Plugin 'pangloss/vim-javascript'
Plugin 'posva/vim-vue'
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

" set c/cpp linters, disable ale for Java
let g:ale_linters = {'c': ['clangtidy'], 'cpp': ['clangtidy'], 'java': []}
" let g:ale_linters = {'c': ['cquery'], 'cpp': []}
" let g:ale_linters = {'c': [], 'cc': [], 'cpp': [], 'java': []}

" use clang-tidy defaults instead of enabling EVERYTHING
let g:ale_c_clangtidy_checks = []

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

" YCM shortcuts
nnoremap <leader>yg :YcmCompleter GoTo<CR>
nnoremap <leader>yd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>yr :YcmCompleter GoToReferences<CR>
nnoremap <leader>yt :YcmCompleter GetType<CR>
nnoremap <leader>yc :YcmCompleter GetDoc<CR>

" Close the preview window after completion
let g:ycm_autoclose_preview_window_after_completion = 1

" vim-go shortcuts
autocmd FileType go nmap <leader>gg  <Plug>(go-def)
autocmd FileType go nmap <leader>gf  <Plug>(go-referrers)
autocmd FileType go nmap <leader>gF  <Plug>(go-callstack))

" Automatic identifier highlighting
let g:go_auto_sameids = 1

" " configure vim-go to use quickfix instead of location, since ALE use location
" " list
" let g:go_list_type = "quickfix"

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

" use rtags for tag shortcuts
autocmd Filetype c,cpp nnoremap <C-]> :call rtags#JumpTo(g:SAME_WINDOW)<CR>
autocmd Filetype c,cpp autocmd BufWritePost,FileWritePost,FileAppendPost <buffer> call rtags#ReindexFile()
" autocmd Filetype c nnoremap <C-[> :call rtags#FindRefs()<CR>

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
autocmd Filetype c,cpp xnoremap <Leader>f :py3f /usr/local/opt/llvm/share/clang/clang-format.py<CR>
" format function
autocmd Filetype c,cpp nnoremap <Leader>F [[v][:py3f /usr/local/opt/llvm/share/clang/clang-format.py<CR><C-O><C-O>

" TagBar activation
nnoremap <leader>t :TagbarToggle<CR>
