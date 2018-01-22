

# WIP

```
docker build  --compress=true -t reddconomy-sponge_test:amd64 --label amd64 --rm --force-rm=true .
```

```
docker run --name=reddconomy-sponge_test -d --restart=always \
-v /srv/reddconomy-sponge_test:/minecraft  -v /srv/reddconomy-sponge_test/docker-logs:/var/log/ \
-p 25565:25565 \
-eJAVA_ARGS='-Xmx1024M -Xms512M'  \
-eOP_UUID='YOUR_UUID' \
-eOP_NAME='YOUR_NAME' \
-eEULA=true \
-ePROPERTIES='
gamemode=0
motd=Reddconomy Test Server
online-mode=true
spawn-protection=40
' \
-eREDDCONOMY_CONFIG='
secretkey="changeme"
url="http://changeme:8099"
' \
reddconomy-sponge_test:amd64
```

```
docker run --name=reddconomy-sponge_test -it --rm \
-v /srv/reddconomy-sponge_test:/minecraft  -v /srv/reddconomy-sponge_test/docker-logs:/var/log/ \
-p 25565:25565 \
-eJAVA_ARGS='-Xmx1024M -Xms512M'  \
-eEULA=true \
-ePROPERTIES='gamemode=0
motd=Reddconomy Test Server
online-mode=true
spawn-protection=40
' \
-eREDDCONOMY_CONFIG='
secretkey="changeme"
url="http://changeme:8099"
' \
reddconomy-sponge_test:amd64
```