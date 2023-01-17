#!/bin/bash

sudo su - ec2-user
echo "<h1>foo version ${version}</h1>" | tee index.html
nohup python3 -m http.server &
