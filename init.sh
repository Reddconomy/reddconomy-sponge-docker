#!/bin/bash
source /reddconomy_updater.sh
sleep 5

cd /minecraft

if [ "$SPONGE_URL" == "" ];
then
  export SPONGE_URL="https://repo.spongepowered.org/maven/org/spongepowered/spongevanilla/1.12.2-7.1.0-BETA-11/spongevanilla-1.12.2-7.1.0-BETA-11.jar"
  export SPONGE_HASH="7382fa594e7d95f75899a222ece5d45dcef1c44212c3a04bdc64ad2f6d77376e"
fi

function downloadAndVerify { # downloadAndVerify FILE DEST(unzip,path) HASH [PASSWORD]
    rm tmp_dl
    echo "Download $1"
    curl $1 -o tmp_dl
    
    hash="`sha256sum tmp_dl| cut -d ' ' -f 1`" 

    if [ "$hash" != "$3" ]; then 
        echo "$1: Integrity check failer. Hash does not match."; 
        exit 1 
    fi 

    if [ "$4" != "" ];
    then
        echo "Decrypt $1"
        rm  tmp_dl2
        openssl aes-256-cbc  -in tmp_dl -md sha256 -d -out tmp_dl2 -k $3
        rm tmp_dl
        mv tmp_dl2  tmp_dl
    fi

    if [ "$2" == "unzip" ];
    then 
      echo "Unzip $1"
      unzip -o  tmp_dl
      rm tmp_dl
    else
      parent="`dirname $2`"
      echo "Create $parent if missing"
      mkdir -p $parent
      echo "Save $1 in $parent"
      mv tmp_dl $2
    fi
}

function addOp { # uid name
  echo "
  {
    \"uuid\": \"$1\",
    \"name\": \"$2\",
    \"level\": 4,
    \"bypassesPlayerLimit\": true
  } " >> ops.json
}

# Download Sponge 
downloadAndVerify \
"$SPONGE_URL" \
"sponge.jar" \
"$SPONGE_HASH"

# Download reddconomy 
downloadReddconomy mods/Reddconomy-sponge.jar

if [ ! -f  ops.json -a "$OP_NAME" != "" -a "$OP_UUID" != "" ];
then
  echo '[' > ops.json
  addOp "$OP_UUID" "$OP_NAME"
  echo ']' >> ops.json
fi

if [ "$EULA" == "true" ];
then
  echo "eula=true" > eula.txt
fi

if [ "$PROPERTIES" != "" ];
then
  echo -e "$PROPERTIES" > server.properties
fi

if [ "$REDDCONOMY_CONFIG" != "" ];
then
  mkdir -p config
  echo -e "$REDDCONOMY_CONFIG" > config/reddconomy-sponge.conf
fi

# Start server
/opt/jdk/bin/java $JAVA_ARGS -jar sponge.jar