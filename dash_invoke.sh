#!/bin/bash
for i in `cat dash_inputs.txt`
do
/bin/sh dash_from_file.sh $i &
done
