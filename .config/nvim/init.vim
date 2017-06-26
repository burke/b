" vim:foldmethod=marker foldlevel=0

" Preamble {{{
set shell=/bin/sh
call pathogen#infect()
" }}}

" ## Settings {{{

" map*leader {{{
let mapleader=" "
let maplocalleader="\\"
" }}}

" TTY Performance {{{
set nocompatible
set synmaxcol=300
set ttyfast
set lazyredraw
" }}}

" Backup/swap/undo Directories {{{
set backupdir=~/.config/nvim/backup
set directory=~/.config/nvim/swaps
set undodir=~/.config/nvim/undo
set undofile
" }}}

" Environment {{{ 
" map */+ registers to macOS pastebuffer
set clipboard=unnamed
" Disable beeps and flashes
set noerrorbells visualbell t_vb=
set encoding=utf-8
" }}}

" Whitespace handling {{{
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:»·,trail:·
" }}}

" Searching {{{
set hlsearch
set incsearch
set ignorecase
set smartcase
" }}}

" Tab completion {{{
set wildmode=list:longest,list:full
" set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*/tmp/*,*.so,*.swp,*.zip
" }}}

" Gutter Line Numberings {{{
set rnu
set nu
set numberwidth=1
" }}}

" Enable Mouse in TTY {{{
if has("mouse")
  set mouse=a
endif
" }}}

" Timeout configuration for (e.g.) kj insert mode mapping {{{
set notimeout
set ttimeout
set timeoutlen=50
" }}}

" (Miscellaneous Settings) {{{
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set printfont=PragmataPro:h12
set fillchars+=vert:│
set scrolloff=3
set autoindent
set autoread
set showmode
set showcmd
set hidden
set nocursorline
set ruler
set laststatus=2
" }}}

" }}}

" NeoVim {{{
if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1

  " Neovim takes a different approach to initializing the GUI. As It seems some
  " Syntax and FileType autocmds don't get run all for the first file specified
  " on the command line.  hack sidesteps that and makes sure we get a chance to
  " get started. See https://github.com/neovim/neovim/issues/2953
  augroup nvim
    au!
    au VimEnter * doautoa Syntax,FileType
  augroup END
endif
" }}}

" Syntax Highlighting {{{
syntax on
let g:jellybeans_use_term_italics = 1
let g:jellybeans_overrides = {
      \  'Search':     { 'guifg': 'fabd2f', 'guibg': '151515', 'attr': 'inverse' },
      \  'IncSearch':  { 'guifg': 'fe8019', 'guibg': '151515', 'attr': 'inverse' },
      \  'SpellBad':   { 'attr': '', 'guibg': '602020' },
      \  'SpellCap':   { 'attr': '' },
      \  'SpellRare':  { 'attr': '' },
      \  'SpellLocal': { 'attr': '' }
      \}
colorscheme jellybeans
" load the plugin and indent settings for the detected filetype
filetype plugin indent on
" }}}

" Python Bindings {{{
let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'
" }}}

" ## Plugin/Feature Configuration {{{

" Netrw {{{
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" }}}

" Supertab {{{
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1
" }}}

" Tagbar {{{
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

if executable('ripper-tags')
    let g:tagbar_type_ruby = {
                \ 'kinds' : [
                    \ 'm:modules',
                    \ 'c:classes',
                    \ 'f:methods',
                    \ 'F:singleton methods',
                    \ 'C:constants',
                    \ 'a:aliases'
                \ ],
                \ 'ctagsbin':  'ripper-tags',
                \ 'ctagsargs': ['-f', '-']
                \ }
endif
" }}}

" LightLine {{{
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'LightlineModified',
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'LightlineFilename',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \ },
      \ }

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? branch : ''
  endif
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
" }}}

" FZF {{{
set rtp+=/usr/local/opt/fzf

nnoremap <leader>j :Buffers<cr>
nnoremap <leader><C-p> :Files<cr>
nnoremap <leader><C-s> :GFiles?<cr>
nnoremap <C-p> :GFiles<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>T :BTags<cr>

" Also useful: :Ag, :Marks, :History, :History/, :Commits, :BCommits

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" }}}

" }}}

" ## Per-Filetype Configuration {{{

" Makefile {{{
augroup makefile
  au!
  au FileType make set noexpandtab
augroup END
" }}}

" Go {{{
augroup golang
  au!
  au BufNewFile,BufRead *.go set nolist
  au Filetype go set makeprg=go\ build\ ./...
augroup END

set rtp+=/Users/burke/src/github.com/golang/lint/misc/vim

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
" }}}

" Rust {{{
let g:rustfmt_autosave = 1
" }}}

" Pandoc {{{
augroup pandoc
  au!
  au FileType pandoc,markdown set textwidth=100 tabstop=8
  au FileType pandoc,markdown let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))
  au Syntax pandoc,markdown syntax sync fromstart
augroup END
let g:pandoc#syntax#codeblocks#embeds#langs = ["c", "ruby", "bash=sh", "diff", "dot"]
" }}}

" Ruby {{{
let g:ruby_indent_assignment_style = 'variable'
augroup ruby_mode_extras
  au!
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,config.ru} set ft=ruby
augroup END
" }}}

" Miscellaneous (txt,md,lua,js,python,ruby-c) {{{
augroup misc_mode_extras
  au!
  au BufRead,BufNewFile *.lua  set ft=lua
  au BufRead,BufNewFile *.ronn set ft=markdown
  au BufNewFile,BufRead *.json set ft=javascript
augroup END

function! s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction

augroup misc_indentation_and_wrapping
  au!
  au BufRead,BufNewFile {*.txt,*.md} call s:setupWrapping()
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79
  au BufRead,BufNewFile */ruby/ruby/*.{c,h}    set sw=4 ts=8 softtabstop=8 noet
augroup END
" }}}

" }}}

" Remember last location in file
augroup remember_last_location
  au!
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
augroup END

" % to bounce from do to end etc.
runtime! macros/matchit.vim
nnoremap <tab> %
vnoremap <tab> %

" ## Mappings {{{

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" ; instead of : {{{
" nnoremap ; :
" <A-;>
nnoremap … ;
" }}}

" Disable F1 {{{
inoremap <f1> <esc>
nnoremap <f1> <esc>
cnoremap <f1> <esc>
" }}}

" Feature/Mode Parity {{{
" like C or D
nnoremap Y yf$
vnoremap . :norm.<cr>
" }}}

" kj = <esc> {{{
inoremap kj <esc>
cnoremap kj <esc>
vnoremap kj <esc>
" }}}

" Navigation {{{
" I don't like the default mappings for H and L, and ^ and $ are hard to type
" for how useful they are.
noremap H ^
noremap L $

" Jumping between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" }}}

" Replace line with contents of yank ring
nnoremap <leader>p Pjddkyy


nnoremap Q @q
" remove trailing space from file
nnoremap <leader>s :%s/ \+$//ge<cr>:noh<cr>
nnoremap <leader>s :syntax sync fromstart<CR>

nnoremap <leader>9 Orequire'pry';binding.pry<esc>

nnoremap <leader><space> :noh<cr>

cnoremap w!! %!sudo tee > /dev/null %

" THANKS NEOVIM
nnoremap <bs> <C-w>h

" wtf even are these {{{
nnoremap ∆ :m+<CR>==
" <A-j>
inoremap ∆ <Esc>:m+<CR>==gi
vnoremap ∆ :m'>+<CR>gv=gv

" <A-k>
nnoremap ˚ :m-2<CR>==
inoremap ˚ <Esc>:m-2<CR>==gi
vnoremap ˚ :m-2<CR>gv=gv
" }}}

nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>ev :edit ~/.config/nvim/init.vim<cr>

nnoremap <leader>n <C-^>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap %^ <C-R>=expand('%')<cr>

nnoremap <leader>5 :GitGutterToggle<cr>
nnoremap <leader>5 :TagbarToggle<cr>

nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

nnoremap <leader>m :make<CR>:copen<CR>

" Align selection by some marker
" e.g. gaip=
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Replace the word under the cursor throughout the file.
nnoremap <leader>6 *#:redraw<cr>:%s/<C-r><C-w>//gc<left><left><left>

" }}}
