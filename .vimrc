function! TranslatePunc()
    execute '%s/\zs\.\ze\(<\|$\| \)/。/g'
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
    execute '%s/Return/返回/g'
endfunction

function! PreTranslate()
    call TranslateTerm()
    call TranslatePunc()
endfunction

set sw=2 ts=2

nnoremap <F6> :call PreTranslate()<CR>
