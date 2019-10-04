#!/bin/sh
ls $(pwd) > testfile

# VIM_DEPS=./../deps

# ls $VIM_DEPS 1>/dev/null 2>&1 || mkdir -p $VIM_DEPS

# ls $VIM_DEPS/nodejs 1>/dev/null 2>&1 \
#     || (curl https://nodejs.org/dist/v12.4.0/node-v12.4.0-linux-x64.tar.xz -o $VIM_DEPS/nodejs.tar.xz -s \
#         && tar -xf $VIM_DEPS/nodejs.tar.xz -C $VIM_DEPS \
#         && rm -vf $VIM_DEPS/*.tar.xz \
#         && mv $VIM_DEPS/node* $VIM_DEPS/nodejs \
#         && sed -i --follow-symlinks "s|/usr/bin/env node|${VIM_DEPS}/nodejs/bin/node|g" $VIM_DEPS/nodejs/bin/npm \
#         && sed -i --follow-symlinks "s|/usr/bin/env node|${VIM_DEPS}/nodejs/bin/node|g" $VIM_DEPS/nodejs/bin/npx \
#         && $VIM_DEPS/nodejs/bin/npm i --prefix $VIM_DEPS/nodejs/lib/node_modules/yarn yarn \
#         && mv $VIM_DEPS/nodejs/lib/node_modules/yarn/node_modules/yarn/* $VIM_DEPS/nodejs/lib/node_modules/yarn \
#         && rm -rf $VIM_DEPS/nodejs/lib/node_modules/yarn/{node_modules,package-lock.json} \
#         && ln -s $VIM_DEPS/nodejs/lib/node_modules/yarn/bin/yarn $VIM_DEPS/nodejs/bin/yarn)  
