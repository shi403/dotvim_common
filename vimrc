
if !1 | finish | endif

if has('vim_starting') && v:version < 800
	echo 'CAUTION!!! Please use vim version 8.0 or over.'
	finish
endif

"--" Vim Starting: {{{1
"------------------------------------------------------------------------
if has('vim_starting')
	set runtimepath+=~/.vim_common
	set runtimepath+=~/.vim_common/kaoriya

	runtime macros/matchit.vim
endif 
"--" Vim Starting: }}}1

"--" Encoding: 文字コードの自動認識: {{{1
"--------------------------------------------------------------------------
"set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp,cp932,sjis,euc-jp,utf-8
set fileformats=unix,dos,mac

set ambiwidth=double

"--" Encoding: 文字コードの自動認識: }}}1

"--" Vim View Options: {{{1
"------------------------------------------------------------------------
"-- Color Scheme --"
syntax on
set background=dark
let g:solarized_termcolors=256
colorscheme molokai

"-- Tab可視化 --"
set nolist
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set tabstop=4

set number " 行番号

"--" Vim View Options: }}}1

"--" StatusLine TabLine: ステータスライン タブライン: {{{1
"---------------------------------------------------------------------------
set laststatus=2
set showtabline=2 " 常にタブラインを表示

set statusline=%F                      " ファイル名表示
set statusline+=%m                     " 変更チェック表示
set statusline+=%r                     " 読み込み専用かどうか表示
set statusline+=%h                     " ヘルプページなら[HELP]と表示
set statusline+=%w                     " プレビューウインドウなら[Prevew]と表示
set statusline+=%=                     " これ以降は右寄せ表示
set statusline+=[ENC=%{&fileencoding}] " file encoding
set statusline+=[LOW=%l/%L]            " 現在行数/全行数

"-- Tab prefix key.
nnoremap  [Tag]   <Nop>
nmap    t [Tag]

"--" Tab Jump: t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" tc 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" tn 次のタブ
map <silent> [Tag]n :tabnext<CR>
" tp 前のタブ
map <silent> [Tag]p :tabprevious<CR>
"--" StatusLine TabLine: }}}1

"--" Netrw Taglist:{{{1
"---------------------------------------------------------------------------
" netrw ロード有効
"let g:loaded_netrwPlugin = 0 

" netrwは常にtree view
let g:netrw_liststyle = 3
let g:netrw_brouse_split = 4
let g:netrw_altv = 1
" 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
let g:netrw_altv = 1
" 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
let g:netrw_alto = 1

map <silent> <leader>e :NERDTreeToggle<cr>
map <silent> <leader>E :TlistToggle<cr>
function! ToggleVExplorer() "{{{2
    if !exists("t:netrw_bufnr")
       exec '1wincmd w'
       25Vexplore
       let t:netrw_bufnr = bufnr("%")
       return
    endif
    let win = bufwinnr(t:netrw_bufnr)
    if win != -1
       let cur = winnr()
       exe win . 'wincmd w'
       close
       exe cur . 'wincmd w'
    endif
    unlet t:netrw_bufnr
endfunction " }}}2
" CtrIPでファイルを中央のウィンドウで開く設定
function! CtrIP_OpenAtCenter(action, line) " {{{2
    let cw = bufwinnr('.')
    for n in range(0, bufnr('$'))
      let bw = bufwinnr(n)
      if bw == cw && buflisted(n)
        exe bw . 'wincmd w'
        break
      endif
    endfor
    call call('ctrlp#acceptfile',[a:action,a:line])
endfunction " }}}2
let g:ctrlp_open_func = {'files': 'CtrIP_OpenAtCenter'}

"--" Taglist: }}}1

"--" Mouse Event: {{{1
"--------------------------------------------------------------------------
set mouse=a

"--" Mouse Event: }}}1

"--" Common Plugin Options: {{{1
"------------------------------------------------------------------------
let g:Align_xstrlen = 3

"--" Common Plugin Options: }}}1

"--" Search Options: {{{1
"--------------------------------------------------------------------------
set   hlsearch
set noincsearch     " do incremental searching
set   ignorecase    " 検索時に大文字小文字を無視
set   smartcase     " 大文字小文字の両方が含まれている場合は大文字小文字を>
set   wrapscan

"--" Search Options: }}}1

"--" Complete: {{{1
"--------------------------------------------------------------------------
set   showcmd		    " display incomplete commands
set   wildmenu
set   wildmode=full

" }}}1 W Search Options:

"--" Utilityes: {{{1
"--------------------------------------------------------------------------
"--" ContinuousNumber: 連番自発: {{{2
nnoremap <silent> co :ContinuousNumber <C-a><CR>
vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber 
	\	let c = col('.')|
	\	for n in range(1, <count>?<count>-line('.'):1) |
	\		exec 'normal! j' . n . <q-args> |
	\		call cursor('.', c) |
	\	endfor
"--" ContinuousNumber: 連番自発: }}}2

" Utilityes: }}}1

"--" Disable Default Plugins:  {{{1
"--------------------------------------------------------------------------- 
let g:loaded_2html_plugin      = 1 
"let g:loaded_logiPat           = 1 
"let g:loaded_getscriptPlugin   = 1 
"let g:loaded_gzip              = 1 
let g:loaded_man               = 1 
"let g:loaded_matchit           = 1 
"let g:loaded_matchparen        = 1 
"let g:loaded_netrwFileHandlers = 1 
"let g:loaded_netrwPlugin       = 1 
"let g:loaded_netrwSettings     = 1 
"let g:loaded_rrhelper          = 1 
"let g:loaded_shada_plugin      = 1 
"let g:loaded_spellfile_plugin  = 1 
"let g:loaded_tarPlugin         = 1 
let g:loaded_tutor_mode_plugin = 1 
let g:loaded_vimballPlugin     = 1 
"let g:loaded_zipPlugin         = 1 


"-- .vim_common
let loaded_taglist = 1

"--" Disable Default Plugins: }}}1


"--------------------------------------------------------------------------
if filereadable(expand('~/.vimrc.$USER')) 
	execute 'source' expand('~/.vimrc.$USER') 
endif 

" vim:foldmethod=marker:foldlevel=0
