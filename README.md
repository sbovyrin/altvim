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

- Coding like a pro
- Zero configuration
- Blazing fast
- Low-resource consumption
- No modes
- Habitual hotkeys ([details](#Hotkeys))
- Advanced code editing ([details](#Advanced-code-editing))
- Language Server Protocol ([details](https://microsoft.github.io/language-server-protocol/))


## Installing

> Available only for mac/linux for now

### Requirements

- VIM 8.0+
- Installed `curl`
- Installed `git`


### Setting up `.vimrc`

1. Create `.vimrc` file in your home user directory if you don't have it yet.
2. Add below code in `.vimrc`:
```
" auto install package manager if is not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -s
endif

call plug#begin('~/.vim/plugged')

" altvim plugin
Plug 'sbovyrin/altvim', { 'do': './scripts/postinstall.sh' }
if isdirectory(get(g:plugs, 'altvim', {'dir': ''}).dir)
    exe join(['source ', g:plugs['altvim'].dir, 'deps/plugins.vim'], '')
endif

call plug#end
```

## Using

- Open a file: `vim <filename>`
- Open a directory `vim <directory>`


## Hotkeys

> \* It means that a hotkey works only when some chars/lines are selected

- Editor command prompt: `Alt + /`


- Save file: `Ctrl + s`
- Quit: `Ctrl + q`
- Close current file: `Ctrl + w`


- Copy: `Ctrl + c`
- Cut: `Ctrl + x`
- Paste: `Ctrl + v`
- Paste from multiclipboard: `Alt + v`
- Undo: `Ctrl + z`
- Redo: `Alt + z`
- Delete: `Backspace`
- Clear: `Space` *
- Clone: `Ctrl + l` *
- Join: `Ctrl + j`


- Indent: `Tab`
- Outdent: `Shift + Tab` *


- Format code: `Ctrl + b` *
- Toggle comment: `Ctrl + /`


- Go to last change: `Alt + Backspace`
- Go to line begin: `Ctrl + Up`
- Go to line end: `Ctrl + Down`
- Go to next word: `Ctrl + Right`
- Go to previous word: `Ctrl + Left`
- Go to specific place in current file: `Ctrl + Space` ([detail](#go-to-specific-place-in-file))
- Go to next specific place in current file: `Alt + Right` ([detail](#go-to-specific-place-in-file))
- Go to previous specific place in current file: `Alt + Left` ([detail](#go-to-specific-place-in-file))
- Go to next problem in current file: `Alt + e`


- Select last selection: `Alt + s`
- Select all: `Ctrl + a`
- Select word: `Ctrl + Shift + Right`
- Select previous word: `Ctrl + Shift + Left`
- Select till specific place in current file: `Ctrl + Alt + Right` ([detail](#go-to-specific-place-in-file))
- Select till previous specific place in current file: `Ctrl + Alt + Left` ([detail](#go-to-specific-place-in-file))
- Select till line begin: `Ctrl + Shift + Up`
- Select till line end: `Ctrl + Shift + Down`


- Show errors/warnings: `Ctrl + e`
- Find in current file: `Ctrl + f`
- Find in project files: `Alt + f`
- Open a file from current workspace: ``Alt + ` ``
- Select opened file: ``Alt + Shift + ` ``
- Open last opened file: ``Alt + Shift + ` ``


## Advanced code editing

### Go to specific place in file
Comming soon...
