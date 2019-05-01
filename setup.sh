#!/bin/bash

cd ~/
touch test.test

apt-get update


apt-get install default-jdk -y

TOMCAT=apache-tomcat-9.0.1
TOMCAT_WEBAPPS=$TOMCAT/webapps
TOMCAT_CONFIG=$TOMCAT/conf/server.xml
TOMCAT_START=$TOMCAT/bin/startup.sh
TOMCAT_ARCHIVE=$TOMCAT.tar.gz
TOMCAT_URL=https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.1/bin/$TOMCAT_ARCHIVE
WAR_URL="https://doc-0s-38-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/v1kbs2vmr0qmf4esjil07c6763r5au8u/1556265600000/01929270806141810432/*/1jFVJdKr4Wyl3HECuDmJCxbNWxEVtngTL?e=download"
#https://filebin.net/k35qpk50uchvhjpw/url-shortener.war?t=51cs7m8e
WAR_FILE='url-shortener.war'

if [ ! -e $TOMCAT ]; then
    if [ ! -r $TOMCAT_ARCHIVE ]; then
    if [ -n "$(which curl)" ]; then
        curl -O $TOMCAT_URL
    elif [ -n "$(which wget)" ]; then
        wget $TOMCAT_URL
    fi
    fi

    if [ ! -r $TOMCAT_ARCHIVE ]; then
    echo "Tomcat could not be downloaded." 1>&2
    echo "Verify that eiter curl or wget is installed." 1>&2
    echo "If they are, check your internet connection and try again." 1>&2
    echo "You may also download $TOMCAT_ARCHIVE and place it in this folder." 1>&2
    exit 1
    fi

    tar -zxf $TOMCAT_ARCHIVE
    rm $TOMCAT_ARCHIVE
fi

if [ ! -w $TOMCAT -o ! -w $TOMCAT_WEBAPPS ]; then
    echo "$TOMCAT and $TOMCAT_WEBAPPS must be writable." 1>&2
    exit 1
fi

curl -o 'url-shortener.war' $WAR_URL

if [ ! -r $WAR_FILE ]; then
    echo "$WAR_FILE is missing. Download it and run this again to deploy it." 1>&2
else
    cp $WAR_FILE $TOMCAT_WEBAPPS
fi

# place tomcat customizations here
sed -i s/8080/9090/g $TOMCAT_CONFIG

$TOMCAT_START
