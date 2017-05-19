function! TranslatePunc()
    execute '%s/\zs\.\ze\(<\|$\| \)/。/g'
    execute '%s/, /，/g'
    execute '%s/:/：/g'
    execute '%s/https?：/:/g'
    execute '%s/(/（/g'
    execute '%s/)/）/g'
endfunction

function! TranslateTerm()
    execute '%s/Let /令/g'
    execute '%s/one or more/一个或更多/g'
    execute '%s/Optionally/可选地/g'
    execute '%s/e\.g\./例如/g'
    execute '%s/i\.e\./即/g'
    execute '%s/If/如果/g'
    execute '%s/Return/返回/g'
endfunction

function! PreTranslate()
    call TranslateTerm()
    call TranslatePunc()
endfunction

nnoremap <F6> :call PreTranslate()<CR>
