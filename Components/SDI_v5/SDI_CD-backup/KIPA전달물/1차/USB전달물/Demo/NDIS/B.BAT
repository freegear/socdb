set CL=/Zp2
del objchk\i386\gtxusb.bsc
build -ceZ
c:\util\q buildchk.err
copy .\objchk\i386\*.sys .
del c:\windows\inf\oem*.inf

