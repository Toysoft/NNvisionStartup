#!/bin/bash

autossh -C -N -f -n -T -p $1 -R $2:$3:$4  $5@$6
