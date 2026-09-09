#! /bin/csh -f
#####################################################################
#
# toolwrap
#
#####################################################################
# Invoke the correct platform-specific tool based on the machine
# we were invoked from and the name we were invoked with. We check
# the lib directory for a binary named <platform>.lib/<tool> or a
# file named <tool>.pl and invoke perl on this script.  
#####################################################################

# @(#) toolwrap.csh $Revision: /main/15 $

# Determine the tool name from the invocation line.
set invoke      = $0
set TOOL_NAME   = ($invoke:t)

# The default version of perl to use
set DEFAULTVER = 5.001

# Determine if the LMC_HOME env var is set.  This is required for
# all user tool invocations.
if ( ! $?LMC_HOME ) then
    echo "${0}:  ERROR:  Environment variable LMC_HOME not set."
    exit 1
endif

# Determine platform type.
set PLATFORM = ""
if ( -d /usr/apollo/bin ) then          # Found an Apollo DN.
    set PLATFORM = "apollo"
else if ( -x /bin/hp9000s700 ) then     # Found an HP 700.
    set PLATFORM = "hp700"

# Check for machines which don't have unique file but
# do have /bin/uname command.
else if ( -x /bin/uname ) then
    set machine = `/bin/uname -a`
    if ( $machine[1] == "AIX" ) then            # Found an IBM RS6000.
        set PLATFORM = "ibmrs"
    else if ( $machine[1] == "SunOS" ) then     # Found a Sun.
        @ os_rev = `echo $machine[3] | awk -F. '{print $1}'`
        if ( $os_rev < 5 ) then                 # SunOS 4.x
            set PLATFORM = "sun4SunOS"
        else if ( $os_rev >= 5 ) then           # SunOS >= 5.x
            set PLATFORM = "sun4Solaris"
        endif
    else if ( $machine[1] == "OSF1" ) then  # Found a DEC Alpha
                set PLATFORM = "decalpha"
    else if ( $machine[1] == "Linux" ) then  # Found a Linux 
	if ( `/bin/uname -m` =~ i?86 ) then
                set PLATFORM = "x86_linux"
	endif
    endif
endif

# Check if this platform is unsupported.  If so, bailout.
if ( $PLATFORM == "" ) then
    echo "ERROR:  Unknown platform type.  Attempt to invoke "
    echo "  $TOOL_NAME on an unsupported platform."
    exit 1
endif

# Rebuild all the arguments with double quotes because
# the $* notation will mess up null or multi-word arguments.
# The $*:q notation will quote the multi-word arguments, but 
# will throw away the null arguments.  So this is what it 
# takes to avoid modifying the arguments in any way.
#
# The double quote did not protect '$' chars in an argument,
# so we now use a single quote to avoid attempted variable
# expansion by the eval below.  STAR:47034 rcg
@ ArgNum = 1
set QUOTE = \'
while ($ArgNum <= $#argv)
  set argv[$ArgNum] = "$QUOTE$argv[$ArgNum]$QUOTE"
  @ ArgNum++
end

# Check this tool is implemented with a readable perl script
set PERLSCR = "$LMC_HOME/lib/bin/$TOOL_NAME.pl"
if ( ! -r $PERLSCR ) then
    # Check for a platform-specific unversioned name of this tool
    set LMCEXE = "$LMC_HOME/lib/$PLATFORM.lib/$TOOL_NAME"
    if ( -x $LMCEXE ) then
        eval $LMCEXE $*
        set tool_status = $status
        exit $tool_status
    endif

    # This tool has no corresponding perl script in the lib/bin directory,
    echo "${0}:  ERROR:  Cannot read $LMCEXE or $PERLSCR"

    if ( -d "$LMC_HOME/lib/$PLATFORM.lib" ) then
        # The <PLATFORM>.lib directory exists, but the tool cannot be found
        # anywhere.  Probably just that they haven't installed on this
        # platform yet.
        echo "Did you install $TOOL_NAME on platform $PLATFORM with"
        echo "environment variable LMC_HOME set to $LMC_HOME?"
    else
        # Can't find <PLATFORM>.lib so best guess is that the user's 
        # LMC_HOME is wrong
        echo "Your LMC_HOME environment variable is set to $LMC_HOME."
        echo "Is this the location that you installed your software?"
    endif
    exit 1
endif

# We found a perl script for the tool. 
# Now we need to determine the proper version of perl to fire up
# on that perl script.  And to do that, we run a perl script
# within this script to grep the version of perl needed
# by the tool's perl script. So first, we need to check for the
# existence of platform-specific versioned perl used by this shell script
set LMCPERL = "$LMC_HOME/lib/$PLATFORM.lib/sl_perl"
if ( ! -x $LMCPERL$DEFAULTVER ) then
    echo "${0}:  ERROR:  Cannot find file $LMCPERL$DEFAULTVER"
    echo "Did you install $TOOL_NAME on platform $PLATFORM with"
    echo "environment variable LMC_HOME set to $LMC_HOME?"
    exit 1
endif

# Use the default version of perl to read the first line of the perl 
# script to figure out which version of perl to use on the script.
# If this fails, use the default version of perl to run the script.
set noglob
set PERLVER = `$LMCPERL$DEFAULTVER -ne 'print((/#\x21.*perl(\S+)/) ? $1 : $ARGV[0]); exit(0);' $PERLSCR $DEFAULTVER`

# Check for existence of platform-specific versioned perl
# used by the perl script we are about to call
if ( ! -x $LMCPERL$PERLVER ) then
    echo "${0}:  ERROR:  Cannot find file $LMCPERL$PERLVER"
    echo "The script $PERLSCR called out perl version '$PERLVER'"
    exit 1
endif


# Start the LMC perl executable (for the correct platorm type)
# using the perl script 'TOOL_NAME.pl' that must exist in the
# $LMC_HOME/lib/bin directory.
# Must use C-shell 'eval' so quoted arguments are interpreted properly.
# We pass a '-p' argument to the script so the script can get the
# name of the program being executed.
eval $LMCPERL$PERLVER $PERLSCR -p $0 $*

set tool_status = $status

exit $tool_status
