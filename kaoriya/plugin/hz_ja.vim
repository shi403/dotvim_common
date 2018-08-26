" vim:set ts=8 sts=2 sw=2 tw=0 nowrap:
"
" hz_ja.vim - Convert character between HANKAKU and ZENKAKU
"
" Last Change: 06-Feb-2006.
" Written By:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
" Commands:
"   :Hankaku	  Convert to HANKAKU.
"   :Zenkaku	  Convert to ZENKAKU.
"   :ToggleHZ	  Toggole convert between HANKAKU and ZENKAKU.
"
" Functions:
"   ToHankaku(str)	Convert given string to HANKAKU.
"   ToZenkaku(str)	Convert given string to ZENKAKU.
"
" To make vim DO NOT LOAD this plugin, write next line in your .vimrc:
"	:let plugin_hz_ja_disable = 1

" Japanese Description:
" ���ޥ��:
"   :[raneg]Hankaku
"   :[range]Zenkaku
"   :[range]ToggleHZ
"   :[range]HzjaConvert {target}
"
" �����ޥåԥ�:
"   �ʲ��ϥӥ��奢�������ΰ���Ф������Ǥ����ޤ�()���HzjaConvert���ޥ��
"   �ȴؿ����Ϥ���target�˻����ǽ��ʸ����Ǥ���
"     gHL	��ǽ��ʸ��������Ⱦ�Ѥ��Ѵ�����	(han_all)
"     gZL	��ǽ��ʸ�����������Ѥ��Ѵ�����	(zen_all)
"     gHA	ASCIIʸ��������Ⱦ�Ѥ��Ѵ�����	(han_ascii)
"     gZA	ASCIIʸ�����������Ѥ��Ѵ�����	(zen_ascii)
"     gHM	���������Ⱦ�Ѥ��Ѵ�����	(han_kigou)
"     gZM	������������Ѥ��Ѵ�����	(zen_kigou)
"     gHW	�ѿ���������Ⱦ�Ѥ��Ѵ�����	(han_eisu)
"     gZW	�ѿ������������Ѥ��Ѵ�����	(zen_eisu)
"     gHJ	�������ʤ�����Ⱦ�Ѥ��Ѵ�����	(han_kana)
"     gZJ	�������ʤ��������Ѥ��Ѵ�����	(zen_kana)
"   �ʲ��ϻ������٤ι⤵���θ���ơ��嵭�Ƚ�ʣ������ǽ�Ȥ��Ƴ�����Ƥ�줿
"   �����ޥåפǤ���
"     gHH	ASCIIʸ��������Ⱦ�Ѥ��Ѵ�����	(han_ascii)
"     gZZ	�������ʤ��������Ѥ��Ѵ�����	(zen_kana)
" 
" �ؿ�:
"   ToHankaku(str)	ʸ�����Ⱦ�Ѥ��Ѵ�����
"   ToZenkaku(str)	ʸ��������Ѥ��Ѵ�����
"   HzjaConvert(str, target)
"			ʸ�����target�˽����Ѵ����롣target�ΰ�̣�ϥ����ޥ�
"			�ԥ󥰤ι��ܤ򻲾ȡ�
"
" ��˥塼��ĥ:
"   GUI�Ķ��Ǥϥӥ��奢��������Υݥåץ��åץ�˥塼(������å���˥塼)��
"   �Ѵ��ѤΥ��ޥ�ɤ��ɲä���ޤ���
"
" ���Υץ饰������ɹ��ߤ����ʤ�����.vimrc�˼��Τ褦�˽񤯤���:
"	:let plugin_hz_ja_disable = 1

scriptencoding cp932

if exists('plugin_hz_ja_disable')
  finish
endif
if !has('multi_byte')
  finish
endif

command! -nargs=0 -range Hankaku <line1>,<line2>call <SID>ToggleLineWise('Hankaku')
command! -nargs=0 -range Zenkaku <line1>,<line2>call <SID>ToggleLineWise('Zenkaku')
command! -nargs=0 -range ToggleHZ <line1>,<line2>call <SID>ToggleLineWise('Toggle')
command! -nargs=1 -range -complete=custom,HzjaConvertComplete HzjaConvert <line1>,<line2>call <SID>HzjaConvert(<q-args>)

vnoremap <silent> gHL <C-\><C-N>:call <SID>HzjaConvertVisual('han_all')<CR>
vnoremap <silent> gZL <C-\><C-N>:call <SID>HzjaConvertVisual('zen_all')<CR>
vnoremap <silent> gHA <C-\><C-N>:call <SID>HzjaConvertVisual('han_ascii')<CR>
vnoremap <silent> gZA <C-\><C-N>:call <SID>HzjaConvertVisual('zen_ascii')<CR>
vnoremap <silent> gHM <C-\><C-N>:call <SID>HzjaConvertVisual('han_kigou')<CR>
vnoremap <silent> gZM <C-\><C-N>:call <SID>HzjaConvertVisual('zen_kigou')<CR>
vnoremap <silent> gHW <C-\><C-N>:call <SID>HzjaConvertVisual('han_eisu')<CR>
vnoremap <silent> gZW <C-\><C-N>:call <SID>HzjaConvertVisual('zen_eisu')<CR>
vnoremap <silent> gHJ <C-\><C-N>:call <SID>HzjaConvertVisual('han_kana')<CR>
vnoremap <silent> gZJ <C-\><C-N>:call <SID>HzjaConvertVisual('zen_kana')<CR>

vnoremap <silent> gHH <C-\><C-N>:call <SID>HzjaConvertVisual('han_ascii')<CR>
vnoremap <silent> gZZ <C-\><C-N>:call <SID>HzjaConvertVisual('zen_kana')<CR>

if has('gui_running')
  vnoremenu 1.120 PopUp.-SEP3-	<Nop>
  vnoremenu 1.130.100 PopUp.���Ѣ�Ⱦ��(&H).����(&L) <C-\><C-N>:call <SID>HzjaConvertVisual('han_all')<CR>
  vnoremenu 1.130.110 PopUp.���Ѣ�Ⱦ��(&H).ASCII(&A) <C-\><C-N>:call <SID>HzjaConvertVisual('han_ascii')<CR>
  vnoremenu 1.130.120 PopUp.���Ѣ�Ⱦ��(&H).����(&M) <C-\><C-N>:call <SID>HzjaConvertVisual('han_kigou')<CR>
  vnoremenu 1.130.130 PopUp.���Ѣ�Ⱦ��(&H).�ѿ�(&W) <C-\><C-N>:call <SID>HzjaConvertVisual('han_eisu')<CR>
  vnoremenu 1.130.140 PopUp.���Ѣ�Ⱦ��(&H).��������(&J) <C-\><C-N>:call <SID>HzjaConvertVisual('han_kana')<CR>
  vnoremenu 1.140.100 PopUp.Ⱦ�Ѣ�����(&Z).����(&L) <C-\><C-N>:call <SID>HzjaConvertVisual('zen_all')<CR>
  vnoremenu 1.140.110 PopUp.Ⱦ�Ѣ�����(&Z).ASCII(&A) <C-\><C-N>:call <SID>HzjaConvertVisual('zen_ascii')<CR>
  vnoremenu 1.140.120 PopUp.Ⱦ�Ѣ�����(&Z).����(&M) <C-\><C-N>:call <SID>HzjaConvertVisual('zen_kigou')<CR>
  vnoremenu 1.140.130 PopUp.Ⱦ�Ѣ�����(&Z).�ѿ�(&W) <C-\><C-N>:call <SID>HzjaConvertVisual('zen_eisu')<CR>
  vnoremenu 1.140.140 PopUp.Ⱦ�Ѣ�����(&Z).��������(&J) <C-\><C-N>:call <SID>HzjaConvertVisual('zen_kana')<CR>
endif

function! HzjaConvertComplete(argleand, cmdline, curpos)
  call s:Initialize()
  return s:targetlist
endfunction

function! s:HzjaConvert(target) range
  let nline = a:firstline
  while nline <= a:lastline
    call setline(nline, HzjaConvert(getline(nline), a:target))
    let nline = nline + 1
  endwhile
endfunction

" Ϳ����줿ʸ�����Ⱦ������ʸ������ߤ��Ѵ����롣�Ѵ�����ˡ�ϰ���target��ʸ
" ����Ȥ��ƻ��ꤹ�롣����Ǥ���ʸ����ϰʲ��ΤȤ��ꡣ
"
"   han_all	���Ƥ�����ʸ����Ⱦ��
"   han_ascii	���ѥ���������Ⱦ��
"   han_kana	���ѥ������ʢ�Ⱦ��
"   han_eisu	���ѱѿ���Ⱦ��
"   han_kigou	���ѵ��梪Ⱦ��
"   zen_all	���Ƥ�Ⱦ��ʸ��������
"   zen_ascii	Ⱦ�ѥ�������������
"   zen_kana	Ⱦ�ѥ������ʢ�����
"   zen_eisu	Ⱦ�ѱѿ�������
"   zen_kigou	Ⱦ�ѵ��梪����
"
function! HzjaConvert(line, target)
  call s:Initialize()
  if !exists('s:mx_'.a:target)
    return a:line
  else
    let mode = a:target =~# '^han_' ? 'Hankaku' : 'Zenkaku'
    return substitute(a:line, s:mx_{a:target}, '\=s:ToggleLine(submatch(0),0,0,mode)', 'g')
  endif
endfunction

function! s:HzjaConvertVisual(target)
  call s:Initialize()
  let save_regcont = @"
  let save_regtype = getregtype('"')
  normal! gvy
  call setreg('"', HzjaConvert(@", a:target), getregtype('"'))
  normal! gvp
  call setreg('"', save_regcont, save_regtype)
endfunction

let s:init = 0
function! s:Initialize()
  if s:init != 0
    return
  endif
  let s:init = 1

  let s:match_character = '\%([���������������������������ĥƥȥϥҥեإ�]��\|[�ϥҥեإ�]��\|.\)'
  let s:match_hankaku = '\%([���������������������������ĥƥȥϥҥեإ�]��\|[�ϥҥեإ�]��\|[ -~���֡ס��򥡥�����������á������������������������������������ĥƥȥʥ˥̥ͥΥϥҥեإۥޥߥ������������󡫡�]\)'

  let zen_ascii = '�����ɡ������ǡʡˡ��ܡ��ݡ������������������������������䡩�����£ãģţƣǣȣɣʣˣ̣ͣΣϣУѣңӣԣգ֣ףأ٣ڡΡ�ϡ����ƣ���������������������������������Сáѡ�'
  let zen_kana = '���֡ס��򥡥�����������á������������������������������������ĥƥȥʥ˥̥ͥΥϥҥեإۥޥߥ������������󡫡��������������������������¥ťǥɥХӥ֥٥ܥѥԥץڥ�'
  let han_ascii = " !\"#$%&'()*+,\\-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\\\\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
  let han_kana = '���֡ס��򥡥�����������á������������������������������������ĥƥȥʥ˥̥ͥΥϥҥեإۥޥߥ������������󡫡�'
  let s:mx_han_all = "[".zen_ascii.zen_kana."]\\+"
  let s:mx_zen_all = "[".han_ascii.han_kana."]\\+"
  let s:mx_han_ascii = "[".zen_ascii."]\\+"
  let s:mx_zen_ascii = "[".han_ascii."]\\+"
  let s:mx_han_kana = "[".zen_kana."]\\+"
  let s:mx_zen_kana = "[".han_kana."]\\+"
  let s:mx_han_eisu = '[�����������������������£ãģţƣǣȣɣʣˣ̣ͣΣϣУѣңӣԣգ֣ףأ٣ڣ��������������������������������]\+'
  let s:mx_zen_eisu = '[0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]\+'
  let s:mx_han_kigou = '[���ɡ������ǡʡˡ��ܡ��ݡ����������䡩���Ρ�ϡ����ơСáѡ�]\+'
  let s:mx_zen_kigou = "[!\"#$%&'()*+,\\-./:;<=>?@[\\\\\\]^_`{|}~]\\+"
  let s:targetlist = "han_all\<NL>zen_all\<NL>han_ascii\<NL>zen_ascii\<NL>han_kana\<NL>zen_kana\<NL>han_eisu\<NL>zen_eisu\<NL>han_kigou\<NL>zen_kigou"

  " Ⱦ�Ѣ����ѥơ��֥����
  let tmp = ''
  let tmp = tmp . " ��!��\"��#��$��%��&��'��(��)��*��+��,��-��.��/��"
  let tmp = tmp . '0��1��2��3��4��5��6��7��8��9��:��;��<��=��>��?��'
  let tmp = tmp . '@��A��B��C��D��E��F��G��H��I��J��K��L��M��N��O��'
  let tmp = tmp . 'P��Q��R��S��T��U��V��W��X��Y��Z��[��\��]��^��_��'
  let tmp = tmp . '`��a��b��c��d��e��f��g��h��i��j��k��l��m��n��o��'
  let tmp = tmp . 'p��q��r��s��t��u��v��w��x��y��z��{��|��}��~��'
  let tmp = tmp . '�����֡֡סס�����򥡥������������������������å�'
  let tmp = tmp . '����������������������������������������������������������������'
  let tmp = tmp . '���������ĥĥƥƥȥȥʥʥ˥˥̥̥ͥͥΥΥϥϥҥҥեեإإۥۥޥ�'
  let tmp = tmp . '�ߥߥ�������������������������󡫡�����'
  let tmp = tmp . '����������������������������������������������'
  let tmp = tmp . '�����¥¥ťťǥǥɥɥХХӥӥ֥֥٥٥ܥ�'
  let tmp = tmp . '�ѥѥԥԥץץڥڥݥ�'
  let tmp = tmp . ''
  let s:table_h2z = tmp

  " ���Ѣ�Ⱦ���Ѵ��ơ��֥��������롣
  let s:table_z2h = ''
  let startcol = 0
  let endcol = strlen(s:table_h2z)
  let curcol = 0
  let mx = '^\(' . s:match_hankaku . '\)\(.\)'
  while curcol < endcol
    let char = matchstr(s:table_h2z, mx, curcol)
    let s:table_z2h = s:table_z2h . substitute(char, mx, '\2\1', '')
    let curcol = curcol + strlen(char)
  endwhile
endfunction

"
" ���ޥ�ɤǻ��ꤵ�줿�ΰ���Ѵ�����
"
function! s:ToggleLineWise(operator) range
  call s:Initialize()

  let ncurline = a:firstline
  while ncurline <= a:lastline
    call setline(ncurline, s:ToggleLine(getline(ncurline), 0, 0, a:operator))
    let ncurline = ncurline + 1
  endwhile
endfunction

"
" Ϳ����줿ʸ������Ѵ������֤���
"
function! s:ToggleLine(line, startcolumn, endcolumn, operator)
  let endcol = ((a:endcolumn > 0 && a:endcolumn < strlen(a:line))? a:endcolumn : strlen(a:line)) - 1
  let startcol = a:startcolumn > 0 ? a:startcolumn - 1: 0
  let curcol = startcol
  let newline = ''
  while curcol <= endcol
    let char = matchstr(a:line, s:match_character, curcol)
    let newline = newline . s:{a:operator}Char(char)
    let curcol = curcol + strlen(char)
  endwhile
  return strpart(a:line, 0, startcol) . newline . strpart(a:line, curcol)
endfunction

function! ToHankaku(str)
  call s:Initialize()
  return s:ToggleLine(a:str, 0, 0, 'Hankaku')
endfunction

function! ToZenkaku(str)
  call s:Initialize()
  return s:ToggleLine(a:str, 0, 0, 'Zenkaku')
endfunction

"
" ����char���ǽ�ʤ��Ⱦ��/�����Ѵ������֤����Ѵ��Ǥ��ʤ����Ϥ��Τޤޡ�
"
function! s:ToggleChar(char)
  return (s:IsHankaku(a:char)) ? (s:ZenkakuChar(a:char)) : (s:HankakuChar(a:char))
endfunction

"
" ����char���ǽ�ʤ�����Ѥ��Ѵ������֤����Ѵ��Ǥ��ʤ����Ϥ��Τޤޡ�
"
function! s:ZenkakuChar(char)
  if s:IsHankaku(a:char)
    let pos = matchend(s:table_h2z, '\V\C' . escape(a:char, '\'))
    if pos >= 0
      return matchstr(s:table_h2z, '.', pos)
    endif
  endif
  return a:char
endfunction

"
" ����char���ǽ�ʤ��Ⱦ�Ѥ��Ѵ������֤����Ѵ��Ǥ��ʤ����Ϥ��Τޤޡ�
"
function! s:HankakuChar(char)
  if !s:IsHankaku(a:char)
    let pos = matchend(s:table_z2h, '\V\C' . escape(a:char, '\'))
    if pos >= 0
      return matchstr(s:table_z2h, s:match_hankaku, pos)
    endif
  endif
  return a:char
endfunction

"
" Ϳ����줿ʸ����Ⱦ�Ѥ��ɤ�����Ƚ�ꤹ�롣
"
function! s:IsHankaku(char)
  return a:char =~ '^' . s:match_hankaku . '$'
endfunction
