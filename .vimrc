" Pre-requisites:
" Plugin 'Chiel92/vim-autoformat'
" Plugin 'vim-syntastic/syntastic'

" vim-autoformat config, run :Autoformat to format
let g:formatdef_spec = '"./bin/translate-references.js"'
let g:formatters_html = ['spec']
let g:syntastic_html_checkers = ['spec']

set ts=4
set sw=4
function! TranslatePunc()
    execute '%s/\zs\.\ze\(<\|$\| \)/。/g'
    execute '%s/ 。 / . /g'
    execute '%s/, /，/g'
    execute '%s/,$/，/g'
endfunction

function! TranslateTerm()
    execute '%s/Let /令/g'
    execute '%s/Set /设置/g'
    execute "%s/'s/的/g"
    execute '%s/one or more/一个或更多/g'
    execute '%s/start tag whose/开始标签 whose/g'
    execute '%s/end tag whose/结束标签 whose/g'
    execute '%s/Reprocess the token/重新处理该标记'
    execute '%s/pop the/把  从  弹出/g'
    execute '%s/ignore the token/忽略该标记/ig'
    execute '%s/Process the token/处理该标记/ig'
    execute '%s/for the token/为该标记/ig'
    execute '%s/Optionally/可选地/g'
    execute '%s/Otherwise/否则/g'
    execute '%s/is true/为 true/g'
    execute '%s/character token/字符标记/g'
    execute '%s/This is an/这是一个/g'
    execute '%s/Switch to/切换到/g'
    execute '%s/Emit a/发出一个/g'
    execute '%s/Emit the/发出/g'
    execute '%s/Anything else/任何其他情况/g'
    execute '%s/to the empty string/设为空字符串/g'
    execute '%s/e\.g\./例如/g'
    execute '%s/then:/则：/g'
    execute '%s/then throw a/则抛出一个/g'
    execute '%s/for example, /例如/gi'
    execute '%s/for instance, /例如/gi'
    execute '%s/i\.e\./即/g'
    execute '%s/If/如果/g'
    execute '%s/return an error/返回一个错误/g'
    execute '%s/and abort these steps/并中止这些步骤/g'
    execute '%s/Return/返回/g'
endfunction

function! PreTranslate()
    call TranslateTerm()
    call TranslatePunc()
endfunction

set sw=2 ts=2

nnoremap <F6> :call PreTranslate()<CR>
nnoremap <F4> :source helper.vim<CR>
