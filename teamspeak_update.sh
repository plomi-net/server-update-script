
#!/bin/bash
#
#######################
# @github: https://github.com/plomi-net/server-update-script/teamspeak_update.sh
# @version: 1.0.0
#######################


#######################
# CONFIG              #
#######################

SERVER_OS=linux
SERVER_TYPE=amd64

CHOWN_USER=myuser
CHOWN_GROUP=myuser

SYSTEM_COMMAND=/etc/init.d/teamspeak3

#######################
# do not edit
#######################

# get latest version from teamspeak site
VERSION=$(curl -s https://www.teamspeak.com/en/downloads/#server | grep -o 'https://files.teamspeak-services.com/releases/server/.*/teamspeak3-server_linux_amd64-.*.tar.bz2' | head -n1 | cut -d "/" -f6)

if [ ! -f ts3.version ]; then
        echo "1" > ts3.version;
fi

INSTALLED_VERSION=$(cat ts3.version)

echo " "
echo "New Version is: $VERSION"
echo "Current Version is: $INSTALLED_VERSION"

if [ $VERSION == $INSTALLED_VERSION ]; then
        echo " "
        echo "TS is up to date"
        echo " "
        exit;
fi

LINK="https://files.teamspeak-services.com/releases/server/$VERSION/teamspeak3-server_"$SERVER_OS"_"$SERVER_TYPE"-"$VERSION".tar.bz2"
wget $LINK -O "latest.tar.bz2"
tar -xvf "latest.tar.bz2"
$SYSTEM_COMMAND stop
tar -jcvf teamspeak3-backup-$(date '+%Y-%m-%d').tar.bz2 teamspeak3
cp -aR "teamspeak3-server_"$SERVER_OS"_"$SERVER_TYPE/* teamspeak3
chown -R $CHOWN_USER:$CHOWN_GROUP teamspeak3
$SYSTEM_COMMAND start
rm -rf teamspeak3-server_linux_amd64
rm -rf latest.tar.bz2
echo $VERSION > ts3.version
echo "Update Done!"
