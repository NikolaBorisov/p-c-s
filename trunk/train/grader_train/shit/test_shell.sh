#!/bin/bash
ulimit -t $1
ulimit -v $2
#ulimit -v $2
#ulimit -f $3
#ulimit -s $4
exec slow.bin
