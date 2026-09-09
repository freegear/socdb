#!/usr/local/bin/perl5.001 
# Copyright(C)1998 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# grepmdl <MdlKeyWord_RegExp> [<ModelName> <ModelName>...]
#   - Read the contents of a '.mdl' file, searching for KeyWords.  
#     KeyWord argument is a regular expression containing %XXX entries 
#     that will be searched in the '.mdl' files.  With no model names 
#     listed, will find %XXX entries for all models listed in '.lmc' files. 
#   Example:  grepmdl "%MLB|%LLB|%CLB" 
#             grepmdl "%TMF" ttl00 ttl04

# @(#) grepmdl.pl $Revision: /main/7 $

$LmcHome   = $ENV{ LMC_HOME };
$LmcPath   = $ENV{ LMC_PATH };
$LmcConfig = $ENV{ LMC_CONFIG };

die "ERROR running $0: ",
    "The LMC_HOME environment variable must be set.\n"
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

# Strip the keyword string out of ARGV.
# This is so we can pass the list of model names to GetMdlPath to get 
# a list of the paths to each '.mdl' file. 
unless( $#ARGV >= 0 ) {
    warn "ERROR running $ProgName: Regular expression argument is missing.\n";
    Usage();
}
$KeyWords = shift(@ARGV);

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

# Grep through each '.mdl' file for any of the requested keywords.
# Returns a two-dimensional array reference, where the row-major 
# dimension represents each line read from each '.mdl' file and 
# the minor indexes are as follows:
#   [x][0] = The contents of the line.
#   [x][1] = The line number in the file.
#   [x][2] = The path to the '.mdl' file.
$MdlContents = GrepMdl( $KeyWords, $MdlList );

# Print the results of searching through the '.mdl' file(s)
foreach $MdlLine ( @$MdlContents ) {
    # Print  <MdlFileName>, <MdlLineNumber>, <MdlLineContents>
    print $$MdlLine[2] . ", Line " . $$MdlLine[1] . ", " . $$MdlLine[0];
}

exit(0);
