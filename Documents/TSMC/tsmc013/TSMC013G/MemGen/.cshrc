# @(#)cshrc Version 2nd.Jan.2004. by H.S.Hong
umask 022
if ( $?prompt ) then
	set history=32
endif
setenv LANG C

set path=(/bin /usr/bin /usr/ccs/lib /usr/ccs/bin /usr/ucb  /usr/sbin /usr/openwin/bin /usr/ucb /usr/local/bin /etc /user/hshong/bin /user/sjseo/scr /usr/local/bin .)
setenv MANPATH /usr/man:/usr/local/man:/Stools/syn_vV-2004.06-1/doc/syn/man
if ( $?prompt ) then
        set history=32
endif

setenv XKeysymDB /Stools/Y/install/bin.sun4v/XKeysymDB
setenv LM_LICENSE_FILE /Stools/license/license.dat.cadence
setenv LM_LICENSE_FILE $LM_LICENSE_FILE/:/Stools/license/license.dat.t
#setenv LM_LICENSE_FILE $LM_LICENSE_FILE/:/Stools/license/license.dat.arm
#setenv LM_LICENSE_FILE $LM_LICENSE_FILE/:/Stools/license/license.dat.cadence
#setenv LM_LICENSE_FILE $LM_LICENSE_FILE/:/Stools/license/license.dat.mti
#setenv LM_LICENSE_FILE $LM_LICENSE_FILE/:/Stools/license/license.dat.syntest

########################################################################NASSDA2.0
set path = ( $path /Stools/nassda2.0/bin)

##########################################################################FPC
set path = ( $path  /Stools/fpc_vV-2003.12-SP1/sparcOS5/fpc/bin)


##########################################################################MAGMA
setenv MAGMA /Stools/blast4.1_Mar_17_2004
set path = ( $path  $MAGMA/sunos57_sun4/bin $MAGMA/sunos57_sun4/flexlm )
limit stacksize 8192k
alias cdcd "cd /home/guest/BF32_data/data/Labs"
alias ls 'ls -F'


########################################################################ADS1.2
setenv ARMHOME                /Stools/arm
setenv ARMLIB                 ${ARMHOME}/common/lib
setenv ARMINC                 ${ARMHOME}/common/include
setenv ARMSD_DRIVER_DIR       ${ARMHOME}/solaris/bin
setenv ARMDLL                 ${ARMHOME}/solaris/bin
setenv ARMCONF                ${ARMHOME}/solaris/bin
setenv WUHOME                 ${ARMHOME}/windu
setenv HHHOME                 ${ARMHOME}/windu/bin.sol2/hyperhelp
 
set path=($ARMHOME/solaris/bin $WUHOME/bin.sol2 $WUHOME/lib.sol2 $path)

setenv ADSCODE 		/Stools/.hshong/TUTOR/BP010-BU-01001-1.01/ARM_ADK_REL1v1/ADScode
setenv TEST_NAME_ROM 	easy_92_hw
setenv TEST_NAME_ROM 	easy_7_hw
setenv TEST_NAME_ROM 	easy_7_it
setenv DIR_ARM7TDMI	/Stools/.hshong/TUTOR/ARM7TDMI	
setenv DIR_ARM922T	/Stools/.hshong/TUTOR/ARM922T

set path = ( $path /Stools/arm/solaris/bin)

########################################################################Modelsim
setenv MGC_HOME 	/Stools/Modelsim5.5a/modeltech
setenv MODEL_TECH 	/Stools/Modelsim5.5a/modeltech
set path = ( $path $MGC_HOME/bin)

########################################################################ARM
set path = ( $path /Stools/fm_vV-2004.06-SP1/bin)

########################################################################VCS
#set path = ( $path /user/hshong/TUTOR/ARM/AT210-BU-01001-r1p1-00rel0/Stools/bin )

########################################################################Formality
set path = ( $path /Stools/fm_vV-2004.06/bin)

########################################################################VCS
setenv VCS_HOME  /Stools/vcs7.1.1
set path = ( $path $VCS_HOME/bin)

########################################################################coreTools
setenv DESIGNWARE_HOME  /Stools/coreTools-U-2003.06-CT4.1.5
set path = ( $path /Stools/coreTools-U-2003.06-CT4.1.5/sparcOS5/dware/bin)

########################################################################LSI VEGA
setenv LSI_RELEASE /Stools/vega
setenv TSMC_RELEASE $LSI_RELEASE
setenv LSI_LICENSE_FILE /Stools/license/license.dat.lsi
set path = ($LSI_RELEASE/bin/SunOS-5.7 $path)

########################################################################STAR RCXT
set path = ( $path /Stools/star-rcxt_vV-2003.12-SP1/SUN.32_star-rcxt/bin)

########################################################################IC445
setenv CDS_INST_DIR /Stools/ic445
set path = ( $path $CDS_INST_DIR/tools/bin )
set path = ( $path $CDS_INST_DIR/tools/dfII/bin )

########################################################################CALIBRE
setenv MGC_HOME /Stools/CALIBRE/ss6_cal_2002.5_10
set path = ( $path $MGC_HOME/bin )
set path = ( $path /Stools/CALIBRE/ss6_cal_2002.5_10/bin )

########################################################################Syntest
setenv SYNTEST /Stools/syntest2.4
setenv VLOG123_HOME /Stools/syntest2.4
set path = ( $path $SYNTEST/bin )

########################################################################LAKER
setenv LAKER /Stools/laker3.0v5
set path = ( $path  $LAKER/bin )

########################################################################SYNPLIFY
setenv SYNPLIFY /Stools/SA3.0.3
set path = ( $path  /Stools/SA3.0.3/asic_303/bin )
set path = ( $path  /Stools/SA3.0.3/asic_303/solaris )

########################################################################MAGMA
setenv MAGMA /Stools/blast4.0_green2_Jan_07_2004
set path = ( $path  $MAGMA/sunos5_sun4_64/bin $MAGMA/sunos5_sun4_64/flexlm )
limit stacksize 8192k
alias cdcd "cd /home/guest/BF32_data/data/Labs"
alias ls 'ls -F'

########################################################################DBchk_tsmc
#set path = ( $path /Stools/DBchk_tsmc )


########################################################################ACROBAT
setenv ACROBAT /Stools/Acrobat5
set path = ( $path $ACROBAT/bin )
set path = ( $path /Stools/netscape )

########################################################################HERCULES
setenv HERCULES_HOME_DIR /Stools/hercules_vV-2003.12
set path = ( $path /Stools/hercules_vV-2003.12/bin/SUN64_58)

########################################################################SMTRF
#setenv SMTRF /Slibs/SMTRF
#setenv PROJ_ROOT        $SMTRF/SM0035
#setenv PROJ_WORKDIR     $SMTRF/SM0035
#setenv PROJ             ${PROJ_ROOT}
#set    path = ($SMTRF ${PROJ}/bin $path)
#set path = ($path $SMTRF/T018_A1_0_10/bin)
#set path = ($path $SMTRF/T015_T1_0_10/bin)

########################################################################UniChip
setenv UNICHIP_HOME /Stools/UniChip
set path = ( $path $UNICHIP_HOME/bin )

########################################################################Artisan
########################################################################0.25um
#set path = ($path /Slibs/artisan/TSMC_0.25-micron-FB/G/aci/ra1sd/bin);
#set path = ($path /Slibs/artisan/TSMC_0.25-micron-FB/G/aci/ra1sh/bin);
#set path = ($path /Slibs/artisan/TSMC_0.25-micron-FB/G/aci/ra2sh/bin);
#set path = ($path /Slibs/artisan/TSMC_0.25-micron-FB/G/aci/rf1sh/bin);
#set path = ($path /Slibs/artisan/TSMC_0.25-micron-FB/G/aci/rf2sh/bin);
#set path = ($path /Slibs/artisan/TSMC_0.25-micron-FB/G/aci/rodsh/bin);

########################################################################0.18um
set path = ($path /Slibs/artisan/TSMC_0.18-micron-FB/G/aci/ra1sd/bin);
set path = ($path /Slibs/artisan/TSMC_0.18-micron-FB/G/aci/ra1sh/bin);
set path = ($path /Slibs/artisan/TSMC_0.18-micron-FB/G/aci/rf1sh/bin);
set path = ($path /Slibs/artisan/TSMC_0.18-micron-FB/G/aci/ra2sh/bin);
set path = ($path /Slibs/artisan/TSMC_0.18-micron-FB/G/aci/rodsh/bin);

########################################################################GCC
#setenv GCC_EXEC_PREFIX  /Stools/gcc-2.95.2/lib
#set path = ( $path /Stools/gcc-2.95.2/bin)

########################################################################Design Compiler
#setenv SYNOPSYS 	/Stools/syn_vV-2004.06-SP2
#set path = ( $path $SYNOPSYS/sparcOS5/syn/bin )
setenv SYNOPSYS         /Stools/syn_vV-2003.12
#set path = ( $path $SYNOPSYS/linux/syn/bin )
set path = ( $path $SYNOPSYS/sparcOS5/syn/bin )

########################################################################PrimeTime
setenv PRIMETIME /Stools/pt_vV-2004.06-SP1-2
set path = ( $path $PRIMETIME/bin )

########################################################################TetraMax
setenv SYNOPSYS_TMAX 	/Stools/tx_vV-2003.12
set path = ( $path $SYNOPSYS_TMAX/sparcOS5/syn/bin)

########################################################################HERCULES
set path = ( $path /Stools/hercules_vU-2003.03/bin/SUN64_58)

########################################################################Verilog-XL & NCSIM
setenv LDV_INST_DIR /Stools/LDV5.1
setenv LDV_VHDL $LDV_INST_DIR/tools/leapfrog

setenv LD_LIBRARY_PATH /usr/local/lib:/usr/openwin/lib:/usr/lib/X11:/usr/lib:/usr/dt/lib:/usr/ucblib
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/syn_vV-2004.06-1/sparcOS5/dcm
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/xcite_2000.3.1/gdll
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/syn_vV-2004.06-1/sparcOS5/mw/lib-sunos5_optimized
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/LDV5.1/tools/lib
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/LDV5.1/tools/lib/64bit
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/Y/tools/lib
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/Y/tools.sun4v/lib/64bit/
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/SA3.0.3/asic_303/solaris/lib
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/tdk9803/vtools_9803a/lib
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/arm/windu/lib.sol2
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/arm/solaris/bin
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/.hshong/TUTOR/ARM7TDMIr3/MM/cadence_xl_verilog
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/.hshong/TUTOR/ARM7TDMIr3/ARM7TDMI_serial/models/cadence_xl_verilog
setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH/:/Stools/.hshong/TUTOR/ARM946-88/LF000-MG-27602-r1p1-00bet0/simulation_models/intest_model/arm946e_88_verilog_SunOS5_1.01rel0/ModelManager/SunOS5/MM/cadence_xl_verilog

set path = ($LDV_INST_DIR/tools/bin $path)
set path = ($LDV_INST_DIR/tools/simvision/bin $path)
set path = ( $path /Stools/tdk9803/bin)
setenv DCALC_LIB /Stools/tdk9803/verilog

########################################################################Debussy
setenv DEBUSSY /Stools/debussy5.0.v13
set path = ( $path $DEBUSSY/bin )
#setenv TURBO_LIBS "Artisan_18 Artisan_25 TSMC_TSMC25E TSMC_TCB773 TSMC_TCB653 TSMC_EXD"
setenv TURBO_LIBPATHS "/Stools/debussy5.0.v13/share/symlib"


########################################################################AXIS 
setenv AXIS_HOME  /Stools/axis_2003.1.3
setenv AXIS_XPLORE_HOME  /Stools/axis_2003.1.3/tools/xplore
setenv AXIS_RCC         $AXIS_HOME
setenv AXIS_HWC         hwc.db_X2k_8
set path = ( $path $AXIS_HOME/bin )
set path = ( $path $AXIS_HOME/tools/xplore/bin )
set path = ( $path $AXIS_HOME/tools/maxplus2/sun/bin )
setenv AXIS_CC GNU_2.95.1
setenv MAXPLUS2_HOME    $AXIS_HOME/tools/maxplus2

############################################################################

stty erase ^H^?

set prompt="% "
set prompt="`hostname`{`whoami`}\!: "
set prompt="$cwd>" 
set time=100
set filec
alias da	'design_analyzer &'
alias dv	'design_vision &'
alias ca	'ca_gui &'
alias cls 	    'clear'
alias cd            'cd \!*;set prompt="$cwd>"'
alias la            'ls -a'
alias ll            'ls -la'
#alias rm            'rm -i'
alias ls           'ls -F'
alias cp           'cp -i'
alias h		history
alias so   	'source ~/.cshrc'
alias sohs   	'source /Stools/.hshong/.cshrc.sun'
alias sohl   	'source /Stools/.hshong/.cshrc.lnx'
alias vv   	'vi ~/.cshrc'
alias vvhs   	'vi /Stools/.hshong/.cshrc.sun'
alias vvhl   	'vi /Stools/.hshong/.cshrc.lnx'
alias mfp	'mfp &'
alias lf	'leapfrog &'
alias vl	'vi $LM_LICENSE_FILE'
alias pp	'ps -ef | grep '
alias sg	'sgen_wish '
alias sc	'signalscan & '
alias wd	'simvision & '
alias lc	'library_compiler & '
alias netscape	'netscape & '
alias vi	'vim '
#alias ra1sh	'ra1sh  & '
#alias ra2sh	'ra2sh  & '
#alias rf2sh	'rf2sh  & '
alias primetime	'primetime  & '
alias rr	'rm *cmd* *log*'
alias sa	'synplify_asic&'
alias xt	'~/xt&'

