" Vim conf
syntax enable
syntax on

set nocompatible
set number
set showcmd
set ruler
set encoding=utf-8
set showmatch
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set relativenumber
set laststatus=2
set hlsearch
set incsearch
set cmdheight=2
set colorcolumn=80
set nowrap
set termguicolors
set noswapfile
set nobackup
set nowritebackup
set lazyredraw
set noshowmode

" Vim conf by file type

" html,phtml indent with 2
autocmd Filetype html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd Filetype phtml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd Filetype php setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" Plug Pluggin Manager
call plug#begin('~/.vim/pluggins')

" Themes

Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'everard/vim-aurora'
Plug 'agude/vim-eldar'
Plug 'jonathanfilip/vim-lucius'

" IDE

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'cohama/lexima.vim'
Plug 'alvan/vim-closetag'
Plug 'scrooloose/nerdtree'
Plug 'turbio/bracey.vim'
Plug 'Yggdroot/indentLine'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Syntax Highlighting

" Vala
Plug 'arrufat/vala.vim'

" C/C++
Plug 'bfrg/vim-cpp-modern'

call plug#end()

" coc-nvim
let g:coc_filetype_map = { "php": "html", "phtml": "html" }

" closetag conf
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.php'

" lexima conf
let g:lexima_enable_basic_rules = 1

" lightline
let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'filename', 'readonly', 'cocstatus', 'modified' ] ]
	\ },
	\ 'component_function': {
	\   'cocstatus': 'coc#status',
	\   'filetype': 'MyFiletype',
	\   'fileformat': 'MyFileformat',
	\ },
	\ }

" Use autocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" coc conf
set statusline^=%{coc#status()}
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" vim-airline conf
"let g:airline_theme='angr'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#formatter = 'unique_tail'

" nerdtree conf
nmap <Space>f :NERDTreeFind<CR>

let NERDTreeShowHidden=1
let NERDTreeWinPos='right'
let NERDTreeWinSize=25

"Fix indentation issue with indentLine
autocmd BufEnter NERD_tree* :LeadingSpaceDisable

"Open the existing NERDTree on each new tab
autocmd bufenter * if (!exists("t:NERDTreeBufName") ) | silent NERDTreeMirror | wincmd l | endif

"Close NERDTree when there is no buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"Prevent other buffers replacing NERDTree
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" indentLine conf
let g:indentLine_fileTypeExclude = ['json']
"let g:indentLine_char = '|'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '.'
"let g:indentLine_setColors = 0

" webdevicons conf
let g:webdevicons_enable_nerdtree = 1

"lightline integration webdevicons
function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

"lightline integration webdevicons
function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" nerdtree syntax highlight

"disable on uncommon file extensions
let g:NERDTreeLimitedSyntax = 1

let g:NERDTreeHighlightCursorline = 0

" Themes 

" nord
"colorscheme nord

" vim-aurora
"colorscheme aurora

" vim lucius
colorscheme lucius
LuciusLight

" gruvbox
"colorscheme gruvbox
"
"set background=dark
"
"let g:gruvbox_contrast_dark = "medium"
"let g:gruvbox_italic = 1
"let g:gruvbox_underline = 1
"let g:gruvbox_italicize_comments = 1
"let g:gruvbox_termcolors = 256
