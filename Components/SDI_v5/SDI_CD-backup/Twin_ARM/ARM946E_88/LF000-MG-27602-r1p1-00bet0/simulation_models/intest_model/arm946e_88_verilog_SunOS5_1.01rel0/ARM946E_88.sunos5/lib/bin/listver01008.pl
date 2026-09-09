#!/usr/local/bin/perl5.001 
# Copyright(C)1998 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# listver - List model versions read from all '.lmc' files.
#     Example:  listver

# @(#) listver.pl $Revision: /main/6 $

$LmcHome   = $ENV{ LMC_HOME };
$LmcPath   = $ENV{ LMC_PATH };
$LmcConfig = $ENV{ LMC_CONFIG };

die "ERROR running $0: The LMC_HOME environment variable must be set.\n" 
     unless( $LmcHome );

# Load the 'libmdl' library of subroutines
require "$LmcHome/lib/bin/libmdl01003.pl";

# Verify the environment variables are properly set
$ProgName = VerifyEnv( $LmcHome, $LmcPath, $LmcConfig, \@ARGV );

# This command accepts no arguments
if( @ARGV ) {
    warn "ERROR running $ProgName: no arguments expected.\n";
    Usage();
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
$Model2Ver = &GetModelVer( $PathList );

unless( scalar(%$Model2Ver) ) {
    die "ERROR running $ProgName: No models listed in any '.lmc' files\n";
}

# Print out the version of each model.
foreach $Model ( sort keys %$Model2Ver ) {
    ($LmcFile, $ModelDir, $Ver) = split( / /, $$Model2Ver{ $Model } );
    print "$Model $Ver\n";
}

exit( 0 );
