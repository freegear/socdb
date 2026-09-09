#! /bin/sh
if [ -e work ]; then
	rm -fr work
fi
if [ -e transcript ]; then
	rm transcript
fi
if [ -e vsim.wlf ]; then
	rm vsim.wlf
fi
