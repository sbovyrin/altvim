# altvim

**v0.2.0**

Using VIM has never been easier than now.


## Why I created this plugin?
I started my programming way using IntelliJ IDEA editor, but I decided to try another editor due to the IDEA slowness and high memory/CPU consumption.
I was looking for a simple and fast editor with features that I need. So I became a user of VSCode. I was totally satisfied and didn't think about searching something else for about a year until one day I heard about VIM editor.
Launching VIM for the first time I was amazed how quickly it opened and was ready to use - it happend in a flash. But my joy didn't last long. I tried to edit a file in VIM and failed (moreover I couldn't quit from VIM :) ).
I returned back to VSCode, but thought of using VIM as main development tool didn't leave me. I tried to use VIM every week, I was looking for answers in google and stackoverflow, but always came back to VSCode, because development process in VIM took me incredibly long time.
After six months of persistent trying to use VIM, I mastered it and could keep my normal development speed or even faster. Since that moment I’ve moved to VIM completely. Today I have nothing except console and browser on my work machine.
After careful studying and testing of vim features, I gathered all my knowledge and experience to create this plugin and share it with all of you. 
Considering all my positive experience working in vim I’m excited to give a lot of people an opportunity to work in really fast and effective editor.


## Contents
- [Quick start](#Quick-start)
- [Features](#Features)


## Quick start

### Prerequisites

> Make sure to use Vim 8.0 or above.

#### curl
Input `curl --version` in terminal to check whether it's installed.

You will see:
```
curl 7.64.0 (x86_64-pc-linux-gnu)
Release-Date: yyyy-mm-dd
...
```

*If you didn't see the result, then you should install `curl`*

#### git
Input `git --version` in terminal to check whether it's installed.
You will see:
```
git version 2.24.0
```

*If you didn't see the result, then you should install `git`*

#### ag
Input `ag --version` in terminal to check whether it's installed.
You will see:
```
ag version 2.2.0
```

*If you didn't see the result, then you should install [`ag`](https://github.com/ggreer/the_silver_searcher#installing)*


**[!]** Add `stty -ixon` to the end of your **.bashrc/.zshrc** file. It disable terminal freezing.

### Installing

1. Create `.vimrc` file in your home user directory if you no have it yet. 
2. Add below code in `.vimrc`:
```
" auto install package manager if is not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -s
endif
call plug#begin('~/.vim/plugged')
Plug 'sbovyrin/altvim', { 'do': './scripts/postinstall.sh' }
if isdirectory(get(g:plugs, 'altvim', {'dir': ''}).dir)
    exe join(['source ', g:plugs['altvim'].dir, 'deps/plugins.vim'], '')
endif
call plug#end
```

## Features
