" fzf plugin
set rtp+=/usr/local/opt/fzf

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


" source ~/dotfiles/.vimrc-common

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

" don't wrap long lines in the middle of a word
set linebreak

" Use ag with ack.vim plugin
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Search word under cursor with ack.vim (ag)
" !: don't immediately open first result
nnoremap <leader>a :Ack!<CR>

" disable ale for C/CPP/go
let g:ale_linters = {'c': [], 'cc': [], 'cpp': [], 'go': []}

" YCM shortcuts
nnoremap <leader>g :YcmCompleter GoTo<CR>
nnoremap <leader>yd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>yr :YcmCompleter GoToReferences<CR>
nnoremap <leader>yt :YcmCompleter GetType<CR>
nnoremap <leader>yc :YcmCompleter GetDoc<CR>

set shiftwidth=4
set tabstop=4
" use spaces instead of tabs
set expandtab

" Turn off trailing whitespace highlights from ntpeters/vim-better-whitespace
" Use {Enable,Toggle}Whitespace to enable.
" autocmd VimEnter * DisableWhitespace
