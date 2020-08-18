fun! altvim#copy()
    normal! y"0
    "let @0 = substitute(@0, '\n', '', '')
    " windows wsl tweak
    if system('uname -r') =~ 'microsoft'
        call system('clip.exe', @0)
    endif
endfun

fun! altvim#paste()
    if (getline('.')[col('.')] == '' )
        \ && (getline('.')[col('.') - 1] !~ ')\|]\|}')
        norm! "0p==
    else
        norm! "0P==
    endif
endfun
