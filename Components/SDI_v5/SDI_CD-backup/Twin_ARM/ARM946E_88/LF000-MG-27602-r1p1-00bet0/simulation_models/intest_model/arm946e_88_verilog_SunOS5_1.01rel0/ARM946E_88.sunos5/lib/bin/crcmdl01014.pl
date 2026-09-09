#!/usr/local/bin/perl5.001 -w
# Copyright(C)1999 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# crcmdl [-a] [-h] [-l] [-v] [-q <PlatformName>] [<ModelName> <ModelName>...]
#
#     Verify the CRC values for each of the entries in an 
#     '.mdl', '.lvd' or '.dvd' file.  Arguments not preceded 
#     by a '-' character are considered model names.
#     If no arguments are specified (or -h), this usage message is 
#     displayed.
#
#     Options:
#       -a   Check CRC values for all models.
#       -h   Display this usage.
#       -l   Check CRC for current library and user versioned files.
#       -v   Verbose; prints expected and received CRC.
#
#     Examples:
#       crcmdl ttl00 ttl04        Check CRC of ttl00 and ttl04.
#       crcmdl -a                 Check CRC of all models.
#       crcmdl -l am2168          Check CRC for LVD, DVD files
#                                   and the MDL for the am2169.
#       crcmdl -a -l              Check CRC for whole library.
#
#     Note: When checking model CRC values, only the version of the
#           model selected by an LMC file is checked.
#           When checking LVD and DVD files, only the latest versions
#           are checked.
#

# For each of the records we search in an mdl file that contains any
# CRC, we need to know 3 things (each separated by a comma):
#    - Which argument contains the file name.
#    - Which argument contains the expected CRC value.
#    - What directories should be searched to find the file.
#          This is a colon-separated list of the following keywords:
#          MdlDir     - The same directory that contains the '.mdl' file.
#                       Usually, this is LMC_HOME/models/<model>/<platform>
#          LibDir     - The platform-specific lib directory.
#                       This is LMC_HOME/lib/<platform_dir>.lib
#          LibDataDir - The non-platform-specific lib/data directory.
#                       This is LMC_HOME/lib/data
#          MdlParent  - One directory above the MdlDir.
#                       Usually, this is LMC_HOME/models/<model>
#
# %MLB are searched in  the same directory that contains
#     the mdl file (typically LMC_HOME/models/<model>/<platform>)
#     and LMC_HOME/lib/<platform_dir>.lib
#     Example: %MLB <AppTypes> <File name> <Versioned function name> <CRC>
# %LLB and %CLB and %EXE are searched in LMC_HOME/lib/<platform_dir>.lib
#     Example: %LLB <AppTypes> <File name> <Versioned function name> <CRC>
#     Example: %CLB <AppTypes> <File name> <Versioned function name> <CRC>
# %MMT and %TMF are searched in  the parent directory that contains
#     the mdl file (typically LMC_HOME/models/<model>)
#     Example: %MMT <Versioned file name> <CRC>
#     Example: %TMF <Versioned file name> <CRC>
# %EXE are searched in LMC_HOME/lib/<platform_dir>.lib
#     Example: %EXE <Executable name> <Versioned executable name> <CRC>

# @(#) crcmdl.pl $Revision: /main/32 $

%ArgRecMDL = (
    "%CCL" => "2,3,LibDataDir",
    "%CLB" => "2,4,LibDir",
    "%CMD" => "1,2,MdlParent",
    "%DOC" => "1,2,MdlParent",
    "%EXE" => "2,3,LibDir",
    "%FMO" => "1,2,MdlDir",
    "%LDB" => "1,2,LibDir",
    "%LLB" => "2,4,LibDir",
    "%MLB" => "2,4,MdlDir:LibDir",
    "%MMT" => "1,2,MdlParent",
    "%SCC" => "1,2,LibDir",
    "%SLI" => "2,3,MdlDir",
    "%TMD" => "1,2,MdlParent",
    "%TMF" => "1,2,MdlParent",
    "%TMT" => "1,2,MdlParent",
    "%ECH" => "1,2,MdlParent",
    "%ECP" => "1,2,LibDataDir",
    "%ECL" => "1,2,LibDir",
    "%EVD" => "1,2,MdlParent",
    "%EVX" => "1,2,MdlParent",
);

#
# A separate associative array is setup for LVD/DVD files.
#   Field 1:  Which argument contains the file name.
#   Field 2:  Which argument contains the expected CRC value, 0=no crc expected.
#   Field 3:  Which field contains the link name (used for calculating path).
#   Field 4:  0 = Plain file, existence not required
#             1 = Plain file, existence required
#             2 = Plain file or dir, existence not required
#             3 = Plain file or dir, existence required
# The search path has been removed since all paths in LVD and DVD files
# are relative to LMC_HOME--there is no search path.
#
%ArgRecLVD = (
    "%LVL" => "1,3,2,3",
    "%LVF" => "1,2,0,1",
    "%UVO" => "3,4,0,0",
    "%UVR" => "3,4,0,1",
    "%DVO" => "1,3,2,0",
    "%DVR" => "1,3,2,1",
    "%DIR" => "1,0,0,0",
    "%LNK" => "1,0,2,0",
    "%MPC" => "3,4,0,1",
);

$CheckLVD    = 0;   # If set, perform LVD/DVD checking.
$CheckMDL    = 0;   # If set, at least one model needs checking.
$CheckAllMDL = 0;   # If set, check all models.
$AltPlatform = 0;   # If set, run check on specified platform.
$Verbose     = 0;   # If set, output additional output.
$Retval      = 0;

$LmcHome       = $ENV{ LMC_HOME };
$LmcPath       = $ENV{ LMC_PATH };
$LmcConfig     = $ENV{ LMC_CONFIG };

# Make STDOUT and STDERR unbuffered so we can immediately see any 
# errors that may occur
select(STDERR); $| = 1;
select(STDOUT); $| = 1;

# Verify LMC_HOME is set.
die "ERROR running $0: The LMC_HOME environment variable must be set.\n"
    unless( $LmcHome );

# Load the 'libmdl' library of subroutines
require "$LmcHome/lib/bin/libmdl01003.pl";

# Verify the environment variables are properly set
$ProgName = VerifyEnv( $LmcHome, $LmcPath, $LmcConfig, \@ARGV );

# Determine which platform we're on
$Platform = GetPlatform();

# Determine path to library directory for this platform
$LibDir = PlatformToLibDir( $Platform, $LmcHome );

# Exit immediately if $LmcCrc is not executable.
$LmcCrcVersion = "sl_crc01004"; 
$LmcCrc = "${LibDir}${LmcCrcVersion}";
if ($Platform eq "pcnt" || $Platform eq 'alphant' ) {
    $LmcCrc .= ".exe"; }

die "ERROR running $ProgName: ",
    "Cannot find Logic Modeling CRC program '$LmcCrc'\n"
    unless( -x $LmcCrc );

#
#  Parse the command line options.  
#  Allow switches on either end of model name.
#
my $PrevArg  = ""; 
for( $i = 0; $i < @ARGV; ) 
{
    if( ($_ = $ARGV[$i]) =~ /^-/ )
    {
       if( $PrevArg ) {
           warn "ERROR running $ProgName: '$PrevArg' is missing ",
                "its argument.\n";
           Usage();
       }

        /^-h/ && Usage();
        /^-a/ && ($CheckAllMDL = 1)   && splice(@ARGV, $i, 1) && next;
        /^-l/ && ($CheckLVD = 1)      && splice(@ARGV, $i, 1) && next;
        /^-v/ && ($Verbose = 1)       && splice(@ARGV, $i, 1) && next;

        # Switches that require an additional argument
        /^-q/ && ($AltPlatform = 1)
                                && ($PrevArg = splice(@ARGV, $i, 1)) && next;

        warn "ERROR running $ProgName: $_ argument unknown.\n";
        Usage();
    }
    elsif( $_ = $PrevArg )
    {
        $PrevArg = "";

        /^-q/ && ($Platform = splice(@ARGV, $i, 1)) && next;
    }
    else
    {
        $i++;
    }
}

if( $PrevArg ) {
    warn "ERROR running $ProgName: '$PrevArg' is missing ",
         "its argument.\n";
    Usage();
}

Usage() if( !@ARGV && !$CheckAllMDL && !$CheckLVD );

#
#  If $AltPlatform is set, we are checking a different platform than
#  the one we are on so we need to redetermine the path to library
#  directory for this platform.  Note that we still need the platform's
#  binary $LmcCrc program, which we determined above.
#
if ( $AltPlatform ) {
    if ( $Platform eq "" ) {
        warn "ERROR running $ProgName: missing arguement.\n";
        Usage();
    }
    $LibDir = PlatformToLibDir( $Platform, $LmcHome );
}

#
#  If $CheckAllMDL is set, all models specified on the command line
#  are redundant--empty the ARGV array.
#  If $CheckAllMdl is not set, but there are still elements in ARGV,
#  then those elements are the models to check.
#
if ( $CheckAllMDL ) {
    @ARGV = ();
    $CheckMDL = 1;
} elsif ( @ARGV ) {
    $CheckMDL = 1;
}

#
#  Handle the MDL and LVD/DVD operation independently.
#  If $CheckMDL is set, then there is at least one model to check.
#  If $CheckLVD is set, then check the latest LVDs and DVDs.
#  
if ( $CheckLVD ) {
    ProcessLVDs();
    CheckCRCs();
}

if ( $CheckMDL ) {
    ProcessMDLs();
    CheckCRCs();
}

exit( $Retval );





############################################################################
# Subroutine:     GetLvdPath
#
#            A routine to retrieve a list of the latest LVD files.
#            An LVD file is a file matching:
#              <platform><any-characters><5-digits>.lvd
#            The list is sorted in reverse (latest versions first).
#            The files are pushed onto the LvdList until the 
#            version changes.
#
# Globals used:     $Libmdl'DirSep
#
# Input arguments:  $Platform  - The platform name.
#                   $LmcHome   - Library Path.
#
# Returns:          \@LvdList  - Reference to List of latest 
#                                LVD file(s).
#
############################################################################
sub GetLvdPath
{
  my( $Platform, $LmcHome ) = @_;
  my( @LvdList ) = ();
  my( @DataFiles ) = ();
  my( $prev_name ) = "";
  my( $tfile ) = "";
  my( $DataDir ) = $LmcHome . $libmdl'DirSep . "data" . $libmdl'DirSep ;

  opendir( DATADIR, $DataDir );
  @DataFiles = grep { /^($Platform)(.*?)(\d{5})\.lvd$/ && 
                      -f "${DataDir}${libmdl'DirSep}$_" &&
                      -r _ && -T _ } readdir( DATADIR );
  closedir DATADIR;

  #
  # Find the latest version in the list of LVD files.
  # By reverse sorting, we will always get the highest numbered version first,
  # save that name for each file prefix.
  #
  foreach $tfile (reverse sort @DataFiles) {
    if ($tfile =~ /(.*?)\d{5}\.lvd$/) {
        if ( $1 ne $prev_name ) {
            # Found new prefix, save to compare against
            $prev_name = $1;

            # Save file name since finding a new prefix means
            # that we've found a new lvd file.
            push(@LvdList, $tfile);
        }
    }
  }

  #
  # Add the DataDir to each entry for full path names.
  #
  foreach (@LvdList) { $_ = "${DataDir}$_" ; }

  return ( \@LvdList );
}


############################################################################
# Subroutine:    GetDvdPath
#
#            A routine to retrieve a list of the latest DVD files.
#            Currently, there can only be one "latest version"
#            so a list of zero or one element is returned.
#            In the future, there may be a need to have multiple
#            latest versions.
#
# Globals used:     $Libmdl'DirSep
#
# Input arguments:  $Platform  - The platform name.
#                   $LmcHome   - Library Path.
#
# Returns:          \@DvdList  - Reference to List of latest 
#                                DVD file(s).
#
############################################################################
sub GetDvdPath
{
  my( $Platform, $LmcHome ) = @_;
  my( @DvdList ) = ();
  my( @DataFiles ) = ();
  my( $DataDir ) = $LmcHome . $libmdl'DirSep . "data" . $libmdl'DirSep ;
  my( $prev_name ) = "";
  my( $tfile ) = "";

  #
  # Collect all of the DVD files in $LMC_HOME/data.
  # DVD files are those files starting with "doc" followed by 5 digits 
  # and are plain files, readable, text files.
  #
  opendir( DATADIR, $DataDir );
  @DataFiles = reverse sort
               grep { /^(.*)(\d{5})\.dvd$/ && 
                      -f "${DataDir}${libmdl'DirSep}$_" &&
                      -r _ && -T _ } readdir( DATADIR );
  closedir DATADIR;

  # If there are any DVD files found, push latest version into the DvdList.
  foreach $tfile (reverse sort @DataFiles) {
    if ($tfile =~ /(.*?)\d{5}\.dvd$/) {
        if ( $1 ne $prev_name ) {
            # Found new prefix, save to compare against
            $prev_name = $1;

            # Save file name since finding a new prefix means
            # that we've found a new lvd file.
            push(@DvdList, $tfile);
        }
    }
  }

  #
  # Add the DataDir to each entry for full path names.
  #
  foreach (@DvdList) { $_ = "${DataDir}$_" ; }

  return ( \@DvdList );
}


############################################################################
# Subroutine:    ProcessLVDs
#
#            A routine to calculate the CRC values for specific
#            lines in LVD and DVD files.  It is modeled after
#            the ProcessMDLs function.
#
# Globals used: $LmcHome
#               $LmcConfig
#               $Platform
#               $DirSep
#               $KeyWords
#               %ArgRecMDL
#
# Input arguments: None
#
# Returns:
#
############################################################################
sub ProcessLVDs
{
    my( $DvdList, $FileRequired );
    my( @Args ) = ();
    my( @ArgSpec ) = ();

    #
    # Since we are using a bunch of globals, clean them up before starting.
    #
    @CrcFiles = @CrcExpect = @CrcRcv = ();
    %CrcHash = {};

    #
    # Get the path of all of the latest '.lvd' files in the data directory.
    # Function GetLvdPath is local, however we may want to promote it to
    # the libmdl.pl (or equivalent.)
    #
    $LvdList = GetLvdPath( $Platform, $LmcHome );
    unless( @$LvdList ) {
        die "ERROR running $ProgName: No '.lvd' files found for ",
            "platform $Platform.\n" ;
    } elsif ( $Verbose ) {
        print "LVD Files Found:\n" ;
        foreach $lvd (@$LvdList) { print "    $lvd\n"; }
        print "\n";
    }

    #
    # Get the path of all of the latest '.dvd' files in the data directory.
    # Function GetDvdPath is local, however we may want to promote it to
    # the libmdl.pl (or equivalent.)
    #
    $DvdList = GetDvdPath( $Platform, $LmcHome );
    unless( @$DvdList ) {
        die "ERROR running $ProgName: No '.dvd' files found.\n" ;
    } elsif ( $Verbose ) {
        print "DVD Files Found:\n" ;
        foreach $dvd (@$DvdList) { print "    $dvd\n"; }
        print "\n";
    }

    # Combine the DVD and LVD lists into LvdList for convenience.
    # foreach (@$DvdList) { push( @$LvdList, $_ ); }
    @$LvdList = ( @$LvdList, @$DvdList );

    #
    # Grep through all of the files for the requested keywords.
    # GrepMdl is used since it looks for keywords in a list of file--
    # not necessarily MDL files.
    #
    $KeyWords = join( '|', keys( %ArgRecLVD ) );
    $LvdContents = GrepMdl( $KeyWords, $LvdList, 1 );

    #
    # LvdLine[0] : The actual line from the LVD/DVD file.
    # LvdLine[1] : The line number in the file.
    # LvdLine[2] : The path to the files itself.
    # 
    foreach $LvdLine ( @$LvdContents ) {

        @Args = split( " ", $$LvdLine[0] );

        # Only consider lines where the first argument in one of our
        # recognized keywords.
        if ( $ArgSpec = $ArgRecLVD{ $Args[0] } ) {

            $CrcExpected = 1;
            ($FileNameIdx, $CrcIdx, $LinkNameIdx, $FileRequired) =
                                   split( /,/, $ArgSpec );
            # When CrcIdx is zero, no crc value is expected
            if ($CrcIdx == 0) {
                # Find total number of args by finding the highest value in
                # the ArgSpec array
                @test_args = split( /,/, $ArgSpec );
                ($CrcIdx) = reverse sort @test_args;
                $CrcIdx++;
                $CrcExpected = 0;
            }

            #
            # Verify that the current line has the correct number of args.
            # Like with MDLs, the CRC is the last field, but may be missing.
            #
            if ( $CrcIdx < $#Args ) {
                # Too many arguments
                warn "ERROR running $ProgName: CRC must be final argument, ",
                     "line $$LvdLine[1], file '$$LvdLine[2]':\n",
                     "  $$LvdLine[0]\n";
                $Retval = 1;
                next;
            } elsif ( $CrcIdx == scalar(@Args) ) {
                # Missing the CRC argument
                $Args[$CrcIdx] = "<none>";
            } elsif ( $CrcIdx > $#Args ) {
                # Not enough arguments
                warn "ERROR running $ProgName: Wrong number of arguments, ",
                     "line $$LvdLine[1], file '$$LvdLine[2]':\n",
                     "  $$LvdLine[0]\n";
                $Retval = 1;
                next;
            }

            #
            # Determine the name of the file we are going to check
            # the CRC.  There are two cases:
            #  1.  The $LinkNameIdx==0 which indicates the 
            #      $FileNameIdx is the full path of the file
            #      offset from LmcHome.
            #  2.  The $LinkNameIdx!=0 which indicates that the
            #      file is determined by prefixing the LinkName's
            #      path to the FileName.
            #      Example:
            #        %LVL lmgrd04001 lib/hp700.lib/lmgrd 2a3349dd
            #        File name is lib/hp700.lib/lmgr04001
            #                                   ^^^^^^^^^ = filename,
            #                     ^^^^^^^^^^^^^^ = Path from link name.
            # (You tell me a better way!?!)
            #
            if ( $LinkNameIdx ) {
                $Args[$LinkNameIdx] =~ /(.*\/)/ ;
                $FileName = $LmcHome . $libmdl'DirSep . 
                              $1 . $Args[$FileNameIdx];
            } else {
                $FileName = $LmcHome . $libmdl'DirSep . $Args[$FileNameIdx];
            }

            #
            # For LVD/DVD files, we should have unique file names in
            # all files.  We should warn against duplicates.
            # Note: If $LinkNameIdx is TRUE, then the line is only redundant
            #       if the filename and the link name are the same.
            #       The toolwrap.csh, for example, may be present many times
            #       which is legal since there are many links to it.
            #
            $HashKey = "$Args[$CrcIdx] $FileName";
            if ( $CrcHash{ $HashKey } ) {
                push( @{ $CrcHash{ $HashKey } }, [$$LvdLine[2], $$LvdLine[1]] );

            } elsif ( -r $FileName ) {
                # If the file is a directory, and its identified as an entry
                # that might be a directory, and the expected CRC is zero 
                # (meaning we expect it to be a directory), don't bother 
                # checking the CRC
                $CrcExpected = 0 if(    ($FileRequired >= 2) 
                                     && (hex($Args[$CrcIdx]) == 0) 
                                     && -d $FileName );
                if ($CrcExpected) {
                    push( @CrcFiles, $FileName );
                    push( @CrcExpect, $Args[$CrcIdx] );
                    push( @{ $CrcHash{$HashKey} }, [$$LvdLine[2],
                                                   $$LvdLine[1]] );
                } 
            } elsif ( ($FileRequired == 1) || ($FileRequired == 3) ) {
                warn "ERROR running $ProgName: Required ",
                     (($FileRequired == 1) ? "file" : "file or directory"),
                     " not found: $FileName\n",
                     "  Referenced in: $$LvdLine[2]\n\n";
                $Retval = 1;
            } elsif ( ($FileRequired == 0) || ($FileRequired == 2) ) {
                warn "WARNING for $ProgName: Optional ",
                     (($FileRequired == 0) ? "file" : "file or directory"),
                     "not found: $FileName\n",
                     "  Referenced in: $$LvdLine[2]\n\n";
            }
        } else {
            # Shouldn't ever get here
            die "ERROR running $ProgName: Unexpected input, ",
                "first arg '$Args[0]', line $$LvdLine[1], ",
                "file '$$LvdLine[2]':\n",
                "$$LvdLine[0]\n\n";
        }

    } ## End  foreach $LvdLine

    if ( $Verbose ) {
        print "# LVD/DVD Expected values:\n";
        for ( $i=0; $i<=$#CrcFiles; $i++ ) {
            print "$CrcExpect[$i]    $CrcFiles[$i]\n"
        }
        print "\n";
    }

    #
    # Call the platform-specific CRC calculation executable to get the
    # CRC of each of the file names in the CrcFiles list.
    #
    if( @CrcFiles ) {
        foreach (@CrcFiles) {
            push ( @CrcRcv, `$LmcCrc $_` );
        }

        if ( $Verbose ) {
            print "# LVD/DVD Calculated values:\n";
            foreach $RcvCrc ( @CrcRcv ) { print $RcvCrc; }
            print "\n";
        }

        die "ERROR running $ProgName: ",
            "CRC calculation program $LmcCrc did not return all data... ",
            "Quitting\n"
            if ( $#CrcFiles != $#CrcRcv );
    } 
}


############################################################################
# Subroutine:    ProcessMDLs
#
#            A routine to calculate CRCs for all files specified
#            in a list of MDL files given a list of model names.  
#            This routine is 
#            mostly to modularize crcmdl with the addition of
#            the LVD/DVD checking.  There are globals all over
#            the place.
#
# Globals used: $LmcHome
#               $LmcConfig
#               $Platform
#               $DirSep
#               $KeyWords
#               %ArgRecMDL
#
# Input arguments: None
#
############################################################################
sub ProcessMDLs 
{
    my( @Args ) = ();
    my( @ArgSpec ) = ();

    #
    # Since we are using a bunch of globals, clean them up before starting.
    #
    @CrcFiles = @CrcExpect = @CrcRcv = ();
    %CrcHash = ();

    # The path to the LMC_HOME/lib/data directory
    $LibDataDir = $LmcHome . $libmdl'DirSep 
                . "lib" . $libmdl'DirSep 
                . "data" . $libmdl'DirSep;

    # Find all the '.lmc' files in the path
    $PathList = FindLmc( $Platform, $LmcHome, $LmcConfig );

    unless( @$PathList) {
        die "ERROR running $ProgName: No '.lmc' files found anywhere in\n",
            "      LMC_CONFIG or LMC_HOME/data directories\n";
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
            "      Using model versions listed in lmc files: @$PathList\n";
    }

    # Regular expression to find keywords in '.mdl' files that contain a CRC.
    $KeyWords = join( '|', keys( %ArgRecMDL ) );

    #
    # Grep through each '.mdl' file for any of the requested keywords.
    # Returns a two-dimensional array reference, where the row-major 
    # dimension represents each line read from each '.mdl' file and 
    # the minor indexes are as follows:
    #   [x][0] = The contents of the line.
    #   [x][1] = The line number in the file.
    #   [x][2] = The path to the '.mdl' file.
    #
    $MdlContents = GrepMdl( $KeyWords, $MdlList, 0 );

    #
    # Build a @CrcFiles array and @CrcExpect array (with identical indexing)
    # that contain a list of filenames and their expected CRC as we read 
    # from each '.mdl' file.
    #
    foreach $MdlLine ( @$MdlContents ) {
        # Split the line read from the '.mdl' into its separate arguments
        @Args = split( ' ', $$MdlLine[0] );
  
        # Check for one of the %XXX commands that we know about.
        # We know we should always get a match here since we just 
        # grep'd for all the keywords we know about.
        if ( $ArgSpec = $ArgRecMDL{ $Args[0] } ) {
            # Pull apart the records of the ArgSpec
            ($FileNameIdx, $CrcIdx, $SearchPath) = split( /,/, $ArgSpec );
            @SearchArray = split( /:/, $SearchPath );

            #
            # Check to ensure we got the correct number of arguments
            # from the line in the '.mdl' file.
            #
            if ( $CrcIdx < $#Args ) {
                # Found too many arguments.
                # The CRC should always be the last argument to each command
                # in the '.mdl' file (by convention) so that it is easy
                # to generate the initial CRC values by just leaving the field
                # blank and running this script.
                warn "ERROR running $ProgName: CRC must be final argument, ",
                     "line $$MdlLine[1], file '$$MdlLine[2]':\n",
                     "  $$MdlLine[0]\n";
                $Retval = 1;
                next;
            } elsif ( $CrcIdx == scalar(@Args) ) {
                # The CRC argument is optional.
                # Do not generate a warning if not present, just fill
                # in "<none>" as the existing value.
                $Args[$CrcIdx] = "<none>";
            } elsif ( $CrcIdx > $#Args ) {
                # Not enough arguments. All other arguments are required.
                warn "ERROR running $ProgName: Wrong number of arguments, ",
                     "line $$MdlLine[1], file '$$MdlLine[2]':\n",
                     "  $$MdlLine[0]\n";
                $Retval = 1;
                next;
            }

            $FoundFile = 0;
            $Looked    = "";

            #
            # Determine if we can find the file somewhere in the
            # path as specified in the %ArgSpec
            #
            foreach $SearchPath ( @SearchArray ) {
                if ( $SearchPath =~ /MdlDir/ ) {
                    # Strip the '.mdl' file name off the path to the '.mdl'
                    # file to get the path to the directory that contains the
                    # '.mdl' file.
                    $$MdlLine[2] =~ /(.*\/)/;
                    $FileName = $1 . $Args[$FileNameIdx];
                    $Looked = $Looked ? "$Looked or '$1'" : "'$1'";
                } elsif ( $SearchPath =~ /LibDir/ ) {
                    $FileName = $LibDir . $Args[$FileNameIdx];
                    $Looked = $Looked ? "$Looked or '$LibDir'" : "'$LibDir'";
                } elsif ( $SearchPath =~ /LibDataDir/ ) {
                    $FileName = $LibDataDir . $Args[$FileNameIdx];
                    $Looked = $Looked ? "$Looked or '$LibDataDir'" 
                                      : "'$LibDataDir'";
                } elsif ( $SearchPath =~ /MdlParent/ ) {
                    # Strip the platform directory and '.mdl' file name off 
                    # the path to the '.mdl' file to get the path to the 
                    # parent directory of the '.mdl' file.
                    $$MdlLine[2] =~ /(.*\/).*\//;
                    $FileName = $1 . $Args[$FileNameIdx];
                    $Looked = $Looked ? "$Looked or '$1'" : "'$1'";
                } else {
                    # Shouldn't ever get here since we specify the ArgSpec
                    # within this file and should therefore never get an
                    # unknown SearchPath name
                    die "ERROR running $ProgName: Impossible error #2";
                }

                #
                # The %CrcHash is keyed by the name of the included file
                # so that we don't bother testing for a file's
                # readability over and over (which is slow).
                # We key by both the expected CRC value and the file name 
                # (instead of just the file name) in case two
                # '.mdl' files list the same name with different
                # CRC values (which should theoretically never occur
                # at the customer site since every new version of a 
                # file should go by a new versioned name, but which we 
                # can't ensure while we are building new unreleased models).
                # Key is   "<Expected crc value> <Included file name>"
                # Value is [[<Mdl file name>,<Mdl line number>] 
                #           [<Mdl file name>,<Mdl line number>]...]
                #
                $HashKey = "$Args[$CrcIdx] $FileName";

                if ( $CrcHash{ $HashKey } ) {
                    push( @{ $CrcHash{ $HashKey } }, 
                          [$$MdlLine[2], $$MdlLine[1]] );
                    $FoundFile = 1;
                    last;
                } elsif ( -r $FileName ) {
                    push( @CrcFiles, $FileName );
                    push( @CrcExpect, $Args[$CrcIdx] );
    
                    $CrcHash{ $HashKey } = [[$$MdlLine[2], $$MdlLine[1]]];
                    $FoundFile = 1;
                    last;
                }
            }

            # Verify the file was found somewhere in the expected path
            unless( $FoundFile ) {
                warn "ERROR running $ProgName: The '.mdl' file ",
                     "'$$MdlLine[2]'\n",
                     "  lists the file '$Args[$FileNameIdx]' ",
                     "at line number $$MdlLine[1]\n",
                     "  which cannot be found in $Looked.\n\n";
    
                $Retval = 1;
            }
    
        } else {
            # Shouldn't ever get here
            die "ERROR running $ProgName: Unexpected input, ",
                "first arg '$Args[0]', line $$MdlLine[1], ",
                "file '$$MdlLine[2]':\n",
                "$$MdlLine[0]\n\n";
        }

    } ## End foreach $MdlFile

    if( @CrcFiles ) {
        #
        # We now know all of the expected values and all of the files
        # we are going to check.  If verbose is set, print them out.
        #
        if ( $Verbose ) {
            print "# MDL Expected values:\n";
            for ( $i=0; $i<=$#CrcFiles; $i++ ) { 
                print "$CrcExpect[$i]    $CrcFiles[$i]\n"
            }
            print "\n";
        }

        #
        # Call the platform-specific CRC calculation executable to get the
        # CRC of each of the file names in the CrcFiles list.
        #
        foreach (@CrcFiles) {
            push ( @CrcRcv, `$LmcCrc $_` );
        }

        if ( $Verbose ) {
            print "# MDL Calculated values:\n";
            foreach $RcvCrc ( @CrcRcv ) { print $RcvCrc; }
            print "\n";
        }

        die "ERROR running $ProgName: ",
            "CRC calculation program $LmcCrc did not return all data ... ",
            "Quitting\n"
            if ( $#CrcFiles != $#CrcRcv );
    }
}


############################################################################
# Subroutine:    CheckCRCs
#
#            A routine to compare the CRC values calculated
#            with the expected values.  Print a message if there
#            is a difference.
#
# Globals used: @CrcFiles
#               @CrcExpect
#               @CrcRcv
#               %CrcHash
#               $ProgName
#
# Input arguments:
#
# Returns:
#
############################################################################
sub CheckCRCs
{
    my( $i, $RcvCrc, $FileName, $HashList );

    for ( $i = 0; $i <= $#CrcFiles; $i++ ) {
        ($RcvCrc, $FileName) = split( ' ', $CrcRcv[$i], 2 );
        chomp( $FileName );

        #
        # $FileName must be equal $CrcFiles[$i] here.
        # The CRC calculation program must return the CRC values
        # for all the files we requested, in the exact order that
        # we requested.
        #
        unless ( $FileName eq $CrcFiles[$i] ) {
            die "ERROR running $ProgName: ",
                "Expect matching files '$CrcFiles[$i]' and '$FileName'\n";
        }
        
        #
        # Disallow RcvCrc == 0, regardless of match, since it
        # means we found an empty file
        #
        if ( hex($RcvCrc) == 0 ) {
            warn "ERROR running $ProgName: $FileName: CRC = 0, EMPTY FILE!\n\n";
            $Retval = 1;
        } elsif ( $RcvCrc ne $CrcExpect[$i] ) {
            warn "$FileName: Expect CRC $CrcExpect[$i], ",
                 "Receive $RcvCrc\n",
                 "  Used by File(s):\n";
            foreach $HashList ( @{ $CrcHash{ "$CrcExpect[$i] $FileName" } } ) {
                warn "  $HashList->[0], line $HashList->[1]\n";
            }
            warn "\n";
            $Retval = 1;
        }
    }
}
