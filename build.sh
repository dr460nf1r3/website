#!/bin/sh
yarn run lint
rm -r public
hugo 
rm .hugo_build.lock
