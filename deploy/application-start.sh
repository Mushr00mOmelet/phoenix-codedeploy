#!/bin/bash

# Check if nginx service is running
if pgrep nginx >/dev/null 2>&1
  then
    sudo service nginx stop
  else
    echo 'Service is not running yet... moving on'
fi

sudo start monica-app
