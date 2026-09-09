#!/usr/local/bin/perl5.001
# Copyright(C)1998 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# sl_copy [option...] <ModelName> <NewFile>
# sl_copy [option...] <ModelName> [ModelName>...] <Directory>
#   -h   Print this help message.
#   -td  Copy the model's timing data source file.  This is the default
#        if no options are specified.
#   -cmd Copy the model's cmd file.  Only applies to Hardware Verification
#        (hv) models.
#   -v   Verbose mode prints the name of each file as it is being created.
#
#     The first form of sl_copy will copy the <ModelName>'s selected file type
#   to <NewFile>.
#     The second form of sl_copy will copy the selected file types for the
#   <ModelName> list to a <Directory>.  The <Directory> must already exist.
#     In either form, if no options are specified, the timing data source
#   file for the <ModelName> will be copied.
#
#   Example:  sl_copy ttl00 myttl00.td
#             sl_copy -td -cmd am186em_hv mydir
#             sl_copy -v am186em_hv ttl00 ttl04 mydir

# @(#) sl_copy.pl $Revision: /main/2 $

$LmcHome   = $ENV{ LMC_HOME };
$LmcPath   = $ENV{ LMC_PATH };
$LmcConfig = $ENV{ LMC_CONFIG };

$ExitVal = 0;
$Verbose = 0;

die "ERROR running $0: ",
    "The LMC_HOME environment variable must be set.\n"
    unless( $LmcHome );

# Load the 'libmdl' library of subroutines
require "$LmcHome/lib/bin/libmdl01003.pl";

# Verify the environment variables are properly set
$ProgName = VerifyEnv( $LmcHome, $LmcPath, $LmcConfig, \@ARGV );

@KeyWords = ();

# Check for command line switches in any order
for( $i = 0; $_ = $ARGV[$i]; ) {
    if( /^-/ ) {
        /^-h/   && Usage();

        /^-cmd/ && push( @KeyWords, "%CMD" ) && splice(@ARGV, $i, 1) && next;
        /^-td/  && push( @KeyWords, "%TMD" ) && splice(@ARGV, $i, 1) && next;
        /^-v/   && ($Verbose = 1)            && splice(@ARGV, $i, 1) && next;

        warn "ERROR running $ProgName: $_ argument unknown.\n";
        Usage();
    } else {
        $i++;
    }
}

unless( @ARGV >= 2 ) {
    warn "ERROR running $ProgName: Two or more arguments required.\n";
    Usage();
}

# Default is to get the td file
push( @KeyWords, "%TMD" ) unless( @KeyWords );

# Strip the destination file name or directory name out of ARGV.
$Destination = pop(@ARGV);

if( -d $Destination ) {
    $Dir = $Destination;

    # Put a slash on the end of the directory if it doesn't already have one
    $Dir .= '/' if( $Dir !~ m#/$# );
} elsif( @ARGV > 2 ) {
    warn "ERROR running $ProgName: When list of models given, last argument ",
         "must be an existing directory name.\n";
    Usage();
} elsif( @KeyWords > 1 ) {
    warn "ERROR running $ProgName: When list of options given, last argument ",
         "must be an existing directory name.\n";
    Usage();
} else {
    $Dir = "";
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

# Get the path to the '.mdl' files for the model listed in ARGV.
$MdlList = GetMdlPath( $Platform, $LmcHome, $LmcPath, $Model2Ver, \@ARGV );

unless( @$MdlList) {
    die "ERROR running $ProgName: No '.mdl' files found for ",
        "requested models.\n",
        "Using model versions listed in lmc files: @$PathList\n";
}

# Convert the keywords list into a regular expression
$KeyWords = join( '|', @KeyWords );

# Grep through the '.mdl' file for the selected keywords.
# Returns a two-dimensional array reference, where the row-major 
# dimension represents each line read from each '.mdl' file and 
# the minor indexes are as follows:
#   [x][0] = The contents of the line.
#   [x][1] = The line number in the file.
#   [x][2] = The path to the '.mdl' file.
$MdlContents = GrepMdl( $KeyWords, $MdlList );

unless( @$MdlContents ) {
    die "ERROR running $ProgName: Cannot find an entry for the version of\n",
        "the model's ($KeyWords) keywords in the file $$MdlList[0]\n";
}

@SrcFiles = ();
foreach $MdlLine ( @$MdlContents ) {
    @Args = split( ' ', $$MdlLine[0] );

    if( $#Args >= 1 ) {
        # Strip the platform directory and '.mdl' file name off
        # the path to the '.mdl' file to get the path to the
        # parent directory of the '.mdl' file.
        $$MdlLine[2] =~ /(.*\/).*\//;
        push( @SrcFiles, $1 . $Args[1] );
    } else {
        warn "ERROR running $ProgName: The entry at line $$MdlLine[1]\n",
             "of the file $$MdlLine[2] does not contain enough arguments.\n";
        $ExitVal = 2;
    }
}

# Now we've got the list of files to copy, so copy them
foreach $SrcFile (@SrcFiles) {

    if( $Dir ) {
        # We're writing the output to a directory.
        # To determine the output file name, find the unversioned basename
        # that we read from the line in the .mdl file.  This means
        # that if the user gave us an alias name we'll generate files
        # by the physical names, not the alias names (oh well).
        $SrcFile =~ m#(.*/)?(.*)#;
        $OutFile = $2;
        $OutFile =~ s/\d{5}//;
        $OutFile = $Dir . $OutFile;
    } else {
        $OutFile = $Destination;
    }

    unless( open( SRCFILE, $SrcFile ) ) {
        warn "Cannot open $SrcFile for read, system error: $!.\n";
        $ExitVal = 3;
        next;
    }
    
    open( OUTFILE, ">$OutFile" ) 
        || die  "Cannot open $OutFile for write, system error: $!.\n";

    print "Writing $OutFile\n" if( $Verbose );

    while( <SRCFILE> ) {
        print OUTFILE $_;
    }
    
    close( OUTFILE );
    close( SRCFILE );
}

exit( $ExitVal );
