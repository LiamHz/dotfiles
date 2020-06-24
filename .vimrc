call plug#begin()
" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'junegunn/vim-easy-align'
Plug 'chmp/mdnav'
Plug 'itchyny/calendar.vim'

" QoL features for writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Color schemes
Plug 'morhetz/gruvbox'

"Syntax support
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Better hlsearch
Plug 'junegunn/vim-slash'

"fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" Map leader key to space
let mapleader=" "

" Source auth credentials
source ~/.cache/calendar.vim/credentials.vim

" Leader remaps
nnoremap <Leader>s :w<CR>
nnoremap <Leader>c :Calendar<CR>
nnoremap <Leader>k :Goyo <bar> set linebreak<CR>
nnoremap <Leader>l :Limelight!!<CR>
nnoremap <Leader>o :w<CR>:FzfFiles<CR>
nnoremap <Leader>f :w<CR>:FzfRg<CR>

" Write and switch to alternate file
nnoremap <Leader>p :w<CR><C-^>

" Fast paste from clipboard
nnoremap <Leader>v "*p`]
"
" Browse UltiSnip snippets from honza/vim-snippes
nnoremap <Leader>u :FzfFiles ~/.vim/plugged/vim-snippets/UltiSnips<CR>

" Simple
nnoremap Y y$

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

" Switching between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-Q> <C-W><C-Q>

augroup MarkdownRemaps
    " Prevent autocmds from piling up upon reloading vimrc
    autocmd!
    " Align on character
    autocmd FileType markdown xmap ga <Plug>(EasyAlign)
    autocmd FileType markdown vnoremap <Leader><Bslash> :EasyAlign*<Bar><Enter>
    " Generate valid ToC for markdown file
    autocmd FileType markdown nnoremap <Leader>i :InsertToc<CR>i## Table of Contents<ESC>vip:s/\((#.*\)\@<=[\.:']//g<CR>{j
    " Run Markdown code block with scheme
    autocmd FileType markdown nnoremap <Leader>r ?```<CR>jVNk:term scheme<CR>
    " Launch Markdown commands
    autocmd FileType markdown nnoremap <Leader>d :MarkdownPreview<CR>
    autocmd FileType markdown nnoremap <Leader>t :Toch<CR>
augroup END

" Incremental search
:set incsearch
" Change default split locations
set splitbelow splitright

" Colorscheme
syntax on
set background=dark
let g:gruvbox_italic = 1
let g:gruvbox_italicize_comments = 0
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

" Set indent levels to 4
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

augroup FiletypeSpecificSettings
    autocmd!
    autocmd Filetype cfg setlocal syntax=haskell
    autocmd Filetype javascript,json,markdown setlocal et ts=2 sw=2 sts=2
augroup END

" fzf.vim
let g:fzf_command_prefix = 'Fzf'

" UltiSnippets config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Limelight and Goyo config
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" vim-markdown
let g:markdown_folding = 1
set conceallevel=2  " Conceal markdown syntax (e.g. **, _)
set concealcursor=n " Only conceal markdown syntax in normal mode

" markdown-preview.nvim
filetype plugin on
let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 1
let g:mkdp_page_title = '${name}'
let g:mkdp_preview_options = {
    \ 'maid': { 'theme': 'default' }
    \ }
let g:mkdp_markdown_css=expand('~/Documents/resources/dev/github-markdown.css')

" Close ToC menu on <Enter>
nnoremap <expr><enter> &ft=="qf" ? "<cr>:lcl<cr>" : (getpos(".")[2]==1 ? "i<cr><esc>": "i<cr><esc>l")
augroup markdownSettings
    autocmd!
    autocmd FileType markdown norm zR
    autocmd FileType markdown setlocal indentexpr=
augroup END

" calendar.vim
let g:calendar_google_calendar = 1
let g:calendar_date_full_month_name=1
let g:calendar_event_start_time=0
let g:calendar_clock_12hour=1
let g:calendar_date_separator=" "
let g:calendar_skip_event_delete_confirm = 1
let g:calendar_skip_task_delete_confirm = 1
let g:calendar_skip_task_clear_completed_confirm = 0
let g:calendar_view = "month"
let g:calendar_views = ['year', 'month', 'day_4', 'day']
let g:weekday_color = 0
let g:weekday_fg_color = 0

augroup calendar-mappings
    autocmd!
    " Remap calendar view navigation
    autocmd FileType calendar nmap <buffer> <C-h> <Plug>(calendar_view_left)
    autocmd FileType calendar nmap <buffer> <C-l> <Plug>(calendar_view_right)
augroup END

" Disable specific highlight groups
" Enabled highlight groups can be shown by running
" :so $VIMRUNTIME/syntax/hitest.vim
augroup calendar-highlights
    autocmd!
    autocmd FileType calendar hi! link CalendarSunday Normal
    autocmd FileType calendar hi! link CalendarSaturday Normal
    autocmd FileType calendar hi! link CalendarTodaySunday Normal
    autocmd FileType calendar hi! link CalendarTodaySaturday Normal
    autocmd FileType calendar hi! link CalendarDayTitle Normal
    autocmd FileType calendar hi! link CalendarSaturdayTitle Normal
    autocmd FileType calendar hi! link CalendarSundayTitle Normal
augroup END
