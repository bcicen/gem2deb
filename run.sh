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
    bundle_gemfile=${workdir}/Gemfile && \
    bundle install --path=${bundle_path:-vendor/bundle} && \
    gem build *.gemspec && \
    gem2deb *.gem && \
    mv *.deb /data/ && \
    echo 'done!'
else
    cd $workdir && \
    gem2deb $GEM_SRC && \
    mv *.deb /data/ && \
    echo 'done!'
fi
