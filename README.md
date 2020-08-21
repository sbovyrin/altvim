# altvim

`v1.0.0`

Using VIM has never been easier.


## Contents

- [Why I created this plugin?](#Why-I-created-this-plugin?)
- [Features](#Features)
- [Installing](#Installing)
- [Using](#Using)
- [Hotkeys](#Hotkeys)
- [Advanced code editing](#Advanced-code-editing)


## Why I created this plugin?
I started my programming way using IntelliJ IDEA editor, but I decided to try another one due to the IDEA slowness and high memory/CPU consumption.
I was looking for a simple and fast editor with features that I need. So I became a user of VSCode. I was totally satisfied and didn't think about searching something else for about a year. Until one day I heard about VIM editor.
Launching VIM for the first time I was amazed how quickly it opened and was ready to use - it happend in a flash! But my joy didn't last long. I tried to edit a file in VIM and failed (moreover I couldn't quit from VIM :) ).
I returned to VSCode, but thought of using VIM as main development tool didn't leave me. I tried to use VIM every week, I was looking for answers in google and stackoverflow, but always came back to VSCode, because development process in VIM took me incredibly long time.
After six months of persistent trying to use VIM, I mastered it and could keep my normal development speed or even faster. Since that moment I’ve moved to VIM completely. Today I have nothing except console and browser on my work machine.
After careful studying and testing of vim features, I gathered all my knowledge and experience to create this plugin and share it with all of you.
Considering all my positive experience working in VIM I’m excited to give a lot of people an opportunity to work in really fast and effective editor.


## Features

- Zero configuration
- Habitual text editing
- Edit text like a pro ([details](#Advanced-text-editing)) 
- Blazing fast
- Language Server Protocol ([details](https://microsoft.github.io/language-server-protocol/))


## Installing

> Available only for mac/linux for now

### Requirements

- VIM 8.0+
- Installed [vim-plug](https://github.com/junegunn/vim-plug#installation)
- Installed `curl`
- Installed `git`


### Setting up `.vimrc`

1. Create `.vimrc` file in your home user directory if you don't have it yet.
2. Add below code in `.vimrc` between `plug#begin` and `plug#end`:
```
Plug 'sbovyrin/altvim', { 'do': './scripts/postinstall.sh' }
if isdirectory(get(g:plugs, 'altvim', {'dir': ''}).dir)
    exe join(['source ', g:plugs['altvim'].dir, 'deps/plugins.vim'], '')
endif
```
3. To install the plugin run VIM command `:PlugInstall --sync | source $MYVIMRC`


## Using

- Open a file: `vim <filename>`
- Open a directory `vim <directory>`


## Hotkeys

> action: <visual_mode><count>[<motions...>]<operator>
