#!/bin/bash

sudo su - ec2-user
echo "foo version ${version}" | tee index.html
nohup python3 -m http.server &
