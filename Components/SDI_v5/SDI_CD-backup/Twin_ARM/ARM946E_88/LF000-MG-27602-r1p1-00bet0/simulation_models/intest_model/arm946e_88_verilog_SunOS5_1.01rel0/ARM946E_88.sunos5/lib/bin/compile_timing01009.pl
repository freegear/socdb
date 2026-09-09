#!/usr/local/bin/perl5.001
# Copyright(C)2001 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# compile_timing [-Help] [-Messages] [-TTemplate <template_path>] <file>
#   Compile the Timing Data <file> into a model-specific <model>.tf
#   -H[elp]                       Display this message and exit.
#   -M[essages]                   Turn on User Defined Timing (UDT) 
#                                 messages in model.
#   -TT[emplate] <template_path>  Specify full path to timing template 
#                                 file. Do not set this option since it
#                                 is determined automatically to ensure
#                                 the correct version of timing template
#                                 file is used.
#   Example:  compile_timing ttl00.td
#             compile_timing i8051_hv.td

#     - This script executes the correct version of compile_timing
#       for the model.
#       1. The model is determined by finding the 'model' line in
#          the Timing Version Source File.
#       2. We then search for the model in the '.lmc' files
#          throughout the LMC_PATH.
#       3. Once we've found the model listed in a '.lmc' file,
#          we read the model's versioned '.mdl' file to find the
#          version of compile_timing that is specified in the '.mdl' file.
#          We also get the version of the timing template file
#          from the '.mdl' file.
#       4. We execute the version of compile_timing that is specified
#          in the '.mdl' file.  We always call the versioned executable
#          with the '-tt' option to indicate the versioned name of the
#          Timing Template file that we determined from the '.mdl'.

# @(#) compile_timing.pl $Revision: /main/16 $

$LmcHome   = $ENV{ LMC_HOME };
$LmcPath   = $ENV{ LMC_PATH };
$LmcConfig = $ENV{ LMC_CONFIG };

$TDArg                 = -1;
$FoundTT               = 0;
$CompileTimingVersion  = "";
$TimingSourceVersion   = "";
$TimingTemplateVersion = "";

$EchoCmd               = 0;

# The name of the %EXE that should exist in the model's '.mdl' file
$MdlExeName = "compile_timing";

die "ERROR running $0: ",
    "The LMC_HOME environment variable must be set.\n"
    unless( $LmcHome );

# Load the 'libmdl' library of subroutines
require "$LmcHome/lib/bin/libmdl01003.pl";

# Determine which platform we're on
$Platform = GetPlatform();

#Add "-p compile_timing" in front of ARGV.
#This solves the problem on NT, when compile_timing is invoked by the backanno wrapper.
if ($Platform eq 'pcnt') {
    unshift(@ARGV,'-p','compile_timing');
}

# Verify the environment variables are properly set
$ProgName = VerifyEnv( $LmcHome, $LmcPath, $LmcConfig, \@ARGV );

# Skip past any command line switches
for( $Arg = 0; $_ = $ARGV[$Arg]; $Arg++ ) {
    /^-h/i  && Usage();                  # -H produces help message
    if( /^-tt/i ) {                      # -tt is timing template file path
        $FoundTT = 1;
        if( $Arg < $#ARGV ) {
            $Arg++;
            $TimingTemplateVersion = $ARGV[$Arg];
        } else {
            warn "ERROR running $ProgName: -tt argument requires file name\n";
            Usage();
        }
        next;
    }
    if( /^-echo/i ) {
        $Echocmd = 1;
        next;
    }
    if( /^-itf/i ) {
        $itf = "";
        last if $Arg == $#ARGV && $TDArg > -1;   # Stop if last arg and TD is ok
    }
    if( /^[^-]/ ) {                              # Stop at first arg without a '-'
        $TDArg = $Arg;                           # if it's the last argument.
        last if $TDArg == $#ARGV;
    }
}

# Verify we've got the one required argument after any switches
if( $#ARGV != $Arg ) {
    warn "ERROR running $ProgName: Wrong number of arguments.\n";
    Usage();
}

if ( $TDArg > -1 ) {
    $TimingSrcFile = $ARGV[$TDArg];
} else {
    warn "ERROR running $ProgName: No timing source file specified.\n";
    Usage();
}

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

# Determine whether $TimingSrcFile is really a td file. If so, search
# through the Timing Data File source code for the "model" name.
# Otherwise, if we are generating an itf file, assume that $TimingSrcFile 
# contains the model name. The model name is used to generate the default
# itf file - that is, the "itf" equivalent of the default "tf" file.
$ModelName[0] = "";
if ( open( TIMINGSOURCE, $TimingSrcFile ) ) {
    while( <TIMINGSOURCE> )
    {
        if( /^\s*model\s+(\w+)/ ) {
            $ModelName[0] = $1;
            last;
        }
    }
    close( TIMINGSOURCE );
}
else {
    die "ERROR running $ProgName: Cannot open $TimingSrcFile\n" if ! defined $itf;

    $ModelName[0] = $TimingSrcFile;
}


# Check that we found the model name listed in the Timing Source File.
die "ERROR running $ProgName: Timing source file $TimingSrcFile\n",
    "does not specify a model name: missing the 'model' keyword.\n"
    unless( $ModelName[0] );

# Check for one of the model names that is listed in any
# of the '.lmc' files we found in $LMC_PATH or $LMC_HOME/data
unless ( $$Model2Ver{ lc($ModelName[0]) } ) {
    if ( $TimingSrcFile eq $ModelName[0] ) {
        die "ERROR running $ProgName: model $ModelName[0] is not listed in any '.lmc' files.\n";
    } else {
        die "ERROR running $ProgName: Timing source file $TimingSrcFile\n",
            "is for model $ModelName[0] which is not listed in any '.lmc' files.\n";
    }
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
$MdlContents = GrepMdl( "(%EXE\\s+$MdlExeName)|(%TMD)|(%TMT)", $MdlList );

foreach $MdlLine ( @$MdlContents ) {
    @Args = split( ' ', $$MdlLine[0] );

    if ( $Args[0] =~ /%EXE/ ) {
        # %EXE compile_timing <Versioned compile_timing> <CRC>
        if( $#Args >= 2 ) {
            # Prepend the $LMC_HOME/lib/<platform>.lib/ directory to the name
            # of the compile_timing executable.
            $CompileTimingVersion  = PlatformToLibDir( $Platform, $LmcHome )
                                   . $Args[2];
        }
    } elsif ( $Args[0] =~ /%TMD/ ) {
        # %TMD <Versioned Timing Data file> <CRC>
        if( $#Args >= 1 ) {
            # Strip the platform directory and '.mdl' file name off
            # the path to the '.mdl' file to get the path to the
            # parent directory of the '.mdl' file.
            $$MdlLine[2] =~ /(.*\/).*\//;

            $TimingSourceVersion = $1 . $Args[1];
        }
    } else {
        # %TMT <Versioned Timing Template file> <CRC>
        if( $#Args >= 1 ) {
            # Strip the platform directory and '.mdl' file name off
            # the path to the '.mdl' file to get the path to the
            # parent directory of the '.mdl' file.
            $$MdlLine[2] =~ /(.*\/).*\//;

            if( !$FoundTT ) {
                $TimingTemplateVersion = $1 . $Args[1];
            }
        }
    }
}

die "ERROR running $ProgName: Cannot find an entry for the version of\n",
    "$MdlExeName in the file $$MdlList[0]\n"
    unless( $CompileTimingVersion );

die "ERROR running $ProgName: Cannot find an entry for the version of the\n",
    "Timing Source file in the file $$MdlList[0]\n"
    if( $TimingSrcFile eq $ModelName[0] && ! $TimingSourceVersion );

die "ERROR running $ProgName: Cannot find an entry for the $MdlExeName\n",
    "Timing Template file version in the file $$MdlList[0]\n"
    if( !$FoundTT && !$TimingTemplateVersion );

die "ERROR running $ProgName: Cannot find the executable for $ProgName ",
    "named $CompileTimingVersion.\n"
    unless( -x $CompileTimingVersion );

die "ERROR running $ProgName: The -TT option must specify a full path to\n",
    "a timing template (.tt) file, but instead found a directory named\n",
    "$TimingTemplateVersion.\n"
    if( -d $TimingTemplateVersion );

die "ERROR running $ProgName: Cannot read the timing source file ",
    "$TimingSourceVersion.\n"
    if ( $TimingSrcFile eq $ModelName[0] && ! -r $TimingSourceVersion );

die "ERROR running $ProgName: Cannot read the timing template file ",
    "$TimingTemplateVersion.\n"
    unless( -r $TimingTemplateVersion );

# Make STDOUT and STDERR unbuffered so we can see any errors that may occur
select(STDOUT); $| = 1;
select(STDERR); $| = 1;

# If this perl script was called with the modelname instead of the
# timing source file, we must replace the modelname with the correct
# version of the timing source file as we read from the '.mdl' file.
$ARGV[$TDArg] = $TimingSourceVersion if $TimingSrcFile eq $ModelName[0];

# If this perl script was called with the -tt switch we call
# the executable compile_timing program with the original -tt argument.
# If this perl script was not called with a -tt switch, we call the
# executable compile_timing program with the -tt argument that contains
# the correct version of the timing template file as we read from
# the '.mdl' file.
unshift( @ARGV, "-tt", $TimingTemplateVersion ) unless $FoundTT;

if ( $Echocmd ) {
    unshift( @ARGV, $CompileTimingVersion);
    $Command = join ' ', @ARGV;
    $Command =~ s/-echo//;
    print "$Command\n";
    exit 0;
}

# Execute the proper version of compile_timing
print "Executing: $CompileTimingVersion @ARGV\n";

if ($Platform eq 'pcnt' || $Platform eq 'alphant' ) {
    unshift( @ARGV, $CompileTimingVersion);
    system( @ARGV );
}
else {
    exec $CompileTimingVersion $ProgName, @ARGV;

    # Should never get here
    die "ERROR running $ProgName: $!\n";
}
