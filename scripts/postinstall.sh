#!/bin/sh

# to make your script exit when a command fails
set -e
# to exit when your script tries to use undeclared variables
set -u

echo "Running altvim post-install...\n"

which curl 1>/dev/null 2>&1 \
    || (echo "Please install curl" && exit 1)

VIM_DEPS=./deps

# prevent creating .npm or .yarn directories in home directory
OLD_HOME=$HOME
HOME=/tmp

ls $VIM_DEPS 1>/dev/null 2>&1 || mkdir -p $VIM_DEPS

download_nodejs()
{
    curl https://nodejs.org/dist/v12.4.0/node-v12.4.0-linux-x64.tar.xz -o $VIM_DEPS/nodejs.tar.xz -s
    tar -xf $VIM_DEPS/nodejs.tar.xz -C $VIM_DEPS 1>/dev/null
    rm -f $VIM_DEPS/*.tar.xz
    mv $VIM_DEPS/node* $VIM_DEPS/nodejs

    return 0
}

install_nodejs()
{
    sed -i --follow-symlinks "s|/usr/bin/env node|$(pwd)/${VIM_DEPS}/nodejs/bin/node|g" $VIM_DEPS/nodejs/bin/npm
    sed -i --follow-symlinks "s|/usr/bin/env node|$(pwd)/${VIM_DEPS}/nodejs/bin/node|g" $VIM_DEPS/nodejs/bin/npx
    $VIM_DEPS/nodejs/bin/npm i --prefix $VIM_DEPS/nodejs/lib/node_modules/yarn yarn
    mv $VIM_DEPS/nodejs/lib/node_modules/yarn/node_modules/yarn/* $VIM_DEPS/nodejs/lib/node_modules/yarn
    rm -rf $VIM_DEPS/nodejs/lib/node_modules/yarn/{node_modules,package-lock.json}
    ln -s ./../lib/node_modules/yarn/bin/yarn.js $VIM_DEPS/nodejs/bin/yarn
    sed -i --follow-symlinks "s|/usr/bin/env node|$(pwd)/${VIM_DEPS}/nodejs/bin/node|g" $VIM_DEPS/nodejs/bin/yarn

    return 0
}

ls $VIM_DEPS/nodejs 1>/dev/null 2>&1 \
    || (download_nodejs && install_nodejs)

HOME=$OLD_HOME

which clear 1>/dev/null 2>&1 && clear
