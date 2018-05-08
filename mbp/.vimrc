" fzf plugin
set rtp+=/usr/local/opt/fzf
nnoremap <leader>f :FZF<CR>

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
Plugin 'elzr/vim-json'
" Plugin 'ntpeters/vim-better-whitespace'
Plugin 'w0rp/ale'
Plugin 'fatih/vim-go'
Plugin 'mileszs/ack.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'lyuts/vim-rtags'
Plugin 'towolf/vim-helm'
" Plugin 'file:///Users/shoda/src/vim-helm'
" Plugin 'file:///usr/local/opt/fzf/plugin/fzf.vim'
" Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'mustache/vim-mustache-handlebars'
" Plugin 'tfnico/vim-gradle'
" Plugin 'mojo.vim'
" Plugin 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
" see set ft=haproxy autocommand
" Plugin 'haproxy'
call vundle#end()            " required
filetype plugin indent on    " required
" vundle end

" enable mouse support
set mouse=a

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

" Turn off trailing whitespace highlights from ntpeters/vim-better-whitespace
" Use {Enable,Toggle}Whitespace to enable.
" autocmd VimEnter * DisableWhitespace

" Search for visually selected text (http://vim.wikia.com/wiki/Search_for_visually_selected_text)
vnoremap // y/\V<C-R>"<CR>

" Use ag with ack.vim plugin
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Search word under cursor with ack.vim (ag)
" !: don't immediately open first result
nnoremap <leader>a :Ack!<CR>

" disable ale for C/CPP/Java
let g:ale_linters = {'c': [], 'cc': [], 'cpp': [], 'java': []}

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

" configure vim-go to use quickfix instead of location, since ALE use location
" list
let g:go_list_type = "quickfix"

" for vim-helm syntax file
autocmd BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl set ft=helm
