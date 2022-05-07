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

" TextEdit might fail if hidden is not set.
set hidden

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" map leader to comma
let mapleader = ","

" Vim conf by file type

" Verilog HDL
au BufNewFile,BufRead *.v			setf v
au BufNewFile,BufRead *.vv			setf v
au BufNewFile,BufRead *.vsh			setf v

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
Plug 'scrooloose/nerdtree'
Plug 'turbio/bracey.vim'
Plug 'Yggdroot/indentLine'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'honza/vim-snippets'
Plug 'cohama/lexima.vim'

" Syntax Highlighting

" V
Plug 'cheap-glitch/vim-v'

" Vala
Plug 'arrufat/vala.vim'

" C/C++
Plug 'bfrg/vim-cpp-modern'

call plug#end()

" coc-nvim
let g:coc_filetype_map = { "php": "html", "phtml": "html" }

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

set statusline^=%{coc#status()}

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

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

" vim-airline conf
"let g:airline_theme='angr'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#formatter = 'unique_tail'

" nerdtree conf
nmap <Space>f :NERDTreeFind<CR>
nmap <Space>F :tabdo NERDTreeClose<CR>

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
LuciusDark

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
