#!/bin/sh

# create wallet
echo ${ANVO_PRV_KEY}

if [ -f "_user_password" ]
then
    echo "=====opening wallet====="
    cat _user_password | core-cli wallet unlock
else
    echo "=====creating wallet====="
    core-cli wallet create --file _user_password
    core-cli wallet open
    cat _user_password | core-cli wallet unlock
    # import private key generated
    echo ${ANVO_PRV_KEY} | core-cli wallet import
fi
exec "$@"
