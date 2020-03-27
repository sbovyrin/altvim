#!/bin/sh

echo "Running altvim post-install...\n"

which curl 1>/dev/null 2>&1 \
    || (echo "Please install curl" && exit 1)

VIM_DEPS=./deps
# prevent creating .npm or .yarn directories in home directory
HOME=/tmp

ls $VIM_DEPS 1>/dev/null 2>&1 || mkdir -p $VIM_DEPS

ls $VIM_DEPS/nodejs 1>/dev/null 2>&1 \
    || (curl https://nodejs.org/dist/v12.4.0/node-v12.4.0-linux-x64.tar.xz -o $VIM_DEPS/nodejs.tar.xz -s \
    && tar -xf $VIM_DEPS/nodejs.tar.xz -C $VIM_DEPS \
    && rm -vf $VIM_DEPS/*.tar.xz \
    && mv $VIM_DEPS/node* $VIM_DEPS/nodejs \
    && sed -i --follow-symlinks "s|/usr/bin/env node|$(pwd)/${VIM_DEPS}/nodejs/bin/node|g" $VIM_DEPS/nodejs/bin/npm \
    && sed -i --follow-symlinks "s|/usr/bin/env node|$(pwd)/${VIM_DEPS}/nodejs/bin/node|g" $VIM_DEPS/nodejs/bin/npx \
    && $VIM_DEPS/nodejs/bin/npm i --prefix $VIM_DEPS/nodejs/lib/node_modules/yarn yarn \
    && mv $VIM_DEPS/nodejs/lib/node_modules/yarn/node_modules/yarn/* $VIM_DEPS/nodejs/lib/node_modules/yarn \
    && rm -rf $VIM_DEPS/nodejs/lib/node_modules/yarn/{node_modules,package-lock.json} \
    && ln -s ./../lib/node_modules/yarn/bin/yarn $VIM_DEPS/nodejs/bin/yarn)

mkdir $(pwd)/../../after/plugin/altvim \
    && echo "autocmd QuitPre * if &ft =~ 'vim-plug' | source $MYVIMRC | endif" > $(pwd)/../../after/plugin/altvim.vim

which clear 1>/dev/null 2>&1 && clear
