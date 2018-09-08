
if has('vim_starting') && v:version < 800
	echo 'CAUTION!!! Please use vim version 8.0 or over.'
	finish
endif

" Window size: {{{
"---------------------------------------------------------------------------
"set columns=140
"set lines=45
" Window size: }}}

" Visual Options: {{{
"---------------------------------------------------------------------------
colorscheme molokai
"colorscheme alduin
" Visual Options: }}}

" Font Options: {{{
"---------------------------------------------------------------------------
if has('win32')
  "-- for Windows
  set guifont=MS_Gothic:h8:cSHIFTJIS
  "set guifont=Migu_1M:h10:cSHIFTJIS
  "-- 行間隔の設定
  set linespace=1
  "-- 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  "set guifont=Osaka?等幅:h14
  "set guifont=Ricty\ Discord\ Regular\ for\ Powerline:h13
  "set guifont=Ricty\ Regular\ for\ Powerline:h13
  set guifont=Cica:h13
elseif has('xfontset')
  "-- for UNIX (xfontsetを使用)
  set guifontset=a14,r14,k14
else
  "-- for UNIX (GTK2)
  set guifont=Bitstream\ Vera\ Sans\ Mono\ 8
endif
" Font Options: }}}

" Mouse Options: {{{
"---------------------------------------------------------------------------
"set mouse=a              " どのモードでもマウスを使えるようにする
""set mousefocus          " マウスの移動で,フォーカス切替え制御 (mousefocus:切替る)
"set mousehide            " 入力時にマウスポインタを隠す (nomousehide:隠さない)

""set guioptions+=a       " ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
""set guioptions+=b       " 横スクロールバー
"set guioptions-=T
""set guioptions-=m
"set guioptions-=r
"set guioptions-=L
" Mouse Options: }}}

" Cursor Options: {{{
"---------------------------------------------------------------------------
set guicursor=a:blinkon0
"set guicursor=n-v-c:blinkwait200-blinkoff100-blinkon200

" Cursor Options: }}}

"--------------------------------------------------------------------------
if filereadable(expand('~/.gvimrc.$USER')) 
	execute 'source' expand('~/.gvimrc.$USER') 
endif 

" vim:foldmethod=marker:foldlevel=0
