package libmdl;
# Copyright(C)2000 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
# This perl library file contains the subroutines used by many of the
# LMC tools to find the versioned files used by each model.
#
# Subroutines defined:
#    FindLmc()
#        - Returns a list of all the '.lmc' files currently in the path.
#
#    GetExeSuffix()
#        - Return the suffix of executable files on the platform.
#
#    GetExeVer()
#        - Given a list of paths to '.lmc' files, generates a
#          hash list of all the versions of all executables that
#          appear in the '.lmc' files.
#
#    GetMdlPath()
#        - Given a list of model names, generates a list of
#          paths to '.mdl' files, one for each model.
#          If the list of model names is empty, finds the '.mdl' 
#          file for each of the models listed in all the '.lmc' files.
#          If the '.mdl' file cannot be found, a message is
#          generated to stdout.
#
#    GetModelVer()
#        - Given a list of paths to '.lmc' files, generates a
#          hash list of all the versions of all models that
#          appear in the '.lmc' files.
#
#    GetPlatform()
#        - Returns the name of the platform that is executing this code.
#
#    GrepMdl()
#        - Grep through each '.mdl' file for any of the requested
#          keywords.  Given a regular expression that contains the
#          %XXX keywords to search and a list of '.mdl' files,
#          find all occurrences of the keywords in the '.mdl'
#          files.  For example:
#          GrepMdl( "%MLB|%LLB|%CLB",
#                   "models/ttl00/hp700/v01000.mdl" )
#          If the '.mdl' file cannot be found, a message is
#          generated to stderr and the script is exited.
#
#    PlatformToLibDir()
#        - Given a platform name and location of LMC_HOME, return
#          the path to the platform-specific library directory
#          $LMC_HOME/lib/<platform_dir>.lib/
#
#    Usage()
#        - Print the comments at the beginning of the invoking script
#          as the usage message, up to the first line that does not
#          begin with a '#'.
#
#    VerifyEnv()
#        - Verifies the LMC_HOME, LMC_PATH, and LMC_CONFIG environment
#          variables and returns the name of the currently running
#          perl script. Also verifies the LMC_HOME contains the
#          directories that should always exist in an LMC_HOME.
#

# @(#) libmdl.pl $Revision: /main/23 $

# Directory separator (Global variable)
$DirSep     ="/";

# Path separator (Global variable)
$PathSep    =":";
if (-e "c:\\") {
    $PathSep    =";";
}

# This is our first stab at the name of the currently executing
# program.  Once somebody calls VerifyEnv, we will update the
# name based on the -p argument passed to the tool.
# The '-p' switch is used when a csh script is used to invoke
# perl (and therefore we lose the name of the original script
# that started everthing off).  The '-p' switch is not
# necessary if these scripts are being run directly.
($ProgName) = $0 =~ /([\w\.]+)$/;


# GrepMdl compiles its regular expression once at its first invocation.
# Subsequent calls will use the original regexp, probably not what you 
# want.  This static variable is to prevent GrepMdl from being called
# twice
$GrepMdlAlreadyCalled = 0;


##############################################################################
# Subroutine:      FindLmc                                                   #
#                  Return a list of all the '.lmc' files in the              #
#                  path.                                                     #
# Globals used:    $DirSep    - Directory separator ('/' or '\')             #
# Input arguments: $Platform, $LMC_HOME, $LMC_CONFIG                         #
# Returns:         \@PathList - Reference to array of paths to               #
#                  all '.lmc' files.                                         #
##############################################################################
sub main'FindLmc
{
    my( $Platform, $LmcHome, $LmcConfig ) = @_;
    my( @PathList ) = ();
    my( @LmcList ) = ();
    my( $File );

    if( $LmcConfig ) {
        @LmcList = split( /$PathSep/, $LmcConfig );
    }

    # Last place to search is $LMC_HOME/data/<platform>.lmc
    push( @LmcList, "${LmcHome}${DirSep}data${DirSep}${Platform}.lmc" );

    # Check that each '.lmc' file ends with a '.lmc' suffix, 
    # the file exists, is readable, and is text
    foreach $File ( @LmcList ) {
        if( ($File =~/\.lmc\s*$/) && -e $File && -r _ && -T _ ) {
            push( @PathList, $File );
        }
    }

    return( \@PathList );
}


###############################################################################
# Subroutine:      GetExeSuffix                                               #
#                  Given a platform name, return the suffix for executable    #
#                  files.                                                     #
# Input arguments: $Platform                                                  #
# Returns:         $Suffix - String to append for executable files            #
###############################################################################
sub main'GetExeSuffix
{
    my( $Platform ) = @_;
    return( ($Platform eq "pcnt" || $Platform eq "alphant") ? ".exe" : "" );
}


###############################################################################
# Subroutine:      GetExeVer                                                  #
#                  Given a list of paths to '.lmc' files, generate a          #
#                  hash list of all the versions of all executables that      #
#                  appear in the '.lmc' files.                                #
# Input arguments: \@PathList  - Reference to array of paths to '.lmc' files. #
# Returns:         \%Exe2Ver - Reference to list of all executable versions.  #
#                  Key is Executable Name as it appears in '.lmc' file.       #
#                  Value is                                                   #
#                    '<Lmc_File> <Version>'.                                  #
###############################################################################
sub main'GetExeVer
{
    my( $PathList )      = @_;
    my( %Exe2Ver )       = ();
    my( %PathListFound ) = ();
    my( $File, $i, @Line );

    # Read the model versions listed in all the '.lmc' files.
    # We read the files in the order they were listed in the
    # LMC_PATH.  As we build the associative array of executable
    # names to executable versions, we are careful to only use the
    # first version of any executable that appears in the '.lmc'
    # files.
    foreach $File ( @$PathList ) {
        # Don't bother rereading this '.lmc' file if we've
        # already read it previously in the path
        unless( $PathListFound{ $File }++ ) {
            if( open( LMCFILE, $File ) ) {
                while( <LMCFILE> ) {
                    if( /^\s*%EXE/ ) {
                        @Line = split;

                        if($#Line < 2) {
                            chop;
                            warn "ERROR running $ProgName on ",
                                 "file $File: Bad %EXE on line $.\n",
                                 "Expected atleast 2 arguments, found ",
                                     $#Line,
                                     "\n",
                                 "Expected %EXE <Name> <Version> [<CRC>]\n",
                                 "Found '$_'\n\n";
                        } else {
                            # The model's physical directory name is allowed
                            # as one of the model's names
                            $Exe2Ver{ $Line[1] } = "$File $Line[2]"
                                unless( $Exe2Ver{ $Line[1] } );
                        }
                    }
                }
                close( LMCFILE );
            } else {
                warn "ERROR running $ProgName: ",
                     "Can't open file $File: $!\n\n";
            }
        }
    }

    return( \%Exe2Ver );
}


#############################################################################
# Subroutine:      GetMdlPath                                               #
#                  Given an ARGV list of model names, generate a list of    #
#                  paths to '.mdl' files, one for each model.               #
#                  If Argv is empty, finds the '.mdl' file for each of the  #
#                  models listed in all the '.lmc' files.                   #
#                  If the '.mdl' file cannot be found, a message is         #
#                  generated to stderr.                                     #
# Globals used:    $DirSep     - Directory separator ('/' or '\')           #
# Input arguments: $Platform   - Current name of platform                   #
#                  $LMC_HOME   - LMC_HOME environment variable setting.     #
#                  $LMC_PATH   - LMC_PATH environment variable setting.     #
#                  \%Model2Ver - A reference to the hash of model names to  #
#                                their versions.                            #
#                  \@Argv      - A reference to the ARGV array.  Each       #
#                                argument is a model name to find.          #
#                                Each name can be the Logical or Physical   #
#                                name. If the array is empty, all models    #
#                                will be searched.                          #
# Returns:         \@MdlList   - Reference to the list of paths to mdl      #
#                                files.                                     #
#############################################################################
sub main'GetMdlPath
{
    my( $Platform, $LmcHome, $LmcPath, $Model2Ver, $Argv ) = @_;
    my( @MdlList ) = () ;
    my( $LmcFile, $PhysicalName, $Ver );
    my( $Model, $ModelVerInfo, $TrailPath, $FoundMdl, $PathDir, $File );
    my( @Dirs )        = () ;
    my( %VersionDone ) = ();

    # Get the colon-separated list of directories from LMC_PATH
    if( $LmcPath ) {
        @Dirs = split( /$PathSep/, $LmcPath );
    }

    # Add $LMC_HOME/models to the directories to search for '.mdl' files
    push( @Dirs, $LmcHome . $DirSep . "models" );

    # Find the '.mdl' files for the Argv list of models.
    # If Argv is empty, find the '.mdl' file for each of the models
    # that are listed in all the '.lmc' files
    foreach $Model ( @$Argv ? @$Argv : sort keys %$Model2Ver ) {
        if( !($ModelVerInfo = $$Model2Ver{ lc($Model) }) ) {
            warn "ERROR running $ProgName: ",
                 "Model '$Model' is unknown because it is ",
                 "not listed in any '.lmc' files.\n\n";
            next;
        }

        ($LmcFile, $PhysicalName, $Ver) = split(/ /, $ModelVerInfo);

        # The trailing part of the path to a '.mdl' file:
        # <model_physical_name>/<platform>/<model_physical_name><version>.mdl
        $TrailPath = $PhysicalName . $DirSep . $Platform
                   . $DirSep . $PhysicalName . $Ver . ".mdl";

        # Only report the same physical model once.
        # The physical name of the model is the same as the directory
        # that contains the model files.
        unless( $VersionDone{ $PhysicalName }++ ) {

            # Search for the '.mdl' file throughout the LMC_PATH,
            # quit once we find the first one
            $FoundMdl = 0;
            foreach $PathDir ( @Dirs ) {
                # search for $LMC_PATH/<model>/<platform>/<model><version>.mdl
                $File = $PathDir . $DirSep . $TrailPath;

                if( -e $File && -r _ && -T _ ) {
                    push( @MdlList, $File );
                    $FoundMdl = 1;
                    last;
                }
            }

            if( !$FoundMdl ) {
                warn "ERROR running $ProgName: File '$LmcFile'\n",
                     "lists model '$Model', but can't find a file \n",
                     "    '$TrailPath'\n",
                     "in the LMC_PATH or in LMC_HOME/models\n\n";
            }
        }
    }

    return( \@MdlList );
}


###############################################################################
# Subroutine:      GetModelVer                                                #
#                  Given a list of paths to '.lmc' files, generate a          #
#                  hash list of all the versions of all models that           #
#                  appear in the '.lmc' files.                                #
# Input arguments: \@PathList  - Reference to array of paths to '.lmc' files. #
# Returns:         \%Model2Ver - Reference to list of all model versions.     #
#                  Key is Model Name.                                         #
#                  Value is                                                   #
#                    '<Lmc_File> <Physical_Name> <Model_Version>'.            #
###############################################################################
sub main'GetModelVer
{
    my( $PathList ) = @_;
    my( %Model2Ver )           = ();
    my( %PathListFound )       = ();
    my( $File, $i, @Line );

    # Read the model versions listed in all the '.lmc' files.
    # We read the files in the order they were listed in the
    # LMC_PATH.  As we build the associative array of model
    # names to model versions, we are careful to only use the
    # first version of any model that appears in the '.lmc'
    # files.
    foreach $File ( @$PathList ) {
        # Don't bother rereading this '.lmc' file if we've
        # already read it previously in the path
        unless( $PathListFound{ $File }++ ) {
            if( open( LMCFILE, $File ) ) {
                while( <LMCFILE> ) {
                    if( /^\s*%MOD/ ) {
                        @Line = split;

                        if($#Line < 2) {
                            chop;
                            warn "ERROR running $ProgName on ",
                                 "file $File: Bad %MOD on line $.\n",
                                 "Expected atleast 2 arguments, found ",
                                     $#Line, "\n",
                                 "Expected %MOD <model_name> <version> ",
                                     "[<alias>...]\n",
                                 "Found '$_'\n\n";
                        } else {
                            # The model's physical directory name is allowed
                            # as one of the model's names (except we force the
                            # corresponding logical name to lower case).
                            $Model2Ver{ lc($Line[1]) } = 
                                "$File $Line[1] $Line[2]"
                                unless( $Model2Ver{ lc($Line[1]) } );

                            # The model may also go by alias names
                            # (which we force to lower case so we can later
                            # do a case-insensitive search).
                            for( $i = 3; $i <= $#Line; $i++ ) {
                                $Model2Ver{ lc($Line[$i]) } =
                                    "$File $Line[1] $Line[2]"
                                    unless( $Model2Ver{ lc($Line[$i]) } );
                            }
                        }
                    }
                }
                close( LMCFILE );
            } else {
                warn "ERROR running $ProgName: ",
                     "Can't open file $File: $!\n\n";
            }
        }
    }

    return( \%Model2Ver );
}


###################################################################
# Subroutine:      GetPlatform                                    #
#                  Return the Logic Modeling name of the platform #
#                  that is executing this code.                   #
# Input arguments: none                                           #
# Returns:         $Platform - The Logic Modeling platform name.  #
###################################################################
sub main'GetPlatform
{
    # Map of the first argument returned by 'uname -a'
    # to the prefix we use for default '.lmc' files
    # that we search in the $LMC_HOME/data directory
    my( %OSNameToPlatform ) = ( "HP-UX",   "hp700",
                                "SunOS",   "sunos",
                                "Solaris", "solaris",
                                "AIX",     "ibmrs",
                                "OSF1",    "decalpha",
			    "x86_linux",   "x86_linux",
                            "CYGWIN32_NT", "pcnt", 
                            "CYGWIN32_ALPHANT", "alphant" );
    my( $UName, $OSName, $Host, $OSRelease, $Ver, $Model, $Platform );

    $Platform = "";

    if( -d "/usr/apollo/bin" ) {
        $Platform = "apollo";
    } elsif( -x "/bin/uname" ) {
        $UName = `/bin/uname -a`;

        ($OSName, $Host, $OSRelease, $Ver, $Model) = split( /\s+/, $UName );

        # Some platforms do not have a direct mapping from the OSName
        # returned by 'uname -a' and the platform name that we use:
        #    - On the hp700, we need to check the 5th argument (the 'Model')
        #      from 'uname -a' to ensure this is a model 7xx or 8xx.
        #    - On the sun, we need to check the release number of the OS
        #      to determine whether this is 'sunos' or 'solaris'.
        if( ($OSName eq "HP-UX") && !($Model =~ /9000\/[78][0-9][0-9]/) ) {
            $OSName = "";
        } elsif( $OSName eq "SunOS" ) {
            $OSName = "Solaris" unless( $OSRelease =~ /(\d)/ && ($1 < 5) );
        } elsif( $OSName eq "CYGWIN32_NT" ) {
	    $OSName = "CYGWIN32_ALPHANT" unless( $Model ne 'alpha' );
        } elsif( $OSName eq "Linux" ) {
            ## uname returns a much longer string
            my ( $hardware ) = `/bin/uname -m`;
	    chomp $hardware;
            ## I wonder what a cyrix or amd chip returns?
            if ( $hardware =~ /i.86/ ) {
              $OSName = "x86_linux";
            }
	}

        # Convert the OSName returned by 'uname -a' to the platform
        # names used by Logic Modeling
        $Platform = $OSNameToPlatform{ $OSName };
    }
    elsif ( $ENV{'PROCESSOR_ARCHITECTURE'} eq "x86" ) {
	$Platform = 'pcnt'; 
    } 
    elsif ( $ENV{'PROCESSOR_ARCHITECTURE'} eq "ALPHA" ) {
	$Platform = 'alphant'; 
    } 
    die "ERROR running $ProgName: Platform type not supported.\n"
        unless( $Platform );

    return( $Platform );
}


#############################################################################
# Subroutine:      GrepMdl                                                  #
#                  Grep through each '.mdl' file for any of the requested   #
#                  keywords.  Given a regular expression that contains the  #
#                  %XXX keywords to search and a list of '.mdl' files,      #
#                  find all occurrences of the keywords in the '.mdl'       #
#                  files.  For example:                                     #
#                      GrepMdl( "%MLB|%LLB|%CLB",                           #
#                               "models/ttl00/hp700/v01000.mdl" )           #
#                  If the '.mdl' file cannot be found, a message is         #
#                  generated to stderr and the script is exited.            #
# Input arguments: $KeyWords     - A list of KeyWords in Perl RegExp form.  #
#                  \@MdlList     - Reference to the list of paths to mdl    #
#                                  files.                                   #
#                  $DisableOpt   - Optional third argument.  If this third  #
#                                  argument is present and non-zero,        #
#                                  disables the regular expression          #
#                                  optimization so this subroutine can be   #
#                                  called multiple times within one perl    #
#                                  script.
# Returns:         \@MdlContents - Reference to the two-dimensional array   #
#                                  of lines found in the '.mdl' files.      #
#                                  The row-major dimension represents each  #
#                                  line read from each '.mdl' file and      #
#                                  the minor indexes are as follows:        #
#                                  [x][0] = The contents of the line.       #
#                                  [x][1] = The line number in the file.    #
#                                  [x][2] = The path to the '.mdl' file.    #
#############################################################################
sub main'GrepMdl
{
    my( $KeyWords, $MdlList ) = @_;
    my( $MdlFile );
    my( @MdlContents ) = ();

    # If the regular expression is just '*', they really meant '.*'
    # so we'll be nice and add the '.' for them
    if( $KeyWords =~/^\*/ ) {
        $KeyWords = "." . $KeyWords;
    }
    
    # If the optional third argument (a boolean) exists and is true,
    # it means we should disable the optimization of the regular expression
    # pattern match (so this subroutine can be called multiple times)
    if( ($#_ == 2) && $_[2] ) {
        foreach $MdlFile ( @$MdlList ) {
            open( MDLFILE, $MdlFile ) || die "ERROR running $ProgName: ",
                                             "Cannot open file $MdlFile: $!.\n";
            while( <MDLFILE> ) {
                if( /^\s*($KeyWords)/ ) {
                    push( @MdlContents, ([$_,$.,$MdlFile]) ); 
                }
            }
            close( MDLFILE );
        }
    } else {
        $GrepMdlAlreadyCalled == 0 || die "GrepMdl uses optimized compiled ",
                                          "regexp and cannot be called twice ",
                                          "unless the third argument is set.\n";

        foreach $MdlFile ( @$MdlList ) {
            open( MDLFILE, $MdlFile ) || die "ERROR running $ProgName: ",
                                             "Cannot open file $MdlFile: $!.\n";
    
            while( <MDLFILE> ) {
                # The KeyWord must appear at the beginning of a line.
                # Whitespace can precede the KeyWord, but any other characters
                # turn the line into a comment.
                if( /^\s*($KeyWords)/o ) {
                    push( @MdlContents, ([$_,$.,$MdlFile]) ); 
                }
            }
            close( MDLFILE );
        }
    
        $GrepMdlAlreadyCalled = 1;
    }

    return( \@MdlContents );
}


###################################################################
# Subroutine:      PlatformToLibDir                               #
#                  Given a platform name and the location of      #
#                  LMC_HOME, return the path to the               #
#                  platform-specific library directory.  The      #
#                  platform name must be  one of the names        #
#                  returned by GetPlatform. The path always ends  #
#                  with the directory separator ('/') so file     #
#                  names can be conveniently added to the end.    #
# Globals used:    $DirSep    - Directory separator ('/' or '\')  #
# Input arguments: $Platform, $LMC_HOME                           #
# Returns:         $LibPath - The path to the platform-specific   #
#                  library directory (backslash appended)         #
###################################################################
sub main'PlatformToLibDir
{
    my( $Platform, $LmcHome ) = @_;
    my( $Path );

    # Map of the Logic Modeling platform name to the name
    # of the platform-specific directory that exists in
    # $LMC_HOME/lib 
    my( %Platform2LibDir ) = ( "hp700",    "hp700",
                               "sunos",    "sun4SunOS",
                               "solaris",  "sun4Solaris",
                               "ibmrs",    "ibmrs",
                               "decalpha", "decalpha",
                               "x86_linux","x86_linux",
                               "pcnt",     "pcnt",
                               "alphant",  "alphant" );

    

    unless( $Path = $Platform2LibDir{ $Platform } ) {
        die "Unknown platform name '$Platform' specified in call to ",
            "PlatformToLibDir().\n";
    }

    # Build path '$LMC_HOME/lib/<platform_dir>.lib/'
    $Path = $LmcHome . $DirSep . "lib" . $DirSep . $Path . ".lib" . $DirSep;

    return( $Path );
}


#############################################################################
# Subroutine:      Usage                                                    #
#                  Print the comments at the beginning of the invoking      #
#                  script (as determined by reading $0) as the usage        #
#                  message, up to the first line that does not begin        #
#                  with a '#'.                                              #
# Input arguments: none                                                     #
# Returns:         none                                                     #
#############################################################################
sub main'Usage
{
    open(SCRIPT, "$0") 
        || die "Bad usage, but can't even find script file.\n";
    <SCRIPT>;   # discard first line (the perl invocation line).
    while ( <SCRIPT> ) {
        /^# ?(.*\n)/ ? print $1 : die "\n";
    }
    die;        # for completeness...should already be dead!
}


###################################################################
# Subroutine:      VerifyEnv                                      #
#                  Verify the LMC environment variables are set   #
#                  so the Logic Modeling software can be run.     #
# Input arguments: $LMC_HOME   - Current setting of env variable. #
#                  $LMC_PATH   - Current setting of env variable. #
#                  $LMC_CONFIG - Current setting of env variable. #
#                  \@ARGV      - Reference to ARGV so can extract #
#                                '-p' argument that represents    #
#                                name of currently executing      #
#                                script.                          #
# Returns:         The name of the currently executing program.   #
###################################################################
sub main'VerifyEnv
{
    my( $LmcHome, $LmcPath, $LmcConfig, $Argv ) = @_;
    my( @LmcList )      = ();
    my( @SwiftDirs )    = ( "bin", "data", "doc", "lib", "models", 
                            "lib" . $DirSep . "bin" );
    my( $Arg, $FullName );

    # Check for -p command line switch.  If it's found, read the
    # name of this program from it and remove the -p switch from
    # ARGV
    for( $Arg = 0; $_ = $$Argv[$Arg]; $Arg++ ) {
        if( /^-p/i ) {
            splice( @$Argv, $Arg, 1 );
            if( $$Argv[$Arg] ) {
                ($ProgName) = splice( @$Argv, $Arg, 1 ) =~ /([\w\.]+)$/;
            } else {
                warn "ERROR running $0: ",
                     "-p argument requires a file name.\n\n";
            }
            last;
        }
    }

    die "ERROR running $ProgName: ",
        "The LMC_HOME environment variable must be set.\n"
        unless( $LmcHome );

    if( $LmcConfig ) {
        @LmcList = split( /$PathSep/, $LmcConfig );

        # Check that each file in the LMC_CONFIG ends with a '.lmc' suffix. 
        # If the file exists, verify it is readable and is text.
        foreach $File ( @LmcList ) {
            if( !($File =~/\.lmc\s*$/) ) {
                warn "ERROR running $ProgName: ",
                     "Each file listed in the LMC_CONFIG environment variable ",
                     "must contain the suffix '.lmc', ignoring '$File'.\n";
            } elsif( -e $File ) {
                if( ! -r _ ) {
                    warn "ERROR running $ProgName: ",
                         "The file '$File' is not readable.\n";
                } elsif( ! -T _ ) {
                    warn "ERROR running $ProgName: ",
                         "The file '$File' is not a text file.\n";
                }
            }
        }
    }

    # Verify that the LMC_HOME directory looks like one
    foreach $DirName (@SwiftDirs) {
        $FullName = $LmcHome . $DirSep . $DirName;
        unless( -d $FullName ) {
            die "ERROR running $ProgName: ",
                "The LMC_HOME environment variable does not point to a valid ",
                "SWIFT SmartModel directory structure.\n",
                "The directory '$FullName' is missing.\n";
        }
    }

    # Currently, there are no rules to check the LMC_PATH variable,
    # but I included it as an argument in case I ever need to check it

    return( $ProgName );
}


# The following line ensures this script can be 'required' by another
# script.  If we reach the end, we have successfully loaded this file
# and therefore return a 1.
1;
