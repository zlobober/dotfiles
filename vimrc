set backspace=indent,eol,start

set virtualedit=block

set mouse=a

set expandtab
set shiftwidth=4
set tabstop=4
set autoindent
set number

syntax on

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/vundle'
Plugin 'Valloric/YouCompleteMe'
Plugin 'airblade/vim-gitgutter'
Plugin 'rhysd/conflict-marker.vim'
Plugin 'nvie/vim-flake8'
Plugin 'jjo/vim-cue'
call vundle#end() 

highlight YcmWarningSection ctermfg=0 ctermbg=11 guifg=Blue guibg=Yellow
highlight YcmErrorSection cterm=bold ctermbg=130 guifg=Blue guibg=Yellow

let g:ycm_global_ycm_extra_conf = '/home/max42/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1

vmap <silent> <Right> l
vmap <silent> <Left> h
vmap <silent> <Up> gk
vmap <silent> <Down> gj
nmap <silent> <Right> l
nmap <silent> <Left> h
nmap <silent> <Up> gk
nmap <silent> <Down> gj
inoremap <silent> <End> <C-o>g<End>
inoremap <silent> <Home> <C-o>g<Home>

nnoremap <C-Up> :tabn<CR>
nnoremap <C-Down> :tabp<CR>
inoremap <C-Up> <Esc>:tabn<CR>
inoremap <C-Down> <Esc>:tabp<CR>

set viminfo='100,<10000,s10,h

set laststatus=2
set statusline+=%F

set wildmode=longest,list
set wildmenu

set wrap linebreak nolist

set tabpagemax=100

"set columns=100
"autocmd VimResized * if (&columns > 100) | set columns=100 | endif
set wrap
set linebreak

function MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        " set the tab page number (for mouse clicks)
        let s .= '%' . (i + 1) . 'T'

        " the label is made by MyTabLabel()
        if i + 1 == tabpagenr()
            let s .= ' %{MyTabLabelSelected(' . (i + 1) . ')} '
        else
            let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
        endif
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999Xclose'
    endif

    return s
endfunction

function MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    return fnamemodify(bufname(buflist[winnr - 1]), ':t') . (getbufvar(buflist[winnr - 1], "&mod") ? ' +' : '')
endfunction

function MyTabLabelSelected(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    return bufname(buflist[winnr - 1]) . (getbufvar(buflist[winnr - 1], "&mod") ? ' +' : '')
endfunction

set tabline=%!MyTabLine()
set showtabline=2
let g:ycm_goto_buffer_command = 'new-tab'

autocmd BufWritePre *.cpp :%s/\s\+$//e
autocmd BufWritePre *.h :%s/\s\+$//e

autocmd BufEnter * silent! lcd %:p:h

autocmd BufReadPost *.cue set syntax=cue
