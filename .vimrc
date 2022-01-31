set nocompatible
inoremap jk <Esc> 
map <up> :res -5<CR>
map <down> :res +5<CR>
map <left> :vertical resize+5<CR>
map <right> :vertical resize-5<CR>
let mapleader = "\<space>"
let localleader = "\\"
map <LEADER>h <C-w>h
map <LEADER>j <C-w>j
map <LEADER>k <C-w>k
map <LEADER>l <C-w>l
map tt : NERDTreeToggle<CR>
map cr : call CompileRun()<CR>
map tc : call RToc()<CR>
map mtt : TagbarToggle<CR>
map mp : MarkdownPreview<CR>
map ms : MarkdownPreviewStop<CR>
set autoindent 
set backspace=indent,eol,start
set encoding=utf-8
set guifont=DroidSansMono_Nerd_Font:h11
set number 
set ruler 
set shiftwidth=4 
set softtabstop=4
set tabstop=4
set background=dark
set showcmd
set showmatch
set cursorline
set wrap
set showcmd
set wildmenu
set hlsearch
set incsearch
set nu
set rnu
"set relativenumber
filetype plugin on
filetype plugin indent on 
syntax enable 


source ~/.vim/snippits.vim

call plug#begin()

"vim 中git操作"
Plug  'tpope/vim-fugitive'
"强化状态栏
Plug  'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plug 'vimwiki/vimwiki'
"对称删除括号
Plug  'jiangmiao/auto-pairs'
"Plug  'taglist.vim'
"自动补全
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"python代码折叠
Plug  'tmhedberg/SimpylFold'
Plug  'vim-scripts/indentpython.vim'
Plug  'Yggdroot/indentLine'
Plug  'dhruvasagar/vim-table-mode'
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin'

"nerdtree字体"
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"Plug  'ferrine/md-img-paste.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
"编辑修改状态栏
Plug 'vim-airline/vim-airline'
"检索代码或者文章中固定表达
Plug 'majutsushi/tagbar'
Plug 'jszakmeister/markdown2ctags'
"markdown语法
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
"在当前光标位置生成目录
Plug 'mzlogin/vim-markdown-toc'
Plug 'lervag/vimtex'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"自动切换输入法"
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()


autocmd VimEnter * NERDTree	"在vim 启动的时候默认开启 NERDTree（autocmd 可以缩写为 au）
autocmd VimEnter * wincmd p
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif	if the last window is NERDTree, then close Vim
autocmd BufEnter * if 0 == len(filter(range(1, winnr('$')), 'empty(getbufvar(winbufnr(v:val), "&bt"))')) | qa! | endif

"自动切换输入法
autocmd InsertEnter * call AutoIM("enter")
autocmd InsertLeave * call AutoIM("leave")

"tab 选择补全
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"自动切换输入法"
let g:lv_restore_last_im = 0
let NERDChristmasTree=1	
let NERDTreeDirArrows=0
let g:nerdtree_tabs_open_on_console_startup=1
let NERDTreeShowBookmarks=1
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
"vimviki改 md
"let g:vimwiki_list = [{'path': '~/vimwiki/',
"                      \ 'syntax': 'markdown', 'ext': '.md'}]

"设置tagbar对于markdown的支持
let g:tagbar_type_markdown = {
   \ 'ctagstype' : 'markdown',
   \ 'kinds' : [
   \ 'h:Chapter',
   \ 'i:Section',
   \ 'k:Paragraph',
   \ 'j:Subparagraph'
   \ ]
\ }
"section_c显示为tagbar检索出来的标题
let g:airline_section_c = airline#section#create(['tagbar'])
"section_x显示文件名
let g:airline_section_x = '%{expand("%")}'
"section_y显示时间
"let g:airline_section_y = airline#section#create(['%{strftime("%D")}'])
"section_z显示日期
"let g:airline_section_z = airline#section#create(['%{strftime("%H:%M")}'])
"激活tagbar扩展
let g:airline#extensions#tagbar#enabled = 1
"markdown对于Latex数学公式的支持
"语法隐藏， 比如 隐藏 链接什么的 
let g:vim_markdown_conceal = "" 
let g:vim_markdown_math = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_level = 0
"设置自动生成的目录的标记 
let g:vmt_cycle_list_item_markers = 1
let g:tex_flavor = 'latex'
let g:vimtex_quickfix_mode = 0


let g:vimtex_view_general_viewer
\ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

" This adds a callback hook that updates Skim after compilation
let g:vimtex_compiler_callback_hooks = ['UpdateSkim']

" vim-go config
let gigo_highlight_functions=1
let g:go_highlight_methods=1
let g:go_highlight_fields=1
let g:go_highlight_types=1
let g:go_highlight_operators=1
let g:go_highliaht_build_constraints=1
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

function! UpdateSkim(status)
if !a:status | return | endif

let l:out = b:vimtex.out()
let l:tex = expand('%:p')
let l:cmd = [g:vimtex_view_general_viewer, '-r']

if !empty(system('pgrep Skim'))
call extend(l:cmd, ['-g'])
endif

if has('nvim')
call jobstart(l:cmd + [line('.'), l:out, l:tex])
elseif has('job')
call job_start(l:cmd + [line('.'), l:out, l:tex])
else
call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
endif
endfunction



func CompileRun()
	exec "w"
	if &filetype == 'markdown'
		exec "MarkdownPreview"
	elseif &filetype == "vimwiki"
		exec "MarkdownPreview"
	elseif &filetype == "go" 
		exec "GoRun %"
	endif
endfunc
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '~/.vim/plugged/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes ',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py,*.go exec ":call SetTitle()"
""定义函数SetTitle，自动插入文件头
func SetTitle()
	"如果文件类型为.sh文件
	if &filetype == 'sh'
		call setline(1, "##########################################################################")
		call append(line("."), "# File Name: ".expand("%"))
		call append(line(".")+1, "# Author: YoYoLikesCiCi-狲齐")
		call append(line(".")+2, "# mail: YoYoLikesCiCi@live.cn")
		call append(line(".")+3, "# Created Time: ".strftime("%c"))
		call append(line(".")+4, "#########################################################################")
		call append(line(".")+5, "#!/bin/zsh")
		call append(line(".")+6, "PATH=/home/edison/bin:/home/edison/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/work/tools/gcc-3.4.5-glibc-2.3.6/bin")
		call append(line(".")+7, "export PATH")
		call append(line(".")+8, "")
	elseif &filetype == 'python'
		call setline(1, "'''*************************************************************************")
		call append(line("."), "	> File Name: ".expand("%"))
		call append(line(".")+1, "	> Author: YoYoLikesCiCi-狲齐")
		call append(line(".")+2, "	> Mail: YoYoLikesCiCi@live.cn ")
		call append(line(".")+3, "	> Created Time: ".strftime("%c"))
		call append(line(".")+4, " ************************************************************************'''")
		call append(line(".")+5, "")
	elseif &filetype == 'go'
		call append(line(".")+7, "")
    else
		call setline(1, "/*************************************************************************")
		call append(line("."), "	> File Name: ".expand("%"))
		call append(line(".")+1, "	> Author: YoYoLikesCiCi-狲齐")
		call append(line(".")+2, "	> Mail: YoYoLikesCiCi@live.cn ")
		call append(line(".")+3, "	> Created Time: ".strftime("%c"))
		call append(line(".")+4, " ************************************************************************/")
		call append(line(".")+5, "")
	endif
	if &filetype == 'cpp'
		call append(line(".")+6, "#include<iostream>")
    	call append(line(".")+7, "using namespace std;")
		call append(line(".")+8, "")
	endif
	if &filetype == 'c'
		call append(line(".")+6, "#include<stdio.h>")
		call append(line(".")+7, "")
	endif
	if &filetype == 'java'
		call append(line(".")+6,"public class ".expand("%"))
		call append(line(".")+7,"")
	endif

	"新建文件后，自动定位到文件末尾
	autocmd BufNewFile * normal G
endfunc

function RToc()
    exe "/-toc .* -->"
    let lstart=line('.')
    exe "/-toc -->"
    let lnum=line('.')
    execute lstart.",".lnum."g/           /d"
endfunction


function! AutoIM(event)
	let is_abc = system('is_abc') != ''

	let need_switch_im = 0
	if a:event == 'leave'
		if !is_abc
			let g:lv_restore_last_im = 1
			let need_switch_im = 1
		else
			let g:lv_restore_last_im = 0
		end
	else " a:event == 'enter'
		if is_abc && g:lv_restore_last_im
			let need_switch_im = 1
		end
	end

	if need_switch_im 
		silent !osascript /Users/neo/.vim/ctrl+space.scpt
	end
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
