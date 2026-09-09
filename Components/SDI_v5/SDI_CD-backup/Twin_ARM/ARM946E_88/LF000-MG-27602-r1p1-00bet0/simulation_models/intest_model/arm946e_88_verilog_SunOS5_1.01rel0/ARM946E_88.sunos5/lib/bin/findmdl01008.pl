#!/usr/local/bin/perl5.001 
# Copyright(C)1998 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# findmdl [<ModelName>]   
#   - List paths to all '.mdl' files.  Argument is list of models to find.
#     With no arguments, will print paths to all '.mdl' files for which 
#     versions have been listed in the '.lmc' files.  Will complain about 
#     any '.mdl' files that cannot be found.
#   Example:  findmdl
#             findmdl ttl00

# @(#) findmdl.pl $Revision: /main/7 $

$LmcHome   = $ENV{ LMC_HOME };
$LmcPath   = $ENV{ LMC_PATH };
$LmcConfig = $ENV{ LMC_CONFIG };

die "ERROR running $0: The LMC_HOME environment variable must be set.\n" 
     unless( $LmcHome );

# Load the 'libmdl' library of subroutines
require "$LmcHome/lib/bin/libmdl01003.pl";

# Verify the environment variables are properly set
$ProgName = VerifyEnv( $LmcHome, $LmcPath, $LmcConfig, \@ARGV );

# Check for command line switches 
for( $Arg = 0; $_ = $ARGV[$Arg]; $Arg++ ) {
    if( /^-/ ) {
        warn "ERROR running $ProgName: $_ argument unknown.\n";
        Usage();
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
# list of versions of all models.
$Model2Ver = GetModelVer( $PathList );

unless( scalar(%$Model2Ver) ) {
    die "ERROR running $ProgName: No models listed in any '.lmc' files\n";
}

# Get the path to all the '.mdl' files for the models listed in ARGV.
$MdlList = GetMdlPath( $Platform, $LmcHome, $LmcPath, $Model2Ver, \@ARGV );

unless( @$MdlList) {
    die "ERROR running $ProgName: No '.mdl' files found for ",
        "requested models.\n",
        "Using model versions listed in lmc files: @$PathList\n";
}

# Print list of paths to '.mdl' files.
foreach $MdlFile ( @$MdlList ) {
    print "$MdlFile\n";
}

exit( 0 );
