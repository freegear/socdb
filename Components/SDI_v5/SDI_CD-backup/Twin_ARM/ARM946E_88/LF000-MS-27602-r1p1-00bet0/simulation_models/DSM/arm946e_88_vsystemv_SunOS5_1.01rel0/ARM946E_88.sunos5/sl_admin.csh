#! /bin/csh -f
#####################################################################
#
# Installation wrapper.  
# This script determines the current platform to invoke the correct
# machine dependent binary.
#
#####################################################################

onintr -

#
# Determine the tool name from the invocation line.
set arg0	= $0
set invoke	= $arg0:r
set name	= ($invoke:t)
set ourpath     = $0
set ourpath     = $ourpath:h
if ($ourpath == $arg0) then
	set ourpath = `pwd`
endif

# echo "ourpath = $ourpath"

#
# Determine platform type.
set platform = ""
if ( -d /usr/apollo/bin ) then			# Found an Apollo DN.
	set platform = "apollo"
else if ( -x /bin/hp9000s700 ) then		# Found an HP 700.
	set platform = "hp700"
#
# Check for machines which don't have unique file but
# do have /bin/uname command.
else if ( -x /bin/uname ) then
	set machine	= `/bin/uname -a`
	if ( $machine[1] == "AIX" ) then	# Found an IBM RS6000.
		set platform = "ibmrs"
	else if ( $machine[1] == "SunOS" ) then	# Found a Sun.
		@ os_rev = `echo $machine[3] | awk -F. '{print $1}'`
		if ( $os_rev < 5 ) then		# SunOS 4.x
			set platform = "sunos"
		else if ( $os_rev >= 5 ) then	# SunOS >= 5.x
			set platform = "solaris"
		endif
        else if ( $machine[1] == "OSF1" ) then  # Found a DEC Alpha
                set platform = "decalpha"
        else if ( $machine[1] == "Linux" ) then  # Found a Linux 
        	if ( `/bin/uname -m` =~ i?86 ) then
                	set platform = "x86_linux"
        	endif
	endif
endif

#
# Check if this platform is unsupported.  If so, bailout.
if ( $platform == "" ) then
	echo "ERROR:  Unknown platform type.  Attempt to invoke "
	echo "	      $name on an unsupported platform."
	exit 1
endif

#
#First check if this is a pcnt cdimage 
#If so give a error right away and bailout.
#
set toc_name=${ourpath}/"sl_toc.dat"
if (-e ${toc_name}) then
    set plat_name=`grep pcnt ${toc_name} | head -1`
    if (${plat_name} == pcnt) then
       echo "ERROR: Cross platform installations are not supported"
       echo "       between UNIX and NT in either direction. " 
       echo "       To install the software on NT, you must mount"
       echo "       the CD on an NT machine. "
       exit 1
    endif
endif
   
#
# Build all possible versions of the path to the "real"
# install so we can try each.
#
set lower="${platform}/${name}"
set mlower="${platform}/${platform}/${name}"
set upper="`echo ${lower} | tr a-z A-Z`"
set mupper="`echo ${mlower} | tr a-z A-Z`"
set lower_version="${lower};1"
set mlower_version="${mlower};1"
set upper_version="`echo ${lower} | tr a-z A-Z`;1"
set mupper_version="`echo ${mlower} | tr a-z A-Z`;1"
set bin_path=($lower $upper $lower_version $upper_version $mlower $mupper $mlower_version $mupper_version)

#
# Now see if one of them work
#
unset install_prog
foreach f ($bin_path)
	if (-e ${ourpath}/$f) then
		set install_prog = ${ourpath}/$f
	endif
end

if ( ! $?install_prog ) then
    #
    # Since the sl_admin executable does not appear to exist on the 
    # media itself, lets look for the executable in the existing 
    # installation before giving up
    #
    if ( $?LMC_HOME ) then
	if ( -e ${LMC_HOME}/bin/sl_admin ) then
	    set install_prog = "${LMC_HOME}/bin/sl_admin"
	else
            echo "ERROR:  Since we were unable to locate the machine-dependant binary for ${name}"
            echo "        on the media image itself, we attempted to use an existing installation"
	    echo "        and could not find one.  Please contact customer support."
            exit 1
	endif
    else
        echo "ERROR:  Since we were unable to locate the machine-dependant binary for ${name}"
        echo "        on the media image itself, we attempted to use an existing installation"
        echo "        and could not find one.  Please contact customer support."
        exit 1
    endif
endif

set CMD = "${install_prog} -media"
if ( $#argv == 0 ) then
	set CMD = "$CMD $ourpath"
else
    while ( $#argv )
	set CMD = "$CMD $argv[1]"
	shift
    end
endif
$CMD
