#!/bin/sh

$rel = lsb_release -r -s

if [ $rel -ge 17.04 ]
    apt-get update
    apt-get install linux-image-virtual linux-tools-virtual linux-cloud-tools-virtual
fi
