#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
    rm -fr work
fi
vlib work


RTL_PATH=../rtl
MOD_PATH=../model

# Etc
action vlog $RTL_PATH/Etc/ClockResetGen.v


