#!/bin/sh
pnpm run lint
rm -r public
hugo 
rm .hugo_build.lock
