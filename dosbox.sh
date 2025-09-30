#!/bin/bash
nasm 1.asm -fbin -o 1.com
if [ $? == 0 ]; then
    dosbox-x -fastlaunch -c "mount c \"$PWD\"" -c "c:" -c "cls" -c "1.com" >>/dev/null 2>&1
fi

