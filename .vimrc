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
    execute '%s/:/：/g'
    execute '%s/https：/https:/g'
    execute '%s/http：/http:/g'
endfunction

function! TranslateTerm()
    execute '%s/Let /令/g'
    execute '%s/Set /设置/g'
    execute "%s/'s/的/g"
    execute '%s/one or more/一个或更多/g'
    execute '%s/Optionally/可选地/g'
    execute '%s/Otherwise/否则/g'
    execute '%s/is true/为 true/g'
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
