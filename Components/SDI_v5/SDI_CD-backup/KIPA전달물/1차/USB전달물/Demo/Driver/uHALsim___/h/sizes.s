; Size defintions
; Copyright (C) ARM Limited 1998. All rights reserved.

 IF :LNOT: :DEF: __sizes_h
__sizes_h		EQU	1

; /* handy sizes */
SZ_1K                   EQU     0x00000400
SZ_4K                   EQU     0x00001000
SZ_8K                   EQU     0x00002000
SZ_16K                  EQU     0x00004000
SZ_64K                  EQU     0x00010000
SZ_128K                 EQU     0x00020000
SZ_256K                 EQU     0x00040000
SZ_512K                 EQU     0x00080000

SZ_1M                   EQU     0x00100000
SZ_2M                   EQU     0x00200000
SZ_4M                   EQU     0x00400000
SZ_8M                   EQU     0x00800000
SZ_16M                  EQU     0x01000000
SZ_30M					 EQU	 0x01e00000
SZ_32M                  EQU     0x02000000
SZ_64M                  EQU     0x04000000
SZ_128M                 EQU     0x08000000
SZ_256M                 EQU     0x10000000
SZ_512M                 EQU     0x20000000

SZ_1G                   EQU     0x40000000
SZ_2G                   EQU     0x80000000

 ENDIF

        END
