#!/bin/bash

if [ $# -ne 1 ]; then
	echo Syntax: $0 password
	exit 1
fi

PASSWORD=$1

# Generate bcrypt hash for password
cd /usr/src/node-red/node_modules/node-red
export PASSWORD_HASH=`node -e "console.log(require('bcryptjs').hashSync(process.argv[1], 8));" $PASSWORD | tr -d '\r'`

# Use Moustache to generate config file by replacing {{VAR}} with environment variables
cd /tmp
./mo nodered-settings.js.mo > /data/settings.js

# Copy sample flows file
cp /tmp/flows.json /data/flows.json
