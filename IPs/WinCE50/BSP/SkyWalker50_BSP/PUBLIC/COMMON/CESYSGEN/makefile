!if 0
Copyright (c) Microsoft Corporation.  All rights reserved.
!endif
!if 0
Use of this source code is subject to the terms of the Microsoft end-user
license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
If you did not accept the terms of the EULA, you are not authorized to use
this source code. For a copy of the EULA, please see the LICENSE.RTF on your
install media.
!endif

WINCEPROJ=common
#
# Include shared SYSGEN makefile
#
!INCLUDE $(_PUBLICROOT)\common\cesysgen\cesysgen.mak

!IFNDEF RES2RES
RES2RES=res2res
!ENDIF

!IFNDEF NK_COMPONENTS
NK_COMPONENTS=nkcompr nkmapfile
!ENDIF

!IFNDEF CORELIBC_COMPONENTS
CORELIBC_COMPONENTS=ccrtstrt
COREDLL_COMPONENTS=$(COREDLL_COMPONENTS) corecrt corestrw
!ENDIF

!IFNDEF FATFS_COMPONENTS
FATFS_COMPONENTS=fatmain fatui
!ENDIF

!IFNDEF DEVICE_COMPONENTS
DEVICE_COMPONENTS=devcore iorm nopmif
!ENDIF

# Temporary support to name the GPE components correctly
!IFNDEF GPE_COMPONENTS
GPE_COMPONENTS=$(GPE_MODULES)
!ENDIF

# The first (and possibly only) time the makefile is invoked,
# the xxx_LANGID variables will not be set.  This is used to
# create the default, 0409, versions of dll's and exe's that
# have resources.  Once this is done, the makefile will be
# re-invoked once for each locale in order to generate the
# other necessary locale resources.  (Search for _LANGIDLIST.)
# The dll's and exe's themselves are not regenerated.
# The resource switching for a specific
# locale does not happen until later when makeimg is used.
!IF "$(CURRENT_LANGID)" == ""
CURRENT_LANGID=0409
!ENDIF

!IF "$(OS_COMPONENT_DIR)" == ""
OS_COMPONENT_DIR=$(_PUBLICROOT)\$(_TGTPROJ)\oak\lib\$(_CPUINDPATH)
!ENDIF


preproc:makedirs 0409_base_resources corelibc fulllibc xlock coredll driverlibs $(CE_MODULES) includes files tokens nls tools

postproc:$(COPY_OS_MODULES) 0409_base_replace_resources $(REPLACE_MODULES) postlocalize



driverlibs:\
wrap2bpp wrap2dr wavemdd cardserv defbuslib pcc_com tch_cal ser_card ser_card2 com_mdd2 ser16550 serpddcm oo16550 ceosutil authhlp \
ddk_bus ddk_map ddk_io ddk_dma ddk_time ddk_power ohcdmdd2 hcdlib uhcdmdd hcd2lib ehcdmdd ntcompat bclib lci ldi loadauth mincrypt traverse cclib libc \
usbclient hidmdd i486oal \
sdcardlibbase sdhclib smclib \
LayoutManager NumPadRmp \
InputLang_0401 InputLang_040D InputLang_04TH0 InputLang_041E InputLang_0439 InputLang_044E InputLang_0446 InputLang_044A InputLang_0447 InputLang_044B InputLang_0449 \
InputLang_0409 InputLang_0411 InputLang_0412 KeybdIst PS2_8042_KbdCommon Nop_KbdCommon Nop_PddList \
kbdus_lib kbdjpn_lib kbdjpn1_lib kbdkor_lib \
HD465irda HD465_KbdCommon HD465ccuart HD465ohcdpdd HD465wavedev \
smc8xx_SCToVK ppc_lcd8xx \
scsi2dad rndismini2 \
rndismini nativemp bthguid tchmdd tch_trns tchbasic battdrvr_lib nleddrvr_lib kerbcomm \
SC2410_SDHCBase \
SMT926_SDHCBase \
pxa27x_sdhc \
smc8xx_SCToVK ppc_lcd8xx \
ufnmddbase ufnclientlibbase scsi2dad rndismini2 pxa25xusbfn_lib pxa25xufnlib \
aablt emul emulstub emulrotate ctblt ctbltstub rctblt drvalphablend drvalphablendstub drvgradfill drvgradfillstub rdrvgradfill gpe gperotate ddgpe dxdrvguid \
pm_mdd_lib pm_default_pdd_lib pm_pda_pdd_lib pmstubs_lib pm_pdd_common_lib \
wdmutil \
au1pcc_lib \
gwestubs \
atapi_common_lib atapi_pcio_lib atapi_pcio_cd_lib atapi_pcip_pdc20262_lib atapi_pcmcia_lib

tools:kd hd osaxst0 osaxst1 dbg ethdbg kitl kitleth ne2kdbg rtl8139dbg dp83815dbg dec21140dbg am79c970dbg am79c973dbg cs8900dbg vbridge vbridgestub smc9000 smsc100 smsc91c net2890lib net2890klib rne_mdd 3c90xdbg eboot blcommon bootpart memtool nkprof celog caplog shimeng kcover PCIreg cecap \
fal ecclib sdnpcik stratak faslk xllp

rt_tests: iltiming osbench celogflush oscapture coversrv

# Empty rule to allow components target in sysgen
keybd pointer nled stansdk:

clean:
        @echo Cleaning up sysgen directories
        -@del $(DELRECURSEFLAG) $(DELFLAGS) $(SG_OUTPUT_SDKLIB)\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELRECURSEFLAG) $(DELFLAGS) $(SG_OUTPUT_OAKLIB)\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELRECURSEFLAG) $(DELFLAGS) $(SG_OUTPUT_OAKTGT)\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELFLAGS) $(SG_OUTPUT_ROOT)\sdk\inc\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELFLAGS) $(SG_OUTPUT_ROOT)\oak\inc\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELFLAGS) $(SG_OUTPUT_ROOT)\ddk\inc\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELFLAGS) $(SG_OUTPUT_ROOT)\oak\java\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELFLAGS) $(SG_OUTPUT_ROOT)\oak\files\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELFLAGS) $(SG_OUTPUT_ROOT)\oak\tokens\jpn\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELFLAGS) $(SG_OUTPUT_ROOT)\oak\tokens\ger\*.* > nul $(SG_XCOPYREDIRECT)
        -@del $(DELFLAGS) $(SG_OUTPUT_ROOT)\oak\tokens\*.* > nul $(SG_XCOPYREDIRECT)

makedirs:
        @echo Creating appropriate directories and deleting COMMON.LOC
        -@del $(DELFLAGS) $(SG_OUTPUT_OAKTGT)\*.loc > nul $(SG_XCOPYREDIRECT)
        -@xcopy /T /I *.* $(SG_OUTPUT_SDKLIB)
        -@xcopy /T /I *.* $(SG_OUTPUT_OAKLIB)
        -@xcopy /T /I *.* $(SG_OUTPUT_OAKTGT)
        -@xcopy /T /I *.* $(SG_OUTPUT_ROOT)\sdk\inc
        -@xcopy /T /I *.* $(SG_OUTPUT_ROOT)\oak\inc
        -@xcopy /T /I *.* $(SG_OUTPUT_ROOT)\ddk\inc
        -@xcopy /T /I *.* $(SG_OUTPUT_ROOT)\oak\java
        -@xcopy /T /I *.* $(SG_OUTPUT_ROOT)\oak\files
        -@xcopy /T /I *.* $(SG_OUTPUT_ROOT)\oak\tokens
        -@xcopy /T /I *.* $(SG_OUTPUT_ROOT)\ddk\lib\$(_CPUINDPATH)
        -@mkdir $(SG_OUTPUT_OAKTGT)\0409 > nul $(SG_XCOPYREDIRECT)


# At END of SYSGEN we recurse for each language in _LANGIDLIST to build
# the combined RESs for GWES & COREDLL once for each language.
# See comments below near GWES & COREDLL resp.
!IF "$(_LANGIDLIST)" != ""
$(_LANGIDLIST)::
    @set CURRENT_LANGID=$@
    $(MAKE) /NOLOGO coredll
!IF "$(GWES_COMPONENTS)" != ""
    $(MAKE) /NOLOGO gwes
!ENDIF
!IF EXIST($(SG_OUTPUT_SDKLIB)\commctrl.lib)
    $(MAKE) /NOLOGO commctrl
!ENDIF

# !IF "$(WINCEREL)" == "1"
#       -@echo WINCEREL set--Copying GWES/COREDLL resources from $(SG_OUTPUT_OAKTGT)\$@ to $(_FLATRELEASEDIR)\$@
#       -@xcopy /I $(SG_OUTPUT_OAKTGT)\$@\gwes.res $(_FLATRELEASEDIR)\$@ > nul
#       -@xcopy /I $(SG_OUTPUT_OAKTGT)\$@\coredll.res $(_FLATRELEASEDIR)\$@ > nul
# !ENDIF
!ENDIF

#
# These are parts of the sysgen process not associated with any modules. They are
# always run.

includes:
        @echo Processing include files
        $(SG_TOKENFILTER) $(SG_INPUT_ROOT)\sdk\inc\*.* $(SG_OUTPUT_ROOT)\sdk\inc
        $(SG_TOKENFILTER) $(SG_INPUT_ROOT)\oak\inc\*.* $(SG_OUTPUT_ROOT)\oak\inc
        $(SG_TOKENFILTER) $(SG_INPUT_ROOT)\ddk\inc\*.* $(SG_OUTPUT_ROOT)\ddk\inc
        copy $(SG_OUTPUT_ROOT)\sdk\inc\ceconfig.h $(SG_OUTPUT_ROOT)\oak\files\ceconfig.h


fonts:

files:
        -@xcopy /D /I $(SG_INPUT_ROOT)\oak\files\*.lex $(SG_OUTPUT_ROOT)\oak\files
        -@xcopy /D /I $(SG_INPUT_ROOT)\oak\files\*.2bp $(SG_OUTPUT_ROOT)\oak\files
        -@xcopy /D /I $(SG_INPUT_ROOT)\oak\files\*.bmp $(SG_OUTPUT_ROOT)\oak\files
        -@xcopy /D /I $(SG_INPUT_ROOT)\oak\files\*.wav $(SG_OUTPUT_ROOT)\oak\files
        -@xcopy /D /I $(SG_INPUT_ROOT)\oak\files\*.p7b $(SG_OUTPUT_ROOT)\oak\files
        $(SG_TOKENFILTER) $(SG_INPUT_ROOT)\oak\files\common.* $(SG_OUTPUT_ROOT)\oak\files

tokens:
        -@xcopy /i /e /q /c /D $(SG_INPUT_ROOT)\oak\tokens $(SG_OUTPUT_ROOT)\oak\tokens
        -@xcopy /i /e /q /c /D $(SG_INPUT_ROOT)\oak\files\intltrns $(SG_OUTPUT_ROOT)\oak\files\intltrns

remove:

crt_cpp_eh_and_rtti:

NLSSRC=$(SG_INPUT_ROOT)\oak\files\

$(SG_OUTPUT_ROOT)\oak\files\nlssrc.txt: \
        $(NLSSRC)\codepage.txt $(NLSSRC)\unicode.txt         \
        $(NLSSRC)\ctype.txt $(NLSSRC)\unisort.txt $(NLSSRC)\l_intl.txt
        -@copy $(NLSSRC)\codepage.txt+$(NLSSRC)\unicode.txt+$(NLSSRC)\ctype.txt+$(NLSSRC)\unisort.txt+$(NLSSRC)\l_intl.txt $(SG_OUTPUT_ROOT)\oak\files\nlssrc.txt /B

nlscopy: \
        $(NLSSRC)\437.txt $(NLSSRC)\708.txt $(NLSSRC)\720.txt $(NLSSRC)\737.txt $(NLSSRC)\775.txt  \
        $(NLSSRC)\850.txt $(NLSSRC)\852.txt $(NLSSRC)\855.txt $(NLSSRC)\857.txt $(NLSSRC)\860.txt  \
        $(NLSSRC)\861.txt $(NLSSRC)\862.txt $(NLSSRC)\863.txt $(NLSSRC)\864.txt $(NLSSRC)\865.txt  \
        $(NLSSRC)\866.txt $(NLSSRC)\869.txt $(NLSSRC)\874.txt $(NLSSRC)\932.txt $(NLSSRC)\936.txt  \
        $(NLSSRC)\949.txt $(NLSSRC)\950.txt $(NLSSRC)\1250.txt $(NLSSRC)\858.txt \
        $(NLSSRC)\20000.txt $(NLSSRC)\20001.txt $(NLSSRC)\20002.txt $(NLSSRC)\20003.txt $(NLSSRC)\20004.txt $(NLSSRC)\20005.txt \
        $(NLSSRC)\20127.txt $(NLSSRC)\20261.txt $(NLSSRC)\20866.txt $(NLSSRC)\21027.txt $(NLSSRC)\21866.txt $(NLSSRC)\29001.txt \
        $(NLSSRC)\20269.txt $(NLSSRC)\28591.txt $(NLSSRC)\28592.txt $(NLSSRC)\28593.txt $(NLSSRC)\28594.txt $(NLSSRC)\28595.txt \
        $(NLSSRC)\28596.txt $(NLSSRC)\28597.txt $(NLSSRC)\28598.txt $(NLSSRC)\28599.txt $(NLSSRC)\28603.txt $(NLSSRC)\28605.txt \
        $(NLSSRC)\1251.txt $(NLSSRC)\1252.txt $(NLSSRC)\1253.txt                  \
        $(NLSSRC)\1254.txt $(NLSSRC)\1255.txt $(NLSSRC)\1256.txt                  \
        $(NLSSRC)\1257.txt $(NLSSRC)\1258.txt $(NLSSRC)\1361.txt                  \
        $(NLSSRC)\big5.txt $(NLSSRC)\ksc.txt $(NLSSRC)\prc.txt $(NLSSRC)\prcp.txt \
        $(NLSSRC)\xjis.txt $(NLSSRC)\bopomofo.txt $(NLSSRC)\nlscfg.inf $(NLSSRC)\locale.txt
        !xcopy /I /D /Q $? $(SG_OUTPUT_ROOT)\oak\files

nlsextra:

nls:$(SG_OUTPUT_ROOT)\oak\files\nlssrc.txt nlscopy nlsextra


!IF "$(COPY_OS_MODULES)" != ""
$(COPY_OS_MODULES):
    @echo copying $*_$(_TGTPROJ) to $*
    @copy $(OS_COMPONENT_DIR)\$*_$(_TGTPROJ).lib $(OS_COMPONENT_DIR)\$*.lib
    @copy $(OS_COMPONENT_DIR)\$*_$(_TGTPROJ).pdb $(OS_COMPONENT_DIR)\$*.pdb
    -@copy $(OS_COMPONENT_DIR)\$*_$(_TGTPROJ).res $(OS_COMPONENT_DIR)\$*.res
!ENDIF




#
# This part has the "sources" files for every componentized module. This part lists every
# component which is part of a module. There are some default rules to build actual dll/exes
# using a two phase link process so that you avoid picking imports from stub libraries
#
# GWES link modifications for Localization: We localize the individual GWES resources, not the
# combined resource file. This is because doing the latter is incompatible with component
# replacement, and is also harder for the loc folks.
#
# So the component selection & RES2RES step to build the big RES file has to happen once
# for EACH language. We first build the straight US RES & LIB, and then recurse for each language
#

gwe1 gwe2 gwe3 gwe4::
    @echo GWE1 - $(GWE1_COMPONENTS)
    @echo GWE2 - $(GWE2_COMPONENTS)
    @echo GWE3 - $(GWE3_COMPONENTS)
    @echo GWE4 - $(GWE4_COMPONENTS)
    @set SOURCELIBS=

gwe1::$(GWE1_COMPONENTS)
gwe2::$(GWE2_COMPONENTS)
gwe3::$(GWE3_COMPONENTS)
gwe4::$(GWE4_COMPONENTS)

gwe1 gwe2 gwe3 gwe4::
    @set TARGETNAME=$@
    @set RELEASETYPE=OAK
    @set TARGETLIBS=
    @set TARGETTYPE=LIBRARY
    $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKLIB)\$@.lib
    @set GWELIBS=%%GWELIBS%% $(SG_OUTPUT_OAKLIB)\$@.lib


# OEM can specify where to place their replaced components
!IF "$(REPLACE_ROOT)" == ""
REPLACE_ROOT=$(_PROJECTROOT)
!ENDIF

!IF "$(GWES_REPLACE)" != ""
$(GWES_REPLACE):
    @set GWELIBS=%%GWELIBS%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
!IF EXIST($(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$(CURRENT_LANGID)\*.res)
    @set GWES_RESOURCES=%%GWES_RESOURCES%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$(CURRENT_LANGID)\$@.res
!ELSE
!MESSAGE public\common\cesysgen\makefile: Warning: No replace resources found for $(CURRENT_LANGID).  Using 0409 instead.
    @set GWES_RESOURCES=%%GWES_RESOURCES%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\0409\$@.res
!ENDIF
    @set GWES_TARGET_RESOURCE=$(SG_OUTPUT_OAKTGT)\$(CURRENT_LANGID)\gwes.res
!ENDIF


!IF "$(GWES_REPLACE_COMPONENTS)" != ""
$(GWES_REPLACE_COMPONENTS):
        @set GWELIBS=%%GWELIBS%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
!ENDIF

calibrui oomui menu startui msgbox_hpc msgbox_ppc gcacheview gcacheviewxp:
    @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
    @set GWES_RESOURCES=%%GWES_RESOURCES%% $(SG_INPUT_LIB)\$(CURRENT_LANGID)\$@.res
	@set GWES_TARGET_RESOURCE=$(SG_OUTPUT_OAKTGT)\$(CURRENT_LANGID)\gwes.res

startui_w_lass:
    @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
    @set GWES_RESOURCES=%%GWES_RESOURCES%% $(SG_INPUT_LIB)\$(CURRENT_LANGID)\startui.res
    @set GWES_TARGET_RESOURCE=$(SG_OUTPUT_OAKTGT)\$(CURRENT_LANGID)\gwes.res

cursor2 cursor8 mcursor1:
    @set GWES_RESOURCES=%%GWES_RESOURCES%% $(SG_INPUT_LIB)\$(CURRENT_LANGID)\$@.res
	@set GWES_TARGET_RESOURCE=$(SG_OUTPUT_OAKTGT)\$(CURRENT_LANGID)\gwes.res

# Backward compatibility rule
mcursor8: mcursor1

# These are arranged in order of dependencies
ceptr pixeldouble wmbase immthunk gwesmain msgque gsetwinlong \
uibase accessib kbdui journal hotkey foregnd idle getpower msgbeep audio \
mgalphablend mgalphablendstub mgbase mgblt mgblt2 mgbitmap mgdc mgdibsec mgdraw mggradfill mggradfillstub mgpalmin mgrgn mgwinmgr mgrast mgrast2 decompdrv mgtt \
mgfntfix mgpal mgprint mgdrwtxt mgpalnat mgdx mgtci mgfe mgalias \
tchui iconcmn icon iconcurs \
atom winmgr defwndproc gcache nclientview nclientviewxp nclient sbcmnview sbcmnviewxp \
sbcmn syscolor loadimg loadbmp caret accel clipbd timer  \
gwectrl btnctl_tpc btnctlview btnctlviewxp btnctl cmbctlview cmbctlviewxp cmbctl imectl \
edctl EditControlOs EditControlPpc EditControlTpc edimefe EdImeFeTpc imgctl lbctlview lbctlviewxp lbctl_ppc lbctl_tpc lbctl scbctl stcctlview \
stcctlviewxp stcctl cursor mcursor \
MouseCursorOnly TouchCursorOnly MouseAndTouchCursor msgbox msgbox_tpc column menu_hpc menu_ppc menu_tpc menuscrl menubc drawmbar mOverlap mNoOver mTapUI mNoTapUI cascade \
oom startup dlgmgr_hpc dlgmgr_ppc dlgmgr_tpc dlgmgr dlgmnem gweshare d3dmhook:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib


# Get ready to link GWES.  First clear the library and resource lists.
# Need to do some extra work for gwe resources.  Some configs have gwe
# components but no gwe resources.  GWES_RESOURCES is set to dummy, which
# is ignored by res2res.  In addition, GWES_TARGET_RESOURCE is set only
# when a resource is used.  It is used in the final link of gwes.exe.
# If no resources have been selected, it will be empty, so there won't
# be any link error.
gwes::
    @set GWELIBS=
    @set GWES_RESOURCES=dummy
    set GWES_TARGET_RESOURCE=

# To build gwes.exe, we build up the replacements first followed by the
# regular components and then build the full gwes static library.
# Next, the library will be linked into an exe.
gwes::$(GWES_REPLACE) $(GWES_REPLACE_COMPONENTS) $(GWES_COMPONENTS) lib_gwes
	@echo GWES_REPLACE: $(GWES_REPLACE)
	@echo GWES_REPLACE_COMPONENTS: $(GWES_REPLACE_COMPONENTS)
	@echo GWES_COMPONENTS: $(GWES_COMPONENTS)
	@echo GWES_RESOURCES: %GWES_RESOURCES%
	@echo GWES_TARGET_RESOURCE: %GWES_TARGET_RESOURCE%

# Set up the "sources file" environment variables for the link operation.
# The lib was built earlier.  We build the lib and exe in two steps so that
# we can make sure that the stubs are added last.  Base resources are copied
# into an 0409 subdirectory so that creating the resource file can be done consistently.
gwes:: 0409_base_resources gwestubs
# Always create the resources for the given locale.
    $(RES2RES) %%GWES_RESOURCES%% -fo $(SG_OUTPUT_OAKTGT)\$(CURRENT_LANGID)\gwes.res
# Only need to relink for 0409 locale.
!IF "$(CURRENT_LANGID)" == "0409"
    @set TARGETTYPE=PROGRAM
    @set TARGETNAME=$@
    @set RELEASETYPE=OAK
    @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_OUTPUT_OAKLIB)\gwes.lib $(SG_OUTPUT_SDKLIB)\gwestubs.lib %GWES_TARGET_RESOURCE%
    @set SOURCELIBS=
    @set EXEENTRY=WinMain
    $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\gwes.exe
!ENDIF

# Concatenate the modules in GWELIBS into gwes.lib.  This will avoid possible
# linker complaints about duplicate symbols in gwestubs.lib.  This only needs to
# be done once when we are creating the executable.
lib_gwes: ceosutil
!IF "$(CURRENT_LANGID)" == "0409"
    @set TARGETTYPE=LIBRARY
    @set TARGETNAME=gwes
    @set RELEASETYPE=OAK
    @set TARGETLIBS=
    @set SOURCELIBS=%%GWELIBS%% $(SG_OUTPUT_SDKLIB)\ceosutil.lib
    @set SOURCEPDBS=$(SG_INPUT_LIB)\mgdi.pdb
    @echo Creating gwes.lib
    $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKLIB)\gwes.lib
!ENDIF

filesys::
        @set SOURCELIBS=
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib $(SG_INPUT_LIB)\fsstubs.lib $(SG_INPUT_LIB)\fsdnot.lib $(SG_INPUT_LIB)\lockmgr.lib $(SG_INPUT_LIB)\$@.res

!IF "$(FILESYS_COMPONENTS)" != ""
$(FILESYS_COMPONENTS)::$(FILESYS_REPLACE_COMPONENTS)
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
!ENDIF

!IF "$(FILESYS_REPLACE_COMPONENTS)" != ""
$(FILESYS_REPLACE_COMPONENTS)::
	@set SOURCELIBS=%%SOURCELIBS%% $(_PROJECTROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
!ENDIF

filesys::$(FILESYS_COMPONENTS) $(FILESYS_REPLACE_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set EXEENTRY=WinMain
        $(MAKECMD) /NOLOGO $@.exe


!IF "$(PM_COMPONENTS)" != ""
pm:: pm_mdd_lib pm_default_pdd_lib pm_pda_pdd_lib pmstubs_lib pm_pdd_common_lib

pm::
        @set SOURCELIBS=
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib

pm_mdd pm_default_pdd pm_pda_pdd pmstubs pm_pdd_common:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@_lib.lib

pm:: $(PM_COMPONENTS)
        @set RELEASETYPE=OAK
        @set TARGETTYPE=DYNLINK
        @set DLLENTRY=DllEntry
        @set DEFFILE=$(_COMMONOAKROOT)\inc\$@.def
        @set TARGETNAME=$@
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll

!ELSE   #  "$(PM_COMPONENTS)" != ""

pm::

!ENDIF #  "$(PM_COMPONENTS)" != ""

devmgr::
        @set SOURCELIBS=
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib

devmgr:: $(DEVICE_COMPONENTS)
        @set RELEASETYPE=OAK
        @set TARGETTYPE=DYNLINK
        @set DLLENTRY=DllMain
        @set DEFFILE=$(_COMMONOAKROOT)\inc\$@.def
        @set TARGETNAME=$@
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll

pmif::
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_OUTPUT_OAKLIB)\pm.lib

pmif nopmif devcore iorm::
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib

device:: pm devmgr
        @set SOURCELIBS=$(SG_INPUT_LIB)\devmain.lib
        @set TARGETLIBS=$(SG_OUTPUT_OAKLIB)\devmgr.lib $(SG_OUTPUT_SDKLIB)\coredll.lib
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set EXEENTRY=WinMain
        $(MAKECMD) /NOLOGO $@.exe

!IFNDEF FSDMGR_COMPONENTS
FSDMGR_COMPONENTS=fsdmain fsdserv storemgr fsdnot lockmgr
!ENDIF

fsdmgr::
        @set SOURCELIBS=
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib
fsdmgr::$(FSDMGR_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set DLLENTRY=DllMain
        @set DEFFILE=$(SG_INPUT_LIB)\$@.def
        $(MAKECMD) /NOLOGO $@.dll
storemgr:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
        -@xcopy /D /I $(SG_INPUT_LIB)\storeapi.lib $(SG_OUTPUT_OAKLIB)
fsdmain:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
fsdserv:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
fsdnot:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
lockmgr::
	@set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib

coredll::
    @set SOURCELIBS=
    @set COREDLL_RESOURCES=$(SG_INPUT_LIB)\$(CURRENT_LANGID)\coreres.res

coredll::$(COREDLL_REPLACE) $(COREDLL_REPLACE_COMPONENTS) $(COREDLL_MESSAGEDIALOGBOXCUSTOMIZE_COMPONENT) $(COREDLL_COMPONENTS) 0409_base_resources
	@echo COREDLL_RESOURCES=%COREDLL_RESOURCES%
    $(RES2RES) %%COREDLL_RESOURCES%% -fo $(SG_OUTPUT_OAKTGT)\$(CURRENT_LANGID)\$@.res
!IF "$(CURRENT_LANGID)" == "0409"
        @set TARGETNAME=$@
        @set RELEASETYPE=SDK
        @set SOURCEPDBS=$(SG_INPUT_LIB)\mgdi.pdb
        @set DLLENTRY=CoreDllInit
        @set TARGETLIBS=$(SG_INPUT_LIB)\corestub.lib $(SG_OUTPUT_OAKTGT)\0409\$@.res
        $(MAKECMD) /NOLOGO $@.dll
!ENDIF

# COREDLL_REPLACE needs to come *before* the explict rules for coredll components. That way the
# first rule (i.e. this one) will get used when we are replacing.
#
# If we are doing coredll component replacement or have the Message/Dialog Box component,
# then coredll is being built for a 2nd time during
# postproc. However during preproc the coredll_all.lib was already built. We now need to force it
# to be rebuilt. We do this by deleting it. Ugh.

# Component and resource files.
!IF "$(COREDLL_REPLACE)" != ""
$(COREDLL_REPLACE):
        -@del $(DELFLAGS) $(SG_OUTPUT_OAKLIB)\coredll_ALL.lib > nul $(SG_XCOPYREDIRECT)
        @set SOURCELIBS=%%SOURCELIBS%% $(_PROJECTROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
        @set COREDLL_RESOURCES=%%COREDLL_RESOURCES%% $(_PROJECTROOT)\oak\lib\$(_CPUINDPATH)\$(CURRENT_LANGID)\$@.res
!ENDIF

# Component only, no resource files.
!IF "$(COREDLL_REPLACE_COMPONENTS)" != ""
$(COREDLL_REPLACE_COMPONENTS):
        -@del $(DELFLAGS) $(SG_OUTPUT_OAKLIB)\coredll_ALL.lib > nul $(SG_XCOPYREDIRECT)
        @set SOURCELIBS=%%SOURCELIBS%% $(_PROJECTROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
!ENDIF

# Message/Dialog Box component.
!IF "$(COREDLL_MESSAGEDIALOGBOXCUSTOMIZE_COMPONENT)" != ""
$(COREDLL_MESSAGEDIALOGBOXCUSTOMIZE_COMPONENT):
        -@del $(DELFLAGS) $(SG_OUTPUT_OAKLIB)\coredll_ALL.lib > nul $(SG_XCOPYREDIRECT)
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
!ENDIF

## The components of COREDLL ##
coremain locusa lmem showerr thunks fiber acl serdev devload rectapi wmgr_c accel_c tapilib \
mmacm mmacmui mmwave mmsnd mmmix fmtmsg rsa32  mgdi_c fpemul corecrt coreimm coreimmstub \
coregwestub coresip asyncio multiui messagedialogboxthunk devmgmt fileinfo fileopen battery dsa \
tnotify snotify:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib

cryptapi:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib $(SG_INPUT_LIB)\mincrypt_coredll.lib

## Filter only components of COREDLL, these filter in/out features from coredll.def
full_crt nostrsafe muireg secloader crypthash:

## Mini version of locale support.  Uses LocUSA but restricts the API's supported
locmini:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\locusa.lib

# These components have RES files that go with them
shexec shcore shortcut shmisc coreloc:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
        @set COREDLL_RESOURCES=%%COREDLL_RESOURCES%% $(SG_INPUT_LIB)\$(CURRENT_LANGID)\$@.res
# These components have ONLY RES files
fmtres timezones:
        @set COREDLL_RESOURCES=%%COREDLL_RESOURCES%% $(SG_INPUT_LIB)\$(CURRENT_LANGID)\$@.res

# These components are used for filtering in sysgen. They aren't real libs ...
shellapis corestra corestrw coresioa coresiow:


corelibc::
        @set SOURCELIBS=
		@xcopy /I $(SG_INPUT_LIB)\ccrt*.pdb $(SG_OUTPUT_OAKLIB)
		@xcopy /I $(SG_INPUT_LIB)\strsafea.pdb $(SG_OUTPUT_OAKLIB)
corelibc::$(CORELIBC_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=SDK
        @set TARGETLIBS=
        @set SOURCEPDBS=
        @set TARGETTYPE=LIBRARY
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_SDKLIB)\$@.lib
ccrtstrt:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib

ws2::
        @set SOURCELIBS=$(SG_INPUT_LIB)\ws2.lib
ws2::$(WS2_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=SDK
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib
        @set DLLENTRY=dllentry
        $(MAKECMD) /NOLOGO $@.dll

winsock::ws2
        @set SOURCELIBS=$(SG_INPUT_LIB)\winsock.lib $(SG_OUTPUT_SDKLIB)\ws2.lib
winsock::$(WINSOCK_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=SDK
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib
        @set DLLENTRY=dllentry
        $(MAKECMD) /NOLOGO $@.dll
sslsock:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib

crypt32:: msasn1
        @set SOURCELIBS=$(SG_INPUT_LIB)\$@.lib  $(SG_INPUT_LIB)\pkiutil.lib $(SG_INPUT_LIB)\certstor.lib $(SG_INPUT_LIB)\chain.lib
crypt32:: $(CRYPT32_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=SDK
        @set TARGETLIBS=$(SG_INPUT_LIB)\$@.res  $(SG_INPUT_LIB)\mincrypt.lib $(SG_OUTPUT_OAKLIB)\msasn1.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib
        @set DLLENTRY=DllEntry
        $(MAKECMD) /NOLOGO $@.dll	
wincrmsg:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
pfx:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
	
cxport::
        @set SOURCELIBS=$(SG_INPUT_LIB)\cxport.lib
cxport::$(CXPORT_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=SDK
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib
        @set DLLENTRY=_DllMainCRTStartup
        $(MAKECMD) /NOLOGO $@.dll

dubftp:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib

audevman:
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib
        @set DLLENTRY=DllMain
        @set SOURCELIBS=$(SG_INPUT_LIB)\audevman.lib $(SG_INPUT_LIB)\swmixer.lib
        @set TARGETTYPE=DYNLINK
        @set DEFFILE=$(SG_INPUT_LIB)\$@.def
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll

## The possible components of WaveAPI ##
wapiwave wapiacm wapiacmui wapimap:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib

waveapi:: audevman
waveapi::
        @set SOURCELIBS=
        -@del $(DELFLAGS) $(SG_OUTPUT_OAKLIB)\$@_ALL.lib > nul $(SG_XCOPYREDIRECT)

waveapi:: $(WAVEAPI_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set DLLENTRY=WaveApiDllEntry
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_OUTPUT_OAKLIB)\audevman.lib
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_INPUT_LIB)\wapistub.lib
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\waveui.lib
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_INPUT_LIB)\0409\waveapi.res
        @set TARGETTYPE=DYNLINK
        @set DEFFILE=$(SG_INPUT_LIB)\$@.def
        $(MAKECMD) /NOLOGO $@.dll

#
# Notification subsystem
#
!IF "$(NOTIFY_REPLACE)" != ""
$(NOTIFY_REPLACE):
        @set NOTIFYLIBS=%%NOTIFYLIBS%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
        @set NOTIFY_RESOURCES=%%NOTIFY_RESOURCES%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$(CURRENT_LANGID)\$@.res
!ENDIF

!IF "$(NOTIFY_REPLACE_COMPONENTS)" != ""
$(NOTIFY_REPLACE_COMPONENTS):
        @set NOTIFYLIBS=%%NOTIFYLIBS%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
!ENDIF

notify::
        @set NOTIFYLIBS=
        @set NOTIFY_RESOURCES=

notify::$(NOTIFY_COMPONENTS) $(NOTIFY_REPLACE) $(NOTIFY_REPLACE_COMPONENTS)

notify::
        @set TARGETNAME=$@
        @set RELEASETYPE=SDK
        @set SOURCELIBS=$(SG_INPUT_LIB)\notify.lib %%NOTIFYLIBS%%
        @set TARGETLIBS=%%NOTIFY_RESOURCES%% $(SG_OUTPUT_SDKLIB)\ceosutil.lib $(SG_OUTPUT_SDKLIB)\coredll.lib
        @set DLLENTRY=DllEntry
        @echo SOURCELIBS=%%SOURCELIBS%%
        @echo TARGETLIBS=%%TARGETLIBS%%
        $(MAKECMD) /NOLOGO $@.dll
notifpub:
        @set NOTIFYLIBS=%%NOTIFYLIBS%% $(SG_INPUT_LIB)\notifpub.lib
        @set NOTIFY_RESOURCES=%%NOTIFY_RESOURCES%% $(SG_INPUT_LIB)\notifpub.res
notifmin:
        @set NOTIFYLIBS=%%NOTIFYLIBS%% $(SG_INPUT_LIB)\notifmin.lib
notifui:
        @set NOTIFYLIBS=%%NOTIFYLIBS%% $(SG_INPUT_LIB)\notifui.lib
notifnoui:
        @set NOTIFYLIBS=%%NOTIFYLIBS%% $(SG_INPUT_LIB)\notifnoui.lib

#
# End of Notification subsystem
#

#
# Bluetooth
#
btd::ceosutil bthguid $(BTD_DRIVERS)
        @set SOURCELIBS=
        @set TARGETLIBS=
btd::$(BTD_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=SDK
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_INPUT_LIB)\cclib.lib $(SG_OUTPUT_SDKLIB)\ceosutil.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_OUTPUT_SDKLIB)\bthguid.lib $(SG_INPUT_LIB)\btstubs.lib
        @set DLLENTRY=_DllMainCRTStartup
        $(MAKECMD) /NOLOGO $@.dll
hci:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\bthci.lib
l2cap:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\l2cap.lib
sdp:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\sdpbase.lib $(SG_INPUT_LIB)\sdpparse.lib
rfcomm:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\rfcomm.lib
portemu:
        @set SOURCELIBS=%%SOURCELIBS%%
tdi:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\bttdi.lib
btpan:
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_OUTPUT_SDKLIB)\ndis.lib
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\btpan.lib
sys:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\btsysd.lib
uart:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\bthuart.lib
amb:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\bthamb.lib
sc:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\bthsc.lib
csr:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\bcsp.lib
usb:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_OUTPUT_OAKLIB)\bthusb.lib
sdio:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_OUTPUT_OAKLIB)\bthsdio.lib
univ:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_OUTPUT_OAKLIB)\bthuniv.lib

# Bluetooth Audio Gateway
!IF "$(BTAGSVC_REPLACE_COMPONENTS)" != ""
$(BTAGSVC_REPLACE_COMPONENTS):
        @set BTAGSVCLIBS=%%BTAGSVCLIBS%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
!ENDIF

!IF "$(BTAGSVC_COMPONENTS)" != ""
$(BTAGSVC_COMPONENTS):
        @set BTAGSVCLIBS=%%BTAGSVCLIBS%% $(SG_INPUT_LIB)\$@.lib
!ENDIF

btagsvc::btdrt ws2
        @set BTAGSVCLIBS=
btagsvc::$(BTAGSVC_COMPONENTS) $(BTAGSVC_REPLACE_COMPONENTS)
        @set TARGETTYPE=DYNLINK
        @set TARGETNAME=$@
        @set DEFFILE=$(SG_OUTPUT_OAKLIB)\$@.def
        @set RELEASETYPE=OAK
        @set SOURCELIBS=$(SG_INPUT_LIB)\$@.lib %%BTAGSVCLIBS%%
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_OUTPUT_OAKLIB)\btdrt.lib $(SG_OUTPUT_SDKLIB)\ceosutil.lib $(SG_OUTPUT_SDKLIB)\ws2.lib
        @set DLLENTRY=_DllMainCRTStartup
        @echo SOURCELIBS=%%SOURCELIBS%%
        @echo TARGETLIBS=%%TARGETLIBS%%
        $(MAKECMD) /NOLOGO $@.dll


tchmdd::
        @set TARGETTYPE=LIBRARY
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set TARGETLIBS=
!IFDEF SYSGEN_TRANSCRIBER
        @set SOURCELIBS=$(SG_INPUT_LIB)\tchmain.lib $(SG_INPUT_LIB)\tch_trns.lib
        echo touch includes transcriber hooks
!ELSE
        @set SOURCELIBS=$(SG_INPUT_LIB)\tchmain.lib $(SG_INPUT_LIB)\tchbasic.lib
        echo touch is minimal
!ENDIF
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKLIB)\$@.lib

#
#
# These are all the modules which are not componentized at all. They are simply copied over
# as part of the sysgen process
#

nkcompr nknocomp nkmapfile nknomapfile::
        set NKLIBS=%%NKLIBS%% $(SG_INPUT_LIB)\$@.lib

# OEM can specify where to place their replaced components
!IF "$(NK_REPLACE_ROOT)" == ""
NK_REPLACE_ROOT=$(_PROJECTROOT)
!ENDIF

!IF "$(NK_REPLACE_COMPONENTS)" != ""
$(NK_REPLACE_COMPONENTS)::
        set NKLIBS=%%NKLIBS%% $(NK_REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
!ENDIF

nk::
        set NKLIBS=

nk::$(NK_COMPONENTS) $(NK_REPLACE_COMPONENTS)
        set TARGETTYPE=LIBRARY
        set TARGETNAME=$@
        set RELEASETYPE=OAK
        set TARGETLIBS=
        set SOURCELIBS=%%NKLIBS%% $(SG_INPUT_LIB)\nkmain.lib
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKLIB)\$@.lib

nkprof::nk
        set TARGETTYPE=LIBRARY
        set TARGETNAME=$@
        set RELEASETYPE=OAK
        set TARGETLIBS=
        set SOURCELIBS=%%NKLIBS%% $(SG_INPUT_LIB)\nkprmain.lib
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKLIB)\$@.lib

httplite:: ws2
    @set SOURCELIBS=$(SG_INPUT_LIB)\httplite.lib
httplite::$(HTTPLITE_COMPONENTS)
    @set TARGETNAME=$@
    @set RELEASETYPE=SDK
    @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_OUTPUT_SDKLIB)\ws2.lib $(SG_INPUT_LIB)\httplstb.lib
    @set DLLENTRY=_DllMainCRTStartup
    $(MAKE) /NOLOGO $@.dll
httpftp:
      @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib


wceload inetcore dubftps \
smc8xx_SCToVK ppc_lcd8xx \
LayoutManager NumPadRmp \
ufnmddbase ufnclientlibbase scsi2dad rndismini2 pxa25xusbfn_lib pxa25xufnlib \
InputLang_0409 InputLang_0411 InputLang_0412 KeybdIst PS2_8042_KbdCommon Nop_KbdCommon \
kbdus_lib kbdjpn_lib kbdjpn1_lib kbdkor_lib \
InputLang_0401 InputLang_040D InputLang_04TH0 InputLang_041E InputLang_0439 InputLang_044E InputLang_0446 InputLang_044A InputLang_0447 InputLang_044B InputLang_0449 \
Nop_PddList \
HD465irda HD465_KbdCommon HD465ccuart HD465ohcdpdd HD465wavedev \
fulllibc xlock \
acmdwrap \
kd hd dbg ethdbg osaxst0 osaxst1 kitl kitleth ne2kdbg rtl8139dbg dp83815dbg dec21140dbg \
am79c970dbg am79c973dbg 3c90xdbg cs8900dbg vbridge vbridgestub smc9000 smsc100 smsc91c net2890lib net2890klib \
rne_mdd blcommon bootpart eboot dsif dsound celog caplog shimeng kcover \
SC2410_SDHCBase s3c2410x_serial \
SMT926_SDHCBase smt926a_serial	\
pxa27x_sdhc \
PCIreg \
fal ecclib sdnpcik stratak faslk \
loadauth mincrypt traverse \
watapi wcdrom wdisk wudfs ksguid dvdif wserial \
ntcompat bclib lci ldi cclib libc cefrtl bthguid kerbcomm \
pcmconv:
        @echo Copying $@.*
        -@xcopy /I /D /Q $(SG_INPUT_LIB)\$@.* $(SG_OUTPUT_OAKLIB) > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(SG_INPUT_ROOT)\oak\target\$(_CPUINDPATH)\$@.* $(SG_OUTPUT_OAKTGT) > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(SG_INPUT_ROOT)\sdk\lib\$(_CPUINDPATH)\$@.* $(SG_OUTPUT_SDKLIB) > nul $(SG_XCOPYREDIRECT)

ceosutil authhlp cecap gwestubs::
        @echo Copying $@.*
        -@xcopy /I /D /Q $(SG_INPUT_LIB)\$@.* $(SG_OUTPUT_OAKLIB) > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(SG_INPUT_LIB)\$@.* $(SG_OUTPUT_SDKLIB) > nul $(SG_XCOPYREDIRECT)


# different rules for signed components depending on whether we want to build them or copy the checked-in binaries
!IFDEF  __SYSGEN_BUILDCSPS
rsabase rsaenh::
	@set TARGETLIBS=$(SG_INPUT_LIB)\$@.lib $(SG_INPUT_LIB)\$@.res $(SG_INPUT_LIB)\rsa32.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\ceosutil.lib $(SG_INPUT_LIB)\mincrypt.lib
        @set DLLENTRY=_DllMainCRTStartup

dssdh::
	@set TARGETLIBS=$(SG_INPUT_LIB)\$@.lib $(SG_INPUT_LIB)\$@.res $(SG_INPUT_LIB)\bignum.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib
        @set DLLENTRY=DllEntry

scwcsp::winscard scwapi
	@set TARGETLIBS=$(SG_INPUT_LIB)\$@.lib $(SG_INPUT_LIB)\$@.res $(SG_OUTPUT_SDKLIB)\winscard.lib $(SG_OUTPUT_SDKLIB)\scwapi.lib $(SG_OUTPUT_SDKLIB)\coredll.lib
        @set DLLENTRY=_DllMainCRTStartup

rsabase rsaenh dssdh scwcsp::
        @set RELEASETYPE=OAK
        @set TARGETTYPE=DYNLINK
        @set DEFFILE=$(SG_INPUT_LIB)\$@.def
        @set SOURCELIBS=
        @set TARGETNAME=$@
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll
!ELSE

rsabase rsaenh dssdh scwcsp:
        @echo Copying $@.*
        -@xcopy /I /D /Q $(SG_INPUT_ROOT)\oak\target\$(_CPUINDPATH)\$@.* $(SG_OUTPUT_OAKTGT) > nul $(SG_XCOPYREDIRECT)	
!ENDIF

#
# The driver library components
#
i486oal \
aablt emul emulstub emulrotate ctblt ctbltstub rctblt drvgradfill drvgradfillstub rdrvgradfill drvalphablend drvalphablendstub wrap2bpp wrap2dr ddgpe dxdrvguid wavemdd tch_trns tchbasic tch_cal cardserv \
defbuslib pcc_com ser_card ser_card2 com_mdd2 ser16550 oo16550 serpddcm ddk_bus ddk_map ddk_io ddk_dma ddk_time ddk_power \
hcdlib ohcdmdd2 uhcdmdd hcd2lib ehcdmdd usbclient hidmdd rndismini nativemp sdcardlibbase sdhclib smclib \
pm_mdd_lib pm_default_pdd_lib pm_pda_pdd_lib pmstubs_lib pm_pdd_common_lib \
battdrvr_lib nleddrvr_lib wdmutil \
atapi_common_lib atapi_pcio_lib atapi_pcio_cd_lib atapi_pcip_pdc20262_lib atapi_pcmcia_lib \
au1pcc_lib:
        @echo Copying $@.*
        -@xcopy /I /D /Q $(SG_INPUT_LIB)\$@.* $(SG_OUTPUT_OAKLIB) > nul $(SG_XCOPYREDIRECT)


#
# Obsolete modules, or components of modules.
#
math pinglib dbgu dbgt nloaddbg cursors miscfunc mainusrq touch demodisp \
vbsen jsen mgdi_s netdetec mgjfonts jscript vbscript consolej arp loadstr:
        @echo WARNING: $@ is no longer part of the OAK. Please remove from your cesysgen.bat


#
# This is to allow backward compatibility additions of dummy targets so that we can change
# components while projects stay on old lkg's
#
!IF "$(_DISABLEBCMAKEFILE)" != "1"
!IF EXIST($(_PRIVATEROOT)\bat\bcsysgen.mak)
!INCLUDE $(_PRIVATEROOT)\bat\bcsysgen.mak
!ENDIF
!ENDIF


####################################################################################################
# These are modules which link as part of the sysgen phase, but are not componentized.
# This includes everything else in PRIVATE\WINCEOS except those that have explicit rules above
# When you add your module here, please follow the 4-step instructions laid down below.
####################################################################################################
#
# STEP1: List your dependencies (other things that must link before you in the sysgen phase) and
#        set your TARGETLIBS variable. List your link libs & RES files first and your import libs last
#        Don't list coredll.dll. It will be included by default. Don't set SOURCELIBS. It is not used
#        in this phase. Also note that all rules in this section must end in :: not :,  The only
#        exception is for rules that define artificial targets, such as export libraries from
#        components with circular dependencies (which should normally be avoided anyway).
#
# IMPORTANT: Don't forget to list your dependencies. Anything you list in TARGETLIBS that also builds
# in this makefile *must* be listed as a dependency. E.g. commctrl etc
#

## Some useful generic macros
OWNLIB=$(SG_INPUT_LIB)\$@.lib
OWNSTATICLIB=$(SG_INPUT_LIB)\$@_lib.lib
OWNRES=$(SG_INPUT_LIB)\$@.res
OWNLIB_RES=$(SG_INPUT_LIB)\$@.lib $(SG_INPUT_LIB)\$@.res
CCLIB=$(SG_OUTPUT_SDKLIB)\commctrl.lib
WINSOCKLIB=$(SG_OUTPUT_SDKLIB)\winsock.lib
WS2LIB=$(SG_OUTPUT_SDKLIB)\ws2.lib
CEOSUTILLIB=$(SG_OUTPUT_SDKLIB)\ceosutil.lib
OTHERS_ROOT=$(_WINCEROOT)\others

# Info file for wcetk.
wcetk:
        -@echo SERVERNAME=$(COMPUTERNAME) > $(SG_OUTPUT_ROOT)\oak\files\wcetk.txt
        @echo PORTNUMBER=5555 >> $(SG_OUTPUT_ROOT)\oak\files\wcetk.txt
        @echo AUTORUN=0 >> $(SG_OUTPUT_ROOT)\oak\files\wcetk.txt
        @echo DEFAULTSUITE= >> $(SG_OUTPUT_ROOT)\oak\files\wcetk.txt
        -@xcopy /I /D /Q $(OTHERS_ROOT)\wcetk\$(_TGTCPU)\clientside.exe $(SG_OUTPUT_OAKTGT)  > nul $(SG_XCOPYREDIRECT)
!IF "$(SYSGEN_WCETK)" != ""
!IF "$(WINCEREL)" == "1"
        -@xcopy /I /D /Q $(SG_OUTPUT_ROOT)\oak\files\wcetk.txt $(_FLATRELEASEDIR)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\wcetk\$(_TGTCPU)\clientside.exe $(_FLATRELEASEDIR)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\wcetk\$(_TGTCPU)\cescript.exe $(_FLATRELEASEDIR)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\wcetk\$(_TGTCPU)\prt_scrn.exe $(_FLATRELEASEDIR)  > nul $(SG_XCOPYREDIRECT)
!ENDIF
!ENDIF

#
# Platman stuff
#
platman:
	@echo Copying Platman components to $(SG_OUTPUT_OAKTGT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\cemgrc.exe $(SG_OUTPUT_OAKTGT)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\cetlkitl.dll $(SG_OUTPUT_OAKTGT)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\cetlstub.dll $(SG_OUTPUT_OAKTGT)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\tcpipc.dll $(SG_OUTPUT_OAKTGT)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\tlcesrv.dll $(SG_OUTPUT_OAKTGT)  > nul $(SG_XCOPYREDIRECT)
!IF "$(SYSGEN_PLATMAN)" != ""
!IF "$(WINCEREL)" == "1"
	@echo Copying Platman components to $(_FLATRELEASEDIR)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\cemgrc.exe $(_FLATRELEASEDIR)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\cetlkitl.dll $(_FLATRELEASEDIR)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\cetlstub.dll $(_FLATRELEASEDIR)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\tcpipc.dll $(_FLATRELEASEDIR)  > nul $(SG_XCOPYREDIRECT)
        -@xcopy /I /D /Q $(OTHERS_ROOT)\platman\target\$(_TGTCPU)\tlcesrv.dll $(_FLATRELEASEDIR)  > nul $(SG_XCOPYREDIRECT)
!ENDIF
!ENDIF

#
# Network/Comm stuff
#
NTCOMPATLIB=$(SG_INPUT_ROOT)\sdk\lib\$(_CPUINDPATH)\ntcompat.lib
CEDDKLIB=$(SG_OUTPUT_OAKLIB)\ceddk.lib
CXPORT_CCLIBS=$(SG_OUTPUT_SDKLIB)\cxport.lib $(SG_INPUT_LIB)\cclib.lib
NDISLIB=$(SG_OUTPUT_SDKLIB)\ndis.lib   $(SG_OUTPUT_SDKLIB)\cxport.lib

mbridge2: mbridge
     copy  $(SG_OUTPUT_OAKTGT)\mbridge.dll $(SG_OUTPUT_OAKTGT)\mbridge2.dll
     copy  $(SG_OUTPUT_OAKTGT)\mbridge.pdb $(SG_OUTPUT_OAKTGT)\mbridge2.pdb
     -copy  $(SG_OUTPUT_OAKTGT)\mbridge.map $(SG_OUTPUT_OAKTGT)\mbridge2.map

#
# PPP build rules
#
# PPP_COMPONENTS is set in the cesysgen.bat to either null, ppp2srv or ppp2srvstub
# depending upon the setting of SYSGEN_PPP and SYSGEN_PPP_SERVER.
#
!IF "$(PPP_COMPONENTS)" != ""

#
# First, set SOURCELIBS to ppp2srv.lib OR ppp2srvstub.lib.
# Only one of these 2 rules will be chosen, based upon the value of
# PPP_COMPONENTS. That is, "ppp" depends upon "$(PPP_COMPONENTS)"
# and that will cause the makefile to perform one of these next 2 rules.
#
# Note that this rule clears out any old SOURCELIBS or TARGETLIBS.
#
#
ppp2srv: ntlmssp
        @set SOURCELIBS=$(SG_INPUT_LIB)\ppp2srv.lib
        @set TARGETLIBS=$(SG_OUTPUT_OAKLIB)\ntlmssp.lib

ppp2srvstub:
        @set SOURCELIBS=$(SG_INPUT_LIB)\ppp2srvstub.lib
        @set TARGETLIBS=

#
# Second, the base rule for PPP which adds the libs that are always in it to
# the SOURCELIBS and TARGETLIBS. This rule also expresses the dependency
# on PPP_COMPONENTS which will cause one of the 2 above rules to be invoked.
#
ppp:: ndis cxport $(PPP_COMPONENTS)
        @set SOURCELIBS=%%SOURCELIBS%% \
            $(SG_INPUT_LIB)\ppp2app.res \
            $(SG_INPUT_LIB)\ppp2app.lib $(SG_INPUT_LIB)\ppp2ncp.lib $(SG_INPUT_LIB)\ppp2ipcp.lib \
            $(SG_INPUT_LIB)\pppipv6cp.lib $(SG_INPUT_LIB)\ppp2lcp.lib  $(SG_INPUT_LIB)\ppp2auth.lib \
            $(SG_INPUT_LIB)\ppp2ccp.lib $(SG_INPUT_LIB)\ppp2ras.lib $(SG_INPUT_LIB)\ppp2ndis.lib
        @set TARGETLIBS=%%TARGETLIBS%% \
            $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib $(CXPORT_CCLIBS) $(NTCOMPATLIB) $(NDISLIB)
        @set RELEASETYPE=OAK
        @set TARGETTYPE=DYNLINK
        @set DLLENTRY=DllEntry
        @set DEFFILE=$(SG_INPUT_LIB)\$@.def
        @set TARGETNAME=$@
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll

!ELSE   #  "$(PPP_COMPONENTS)" != ""

ppp::

!ENDIF #  "$(PPP_COMPONENTS)" != ""



#
# Nativewifi has AP/STA components that can be selectively linked to nwifi.dll based on $(NWIFI_COMPONENTS).
#

nwifi:: ndis
	@set TARGETLIBS=
	@set SOURCELIBS=$(OWNLIB) $(SG_INPUT_LIB)\wlcrypto.lib $(SG_INPUT_LIB)\rsa32.lib 

nwifi:: $(NWIFI_COMPONENTS)
	@set TARGETNAME=$@
	@set RELEASETYPE=OAK
        @set TARGETLIBS= $(SG_OUTPUT_SDKLIB)\coredll.lib $(NDISLIB) $(NTCOMPATLIB) $(SG_INPUT_LIB)\apstastub.lib
        @set TARGETTYPE=DYNLINK
	@set DLLENTRY=DllEntry
        @set DEFFILE=$(SG_INPUT_LIB)\$@.def
	@echo TARGETLIBS=%TARGETLIBS%
	@echo SOURCELIBS=%SOURCELIBS%
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll

ap sta:
	@set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib



afd::cxport
        @set SOURCELIBS=$(SG_INPUT_LIB)\afdlib.lib
afd::$(AFD_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib $(CXPORT_CCLIBS) $(SG_OUTPUT_SDKLIB)\ceosutil.lib $(SG_INPUT_LIB)\afdstubs.lib
        @set DLLENTRY=DllEntry
        $(MAKECMD) /NOLOGO $@.dll
afddnslib afddnsproxy:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib

nspm::
        @set TARGETLIBS=$(OWNLIB)
wspm::
        @set TARGETLIBS=$(OWNLIB)
ws2instl:: ws2
        @set TARGETLIBS=$(OWNLIB) $(WS2LIB) $(CEOSUTILLIB)
ndis:: ceddk cxport
        @set TARGETLIBS=$(SG_INPUT_LIB)\ndislib.lib     $(NTCOMPATLIB) $(CEDDKLIB)  $(CXPORT_CCLIBS)
tcpip6:: cxport iphlpapi ndis
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\sys6.lib $(SG_INPUT_LIB)\tcp6.lib $(SG_INPUT_LIB)\tcpxsum.lib $(SG_INPUT_LIB)\udp6.lib \
        $(SG_INPUT_LIB)\ip6.lib $(SG_INPUT_LIB)\algrthm6.lib $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(NDISLIB) $(NTCOMPATLIB) $(CXPORT_CCLIBS)
tcpstk:: cxport ndis
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\tcp.lib $(SG_INPUT_LIB)\ip.lib $(SG_INPUT_LIB)\tcpxsum.lib $(NDISLIB) $(NTCOMPATLIB) $(CXPORT_CCLIBS)
pptp::  ndis cxport netmui
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\raspptp.lib $(CXPORT_CCLIBS) $(NTCOMPATLIB) $(WINSOCKLIB) $(NDISLIB)
l2tp::  ndis cxport iphlpapi ws2 crypt32 netmui
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\l2tp.lib $(SG_INPUT_LIB)\ipsec_api.lib $(CXPORT_CCLIBS) $(NTCOMPATLIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WS2LIB) $(NDISLIB) $(SG_OUTPUT_SDKLIB)\crypt32.lib
pppoe:: ndis cxport
        @set TARGETLIBS=$(OWNLIB) $(CXPORT_CCLIBS) $(NTCOMPATLIB) $(NDISLIB)
eap::   cxport
        @set TARGETLIBS=$(OWNLIB) $(CXPORT_CCLIBS)
eapchap:: eap
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\eap.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib $(CXPORT_CCLIBS)
eaptls::secur32 crypt32 eap
	@set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\eap.lib $(SG_OUTPUT_SDKLIB)\crypt32.lib $(SG_OUTPUT_SDKLIB)\secur32.lib $(CXPORT_CCLIBS)
eapol:: cxport eap
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\eap.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib $(CXPORT_CCLIBS)
smsc100fd elnk3 sisnic ieepro xircce3 rtl8139 e100bex dp83815 vmini tunmp pcx500:: ndis ceddk netmui
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB) $(NDISLIB)
RTL8180wf:: ndis ceddk netmui NativeMP
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB) $(NDISLIB) $(SG_OUTPUT_OAKLIB)\NativeMP.lib
ne2000:: ndis ceddk ne2000isr netmui
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB) $(NDISLIB)
islp2nds:: ndis ceddk
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB) $(NDISLIB) $(SG_INPUT_LIB)\ndcwepssn.lib
pegasSDN:: sdcardlib ceddk sdbus ndis netmui ntcompat
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB) $(NDISLIB) $(NTCOMPATLIB) $(SG_OUTPUT_OAKLIB)\sdcardlib.lib $(SG_OUTPUT_OAKLIB)\sdbus.lib
rndismp:: ndis ceddk ntcompat
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB) $(NTCOMPATLIB) $(NDISLIB)
mbridge:: ndis cxport ceddk netmui
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\bridge.lib $(CEDDKLIB) $(NTCOMPATLIB) $(NDISLIB) $(CXPORT_CCLIBS)
ndispwr::
        @set TARGETLIBS=$(OWNLIB)
ndisuio:: ndis ceddk cxport
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ndisuio.lib $(CEDDKLIB) $(NTCOMPATLIB) $(NDISLIB) $(CXPORT_CCLIBS)
wzcsapi::
        @set TARGETLIBS=$(OWNLIB)
wzcsvc:: iphlpapi cxport wlclient
        @set TARGETLIBS=$(OWNLIB) $(CXPORT_CCLIBS) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(NTCOMPATLIB) $(SG_OUTPUT_OAKLIB)\wlclient.lib
wlclient::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\wlshr.lib
wlsvc:: oneex wzcsapi
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\wlshr.lib $(SG_OUTPUT_OAKLIB)\oneex.lib $(SG_OUTPUT_OAKLIB)\wzcsapi.lib
oneex:: wlclient crypt32 cxport
	@set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\wlshr.lib $(SG_OUTPUT_OAKLIB)\wlclient.lib $(SG_OUTPUT_SDKLIB)\crypt32.lib $(CXPORT_CCLIBS) $(SG_INPUT_LIB)\rsa32.lib
autoras:: iphlpapi
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WINSOCKLIB)
asyncmac:: ndis cxport netmui
        @set TARGETLIBS=$(OWNLIB) $(CXPORT_CCLIBS) $(NDISLIB)
redir:: cxport
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\browser.lib $(SG_INPUT_LIB)\rdrapi.lib $(SG_INPUT_LIB)\rdrnet.lib $(SG_INPUT_LIB)\libxy.lib $(SG_INPUT_LIB)\rsa32.lib $(SG_INPUT_LIB)\fsdnot.lib $(CXPORT_CCLIBS)
netbios dhcp:: cxport
        @set TARGETLIBS=$(OWNLIB) $(CXPORT_CCLIBS)
dhcpv6l:: cxport ws2 iphlpapi
	@set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WS2LIB) $(CXPORT_CCLIBS)
ipnat:: cxport
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\natlib.lib $(SG_INPUT_LIB)\dhcpallo.lib $(SG_INPUT_LIB)\natwdm.lib $(SG_INPUT_LIB)\tcpxsum.lib $(CXPORT_CCLIBS) $(SG_OUTPUT_SDKLIB)\ceosutil.lib $(WINSOCKLIB)
ipsec:: cxport ndis
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\mincrypt.lib $(NTCOMPATLIB) $(NDISLIB) $(SG_INPUT_LIB)\ipsecshr.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib
ipsecsvc:: ws2 iphlpapi crypt32
	@set TARGETLIBS=$(SG_INPUT_LIB)\ceipsec.lib $(SG_INPUT_LIB)\ipsecsvc.res $(SG_INPUT_LIB)\ipsecspd.lib $(SG_INPUT_LIB)\nsu.lib $(SG_INPUT_LIB)\ipsecshr.lib $(SG_INPUT_LIB)\oakley.lib $(SG_INPUT_LIB)\ipseccpputils.lib $(SG_INPUT_LIB)\ceosutil.lib $(SG_INPUT_LIB)\mincrypt.lib $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(SG_OUTPUT_SDKLIB)\ws2.lib $(SG_OUTPUT_SDKLIB)\crypt32.lib
ipseccfg::
	@set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ipsec_api.lib $(SG_INPUT_LIB)\ceosutil.lib $(SG_OUTPUT_SDKLIB)\ws2.lib

credman:: credsvc credprov

credsvc::
	@set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ceosutil.lib
credprov::
	@set TARGETLIBS=$(OWNLIB)
fw6:: iphlpapi ws2
        @set TARGETLIBS=$(OWNLIB) $(WS2LIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib

lassd::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ceosutil.lib
lap_pw::
        @set TARGETLIBS=$(OWNLIB_RES)  $(SG_INPUT_LIB)\ceosutil.lib

fwapi::
        @set TARGETLIBS=$(OWNLIB)
iphlpapi:: ws2
        @set TARGETLIBS=$(OWNLIB) $(WS2LIB)
irdastk:: irsir cxport
                @set TARGETLIBS=$(SG_INPUT_LIB)\irtdi.lib $(SG_INPUT_LIB)\irlap.lib $(SG_INPUT_LIB)\irlmp.lib $(SG_INPUT_LIB)\irutil.lib $(NTCOMPATLIB) $(NDISLIB) $(CXPORT_CCLIBS)
irsir:: ndis ceddk
        @set TARGETLIBS=$(SG_INPUT_LIB)\irsirlib.lib $(SG_INPUT_LIB)\irmacutl.lib $(CEDDKLIB) $(NDISLIB)
ircomm:: winsock
        @set TARGETLIBS=$(SG_INPUT_LIB)\ircomlib.lib $(WINSOCKLIB)
msasn1::
        @set TARGETLIBS=$(OWNLIB)
certui:: crypt32
    @set TARGETLIBS=$(OWNLIB_RES) $(SG_OUTPUT_SDKLIB)\commctrl.lib $(SG_OUTPUT_SDKLIB)\crypt32.lib
secur32::
        @set TARGETLIBS=$(SG_INPUT_LIB)\sspi.lib
schannel:: crypt32
        @set TARGETLIBS=$(SG_INPUT_LIB)\schnlc.lib  $(SG_INPUT_LIB)\spbase.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib $(SG_OUTPUT_SDKLIB)\crypt32.lib
ssllsp::
	@set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\sslsock.lib
ntlmssp::
        @set TARGETLIBS=$(SG_INPUT_LIB)\ntlm.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib
cryptdll::
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\rsa32.lib
kerberos::cryptdll winsock msasn1
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\msasn1.lib $(SG_OUTPUT_OAKLIB)\cryptdll.lib $(SG_OUTPUT_SDKLIB)\winsock.lib
spnego::msasn1 secur32
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\msasn1.lib $(SG_OUTPUT_SDKLIB)\secur32.lib
loaddbg memtool zlib toolhelp rasdial winscard autodial::
        @set TARGETLIBS=$(OWNLIB)
cerdisp:: winsock
        @set TARGETLIBS=$(OWNLIB_RES) $(WINSOCKLIB)
lmemdebug:: toolhelp
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\toolhelp.lib
scard:: winscard
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\winscard.lib
scwapi:: winscard
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\winscard.lib
scwcspgui:: winscard
        @set TARGETLIBS=$(OWNLIB_RES) $(SG_OUTPUT_SDKLIB)\winscard.lib
pscr bulltlp3:: ceddk
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\smclib.lib $(CEDDKLIB)
stcusb:: usbd
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\smclib.lib $(SG_OUTPUT_OAKLIB)\usbd.lib
shell:: toolhelp shellcelog
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\toolhelp.lib
usb8023:: usbd ndis rndismp netmui
        @set TARGETLIBS=$(OWNLIB) $(NDISLIB) $(NTCOMPATLIB) $(SG_OUTPUT_OAKLIB)\usbd.lib $(SG_OUTPUT_OAKLIB)\rndismp.lib $(SG_INPUT_LIB)\usbclient.lib

ipv6hlp:: iphlpapi cxport ws2
        @set TARGETLIBS=$(OWNLIB) $(CXPORT_CCLIBS) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WS2LIB) $(NTCOMPATLIB)
ipv6::
	@set TARGETLIBS=$(OWNLIB) $(CXPORT_CCLIBS) $(WS2LIB) $(NTCOMPATLIB)
ipv6tun::
	@set TARGETLIBS=$(OWNLIB)
eventlog::
	@set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\$@.res $(SG_INPUT_LIB)\ceosutil.lib  $(SG_INPUT_LIB)\EventLogFormatIO.lib $(SG_INPUT_LIB)\EventLogHlprExports.lib $(SG_INPUT_LIB)\EventLogDriver.lib
eventlogmsgs::
	@set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\$@.res
dnsapi::
	@set TARGETLIBS=$(OWNLIB)
netapi32::wldap32 dnsapi ws2
	@set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ldaphlp.lib $(SG_INPUT_LIB)\dcdiscover.lib $(SG_OUTPUT_SDKLIB)\wldap32.lib $(SG_OUTPUT_SDKLIB)\ws2.lib $(SG_OUTPUT_SDKLIB)\dnsapi.lib $(SG_INPUT_LIB)\ceosutil.lib

dhcpsrv::
    @set TARGETLIBS=$(OWNLIB)
veim:: ndis cxport dhcpsrv
    @set TARGETLIBS=$(OWNLIB) $(NDISLIB) $(CXPORT_CCLIBS) $(SG_OUTPUT_OAKLIB)\dhcpsrv.lib


#
#               commctrl
#
!IF "$(COMMCTRLLIB_RES)" == ""
COMMCTRLLIB_RES=commctrl_hpc
!ENDIF
!IF "$(COMMCTRL_SKIN)" == ""
COMMCTRL_SKIN=commctrlview
!ENDIF

!IF "$(COMMCTRL_REPLACE)" != ""
$(COMMCTRL_REPLACE)::
    @set COMMCTRL_SKIN=
    @set COMMCTRL_LIBS=%%COMMCTRL_LIBS%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
    @set COMMCTRL_RESOURCES=%%COMMCTRL_RESOURCES%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$@.res
#        @set COMMCTRL_RESOURCES=%%COMMCTRL_RESOURCES%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$(CURRENT_LANGID)\$@.res
!ENDIF

!IF "$(COMMCTRL_REPLACE_COMPONENTS)" != ""
$(COMMCTRL_REPLACE_COMPONENTS)::
	@set COMMCTRL_SKIN=
    @set COMMCTRL_LIBS=%%COMMCTRL_LIBS%% $(REPLACE_ROOT)\oak\lib\$(_CPUINDPATH)\$@.lib
!ENDIF

# Special rule for commctrl which links platform specific lib/resources and
# can be linked with either the 9x or the XP style UI
$(COMMCTRLLIB_RES)::
	@set COMMCTRL_LIBS=%%COMMCTRL_LIBS%% $(SG_INPUT_LIB)\$@.lib
	@set COMMCTRL_RESOURCES=%%COMMCTRL_RESOURCES%% $(SG_INPUT_LIB)\$(CURRENT_LANGID)\$@.res

commctrlview::
	@set COMMCTRL_LIBS=%%COMMCTRL_LIBS%% $(SG_INPUT_LIB)\$@.lib

commctrlviewxp::
	@set COMMCTRL_LIBS=%%COMMCTRL_LIBS%% $(SG_INPUT_LIB)\$@.lib
	@set COMMCTRL_RESOURCES=%%COMMCTRL_RESOURCES%% $(SG_INPUT_LIB)\$@.res


# Get ready to link commctrl.
# First clear the library and resource lists.
commctrl::
        @set COMMCTRL_LIBS=
        @set COMMCTRL_RESOURCES=$(SG_INPUT_LIB)\$(CURRENT_LANGID)\commctrlbase.res

# Now build up the library and resource lists,
# putting replacements first
commctrl::$(COMMCTRL_REPLACE) $(COMMCTRL_REPLACE_COMPONENTS) $(COMMCTRLLIB_RES) $(COMMCTRL_SKIN) 0409_base_resources
        $(SG_TOKENFILTER) $(SG_INPUT_LIB)\$@.def $(SG_OUTPUT_OAKLIB)

# Link commctrl.dll. Need to invoke nmake only once
commctrl_dll::
    -del /q $(SG_OUTPUT_OAKTGT)\$(CURRENT_LANGID)\commctrl.res
	@echo COMMCTRL_RESOURCES=%COMMCTRL_RESOURCES%
    $(RES2RES) %%COMMCTRL_RESOURCES%% -fo $(SG_OUTPUT_OAKTGT)\$(CURRENT_LANGID)\commctrl.res
!IF "$(CURRENT_LANGID)" == "0409"
    @set TARGETTYPE=DYNLINK
    @set DEFFILE=$(SG_OUTPUT_OAKLIB)\commctrl.def
    @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib
    @set SOURCELIBS=$(SG_INPUT_LIB)\commctrl.lib %%COMMCTRL_LIBS%%
    @set TARGETNAME=commctrl
    @set RELEASETYPE=SDK
    @set CPL=
    @set DLLENTRY=DllEntry
    @set TARGETLIBS=%%TARGETLIBS%% $(SG_OUTPUT_OAKTGT)\0409\commctrl.res
	-del /q $(SG_OUTPUT_SDKLIB)\commctrl.lib
	-del /q $(SG_OUTPUT_SDKLIB)\commctrl.exp
    $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\commctrl.dll
!ENDIF

# Export lib for platforms that want to replace commctrl components
commctrl_sdklib::
	$(LIBRARIAN) -out:$(SG_OUTPUT_SDKLIB)\commctrl.lib -def:$(SG_OUTPUT_OAKLIB)\commctrl.def $(MACHINEOPTION)

!IF "$(__QBLDPASS)"=="preproc"
!IF "$(COMMCTRL_REPLACE)" != ""
commctrl::commctrl_sdklib

!ELSE IF "$(COMMCTRL_REPLACE_COMPONENTS)" != ""
commctrl::commctrl_sdklib

!ELSE
commctrl::commctrl_dll

!ENDIF
!ELSE
commctrl::commctrl_dll

!ENDIF


#
#               Utilities
#
celogflush oscapture shellcelog ceramdrv::
                @set TARGETLIBS=$(OWNSTATICLIB)

#
#		coversrv code coverage runtime
#
coversrv::
                @set TARGETLIBS=$(OWNSTATICLIB)

#############################################################################################################
#
#               BSP Drivers
#
#############################################################################################################

ceddk giisr ti1250isr isr16550 ne2000isr mmtimer ramdisk regenum enumfaslpci trueffs usbd hidparse \
KbdNopUS KbdNopJpn1 KbdNopJpn2 KbdNopKor::
                @set TARGETLIBS=$(OWNSTATICLIB)

parallel \
com16550 com_card dualio uhci ehci ensoniq HD465parallel HD465ohci gdcfg \
Kbd8042US Kbd8042Jpn1 Kbd8042Jpn2 Kbd8042Kor \
es1371 gxuamaud battdrvr nleddrvr:: ceddk
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB)

battdrvr:: battdrvr_lib

nleddrvr:: nleddrvr_lib

ohci2:: ceddk ohcdmdd2 hcdlib
                @set TARGETLIBS=$(SG_INPUT_LIB)\ohci_lib.lib $(CEDDKLIB) $(SG_INPUT_LIB)\ohcdmdd2.lib $(SG_INPUT_LIB)\hcdlib.lib

i82365:: ceddk cardserv
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\cardserv.lib

ti1250:: ceddk cardserv pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\cardserv.lib $(SG_OUTPUT_OAKLIB)\pcibus.lib

pcc_tipccard:: ceddk pcc_com pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\pcc_com.lib $(SG_OUTPUT_OAKLIB)\pcibus.lib

pcc_tipccard16:: ceddk pcc_com pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\pcc_com.lib $(SG_OUTPUT_OAKLIB)\pcibus.lib

pcc_tipccard32:: ceddk pcc_com pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\pcc_com.lib $(SG_OUTPUT_OAKLIB)\pcibus.lib

pcc_i82365:: ceddk pcc_com pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\pcc_com.lib $(SG_OUTPUT_OAKLIB)\pcibus.lib

sdnpcid:: ceddk fal ecclib
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\fal.lib $(SG_OUTPUT_OAKLIB)\ecclib.lib

stratad:: ceddk fal
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\fal.lib
                -@xcopy /I $(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)

fasld:: ceddk fal
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\fal.lib
                -@xcopy /I  $(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)

enumfaslpci:: ceddk pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\pcibus.lib
                -@xcopy /I  $(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)
				
ramfmd:: ceddk fal
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\fal.lib

busenum pcibus::ceddk defbuslib
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB)

pcc_serv:: ceddk pcc_com pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\pcc_com.lib $(SG_OUTPUT_OAKLIB)\pcibus.lib

pcc_serv16:: ceddk pcc_com
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\pcc_com.lib

pcc_serv32:: ceddk pcc_com pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\pcc_com.lib $(SG_OUTPUT_OAKLIB)\pcibus.lib

pcc_pcm:: ceddk pcc_com
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\pcc_com.lib

gdcfg:: ceddk pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\pcibus.lib

atadisk:: ceddk
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(_COMMONOAKROOT)\lib\$(_CPUINDPATH)\storeapi.lib

atapi:: ceddk atapi_common_lib atapi_pcio_lib atapi_pcio_cd_lib atapi_pcip_pdc20262_lib atapi_pcmcia_lib
		@set SOURCELIBS=
                @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib $(CEDDKLIB) $(_COMMONOAKROOT)\lib\$(_CPUINDPATH)\storeapi.lib

atapi:: atapi_common $(ATAPI_COMPONENTS)
		@set TARGETNAME=$@
		@set DLLENTRY=DllMain
		@set DEFFILE=$(SG_INPUT_LIB)\$@.def
		$(MAKECMD) /NOLOGO $@.dll

atapi_common:
		@set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@_lib.lib
atapi_pcio:
		@set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@_lib.lib
atapi_pcio_cd:
		@set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@_lib.lib
atapi_pcip_pdc20262:
		@set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@_lib.lib
atapi_pcmcia:
		@set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@_lib.lib

gpe::
		@echo Deleting gpe.lib
		-@del $(SG_OUTPUT_OAKLIB)\gpe.lib

gpe:: drvalphablend emulrotate rctblt rdrvgradfill
		@set SOURCELIBS=$(OWNSTATICLIB) $(SG_INPUT_LIB)\rdrvgradfill.lib $(SG_INPUT_LIB)\drvalphablend.lib $(SG_INPUT_LIB)\emulrotate.lib $(SG_INPUT_LIB)\rctblt.lib $(SG_INPUT_LIB)\genblt.lib $(SG_INPUT_LIB)\genblt_cpu.lib

gpe::
		@echo SOURCELIBS=%%SOURCELIBS%%
		@set TARGETNAME=$@
		@set RELEASETYPE=OAK
		@set TARGETLIBS=
		@set TARGETTYPE=LIBRARY
		$(MAKE) /NOLOGO $(SG_OUTPUT_OAKLIB)\$@.lib

gperotate:: gpe
        	-@xcopy /I /D /Q $(SG_OUTPUT_OAKLIB)\gpe.* $(SG_OUTPUT_OAKLIB)\gperotate.* > nul $(SG_XCOPYREDIRECT)

ddi_nop:: gpe
                @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\gpe.lib

ddi_3dr:: ceddk dxdrvguid gpe
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\dxdrvguid.lib $(SG_OUTPUT_OAKLIB)\gpe.lib

ddi_gx ddi_tvia5  ddi_s3v:: ceddk dxdrvguid gpe
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\dxdrvguid.lib $(SG_OUTPUT_OAKLIB)\gpe.lib

ddi_ragexl:: ceddk dxdrvguid gpe ntcompat pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\dxdrvguid.lib $(SG_OUTPUT_OAKLIB)\gpe.lib $(NTCOMPATLIB) $(SG_OUTPUT_OAKLIB)\pcibus.lib

ddi_ati:: ceddk dxdrvguid gpe ntcompat pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\dxdrvguid.lib $(SG_OUTPUT_OAKLIB)\gpe.lib $(NTCOMPATLIB) $(SG_OUTPUT_OAKLIB)\pcibus.lib

ddi_perm3 ddi_flat ddi_hflat:: ceddk dxdrvguid gpe
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\dxdrvguid.lib $(SG_OUTPUT_OAKLIB)\gpe.lib

ddi_mq200:: ceddk dxdrvguid gpe
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\dxdrvguid.lib $(SG_OUTPUT_OAKLIB)\gpe.lib

ddi_rflat:: ceddk gpe
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\gpe.lib

ddi_perm3_swg:: ceddk swg dxdrvguid
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\swg.lib $(SG_INPUT_LIB)\dxdrvguid.lib

perm3_cfg:: ceddk pcibus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\pcibus.lib


multimon:: gpe
                @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\gpe.lib $(SG_OUTPUT_SDKLIB)\coredll.lib

d3dm_nulldrv::
		@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_SDKLIB)\coredll.lib

sdcardlib:: sdcardlibbase ceosutil
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set SOURCELIBS=$(SG_OUTPUT_OAKLIB)\sdcardlibbase.lib $(SG_OUTPUT_SDKLIB)\ceosutil.lib
        @set TARGETTYPE=LIBRARY
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKLIB)\$@.lib

sdbus:: sdcardlib defbuslib ceddk
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\sdcardlib.lib $(SG_OUTPUT_OAKLIB)\defbuslib.lib

sdhc:: sdcardlib sdhclib ceddk sdbus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\sdcardlib.lib $(SG_OUTPUT_OAKLIB)\sdhclib.lib $(SG_OUTPUT_OAKLIB)\sdbus.lib

ellencfg:: pcibus ceddk
                @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\pcibus.lib $(CEDDKLIB)

sdhc_sc2410:: sdcardlib sdhclib ceddk sdbus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\sdcardlib.lib $(SG_OUTPUT_OAKLIB)\sdhclib.lib $(SG_OUTPUT_OAKLIB)\sdbus.lib

sdhc_smt926:: sdcardlib sdhclib ceddk sdbus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\sdcardlib.lib $(SG_OUTPUT_OAKLIB)\sdhclib.lib $(SG_OUTPUT_OAKLIB)\sdbus.lib

pxa255_sdhc:: sdcardlib sdhclib ceddk sdbus pxa255_drvlib
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\sdcardlib.lib $(SG_OUTPUT_OAKLIB)\sdhclib.lib $(SG_OUTPUT_OAKLIB)\sdbus.lib $(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_OUTPUT_OAKLIB)\pxa255_drvlib.lib

sdmemory:: sdcardlib ceddk sdbus
                @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\sdcardlib.lib $(SG_OUTPUT_OAKLIB)\sdbus.lib

usbhid:: usbclient usbd hidparse hidmdd
                @set TARGETLIBS=$(OWNSTATICLIB) $(SG_INPUT_LIB)\usbclient.lib $(SG_OUTPUT_OAKLIB)\usbd.lib $(SG_OUTPUT_OAKLIB)\hidparse.lib $(SG_OUTPUT_OAKLIB)\hidmdd.lib

kbdhid conshid:: hidparse
                @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\hidparse.lib

mouhidtrns:: hidparse
                @set TARGETLIBS=$(SG_INPUT_LIB)\mouhidbase.lib $(SG_OUTPUT_OAKLIB)\hidparse.lib $(SG_INPUT_LIB)\MouHidTrns.lib

mouhid:: hidparse
                @set TARGETLIBS=$(SG_INPUT_LIB)\mouhidbase.lib $(SG_OUTPUT_OAKLIB)\hidparse.lib $(SG_INPUT_LIB)\MouHidStd.lib

usbmsc:: usbclient usbd
                @set TARGETLIBS=$(OWNSTATICLIB) $(SG_INPUT_LIB)\usbclient.lib $(SG_OUTPUT_OAKLIB)\usbd.lib

usbprn:: usbclient usbd
                @set TARGETLIBS=$(OWNSTATICLIB) $(SG_INPUT_LIB)\usbclient.lib $(SG_OUTPUT_OAKLIB)\usbd.lib

usbdisk6:: usbclient usbmsc ntcompat
                @set TARGETLIBS=$(OWNSTATICLIB) $(SG_INPUT_LIB)\usbclient.lib $(SG_OUTPUT_OAKLIB)\usbmsc.lib $(NTCOMPATLIB) $(_COMMONOAKROOT)\lib\$(_CPUINDPATH)\storeapi.lib

usbmsfn:: scsi2dad ufnclientlib
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\scsi2dad.lib $(SG_OUTPUT_OAKLIB)\ufnclientlib.lib $(_COMMONOAKROOT)\lib\$(_CPUINDPATH)\storeapi.lib

rndisfn:: rndismini2 ndis ufnclientlib
	@set TARGETLIBS=$(OWNSTATICLIB) $(NDISLIB) $(SG_OUTPUT_OAKLIB)\rndismini2.lib $(SG_OUTPUT_OAKLIB)\ufnclientlib.lib

ufnmdd:: ufnmddbase ceosutil defbuslib
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set SOURCELIBS=$(SG_OUTPUT_OAKLIB)\ufnmddbase.lib $(SG_OUTPUT_SDKLIB)\ceosutil.lib $(SG_OUTPUT_OAKLIB)\defbuslib.lib
        @set TARGETTYPE=LIBRARY
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKLIB)\$@.lib

ufnclientlib:: ufnclientlibbase ceddk
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set SOURCELIBS=$(SG_OUTPUT_OAKLIB)\ufnclientlibbase.lib $(CEDDKLIB)
        @set TARGETTYPE=LIBRARY
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKLIB)\$@.lib

pxa25xusbfn:: ceddk ufnmdd pxa255_drvlib pxa25xufnlib
	@set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\ufnmdd.lib $(SG_OUTPUT_OAKLIB)\pxa255_drvlib.lib $(SG_OUTPUT_OAKLIB)\pxa25xufnlib.lib

sc2410usbfn:: ceddk ufnmdd
	@set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\ufnmdd.lib

smt926usbfn:: ceddk ufnmdd
	@set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\ufnmdd.lib

usbfn:: ufnmdd ufnclientlib

net2280:: ceddk ufnmdd
	@set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\ufnmdd.lib

udfs::fsdmgr
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\fsdmgr.lib

fatfsd::fsdmgr
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\fsdmgr.lib

tfat::fsdmgr
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\fsdmgr.lib

rawfs::fsdmgr
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\fsdmgr.lib $(SG_INPUT_LIB)\cecompress.lib

binfs::fsdmgr
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\fsdmgr.lib

relfsd::fsdmgr
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\fsdmgr.lib

diskcache::fsdmgr
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\fsdmgr.lib

mspart::fsdmgr
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\fsdmgr.lib

oemfs::
        @set TARGETLIBS=$(OWNLIB)

!IFNDEF FATUTIL_COMPONENTS
FATUTIL_COMPONENTS=fatutil_main fatutil_noui
!ENDIF

fatutil::
        @set SOURCELIBS=
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib $(_COMMONOAKROOT)\lib\$(_CPUINDPATH)\storeapi.lib
fatutil::$(FATUTIL_COMPONENTS)
        @set TARGETNAME=$@
        @set RELEASETYPE=OAK
        @set DLLENTRY=DllMain
        @set DEFFILE=$(SG_INPUT_LIB)\$@.def
        $(MAKECMD) /NOLOGO $@.dll
fatutil_main:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
fatutil_noui:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
fatutil_ui:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_INPUT_LIB)\fatutil.res

uspce::
        @set TARGETLIBS=\
            $(OWNLIB_RES) \
            $(SG_INPUT_LIB)\otls.lib \
            $(SG_INPUT_LIB)\unilib.lib \
            $(SG_INPUT_LIB)\lpk.lib

# driverlib dependencies for BSP drivers
es1371:: wavemdd

HD465ohci:: HD465ohcdpdd

ceddk:: ddk_bus ddk_io ddk_map ddk_dma ddk_time ddk_power

ddi_3dr ddi_ati ddi_gx ddi_flat ddi_hflat ddi_mq200 ddi_ragexl ddi_tvia5:: ddgpe

giisr ti1250isr isr16550 ne2000isr:: ddk_io fulllibc

com16550:: com_mdd2 oo16550 serpddcm

com_card:: com_mdd2 ser16550 ser_card2

dualio:: com_mdd2 ser16550

serialusbfn:: com_mdd2 serpddcm ceddk ufnclientlib
	    @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\com_mdd2.lib $(SG_OUTPUT_OAKLIB)\serpddcm.lib $(SG_OUTPUT_OAKLIB)\ufnclientlib.lib

ohci2:: ohcdmdd2 hcdlib

uhci:: uhcdmdd hcdlib

ehci:: ehcdmdd hcd2lib

Kbd8042:: PS2_8042_KbdCommon LayoutManager KeybdIst ceddk
	@set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(SG_OUTPUT_OAKLIB)\PS2_8042_KbdCommon.lib $(SG_OUTPUT_OAKLIB)\LayoutManager.lib $(SG_OUTPUT_OAKLIB)\KeybdIst.lib

KbdNop:: Nop_KbdCommon Nop_PddList LayoutManager
	@set TARGETLIBS=$(SG_OUTPUT_OAKLIB)\Nop_KbdCommon.lib $(SG_OUTPUT_OAKLIB)\LayoutManager.lib $(SG_OUTPUT_OAKLIB)\Nop_PddList.lib

# legacy keyboard layout files

PS2_AT_00000409:: kbdus_lib
	@set KBD_BASE_FILES=kbdus_lib

PS2_AT_00000411:: kbdjpn_lib
	@set KBD_BASE_FILES=kbdjpn_lib

PS2_AT_00000412:: kbdkor_lib
	@set KBD_BASE_FILES=kbdkor_lib

PS2_AT_00010411:: kbdjpn1_lib
	@set KBD_BASE_FILES=kbdjpn1_lib

PS2_AT_00000409 PS2_AT_00000411 PS2_AT_00000412 PS2_AT_00010411::
	@echo Copying %%KBD_BASE_FILES%%.* to $@.*
	-@xcopy /I /D /Q $(SG_INPUT_LIB)\%%KBD_BASE_FILES%%.* $(SG_OUTPUT_OAKLIB)\$@.* > nul $(SG_XCOPYREDIRECT)


# keyboard layouts

kbdus:: InputLang_0409 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0409.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdjpn:: InputLang_0411 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0411.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdjpn1:: InputLang_0411 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0411.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdkor:: InputLang_0412 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0412.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbda1:: InputLang_0401 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0401.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdheb:: InputLang_040D NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_040D.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdth0:: InputLang_041E NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_041E.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdinhin:: InputLang_0439 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0439.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdinmar:: InputLang_044E NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_044E.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdinpun:: InputLang_0446 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0446.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdintel:: InputLang_044A NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_044A.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdinguj:: InputLang_0447 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0447.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdinkan:: InputLang_044B NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_044B.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbdintam:: InputLang_0449 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0449.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib

kbddv:: InputLang_0409 NumPadRmp
	@set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\InputLang_0409.lib $(SG_OUTPUT_OAKLIB)\NumPadRmp.lib


# aliases for build groups
pcmcia:: cardserv

!IF "$(_TGTCPU)" != "SH4"
pcmcia:: i82365 ti1250 ti1250isr
!ENDIF

pccard:: pcc_com pcc_serv pcc_serv16 pcc_serv32 pcc_pcm pcc_tipccard pcc_tipccard16 pcc_tipccard32 pcc_i82365

display:: ddi_3dr ddi_mq200 ddi_ragexl ddi_hflat ddi_nop

!IF "$(_TGTCPUFAMILY)" == "x86"
display:: ddi_flat ddi_rflat ddi_gx ddi_rgx
!ENDIF

8042keyboard::  Kbd8042US Kbd8042Jpn1 Kbd8042Jpn2 Kbd8042Kor Kbd8042 \
                kbdus kbdjpn kbdjpn1 kbdkor PS2_AT_00000409 PS2_AT_00000411 PS2_AT_00000412 PS2_AT_00010411

nopkeyboard::  KbdNopUS KbdNopJpn1 KbdNopJpn2 KbdNopKor KbdNop \
               kbdus kbdjpn kbdjpn1 kbdkor PS2_AT_00000409 PS2_AT_00000411 PS2_AT_00000412 PS2_AT_00010411

hidclients::  kbdhid conshid MouHid MouHidTrns

serial:: com16550 isr16550 com_card

audiodrv:: ensoniq es1371
!IF "$(_TGTCPUFAMILY)" == "x86"
audiodrv:: gxuamaud
!ENDIF

pci:: pcibus gdcfg

usbhost:: ohci2 uhci ehci

# XLLP is an Intel (ARM/XScale) library that needs to build for all OS configurations.
!IF "$(_TGTCPUFAMILY)" == "ARM"
xllp: pxa27x_xllp
csp_mininput: pxa27x_keypad
!ELSE
xllp:
csp_mininput:
!ENDIF

!IF "$(_TGTCPUFAMILY)" == "SH"
csp:: HD465parallel HD465ohci

#############################################################################################################

!ELSEIF "$(_TGTCPUFAMILY)"=="ARM"
csp:: pxa255_csp pxa27x_csp s3c2410x_csp smt926a_csp

#-------------------------------------------------------------------------------
#
# Intel PXA255 (XScale "Cotulla") CSP drivers.
#
pxa255_csp: pxa255_lcd pxa255_serial pxa255_pdd16550 pxa255_wavedev pxa25xusbfn pxa255_sdhc

pxa255_lcd pxa255_drvlib pxa255_ser16550 pxa255_serpdd::
    @echo Copying $@.*
    -@xcopy /I /D /Q $(SG_INPUT_LIB)\$@.* $(SG_OUTPUT_OAKLIB) >nul $(SG_XCOPYREDIRECT)

pxa255_serial:: com_mdd2 ser_card2 ser16550 pxa255_ser16550 pxa255_serpdd pxa255_drvlib ceddk
    @set TARGETLIBS=$(SG_OUTPUT_OAKLIB)\com_mdd2.lib $(SG_OUTPUT_OAKLIB)\ser_card2.lib \
        $(SG_OUTPUT_OAKLIB)\ser16550.lib \
        $(SG_OUTPUT_OAKLIB)\pxa255_ser16550.lib \
        $(SG_OUTPUT_OAKLIB)\pxa255_serpdd.lib \
        $(SG_OUTPUT_OAKLIB)\pxa255_drvlib.lib \
        $(SG_OUTPUT_OAKLIB)\ceddk.lib

pxa255_pdd16550:: oo16550 pxa255_drvlib ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) \
        $(SG_OUTPUT_OAKLIB)\pxa255_drvlib.lib \
        $(SG_OUTPUT_OAKLIB)\ceddk.lib \
        $(SG_OUTPUT_OAKLIB)\com_mdd2.lib \
        $(SG_OUTPUT_OAKLIB)\serpddcm.lib \
        $(SG_OUTPUT_OAKLIB)\oo16550.lib \

pxa255_wavedev:: wavemdd pxa255_drvlib
    @set TARGETLIBS=$(OWNSTATICLIB) \
        $(SG_OUTPUT_OAKLIB)\wavemdd.lib \
        $(SG_OUTPUT_OAKLIB)\pxa255_drvlib.lib


#-------------------------------------------------------------------------------
#
# Intel PXA27x (XScale "Bulverde") CSP drivers.
#
pxa27x_csp: pxa27x_xllp pxa27x_lcd pxa27x_ohci pxa27x_uart pxa27x_wavedev pxa27x_usbfn

pxa27x_ohci pxa27x_uart pxa27x_usbfn pxa27x_xllp::
    @echo Copying $@.*
    -@xcopy /I /D /Q $(SG_INPUT_LIB)\$@.* $(SG_OUTPUT_OAKLIB) >nul $(SG_XCOPYREDIRECT)

pxa27x_lcd:: pxa255_drvlib pxa27x_xllp gperotate ddgpe dxdrvguid ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) \
                    $(SG_OUTPUT_OAKLIB)\pxa255_drvlib.lib \
                    $(SG_OUTPUT_OAKLIB)\pxa27x_xllp.lib \
                    $(SG_OUTPUT_OAKLIB)\dxdrvguid.lib \
                    $(SG_OUTPUT_OAKLIB)\gperotate.lib \
                    $(SG_OUTPUT_OAKLIB)\ceddk.lib

pxa27x_keypad:: pxa27x_xllp ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) \
                    $(SG_OUTPUT_OAKLIB)\pxa27x_xllp.lib \
                    $(SG_OUTPUT_OAKLIB)\ceddk.lib

pxa27x_wavedev:: wavemdd pxa27x_xllp
    @set TARGETLIBS=$(OWNSTATICLIB) \
        $(SG_OUTPUT_OAKLIB)\wavemdd.lib \
        $(SG_OUTPUT_OAKLIB)\pxa27x_xllp.lib \
        $(SG_OUTPUT_OAKLIB)\ceddk.lib


#-------------------------------------------------------------------------------
#
# Samsung S3C2410X CSP drivers.
#
s3c2410x_csp: s3c2410x_lcd s3c2410x_serial s3c2410x_touch \
    s3c2410x_wavedev sdhc_sc2410 sc2410usbfn

s3c2410x_lcd:: gpe ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\gpe.lib $(SG_OUTPUT_OAKLIB)\ceddk.lib

s3c2410x_touch:: tchmdd tch_cal
    $(SG_TOKENFILTER) $(SG_INPUT_LIB)\$@.def $(SG_OUTPUT_OAKLIB)
    @set TARGETNAME=$@
    @set TARGETTYPE=DYNLINK
    @set RELEASETYPE=OAK
    @set CPL=
    @set SOURCELIBS=
    @set DLLENTRY=TouchPanelDllEntry
    @set DEFFILE=$(SG_OUTPUT_OAKLIB)\$@.def
    @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\tchmdd.lib $(SG_OUTPUT_OAKLIB)\tch_cal.lib $(SG_OUTPUT_SDKLIB)\coredll.lib
    $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll

s3c2410x_wavedev:: ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\ceddk.lib

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#
# SMT SMT926A CSP drivers.
#
smt926a_csp: smt926a_lcd smt926a_serial smt926a_touch \
    smt926a_wavedev sdhc_smt926 smt926usbfn

smt926a_lcd:: gpe ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\gpe.lib $(SG_OUTPUT_OAKLIB)\ceddk.lib

#smt926a_lcd:: ddgpe ceddk
#    @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\ddgpe.lib $(SG_OUTPUT_OAKLIB)\ceddk.lib

smt926a_touch:: tchmdd tch_cal
    $(SG_TOKENFILTER) $(SG_INPUT_LIB)\$@.def $(SG_OUTPUT_OAKLIB)
    @set TARGETNAME=$@
    @set TARGETTYPE=DYNLINK
    @set RELEASETYPE=OAK
    @set CPL=
    @set SOURCELIBS=
    @set DLLENTRY=TouchPanelDllEntry
    @set DEFFILE=$(SG_OUTPUT_OAKLIB)\$@.def
    @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\tchmdd.lib $(SG_OUTPUT_OAKLIB)\tch_cal.lib $(SG_OUTPUT_SDKLIB)\coredll.lib
    $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll

smt926a_wavedev:: ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) $(SG_OUTPUT_OAKLIB)\ceddk.lib

#-------------------------------------------------------------------------------

#############################################################################################################

!ELSEIF "$(_TGTCPUFAMILY)"=="MIPS"
csp:: au1csp vr4131csp

#-------------------------------------------------------------------------------
#
# AMD Au1 Alchemy CSP drivers
#

!IFDEF SYSGEN_NDIS
au1csp: au1mac au1uart au1ohcd au1ac97
!ELSE
au1csp: au1uart au1ohcd au1ac97
!ENDIF

au1mac:: ndis ceddk netmui
    @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB) $(NDISLIB)

au1uart:: com_mdd2 ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB)

au1ohcd:: ohcdmdd2 hcdlib ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB)

au1ac97:: ceddk
    @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB)

#-------------------------------------------------------------------------------
#
# NEC Vr4131 CSP drivers
#
vr4131csp: vr4131uart

vr4131uart:: com_mdd2 oo16550 serpddcm
    @set TARGETLIBS=$(OWNSTATICLIB) $(CEDDKLIB)

#############################################################################################################

!ELSE

csp::
    @echo No Chip Support Package for this CPU or CPU type

!ENDIF

#############################################################################################################

d3dmdrivers:: d3dm_nulldrv


#
#       Bluetooth stack
#
btdrt::
        @set SOURCELIBS=$(OWNLIB)
btdrt::$(BTDRT_COMPONENTS)
        @set TARGETTYPE=DYNLINK
        @set TARGETNAME=$@
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib $(SG_INPUT_LIB)\ceosutil.lib $(SG_INPUT_LIB)\btdrtstubs.lib $(SG_OUTPUT_SDKLIB)\bthguid.lib
        @set DEFFILE=$(SG_OUTPUT_OAKLIB)\$@.def
        $(SG_TOKENFILTER) $(SG_INPUT_LIB)\$@.def $(SG_OUTPUT_OAKLIB)
        @set RELEASETYPE=OAK
        @set DLLENTRY=DllMain
        @set CPL=
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll
sdpuser:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\$@.lib $(SG_INPUT_LIB)\btcomstbs.lib $(SG_INPUT_LIB)\sdpparse.lib $(SG_INPUT_LIB)\btd.lib
bthns:
        @set SOURCELIBS=%%SOURCELIBS%% $(SG_INPUT_LIB)\bthns.lib


bthusb::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ceosutil.lib
bthsdio:: sdcardlib ceddk sdbus
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB) $(SG_INPUT_LIB)\ceosutil.lib $(SG_OUTPUT_OAKLIB)\sdcardlib.lib $(SG_OUTPUT_OAKLIB)\sdbus.lib
bthuart::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ceosutil.lib
bthamb::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ceosutil.lib
bthcsr::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\bcsp.lib $(SG_INPUT_LIB)\ceosutil.lib
bthsc::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ceosutil.lib
bthuniv::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ceosutil.lib
wendyser:: ceddk
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB)
sio950:: ceddk
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB)
wcestreambt:: ceddk
        @set TARGETLIBS=$(OWNLIB) $(CEDDKLIB)
btloader::
        @set TARGETLIBS=$(OWNLIB)
btgw::btdrt winsock
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\btdrt.lib $(WINSOCKLIB)
btsvc::btdrt
        @set TARGETLIBS=$(OWNLIB) $(OWNRES) $(SG_INPUT_LIB)\btenum.lib $(SG_OUTPUT_OAKLIB)\btdrt.lib $(SG_INPUT_LIB)\ceosutil.lib
btmodem::btdrt
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\btdrt.lib $(SG_INPUT_LIB)\ceosutil.lib
btscosnd::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ceosutil.lib
btdun::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\ceosutil.lib
bthhid:: hidparse btdrt btd hidmdd
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\bthhidc.lib $(SG_INPUT_LIB)\btcomstbs.lib $(SG_OUTPUT_SDKLIB)\btd.lib $(SG_OUTPUT_OAKLIB)\btdrt.lib $(SG_OUTPUT_OAKLIB)\hidparse.lib $(SG_INPUT_LIB)\ceosutil.lib $(SG_OUTPUT_OAKLIB)\hidmdd.lib


osbenchpsl::
        @set TARGETLIBS=$(OWNLIB)
osbench_dll:: osbenchpsl
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\osbenchpsl.lib
osbench:: osbenchpsl osbench_dll
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\osbenchpsl.lib
iltiming_dll::
        @set TARGETLIBS=$(OWNLIB)
iltiming:: iltiming_dll
        @set TARGETLIBS=$(OWNLIB)


ime:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(SG_OUTPUT_SDKLIB)\commctrl.lib

connmc:: commctrl iphlpapi ws2
        @set TARGETLIBS=$(OWNLIB) $(OWNLIB_RES) $(CCLIB) $(WS2LIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib
rnaapp::
        @set TARGETLIBS=$(OWNLIB_RES) $(SG_INPUT_LIB)\tapihelp.lib
pegterm:: termctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(SG_INPUT_LIB)\tapihelp.lib $(SG_OUTPUT_OAKLIB)\termctrl.lib
ping:: ws2 iphlpapi
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WS2LIB)
netstat:: winsock iphlpapi
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WINSOCKLIB)
rasentry:: winsock cxport
        @set TARGETLIBS=$(OWNLIB) $(CXPORT_CCLIBS) $(WINSOCKLIB)
ndisconfig::
	@set TARGETLIBS=$(OWNLIB)
ipconfig::  iphlpapi ws2
        @set TARGETLIBS= $(OWNLIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WS2LIB)
netlogctl::
        @set TARGETLIBS= $(OWNLIB)

netlog::  ndis
        @set TARGETLIBS= $(OWNLIB) $(NDISLIB)

tracert::  iphlpapi ws2
        @set TARGETLIBS= $(OWNLIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WS2LIB)
wzctool::  wzcsapi
	@set TARGETLIBS= $(OWNLIB) $(SG_OUTPUT_OAKLIB)\wzcsapi.lib
netui:: iphlpapi btdrt ws2
        @set TARGETLIBS= $(OWNLIB_RES) $(SG_INPUT_LIB)\btenum.lib $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(SG_OUTPUT_OAKLIB)\btdrt.lib $(WS2LIB)
netmui::
        @set TARGETLIBS= $(OWNLIB_RES)
ethman:: netui iphlpapi ws2
        @set TARGETLIBS= $(OWNLIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WS2LIB)
route:: winsock iphlpapi
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\iphlpapi.lib $(WINSOCKLIB)
pcl:: prnport
        @set TARGETLIBS=$(SG_INPUT_LIB)\pcllib.lib $(SG_OUTPUT_OAKLIB)\prnport.lib
prnport:: prnerr winsock
        @set TARGETLIBS=$(WINSOCKLIB) $(SG_INPUT_LIB)\prnportl.lib $(SG_OUTPUT_OAKLIB)\prnerr.lib
wavesamples: wavplay wavrec capsrc
wavplay wavrec capsrc::
		@set TARGETLIBS=$(OWNLIB)
cmdbar dbview generic polygons reversi rmonkey spincube inksamp inksamp2:: commctrl
        @set TARGETLIBS=$(OWNLIB) $(OWNLIB_RES) $(SG_OUTPUT_SDKLIB)\commctrl.lib
spintest:: commctrl spincube
        @set TARGETLIBS=$(OWNLIB) $(OWNLIB_RES) $(SG_OUTPUT_SDKLIB)\commctrl.lib $(SG_OUTPUT_OAKLIB)\spincube.lib
tapi hello kbdtest text etcha::
        @set TARGETLIBS=$(OWNLIB)
unimodem::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\unimodem.res $(SG_INPUT_LIB)\unimodemnl.res
msim:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(SG_OUTPUT_SDKLIB)\commctrl.lib
LargeKB::
        @set TARGETLIBS=$(OWNLIB_RES)
enroll:: crypt32
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_SDKLIB)\crypt32.lib
sipselect:: commctrl
        @set TARGETLIBS=$(OWNLIB) $(CCLIB) $(OWNLIB_RES)
cacjpn:: commctrl hwxjpn
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB) $(SG_OUTPUT_OAKLIB)\hwxjpn.lib
multibox:: commctrl hwxjpn
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB) $(SG_OUTPUT_OAKLIB)\hwxjpn.lib
mboxkor:: commctrl hwxkor
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB) $(SG_OUTPUT_OAKLIB)\hwxkor.lib
mboxcht:: commctrl hwxcht
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB) $(SG_OUTPUT_OAKLIB)\hwxcht.lib
chajeiim::
        @set TARGETLIBS=$(OWNLIB_RES)
phonim::
        @set TARGETLIBS=$(OWNLIB_RES)
testime:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(SG_OUTPUT_SDKLIB)\commctrl.lib
imeskdic:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB)
mskana:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB)
msroma:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB)
msallchar:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB) $(SG_INPUT_LIB)\plv.lib $(SG_INPUT_LIB)\ptv.lib $(SG_INPUT_LIB)\ptt.lib $(SG_INPUT_LIB)\ptlv.lib $(SG_INPUT_LIB)\ddbtn.lib $(SG_INPUT_LIB)\stub_ce.lib
msradlist:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB) $(SG_INPUT_LIB)\plv.lib $(SG_INPUT_LIB)\ptv.lib $(SG_INPUT_LIB)\ptt.lib $(SG_INPUT_LIB)\ptlv.lib $(SG_INPUT_LIB)\ddbtn.lib $(SG_INPUT_LIB)\stub_ce.lib
msstrklist:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB) $(SG_INPUT_LIB)\plv.lib $(SG_INPUT_LIB)\ptv.lib $(SG_INPUT_LIB)\ptt.lib $(SG_INPUT_LIB)\ptlv.lib $(SG_INPUT_LIB)\ddbtn.lib $(SG_INPUT_LIB)\stub_ce.lib
lpcd::
        @set TARGETLIBS=$(OWNLIB) $(SG_INPUT_LIB)\lpcmain.lib $(SG_INPUT_LIB)\ceosutil.lib $(SG_INPUT_LIB)\rsa32.lib
lpcrt::
        @set TARGETLIBS=$(SG_INPUT_LIB)\lpcclnt.lib
snmp::  winsock snmpapi
        @set TARGETLIBS=$(OWNLIB) $(WINSOCKLIB) $(SG_OUTPUT_OAKLIB)\snmpapi.lib
snmp_mibii:: snmp winsock snmpapi iphlpapi
        @set TARGETLIBS=$(OWNLIB) $(WINSOCKLIB) $(SG_OUTPUT_OAKLIB)\snmpapi.lib $(SG_OUTPUT_SDKLIB)\iphlpapi.lib
snmp_hostmib:: snmp snmpapi winsock toolhelp
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\snmpapi.lib $(WINSOCKLIB) $(SG_OUTPUT_SDKLIB)\toolhelp.lib
snmp_snmptestmib:: snmp winsock snmpapi
        @set TARGETLIBS=$(OWNLIB) $(WINSOCKLIB) $(SG_OUTPUT_OAKLIB)\snmpapi.lib
snmpapi:: winsock
        @set TARGETLIBS=$(OWNLIB) $(WINSOCKLIB)
wldap32::  winsock
        @set TARGETLIBS=$(OWNLIB_RES) $(WINSOCKLIB)

softkb::
        @set TARGETLIBS=$(OWNLIB)
bridge::
        @set TARGETLIBS= $(SG_INPUT_LIB)\bridgexe.lib

gb18030::
        @set TARGETLIBS=$(OWNLIB)

#
# IMEJP 3.1
#
imjp31k:: commctrl
        @set TARGETLIBS=\
             $(OWNLIB_RES) $(CCLIB) \
             $(SG_INPUT_LIB)\imjp31_slm2.lib $(SG_INPUT_LIB)\imjp31_vqcomp.lib $(SG_INPUT_LIB)\imjp31_defs.lib \
             $(SG_INPUT_LIB)\imjp31_udman.lib $(SG_INPUT_LIB)\imjp31_iusrdict.lib $(SG_INPUT_LIB)\imjp31_isysdict.lib \
             $(SG_INPUT_LIB)\imjp31_misc.lib $(SG_INPUT_LIB)\imjp31_opendct.lib $(SG_INPUT_LIB)\imjp31_fedictmisc.lib \
             $(SG_INPUT_LIB)\imjp31_propmgr.lib $(SG_INPUT_LIB)\imjp31k_apimgr.lib $(SG_INPUT_LIB)\imjp31k_ipoint.lib \
             $(SG_INPUT_LIB)\imjp31k_inpmgr.lib $(SG_INPUT_LIB)\imjp31k_regmgr.lib $(SG_INPUT_LIB)\imjp31k_ijconv.lib \
             $(SG_INPUT_LIB)\imjp31k_iphrase.lib $(SG_INPUT_LIB)\imjp31k_ijkbd.lib $(SG_INPUT_LIB)\imjp31k_iconvert.lib \
             $(SG_INPUT_LIB)\imjp31k_cnvmgr.lib $(SG_INPUT_LIB)\imjp31_dictype.lib $(SG_INPUT_LIB)\imjp31_imemdict.lib \
             $(SG_INPUT_LIB)\imjp31k_ifelang.lib $(SG_INPUT_LIB)\imjp31k_ifecom.lib $(SG_INPUT_LIB)\imjp31k_banri.lib \
             $(SG_INPUT_LIB)\imjp31_sharemem.lib $(SG_INPUT_LIB)\imjp31_filemap.lib \
             $(SG_INPUT_LIB)\imjp31t.lib
imjp31:: imjp31k commctrl
        @set TARGETLIBS=\
             $(OWNLIB_RES) $(CCLIB) \
             $(SG_INPUT_LIB)\imjp31_misc.lib $(SG_INPUT_LIB)\imjp31_opendct.lib $(SG_INPUT_LIB)\imjp31_propmgr.lib \
             $(SG_INPUT_LIB)\imjp31_sharemem.lib $(SG_INPUT_LIB)\imjp31_ime_common.lib $(SG_INPUT_LIB)\imjp31_candwnd.lib \
             $(SG_INPUT_LIB)\imjp31_globalflag.lib $(SG_INPUT_LIB)\imjp31_ui_pop_stub.lib $(SG_INPUT_LIB)\imjp31_ui_delword_stub.lib \
             $(SG_INPUT_LIB)\imjp31_ui_hideoff.lib \
             $(SG_INPUT_LIB)\$(IMEJPN_SKINNABLEUI_COMPONENT).lib $(SG_INPUT_LIB)\$(IMEJPN_SKINNABLEUI_COMPONENT).res \
             $(SG_OUTPUT_OAKLIB)\imjp31k.lib \
             $(SG_INPUT_LIB)\imjp31t.lib
imjp31m:: commctrl
        @set TARGETLIBS=\
             $(OWNLIB_RES) $(CCLIB) \
             $(SG_INPUT_LIB)\imjp31t.lib
imjp31ux:: commctrl
        @set TARGETLIBS=\
             $(OWNLIB_RES) $(CCLIB) \
             $(SG_INPUT_LIB)\imjp31_propmgr.lib $(SG_INPUT_LIB)\imjp31_sharemem.lib \
             $(SG_INPUT_LIB)\imjp31t.lib
imjp31u:: commctrl
        @set TARGETLIBS=\
             $(OWNLIB_RES) $(CCLIB) \
             $(SG_INPUT_LIB)\imjp31_misc.lib $(SG_INPUT_LIB)\imjp31_propmgr.lib $(SG_INPUT_LIB)\imjp31_sharemem.lib \
             $(SG_INPUT_LIB)\imjp31_dictype.lib $(SG_INPUT_LIB)\imjp31_opendct.lib \
             $(SG_INPUT_LIB)\imjp31t.lib
imjp31u_q:: commctrl
        @set TARGETLIBS=\
             $(OWNLIB_RES) $(CCLIB) \
             $(SG_INPUT_LIB)\imjp31_misc.lib $(SG_INPUT_LIB)\imjp31_propmgr.lib $(SG_INPUT_LIB)\imjp31_sharemem.lib \
             $(SG_INPUT_LIB)\imjp31_dictype.lib \
             $(SG_INPUT_LIB)\imjp31t.lib
imjp31dx:: commctrl
        @set TARGETLIBS=\
             $(OWNLIB_RES) $(CCLIB) \
             $(SG_INPUT_LIB)\imjp31_misc.lib $(SG_INPUT_LIB)\imjp31_propmgr.lib $(SG_INPUT_LIB)\imjp31_sharemem.lib \
             $(SG_INPUT_LIB)\imjp31dx_data.lib $(SG_INPUT_LIB)\imjp31dx_ui.lib $(SG_INPUT_LIB)\imjp31dx_util.lib $(SG_INPUT_LIB)\imjp31dx_ctext.lib \
             $(SG_INPUT_LIB)\imjp31t.lib
imjp31dx_q:: commctrl
        @set TARGETLIBS=\
             $(SG_INPUT_LIB)\$(IMEJPN_DICTIONARY_TOOL_PORTRAIT_COMPONENT).lib $(SG_INPUT_LIB)\$(IMEJPN_DICTIONARY_TOOL_PORTRAIT_COMPONENT).res $(CCLIB) \
             $(SG_INPUT_LIB)\imjp31t.lib
imjp31c:: commctrl
        @set TARGETLIBS=\
             $(OWNLIB_RES) $(CCLIB) \
             $(SG_INPUT_LIB)\imjp31_misc.lib $(SG_INPUT_LIB)\imjp31_propmgr.lib $(SG_INPUT_LIB)\imjp31_sharemem.lib \
             $(SG_INPUT_LIB)\imjp31t.lib

imjp31_dics_compact::
imjp31_dics_std::

#
# pIME
#
imejpp:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB) $(SG_INPUT_LIB)\imemisc.lib

imejppui:: commctrl
        @set TARGETLIBS=$(OWNLIB_RES) $(CCLIB)

imejpp_dic_s::

imejpp_dic_n::

#
# HWX and Spell
#
hwxcht hwxjpn hwxkor hwxusa::
        @set TARGETLIBS=$(OWNLIB) $(OWNLIB_RES)

splusa::
        @set TARGETLIBS=$(OWNLIB)

#
# !!GENERIC EASILY SHAREABLE RULES!!
#
termctrl console cmd commdlg prnerr \
cegsm gsm610 msfilter net rezmeter::
        @set TARGETLIBS=$(OWNLIB_RES)


tktest regdump usrexceptdmp prtscrn fsreset commctr::
        @set TARGETLIBS=$(OWNLIB)

#
# 1394 / WDM
#

setupapi::
        @set TARGETLIBS=$(OWNSTATICLIB)

wdmlib:: ceddk
        @set TARGETLIBS=$(OWNSTATICLIB) \
        $(SG_INPUT_LIB)\wdmhal.lib \
        $(SG_INPUT_LIB)\wdmutil.lib \
        $(CEDDKLIB) \
        $(CXPORT_CCLIBS)

cewdmmgr 1394bus oemohci 1394ohcd \
sbp2 61883 avc avc_stream avc_unit avc_vcr \
avc_vvcr 1394dcam virtdcam 1394diag 1394vdev:: wdmlib
        @set TARGETLIBS=$(OWNSTATICLIB) \
        $(SG_OUTPUT_OAKLIB)\wdmlib.lib \
        $(SG_INPUT_LIB)\wdmutil.lib

cewdmmgr 1394ohcd:: ceddk
        @set TARGETLIBS=%%TARGETLIBS%% $(CEDDKLIB)

scsiblk:: setupapi wdmlib
        @set TARGETLIBS=$(OWNSTATICLIB) \
            $(SG_OUTPUT_OAKLIB)\setupapi.lib \
            $(SG_OUTPUT_OAKLIB)\wdmlib.lib \
            $(SG_INPUT_LIB)\wdmutil.lib


oemohci::
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_INPUT_LIB)\mstv1394.lib

1394ohcd oemohci:: 1394bus
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_OUTPUT_OAKLIB)\1394bus.lib

avc_vvcr:: avc_unit
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_OUTPUT_OAKLIB)\avc_unit.lib

topomap:: setupapi
        @set TARGETLIBS=$(OWNLIB) $(SG_OUTPUT_OAKLIB)\setupapi.lib

#
# camera
#

nullcam::
        @set TARGETLIBS=$(OWNLIB)



###############################################################################
#
# STEP-2: Initialization. All modules should be listed in this rule
#
###############################################################################

ne2000 islp2nds pxa25xusbfn sc2410usbfn smt926usbfn smsc100fd elnk3 sisnic ieepro xircce3 pcx500 pegasSDN RTL8180wf irdastk irsir ircomm msasn1 certui schannel ssllsp ntlmssp cryptdll kerberos spnego kdccore \
rtl8139 e100bex dp83815 vmini tunmp mbridge ndispwr ndisuio wzcsapi wzcsvc 80211sim nwifi wlclient wlsvc oneex autoras tcpip6 tcpstk ppp pptp l2tp pppoe asyncmac eap eapchap eaptls eapol redir netbios dhcp ipnat autodial scard pscr bulltlp3 stcusb \
ime msim largekb enroll cacjpn multibox mboxkor mboxcht chajeiim phoneim testime tapi unimodem termctrl pegterm connmc ping ipconfig tracert ndisconfig bridge route rasentry rasdial rnaapp netstat \
cmdbar dbview generic polygons reversi rmonkey spincube spintest wzctool \
hello kbdtest text etcha inksamp inksamp2 imeskdic mskana msallchar msradlist msroma msstrklist \
console cmd net shell netui netmui ethman cegsm gsm610 msfilter pcl prnerr prnport \
imjp31k imjp31 imjp31m imjp31ux imjp31u imjp31u_q imjp31dx imjp31dx_q imjp31c \
nspm dhcpv6l \
imejpp imejppui iltiming iltiming_dll osbench osbench_dll osbenchpsl \
snmp snmpapi snmp_hostmib snmp_mibii snmp_snmptestmib \
setupapi wdmlib cewdmmgr 1394bus 1394ohcd oemohci sbp2 scsiblk 61883 avc avc_unit avc_stream avc_vcr avc_vvcr 1394dcam virtdcam 1394diag 1394vdev topomap \
pvbload pvbhost pvbform pdm vbrmon lpcd lpcrt softkb scwcspgui ws2instl wspm \
bthusb bthsdio bthuart bthamb bthsc bthcsr bthuniv btsvc btmodem btscosnd btdun bthhid \
wendyser sio950 wcestreambt btloader btgw rndismp usb8023 multimon \
i82365 ti1250 pcc_tipccard pcc_tipccard16 pcc_tipccard32 pcc_i82365 pcc_serv pcc_serv16 pcc_serv32 pcc_pcm \
pxa255_wavedev pxa255_serial pxa255_pdd16550 \
s3c2410x_usb_device s3c2410x_wavedev s3c2410x_lcd sdhc_sc2410 pxa27x_lcd pxa27x_keypad pxa27x_wavedev \
smt926a_usb_device smt926a_wavedev smt926a_lcd sdhc_smt926 \
pxa255_sdhc \
atapi atadisk \
gpe ddi_3dr ddi_ati ddi_gx ddi_mq200 ddi_perm3 ddi_perm3_swg ddi_ragexl ddi_s3v ddi_tvia5 perm3_cfg \
ddi_flat ddi_rflat ddi_rgx ddi_hflat ddi_nop \
ceddk gdcfg \
giisr ti1250isr isr16550 ne2000isr pcibus parallel ramdisk regenum enumfaslpci busenum mspart udfs fatfsd tfat fatutil relfsd binfs rawfs diskcache oemfs battdrvr nleddrvr \
Kbd8042US Kbd8042Jpn1 Kbd8042Jpn2 Kbd8042Kor Kbd8042 \
KbdNopUS KbdNopJpn1 KbdNopJpn2 KbdNopKor KbdNop \
kbdus kbdjpn kbdjpn1 kbdkor kbda1 kbdheb kbdth0 kbdinhin kbdinmar kbdinpun kbdintel kbdinguj kbdinkan kbdintam kbddv \
usbmsfn rndisfn net2280 com16550 com_card trueffs usbhid kbdhid mouhid MouHidTrns conshid hidparse usbprn usbmsc usbdisk6 ohci2 uhci ehci usbd ensoniq es1371 gxuamaud \
sdbus sdhc ellencfg \
sdmemory \
HD465parallel HD465ohci serialusbfn celogflush oscapture shellcelog coversrv ceramdrv stratad fasld ramfmd \
wavrec wavplay capsrc ipv6hlp ipv6 ipv6tun zlib ipsec credsvc credprov ipsecsvc eventlog eventlogmsgs \
hwxcht hwxjpn hwxkor hwxusa splusa tktest rezmeter regdump usrexceptdmp prtscrn fsreset gb18030 lmemdebug cerdisp d3dm_nulldrv lassd lap_pw netlog netlogctl nullcam \
dhcpsrv veim ipseccfg::
        @set RELEASETYPE=OAK
        @set CPL=

fw6 fwapi \
commdlg ndis toolhelp secur32 winscard mmtimer iphlpapi scwapi wldap32 dnsapi netapi32 uspce::
        @set RELEASETYPE=SDK
        @set CPL=

#################################################################################################
# STEP-3: Hack for .CPLs only! If (and only if) your module needs to be renamed from .DLL to .CPL
###################################################################################
ime certui::
        @set CPL=1

###################################################################################
#
# STEP-4: Add your module to exactly ONE of the following rules, choosing your
#         DLL or EXE entry point. NOTE: DO NOT create new rules
#
# DllEntry/DllMain -- calls entry supplied by module. Does NOT call C++ static ctors/dtors
# DllMainCRTStartup - calls C++ static ctors & dtors. Then calls module's DllMain
# WinMain -- calls module's standard EXE entry point. Does NOT call C++ static ctors/dtors
# WinMainCRTStartup -- Calls C++ static ctors, then calls module's WinMain
# mainWCRTStartup -- for console apps whose entry is wmain(int argc, WCHAR **argv). Also calls C++ ctors/dtors
# mainACRTStartup -- for console apps whose entry is main(int argc, char **argv). Also calls C++ ctors/dtors
#
###################################################################################

cegsm gsm610 commdlg console dhcp elnk3 sisnic ieepro pcx500 RTL8180wf \
ime iphlpapi ipnat autodial ircomm irdastk irsir lpcd lpcrt msfilter msim largekb \
ndis ne2000 islp2nds smsc100fd rtl8139 e100bex dp83815 vmini tunmp mbridge ndispwr ndisuio \
wzcsapi wzcsvc nwifi wlclient wlsvc oneex autoras netbios dhcpv6l \
netui netmui ethman ntlmssp ppp pptp l2tp pppoe asyncmac eap eapchap eapol redir certui schannel snmpapi snmp_hostmib snmp \
iltiming_dll nspm osbench_dll pscr bulltlp3 stcusb stratad fasld ramfmd \
tapi tcpip6 tcpstk termctrl testime unimodem ws2instl wspm xircce3 softkb rndismp usb8023 \
i82365 ti1250 pcc_i82365 pcc_tipccard pcc_tipccard16 pcc_tipccard32 pcc_serv pcc_serv16 pcc_serv32 pcc_pcm \
giisr ti1250isr isr16550 ne2000isr usbmsfn rndisfn com16550 com_card net2280 \
pxa25xusbfn sc2410usbfn smt926usbfn \
vr4131uart au1uart \
serialusbfn usbhid kbdhid mouhid MouHidTrns conshid hidparse usbprn usbmsc usbdisk6 sdnpcid \
pxa255_pdd16550 busenum \
sdbus sdhc ellencfg \
sdhc_sc2410 \
sdhc_smt926 \
pxa255_sdhc \
sdmemory \
es1371 lmemdebug ipv6hlp ipsecsvc bthcsr eventlog eventlogmsgs dnsapi netapi32::
        @set DLLENTRY=DllEntry

pcl prnerr \
setupapi \
prnport snmp_mibii snmp_snmptestmib wldap32 msasn1 cryptdll ssllsp kerberos eaptls imeskdic mskana msallchar msradlist msroma msstrklist scwapi bthuniv wendyser sio950 wcestreambt pegasSDN \
atapi atadisk \
s3c2410x_usb_device s3c2410x_wavedev \
smt926a_usb_device smt926a_wavedev \
pxa255_serial pxa255_wavedev pxa27x_wavedev pxa27x_keypad \
pcibus perm3_cfg ceddk gdcfg battdrvr nleddrvr \
fwapi cewdmmgr 1394bus \
mmtimer parallel ramdisk enumfaslpci regenum ohci2 uhci ehci usbd ensoniq gxuamaud mspart udfs fatfsd tfat relfsd fatutil binfs rawfs diskcache oemfs \
Kbd8042US Kbd8042Jpn1 Kbd8042Jpn2 Kbd8042Kor Kbd8042 \
KbdNopUS KbdNopJpn1 KbdNopJpn2 KbdNopKor KbdNop ipsec \
kbdus kbdjpn kbdjpn1 kbdkor kbda1 kbdheb kbdth0 kbdinhin kbdinmar kbdinpun kbdintel kbdinguj kbdinkan kbdintam kbddv \
au1mac au1ohcd au1ac97 \
HD465parallel HD465ohci hwxcht hwxjpn hwxkor hwxusa splusa gb18030 shellcelog nullcam::
    @set DLLENTRY=DllMain

imjp31 imjp31k imjp31u imjp31u_q imjp31c \
imejpp imejppui pdm pvbform pvbhost secur32 kdccore spnego spincube toolhelp zlib \
vbrmon cacjpn multibox mboxkor mboxcht chajeiim phonim bthusb bthsdio bthuart bthamb bthsc multimon btsvc btmodem btscosnd btdun bthhid scwcspgui \
fw6 scard winscard credsvc credprov lassd lap_pw \
s3c2410x_lcd smt926a_lcd pxa27x_lcd \
ddi_mq200 ddi_3dr ddi_ati ddi_gx ddi_tvia5 ddi_perm3 ddi_perm3_swg ddi_flat ddi_ragexl ddi_rflat ddi_rgx ddi_hflat ddi_nop d3dm_nulldrv netlog dhcpsrv veim::
    @set DLLENTRY=_DllMainCRTStartup

wdmlib::
    @set DLLENTRY=WDMLibDllMain

uspce::
    @set DLLENTRY=UspDllControl

1394ohcd oemohci \
sbp2 61883 avc avc_stream avc_unit avc_vcr \
1394dcam virtdcam 1394diag 1394vdev \
scsiblk avc_vvcr::
    @set DLLENTRY=WDM1394DllMain

# This DLL entry is for TrueFFS ONLY!
trueffs::
    @set DLLENTRY=TFFSdiskEntry

cmdbar dbview etcha inksamp inksamp2 generic hello kbdtest memtool \
pegterm polygons pvbload connmc reversi rmonkey \
topomap \
wavrec wavplay capsrc \
rnaapp ndisconfig spintest text imjp31m imjp31ux imjp31dx imjp31dx_q iltiming osbench enroll sipselect celogflush oscapture coversrv rezmeter regdump usrexceptdmp prtscrn cerdisp::
        @set EXEENTRY=WinMain

netstat shell ceramdrv fsreset::
        @set EXEENTRY=main

cmd net ping ipconfig tracert wzctool bridge route rasentry rasdial btloader btgw tktest loaddbg ipv6 ipv6tun netlogctl ipseccfg::
        @set EXEENTRY=mainWCRTStartup

##############################################################################
# STEP-5: Add your module to exactly ONE of the following rules.
#                 DO NOT create new rules.
##############################################################################


#
# This is the standard rule for DLLs
#
cegsm gsm610 commdlg console dhcp dhcpv6l elnk3 sisnic ieepro ime \
imejpp imejppui iphlpapi ipnat autodial ircomm irdastk irsir lpcd lpcrt msfilter \
imjp31k imjp31 imjp31u imjp31u_q imjp31c \
fw6 fwapi lassd lap_pw netlog \
msim largekb ndis ne2000 islp2nds smsc100fd pscr bulltlp3 stcusb scard scwapi scwcspgui winscard  \
rtl8139 e100bex dp83815 vmini tunmp mbridge ndispwr ndisuio wzcsapi wzcsvc nwifi wlclient wlsvc oneex autoras netbios netui netmui ethman ntlmssp cryptdll kerberos spnego kdccore pcl pdm ppp pptp l2tp pppoe asyncmac eap eapchap eaptls eapol prnerr prnport pvbform \
pvbhost redir msasn1 certui schannel ssllsp secur32 snmp snmpapi snmp_hostmib snmp_mibii snmp_snmptestmib wldap32 spincube \
tapi tcpip6 tcpstk termctrl testime cacjpn multibox mboxkor mboxcht chajeiim phonim toolhelp zlib unimodem ws2instl nspm wspm vbrmon xircce3 imeskdic mskana msallchar msradlist msroma msstrklist \
setupapi wdmlib cewdmmgr 1394bus 1394ohcd oemohci sbp2 scsiblk 61883 avc avc_unit avc_stream avc_vcr avc_vvcr 1394dcam virtdcam 1394diag 1394vdev \
iltiming_dll osbench_dll softkb bthusb bthsdio bthuniv bthuart bthamb bthsc bthcsr wendyser sio950 wcestreambt rndismp usb8023 multimon btsvc btmodem btscosnd btdun bthhid pcx500 pegasSDN RTL8180wf \
i82365 ti1250 ti1250 pcc_i82365 pcc_tipccard pcc_tipccard16 pcc_tipccard32 pcc_serv pcc_serv16 pcc_serv32 pcc_pcm \
atapi atadisk pcibus \
ddi_3dr ddi_ati ddi_flat ddi_gx ddi_mq200 ddi_perm3 ddi_perm3_swg perm3_cfg ddi_ragexl ddi_rflat ddi_rgx ddi_s3v ddi_tvia5 ddi_hflat ddi_nop \
ceddk gdcfg battdrvr nleddrvr \
mmtimer parallel ramdisk regenum enumfaslpci busenum usbmsfn rndisfn com16550 com_card trueffs net2280 \
pxa255_wavedev pxa255_serial pxa255_pdd16550 pxa25xusbfn \
s3c2410x_usb_device s3c2410x_wavedev s3c2410x_lcd sc2410usbfn sdhc_sc2410 pxa27x_lcd pxa27x_keypad pxa27x_wavedev \
smt926a_usb_device smt926a_wavedev smt926a_lcd smt926usbfn sdhc_smt926 \
pxa255_sdhc \
serialusbfn usbhid kbdhid MouHid MouHidTrns conshid hidparse usbmsc usbdisk6 mspart udfs fatfsd tfat binfs relfsd rawfs fatutil diskcache oemfs \
sdbus sdhc ellencfg \
sdmemory \
ohci2 uhci ehci usbd usbprn ensoniq es1371 gxuamaud HD465parallel HD465ohci sdnpcid stratad fasld ramfmd \
TraRecoDeu TraRecoEnu TraRecoFra CalligDeu CalligEnu CalligFra  \
Kbd8042US Kbd8042Jpn1 Kbd8042Jpn2 Kbd8042Kor Kbd8042 \
kbdus kbdjpn kbdjpn1 kbdkor kbda1 kbdheb kbdth0 kbdinhin kbdinmar kbdinpun kbdintel kbdinguj kbdinkan kbdintam kbddv \
KbdNopUS KbdNopJpn1 KbdNopJpn2 KbdNopKor KbdNop credsvc credprov ipsec ipsecsvc \
au1mac au1uart au1ohcd au1ac97 vr4131uart \
hwxcht hwxjpn hwxkor hwxusa splusa gb18030 lmemdebug ipv6hlp d3dm_nulldrv eventlog eventlogmsgs dnsapi netapi32 uspce shellcelog nullcam \
dhcpsrv veim::
        @set TARGETTYPE=DYNLINK
        @set DEFFILE=$(SG_INPUT_LIB)\$@.def
        @set TARGETLIBS=%%TARGETLIBS%% $(SG_OUTPUT_SDKLIB)\coredll.lib
        @set SOURCELIBS=
        @set TARGETNAME=$@
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll

#
# Use this rule for targets which should not have coredll automatically
# added to their target library list. For example, installable ISR DLLs that
# are linked during sysgen cannot have dependencies on coredll because they
# are loaded inside the kernel; such libraries are not allowed to have import
# dependencies.
#
giisr ti1250isr isr16550 ne2000isr::
        @set TARGETTYPE=DYNLINK
        @set DEFFILE=$(SG_INPUT_LIB)\$@.def
        @set TARGETLIBS=%%TARGETLIBS%%
        @set SOURCELIBS=
        @set TARGETNAME=$@
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.dll


#
# This is the standard rule for EXEs
#
cmd cmdbar dbview etcha inksamp inksamp2 generic hello ipconfig tracert ndisconfig wzctool bridge route kbdtest loaddbg \
memtool net netstat pegterm ping polygons pvbload rasdial netlogctl \
imjp31m imjp31ux imjp31dx imjp31dx_q \
rasentry connmc reversi rmonkey rnaapp shell spintest text \
topomap \
wavrec wavplay capsrc ipv6 ipv6tun \
iltiming osbench enroll sipselect btloader btgw celogflush oscapture coversrv ceramdrv tktest rezmeter \
regdump usrexceptdmp prtscrn fsreset cerdisp ipseccfg::
        @set TARGETTYPE=PROGRAM
        @set TARGETLIBS=$(SG_OUTPUT_SDKLIB)\coredll.lib %%TARGETLIBS%%
        @set SOURCELIBS=
        @set TARGETNAME=$@
        $(MAKECMD) /NOLOGO $(SG_OUTPUT_OAKTGT)\$@.exe


######################################################################################
# STEP-6: If (and only if) your module has a localizable RES file, add it to the first
#         line below. This creates a text file that is used during MAKEIMG to insert
#         the correct localized resources.
######################################################################################

cegsm gsm610 cmd commdlg console fatfs filesys msfilter msim lap_pw \
netui btsvc netmui pegterm prnerr connmc rnaapp crypt32 softkb tapi termctrl \
unimodem waveapi net spintest spincube i82365 ti1250 fatutil eventlog eventlogmsgs::
        @echo $@ >> $(SG_OUTPUT_OAKTGT)\common.loc

!IF "$(CURRENT_LANGID)" == "0409"
gwes::
        @echo $@ >> $(SG_OUTPUT_OAKTGT)\common.loc

coredll::
        @echo $@ >> $(SG_OUTPUT_OAKTGT)\common.loc

commctrl::
        @echo $@ >> $(SG_OUTPUT_OAKTGT)\common.loc

!ENDIF

#################### END of 6-STEP standardized default SYSGEN LINK PHASE ######################


