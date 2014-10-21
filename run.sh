#!/bin/bash

[ -z $GEM_SRC ] && {
    GEM_SRC=$1
}

[ -z $GEM_SRC ] && {
    echo "This container must be started with a GEM_SRC variable set or provided as an argument"
    exit 1
}

workdir=$(mktemp -d)
isgiturl=$(echo $GEM_SRC | grep '\.git$' | wc -l)

if [ $isgiturl == 1 ]; then
    git clone $GEM_SRC $workdir 1> /dev/null
    [ $? != 0 ] && {
        echo "error cloning from $GEM_SRC"
        exit 1
    }
    cd $workdir && \
    gemname=$(ls *.gemspec | cut -f1 -d\.) && \
    bundle_gemfile=$PWD/Gemfile && \
    gem build ${gemname}.gemspec && \
    bundle install --path=${bundle_path:-vendor/bundle} && \
    gem2deb *.gem && \
    echo 'done!'
else
    gem2deb $GEM_SRC
    echo 'done!'
fi
