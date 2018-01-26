#!/bin/bash
if [ "$REDDCONOMY_VERSION_URL" == "" ];
then
    export REDDCONOMY_VERSION_URL="https://dl.bintray.com/reddconomy/Reddconomy/Reddconomy_latest.txt"
fi

if [ "$REDDCONOMY_DOWNLOAD_URL" == "" ];
then
    export REDDCONOMY_DOWNLOAD_URL="https://dl.bintray.com/reddconomy/Reddconomy/Reddconomy-sponge-{VERSION}.jar"
    export REDDCONOMY_DOWNLOAD_PASSWORD=""
fi

function getReddconomyVersion(){
    version="`curl  -L \"$REDDCONOMY_VERSION_URL\"`"
    echo $version
}

function downloadReddconomy {
    version="`curl  -L \"$REDDCONOMY_VERSION_URL\"`"
    dest=$1
    
    parent="`dirname $dest`"
    echo "Create $parent if missing"
    mkdir -p $parent

    if [ -f $dest ]; then 
        rm $dest
    fi
    dl="`echo \"$REDDCONOMY_DOWNLOAD_URL\" | sed s/\{VERSION\}/$version/g`"
    
    echo "Download $dl in $dest"

    if [ "$REDDCONOMY_DOWNLOAD_PASSWORD" == "" ];
    then
        curl -L "$dl" -o "$dest"
    else
        curl -L "$dl" | openssl aes-256-cbc  -md sha256 -d -out "$dest" -k $REDDCONOMY_DOWNLOAD_PASSWORD
    fi
}

export REDDCONOMY_VERSION="`getReddconomyVersion`"

function checkForReddconomyUpdate {
    new_version="`getReddconomyVersion`"
    echo "Installed version: $REDDCONOMY_VERSION"
    echo "Latest version: $new_version"
    if [ "$REDDCONOMY_VERSION" != "$new_version" ];
    then
        echo "~~ New version available ~~" 
        export REDDCONOMY_VERSION=$new_version
        echo "true"
    else
        echo "false"
    fi
}