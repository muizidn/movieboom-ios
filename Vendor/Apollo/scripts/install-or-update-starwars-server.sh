#!/bin/bash

cd $(dirname "$0")/../..

git -C starwars-server pull || git clone https://github.com/apollographql/starwars-server

cd starwars-server

npm install
npm prune
