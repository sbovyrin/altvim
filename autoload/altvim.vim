fun! altvim#lsp_status() abort
    let l:info = lsp#get_buffer_diagnostics_counts()
    if empty(l:info) | return '' | endif
    
    let l:msgs = []
    
    if get(l:info, 'error', 0)
        call add(msgs, 'E' . info['error'])
    endif
    
    if get(l:info, 'warning', 0)
        call add(msgs, 'W' . info['warning'])
    endif
    
    if len(l:msgs) > 0
        let l:msgs = [' ['] + msgs + [']']
    endif
    
    return join(l:msgs, '')
endfun
