#!/usr/local/bin/perl5.001
# Copyright(C)1999 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# ptm_make 
#   - Create portmap files from Logic Modeling SWIFT models.

#     - This script executes the correct version of ptm_make.
#       1. We search for '%EXE ptm_make' in the '.lmc' files
#          throughout the LMC_CONFIG.
#       2. We execute the version of ptm_make that is specified
#          in the '.lmc' file.  

# @(#) ptm_make.pl $Revision: /main/8 $

$LmcHome   = $ENV{ LMC_HOME };
$LmcPath   = $ENV{ LMC_PATH };
$LmcConfig = $ENV{ LMC_CONFIG };

$EchoCmd   = 0;

# The name of the %EXE that should exist in an '.lmc' file
$ExeName = "ptm_make";

die "ERROR running $0: ",
    "The LMC_HOME environment variable must be set.\n"
    unless( $LmcHome );

# Load the 'libmdl' library of subroutines
require "$LmcHome/lib/bin/libmdl01003.pl";

# Verify the environment variables are properly set
$ProgName = VerifyEnv( $LmcHome, $LmcPath, $LmcConfig, \@ARGV );

# Skip past any command line switches
for( $Arg = 0; $_ = $ARGV[$Arg]; $Arg++ ) {
    if( /^-echo/i ) {
        $Echocmd = 1;
	next;
    }
}

# Determine which platform we're on
$Platform = GetPlatform();

# Find all the '.lmc' files in the path
$PathList = FindLmc( $Platform, $LmcHome, $LmcConfig );

unless( @$PathList) {
    die "ERROR running $ProgName: No '.lmc' files found anywhere in\n",
        "LMC_CONFIG or LMC_HOME/data directories\n";
}

# Read the contents of all the '.lmc' files in the path to get the
# list of versions of all executables.
$Exe2Ver = GetExeVer( $PathList );

# Check that we found the executable name listed in some '.lmc' file.
die "ERROR running $ProgName: Cannot find an entry for the version of\n",
    "$ExeName in any '.lmc' file. Your LMC_HOME and LMC_CONFIG\n",
    "environment variables determine which '.lmc' files are read.\n"
    unless( $$Exe2Ver{ $ExeName } );

#
# The Exe2Ver hash values all contain a string of the form
#     "<LMC file name> <Executable version>"
# such as "ptm_make 01000"
# Now we split out the path to the '.lmc' file and the version of
# the executable.
($LmcName, $ExeVer) = split( " ", $$Exe2Ver{ $ExeName }, 2 );

# Build the path to the executable:
#  $LMC_HOME/lib/<platform>.lib/ptm_make<version>
$ExePath  = PlatformToLibDir( $Platform, $LmcHome )
          . $ExeName . $ExeVer . GetExeSuffix( $Platform );

# Verify the versioned executable can be found
die "ERROR running $ProgName: Cannot find the executable for $ProgName ",
    "named $ExePath.\n",
    "The file $LmcName called out version $ExeVer for $ExeName.\n"
    unless( -x $ExePath );

# Make STDOUT and STDERR unbuffered so we can see any errors that may occur
select(STDOUT); $| = 1;
select(STDERR); $| = 1;

if ( $Echocmd ) {
    unshift( @ARGV, $ExePath);
    $Command = join ' ', @ARGV;
    $Command =~ s/-echo//;
    print "$Command\n";
    exit 0;
}

# Execute the proper version of compile_timing
print "Executing: $ExePath @ARGV\n";

if ($Platform eq 'pcnt' || $Platform eq 'alphant' ) {
    unshift( @ARGV, $ExePath);
    system( @ARGV );
}
else {
    exec $ExePath $ProgName, @ARGV;

    # Should never get here
    die "ERROR running $ProgName: $!\n";
}
