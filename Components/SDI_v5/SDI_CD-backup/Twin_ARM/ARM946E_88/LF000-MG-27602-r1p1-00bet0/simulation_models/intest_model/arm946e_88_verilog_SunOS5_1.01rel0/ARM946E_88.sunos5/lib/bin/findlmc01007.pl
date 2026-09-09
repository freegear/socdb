#!/usr/local/bin/perl5.001 
# Copyright(C)1998 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# findlmc   - List paths to all '.lmc' files.
#     Example:  findlmc
#

# @(#) findlmc.pl $Revision: /main/6 $

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

# Print out each unique '.lmc' file name.
foreach $File ( @$PathList ) {
    unless( $PathListFound{ $File }++ ) {
        print "$File\n";
    }
}

exit( 0 );
