let mapleader=" "

" Auth credentials
source ~/.cache/calendar.vim/credentials.vim

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

" fzf
let g:fzf_command_prefix = 'Fzf'
nnoremap <Leader>o :FzfFiles<CR>

" Tab navigation
nnoremap tt  :tabedit<Space>
nnoremap tl  :tabnext<CR>
nnoremap th  :tabprev<CR>
nnoremap td  :tabclose<CR>
nnoremap tm  :tabm<Space>
nnoremap tj  :tabfirst<CR>
nnoremap tk  :tablast<CR>

" Incremental search
:set incsearch

" Colorscheme
set background=dark
let g:gruvbox_contrast_dark = '(hard)'
syntax on
colorscheme gruvbox

" Swap the ; and : keys
nnoremap ; :
nnoremap : ;

" Change default split locations
set splitbelow splitright

" Keybinds for switching between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Make Y similar to C and D
nnoremap Y y$

" UltiSnippets config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Limelight and Goyo config
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

nnoremap <Leader>k :Goyo <bar> set linebreak<CR>
nnoremap <Leader>l :Limelight!!<CR>

" Write and switch to alternate file
nnoremap <Leader>p :w<CR><C-^>

" Set indent levels to 4
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Set indentation for javascript files to 2 spaces
autocmd Filetype javascript setlocal et ts=2 sw=2 sts=2
autocmd Filetype json setlocal et ts=2 sw=2 sts=2

" File specific syntax highlighting
autocmd Filetype cfg setlocal syntax=haskell

" Highlight the 81st column
"let blacklist = ['markdown', 'calendar'] " Don't apply column highlighting to these file types
"autocmd BufRead * if index(blacklist, &ft) < 0 | call matchadd('ColorColumn', '\%81v', 100)
"highlight ColorColumn ctermbg = white

" calendar.vim
nnoremap <Leader>c :Calendar<CR>
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

let g:calendar_google_calendar = 1

augroup calendar-mappings
    autocmd!
    " Remap calendar view navigation
    autocmd FileType calendar nmap <buffer> <C-h> <Plug>(calendar_view_left)
    autocmd FileType calendar nmap <buffer> <C-l> <Plug>(calendar_view_right)
augroup END

" Disable specific highlight groups
" Enabled highlight groups can be shown by running
" :so $VIMRUNTIME/syntax/hitest.vim
autocmd FileType calendar hi! link CalendarSunday Normal
autocmd FileType calendar hi! link CalendarSaturday Normal
autocmd FileType calendar hi! link CalendarTodaySunday Normal
autocmd FileType calendar hi! link CalendarTodaySaturday Normal
autocmd FileType calendar hi! link CalendarDayTitle Normal
autocmd FileType calendar hi! link CalendarSaturdayTitle Normal
autocmd FileType calendar hi! link CalendarSundayTitle Normal

" Global search
nnoremap <Leader>s :g//#<Left><Left>
function! CCR()
    " grab the current command-line
    let cmdline = getcmdline()

    " does it end with '#' or 'number' or one of its abbreviations?
    " used primarily for global search
    if cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
        " press '<CR>' then ':' to enter command-line mode
        return "\<CR>:"
    else
        " press '<CR>'
        return "\<CR>"
    endif
endfunction

" map '<CR>' in command-line mode to execute the function above
cnoremap <expr> <CR> CCR()

" Markdown table alignment
xmap ga <Plug>(EasyAlign)
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" markdown-preview.nvim
filetype plugin on
let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 1
let g:mkdp_page_title = '${name}'
let g:mkdp_preview_options = {
    \ 'maid': { 'theme': 'default' }
    \ }
let g:mkdp_markdown_css=expand('~/Documents/resources/dev/github-markdown.css')

nnoremap <Leader>d :MarkdownPreview<CR>

" vim-markdown
let g:markdown_folding = 1
autocmd FileType markdown norm zR
autocmd FileType markdown setlocal indentexpr=
set conceallevel=2 " Hide URLs in markdown links
set concealcursor=n " Only reveal hidden URLs when in Insert mode

" Table of contents QoL changes
autocmd FileType markdown nnoremap <buffer> <leader>t :Toch<CR>
nnoremap <expr><enter> &ft=="qf" ? "<cr>:lcl<cr>" : (getpos(".")[2]==1 ? "i<cr><esc>": "i<cr><esc>l")
