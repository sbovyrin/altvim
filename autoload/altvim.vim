function! altvim#isActivePlugin(pluginName) abort
    return has_key(g:plugs, a:pluginName) && isdirectory(g:plugs[a:pluginName].dir)
endfunction
