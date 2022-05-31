call plug#begin()
" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'junegunn/vim-easy-align'
Plug 'chmp/mdnav'

" Profile startup time
Plug 'dstein64/vim-startuptime'

" QoL features for writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Color schemes
"Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'joshdick/onedark.vim'

"Syntax support
Plug 'sheerun/vim-polyglot'
Plug 'LiamHz/vim-vulkan'

" Git
"Plug 'tpope/vim-fugitive'

" Autocompletion
"Plug 'xavierd/clang_complete'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Better hlsearch
Plug 'junegunn/vim-slash'

"fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Diff lines
Plug 'AndrewRadev/linediff.vim'

" Link to specific line in file
Plug 'wsdjeg/vim-fetch'
call plug#end()

" fast af boi
Plug 'justinmk/vim-sneak'

" Map leader key to space
let mapleader=" "

" Leader remaps
"nnoremap <Leader>t :w<CR>:e ~/Documents/personal/notes/todo.md<CR>
nnoremap <Leader>t :term<CR><C-w>5-
nnoremap <Leader>s :w<CR>
nnoremap <Leader>k :Goyo <bar> set linebreak<CR>
nnoremap <Leader>a :MarkdownPreview<CR>
nnoremap <Leader>l :Limelight!!<CR>
nnoremap <Leader>o :FzfFiles<CR>
nnoremap <Leader>f :FzfRg<CR>

" vim-fugitive shortcuts
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gd :Gvdiffsplit<CR>

" Open Markdown style relative file
"nnoremap <Leader>g :w<CR>f(lgf

" Visual select pasted text
nnoremap gp `[v`]

" Write and switch to alternate file
nnoremap <Leader>p <C-^>

" Fast paste from clipboard
nnoremap <Leader>v "*p`]

" Browse UltiSnip snippets from honza/vim-snippes
nnoremap <Leader>u :FzfFiles ~/.vim/plugged/vim-snippets/UltiSnips<CR>

" Toggle todo item
nnoremap <silent> <Leader>e :silent! s/\v(TODO<bar>DONE)/\={'TODO':'DONE','DONE':'TODO'}[submatch(0)]<CR>^
      "\ :s/^ *./\=tr(submatch(0), '-+', '+-')<CR>

" Quickfix navigation
nnoremap ]q :w<CR>:cnext<CR>
nnoremap [q :w<CR>:cprevious<CR>

" Normal remaps
nnoremap Y y$
nnoremap Q @q
nnoremap R @r
nnoremap j gj
nnoremap k gk

" Fast indentation
nnoremap > >>
nnoremap < <<
vnoremap > >gv
vnoremap < <gv

" Swap the ; and : keys
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Tab navigation
nnoremap tt  :tabedit<Space>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap th  :tabfirst<CR>
nnoremap tl  :tablast<CR>
nnoremap td  :tabclose<CR>
nnoremap tm  :tabm<Space>

" Autocompletion
inoremap <C-X><C-l> <C-X><C-L>

" Map <Enter> key to select highlighted menu item when completion popup menu is visible
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"autocmd! FileType cpp inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-x><C-u><C-p><Down>'

" Colorscheme
syntax on
"set background=dark
"let g:gruvbox_italic = 1
"let g:gruvbox_italicize_comments = 0
"let g:gruvbox_contrast_dark = 'hard'
"let g:gruvbox_invert_selection='0'
"colorscheme gruvbox
colorscheme nord

" Column highlight
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%73v.\+/

" Better foldtext
set foldmethod=indent
function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

" coc completion
" Goto definitions
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nnoremap <leader>rn <Plug>(coc-rename)

" nnoremap <C-l> f,2lvt,<C-g>
 "inoremap <C-l> <ESC>f,2lvt,<C-g>

" Termdebug
packadd termdebug
let g:termdebug_wide=1

augroup Config
  autocmd!
  " Unfold all folds on file load
  autocmd FileType * norm zR
  " Get zsh startup files (including .zshrc)
  autocmd vimenter * let &shell='/bin/zsh -l'
  autocmd BufNewFile,BufRead * setlocal completeopt=menuone
  " Enable coc for specific files
  autocmd FileType * execute "silent! CocDisable"
  autocmd BufNew,BufEnter *.cpp,*.h,*.hpp,*.js execute "silent! CocEnable"
  autocmd BufLeave *.cpp,*.h,*.hpp,*.js execute "silent! CocDisable"
augroup END

" GLSL syntax highlighting
autocmd! BufNewFile,BufRead *.vs,*.fs,*.vert,*.frag set ft=glsl

augroup PyFiles
  autocmd!
  autocmd FileType python nnoremap <Leader>rp :!python3 %<CR>
  autocmd FileType elixir nnoremap <Leader>rp :!elixir %<CR>
augroup END

augroup CppFiles
  autocmd!
  autocmd FileType cpp,glsl nnoremap <Leader>rc :!cd build && make && ./Excal && cd ..<CR>
  autocmd FileType cpp,glsl nnoremap <Leader>rb :!cd build && cmake .. && make && ./Excal && cd ..<CR>
  autocmd FileType cpp nnoremap <silent> <Leader>dd :!cd ../build && cmake .. && make<CR>
    \:Termdebug ../build/Excal<CR>
    \set startup-with-shell off<CR>
    \<C-w>10-<C-w>w
  autocmd FileType cpp nnoremap <silent> <Leader>dr :Run<CR>
  autocmd FileType cpp nnoremap <silent> <Leader>di :Break<CR>
  autocmd FileType cpp nnoremap <silent> <Leader>do :Clear<CR>
  autocmd FileType cpp nnoremap <silent> <Leader>dl :Step<CR>
  autocmd FileType cpp nnoremap <silent> <Leader>dj :Continue<CR>
  autocmd FileType cpp let g:limelight_bop = ' *}\n.*\n \zs *\(void\|bool\|vk\).*('
  autocmd FileType cpp let g:limelight_eop = ' *}\n\ze.*\n^ *\(void\|bool\|vk\).*('
  "autocmd FileType cpp nnoremap <Leader>ll mz?void .*(<CR>V%$%:Limelight<CR>'z
augroup END

augroup MarkdownFiles
  " Prevent autocmds from piling up upon reloading vimrc
  autocmd!
  " Spellcheck
  autocmd FileType markdown setlocal spell
  autocmd BufRead band-routine.md setlocal nospell
  " Align on character
  autocmd FileType markdown nnoremap <Leader><Bslash> vip:EasyAlign*<Bar><CR>
  " Generate valid ToC for markdown file
  autocmd FileType markdown nnoremap <Leader>i :InsertToc<CR>i## Table of Contents<ESC>vip:s/\((#.*\)\@<=[\.:']//g<CR>{j
  " Run Markdown code block with scheme
  autocmd FileType markdown nnoremap <Leader>rl ?```<CR>jVNk:term scheme<CR><C-W>k<C-O><C-O><C-W>j
  " Run Markdown code block with Python
  autocmd FileType markdown nnoremap <Leader>rp ?```<CR>jVNk:term python3<CR><C-W>k<C-O><C-O><C-W>j
  " Launch Markdown commands
  autocmd FileType markdown nnoremap <Leader>d :MarkdownPreview<CR>
  autocmd FileType markdown nnoremap <Leader>; :Toc<CR>
  " Custom highlight group
  autocmd FileType * hi mdTodo term=standout cterm=bold ctermfg=13 gui=bold,italic guifg=#ffa0a0 guibg=bg
  autocmd FileType * hi mdDone term=standout cterm=bold ctermfg=13 gui=bold,italic guifg=#ffa0a0 guibg=bg
  " Regex match for mdTodo group
  " Specify optional included trailing date format
  autocmd FileType * call matchadd('mdTodo', '\v.{-}\zs(TODO)')
  autocmd FileType * call matchadd('mdDone', '\v.{-}\zs(DONE)')
augroup END

augroup AgendaFiles
  autocmd!
  "autocmd BufRead */notes/todo.md call matchadd('Comment', '/Users/liamhinzman.*')
  "" Clear file, and populate it with all _TODO items in ~/Documents/personal
  "" TODO Create heading 'Today' that matches all TODOs with :put=strftime('%m/%d')
  "" TODO Create keybind that creates a _TODO with the current data using
  ""      :put=strftime('%m'd')
  "" TODO Create keybinds that increment / decrement the day of a _TODO
  "autocmd BufRead */notes/todo.md norm dG
  "autocmd BufRead */notes/todo.md read!
  "      \ grep --exclude="**notes/todo.md" -rn TODO ~/Documents/personal
  "      \ | awk -F ':' '{sub(/  *[^a-zA-Z]*TODO/, "TODO"); print $3"|"$1":"$2}'
  "      \ | column -t -s "|"
  "      \ | sort -n 
  "autocmd BufRead */notes/todo.md norm ggdd
  "autocmd BufRead */notes/todo.md nnoremap <Leader>j :w<CR>$F/gF
  "autocmd BufEnter */notes/todo.md setlocal nospell
augroup END

" Incremental search
:set incsearch

" Change default split locations
set splitbelow splitright

" Case insensitive search
set ignorecase
set smartcase

" Set indent levels to 2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" fzf.vim
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'yoffset': 1, 'border': 'rounded' } }

" UltiSnippets config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Limelight and Goyo config
let g:goyo_width=81
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

function! s:goyo_enter()
  hi mdTodo term=standout cterm=bold ctermfg=13 gui=bold,italic guifg=#ffa0a0 guibg=bg
  hi mdDone term=standout cterm=bold ctermfg=142 gui=bold,italic guifg=#ffa0a0 guibg=bg
  call matchadd('mdTodo', '\v.*\zs(TODO) ([0-9]*\/[0-9]*)*')
  call matchadd('mdDone', '\v.*\zs(DONE) ([0-9]*\/[0-9]*)*')
endfunction

function! s:goyo_leave()
  hi mdTodo term=standout cterm=bold ctermfg=13 gui=bold,italic guifg=#ffa0a0 guibg=bg
  hi mdDone term=standout cterm=bold ctermfg=142 gui=bold,italic guifg=#ffa0a0 guibg=bg
  call matchadd('mdTodo', '\v.*\zs(TODO) ([0-9]*\/[0-9]*)*')
  call matchadd('mdDone', '\v.*\zs(DONE) ([0-9]*\/[0-9]*)*')
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" vim-markdown
let g:markdown_folding = 1
let g:vim_markdown_fenced_languages = ['mermaid=javascript'] " Apply javascript style syntax highlighting to mermaid code
set conceallevel=2  " Conceal markdown syntax (e.g. **, _)
set concealcursor=n " Only conceal markdown syntax in normal mode
let g:vim_markdown_conceal_code_blocks = 0 " Disable conceal for code blocks

" markdown-preview.nvim
filetype plugin on
let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 1
let g:mkdp_page_title = '${name}'
let g:mkdp_preview_options = {
  \ 'disable_sync_scroll': 0
\ }
  "\ 'maid': { 'theme': 'default' },
let g:mkdp_markdown_css=expand('~/Documents/resources/dev/github-markdown.css')

augroup FiletypeSpecificSettings
  autocmd!
  autocmd FileType * xmap ga <Plug>(EasyAlign)
  autocmd FileType cfg setlocal syntax=haskell
  autocmd FileType cpp let g:goyo_width=90
  autocmd Filetype python setlocal et ts=2 sw=2 sts=2
  autocmd Filetype html setlocal et ts=2 sw=2 sts=2
augroup END


" Close ToC menu on <Enter>
nnoremap <expr><enter> &ft=="qf" ? "<cr>:lcl<cr>" : (getpos(".")[2]==1 ? "i<cr><esc>": "i<cr><esc>l")
augroup markdownSettings
  autocmd!
  autocmd FileType markdown setlocal indentexpr=
augroup END
