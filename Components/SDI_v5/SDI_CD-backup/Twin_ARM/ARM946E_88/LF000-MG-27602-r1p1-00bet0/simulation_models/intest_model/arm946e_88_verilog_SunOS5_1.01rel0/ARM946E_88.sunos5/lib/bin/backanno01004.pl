#!/usr/local/bin/perl5.001
# Copyright(C)2001 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#

# @(#) ba.pl $Revision: /main/4 $

$LmcHome   = $ENV{ LMC_HOME };
$LmcPath   = $ENV{ LMC_PATH };
$LmcConfig = $ENV{ LMC_CONFIG };

# The name of the %EXE that should exist in an '.lmc' file
$ExeName = "backanno";

die "ERROR running $0: ",
    "The LMC_HOME environment variable must be set.\n"
    unless( $LmcHome );

# Load the 'libmdl' library of subroutines
require "$LmcHome/lib/bin/libmdl01003.pl";

# Verify the environment variables are properly set
$ProgName = VerifyEnv( $LmcHome, $LmcPath, $LmcConfig, \@ARGV );

# Determine which platform we're on
$Platform = GetPlatform();

# Find all the '.lmc' files in the path
$PathList = FindLmc( $Platform, $LmcHome, $LmcConfig );

unless( @$PathList) {
    die "ERROR running $ProgName: No '.lmc' files found anywhere in\n",
        "LMC_CONFIG or LMC_HOME/data directories\n";
}

# Read the contents of all the '.lmc' files in the path to get the
# list of versions of all models.
$Model2Ver = GetModelVer( $PathList );

unless( scalar(%$Model2Ver) ) {
    die "ERROR running $ProgName: No models listed in any '.lmc' files\n";
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
# such as "mod_param 01000"
# Now we split out the path to the '.lmc' file and the version of
# the executable.
($LmcName, $ExeVer) = split( " ", $$Exe2Ver{ $ExeName }, 2 );

# Build the path to the executable:
#  $LMC_HOME/lib/<platform>.lib/mod_param<version>
$ExePath  =  PlatformToLibDir( $Platform, $LmcHome ) . "$ExeName$ExeVer" . GetExeSuffix( $Platform );

# Verify the versioned executable can be found
die "ERROR running $ProgName: Cannot find the executable for $ProgName ",
    "named $ExePath.\n",
    "The file $LmcName called out version $ExeVer for $ExeName.\n"
    unless( -x $ExePath );

# Make STDOUT and STDERR unbuffered so we can see any errors that may occur
select(STDOUT); $| = 1;
select(STDERR); $| = 1;

# Execute the proper version of mod_param 
print "Executing: $ExePath @ARGV\n";
@ba_args = ($ExePath, @ARGV);
$retVal = 0xffff & system(@ba_args);
$retVal >>=8;
if ($retVal != 0) { exit(1); }

# for each model that was back annotated run the timing compiler on it
$baModelsList = "BAMODELS.LST";

if (!open(BAMODELSLIST, $baModelsList)) {
  print "${ProgName}: ERROR:  Can't find $baModelsList\n";
  exit(1);
}

$retStatus = 0;
$outDir = "";
while( <BAMODELSLIST> )
{
    @fields = split;

    if ($outDir eq "") { $outDir = $fields[0]; next; }

    $ModelName[0] = $fields[0];
    print "\nNOTE: Compiling time file for model '$ModelName[0]'\n";

    # Check for one of the model names that is listed in any
    #of the '.lmc' files we found in $LMC_PATH or $LMC_HOME/data

    unless ( $$Model2Ver{ lc($ModelName[0]) } ) {
	print "${ProgName}: ERROR:  model $ModelName[0] is not listed in any '.lmc' files.\n";
	exit(1);
    }
    
    # Get the path to the '.mdl' file for the model listed in the timing source code.
    $MdlList = GetMdlPath( $Platform, $LmcHome, $LmcPath, $Model2Ver, \@ModelName );

    unless( @$MdlList) {
	die "ERROR running $ProgName: No '.mdl' files found for ",
        "requested models.\n",
        "Using model versions listed in lmc files: @$PathList\n";
    }

# Grep through the '.mdl' file for the compile_timing version specification
# and the version of the Timing Template file.
# Returns a two-dimensional array reference, where the row-major
# dimension represents each line read from each '.mdl' file and
# the minor indexes are as follows:
#   [x][0] = The contents of the line.
#   [x][1] = The line number in the file.
#   [x][2] = The path to the '.mdl' file.

    $TimingSourceVersion = "";
    $MdlContents = GrepMdl( "(%TMD)", $MdlList, 1 );

    foreach $MdlLine ( @$MdlContents ) {
	@Args = split( ' ', $$MdlLine[0] );

	if ( $Args[0] =~ /%TMD/ ) {
	    # %TMD <Versioned Timing Data file> <CRC>
	    if( $#Args >= 1 ) {
		# Strip the platform directory and '.mdl' file name off
		# the path to the '.mdl' file to get the path to the
		# parent directory of the '.mdl' file.
		$$MdlLine[2] =~ /(.*\/).*\//;

		$TimingSourceVersion = $1 . $Args[1];
	    }
	}
    }

    die "ERROR running $ProgName: Cannot find an entry for the version of the\n",
    "Timing Source file in the file $$MdlList[0]\n"
	if( ! $TimingSourceVersion );

    die "ERROR running $ProgName: Cannot read the timing source file ",
    "$TimingSourceVersion.\n"
	if (! -r $TimingSourceVersion );

    $CTPath  = "$LmcHome/bin/compile_timing";
    @ct_args = ($CTPath, "-port_delays", "-o", $outDir, $TimingSourceVersion);

    $retVal = 0xffff & system(@ct_args);
    $retVal >>=8;
    if ($retVal != 0) { $retStatus = 1; }
}
close( BAMODELSLIST );

exit($retStatus);



