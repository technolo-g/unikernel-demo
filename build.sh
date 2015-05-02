#!/bin/bash
./rebar g-d clean compile
./railing image -x rel -l ssl -l inets -l mnesia
dd if=/dev/zero of=/tmp/fs.img bs=1024 count=102400

sudo xl create -c testn_autoprox
