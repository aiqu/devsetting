"    Vim configuration file
"
"    Copyright (C) 2017 Gwangmin Lee
"    
"    Author: Gwangmin Lee <gwangmin0123@gmail.com>
"
"    This program is free software: you can redistribute it and/or modify
"    it under the terms of the GNU General Public License as published by
"    the Free Software Foundation, either version 3 of the License, or
"    (at your option) any later version.
"
"    This program is distributed in the hope that it will be useful,
"    but WITHOUT ANY WARRANTY; without even the implied warranty of
"    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"    GNU General Public License for more details.
"
"    You should have received a copy of the GNU General Public License
"    along with this program.  If not, see <http://www.gnu.org/licenses/>.
"
">> Vundles

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'				"A tree explorer
Plugin 'nathanaelkane/vim-indent-guides' 	"visually displaying indent levels in code
Plugin 'scrooloose/nerdcommenter'			"intensely orgasmic commenting
Plugin 'vim-airline/vim-airline'			"lean & mean status/tabline
Plugin 'vim-airline/vim-airline-themes'		"
Plugin 'tpope/vim-fugitive'					"a Git wrapper 
"Shows a git diff in the column and stages/undoes hunks.
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-syntastic/syntastic'
Plugin 'leafgarland/typescript-vim'
Plugin 'jason0x43/vim-js-indent'
Plugin 'Quramy/tsuquyomi'
Plugin 'fatih/vim-go'
Plugin 'fatih/molokai'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'milkypostman/vim-togglelist'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set noic              " case sensitive
set history=50						" keep 50 lines of command line history
set ruler							" show the cursor position all the time
set showcmd							" display incomplete commands
set incsearch						" do incremental searching
set fileencodings=utf-8,euc-kr		"set file write encoding
set encoding=utf-8					"set screen encoding
set ai si cindent et				"enable auto / smart / C indenting & tab expansion
set ts=2 sts=2 sw=2					"tapstop softtapstop shiftwidth
set cinoptions=:0,l1,g0,)100		"see :help cinoptions-values
set nu								"show line number
set showmatch						"When a bracket is inserted, briefly jump to the matching one.
set laststatus=2
set wrap							"auto linewrap displaying content, not file itself"
set title							"show filename"
set hlsearch						"highlight search
syntax on							"syntax highlighting

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

colo desert							"set colortheme to desert

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\   exe "normal g`\"" |
				\ endif

augroup END

">> ctags

set tags=./tags,tags
set tags+=../tags
set tags+=../../tags
set tags+=../../../tags
set tags+=../../../../tags
set tags+=../../../../../tags
set tags+=../../../../../../tags

">> cscope

set csprg=cscope
set csto=0						"search cscope db first and tags later
set cst							"":tag" and CTRL-] will always use :cstag instead of the default :tag
set nocsverb					
if filereadable("./cscope.out")
	cs add cscope.out
endif
set csverb


">> Taglist

"let Tlist_Display_Tag_Scope=1
let Tlist_Display_Prototype=0
let Tlist_Use_Right_Window=1
let Tlist_WinWidth=50
let Tlist_Exit_OnlyWindow = 1					"Close Vim if the taglist is the only window.

">> Shortcuts

"Fix all wrong indent
map F <ESC>ggVG=
"Delete trailing space
map T <ESC>:%s/\s\+$//e<CR>
"Taglist shortcut
map <C-l> :Tlist<CR><C-w>w

">> NERDtree

"make autostart NERDtree if no args supplied
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"uncomment it to make autostart NERDtree
"autocmd vimenter * NERDTree
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeShowHidden = 1

">> airline

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme='bubblegum'

">> highlight

hi Search cterm=NONE ctermfg=grey ctermbg=yellow
hi VIsual cterm=NONE ctermfg=grey ctermbg=yellow
"hi ColorColumn ctermbg=235 guibg=#2c2d27
"execute "set colorcolumn=" . join(range(81,335), ',')

">> fold

set foldmethod=indent					"Lines with equal indent form a fold.
set foldlevelstart=20
nnoremap <space> za
vnoremap <space> zf

au BufNewFile,BufRead *.ejs set filetype=ejs

">> Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['flake8', 'pylint']
let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_cpp_cpplint_exec = "cpplint"

let g:syntastic_mode_map = {
    \ "mode": "active"}

">> Typescript
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

">> vim-go
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>d  <Plug>(go-decls-dir)
autocmd FileType go nmap <leader>i  <Plug>(go-info)
let g:go_def_mode = "godef"

" set vim's update rate to 100ms
set updatetime=100
