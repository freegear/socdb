#!/usr/local/bin/perl5.001
# Copyright(C)1998 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# modeldiff <old lmc_home directory>
#
#   Compares (diff) the contents of LMC_HOME with an old style library.
#   Reports models found in one library but not the other, and compares
#   the version numbers (what strings).  If the old style library has a model
#   version that is later than the LMC_HOME, an error is generated, the user
#   is advised to request an update from Synopsys/Logic Modeling.
#
#   All errors are written to a log file called: modeldiff.log.
#

# @(#) modeldiff.pl $Revision: /main/10 $

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

# Need file name
unless( @ARGV == 1 ) {
    Usage();
}

# Determine which platform we're on
$Platform = GetPlatform();

if ($Platform eq 'pcnt') {
    die "ERROR: modeldiff is not supported on NT.\n"; }

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

# Open log file, take any file ext and add .log.  Only send error messages
# to the log file, not status messages.
$logfile = $ProgName;
$position = rindex($logfile, ".");
if ($position >= 0) {
    $logfile = substr($logfile, 0, $position);
}
unless( open(LOGFILE, ">$logfile.log") ) {
    die "Can't open log file: $logfile.log\n";
}

# Set Old style (<= R40) release
$OldLmcHome = $ARGV[0];

unless (-e $OldLmcHome ) {
    die "Can't open $OldLmcHome\n";
}
unless (-e $LmcHome ) {
    die "Can't open $LmcHome\n";
}
my $R40ModelDir;
if ($Platform eq 'pcnt') {
    $R40ModelDir = 'models'; }
else {
    $R40ModelDir = 'templates'; }

opendir(OLDDIR, $OldLmcHome . "/$R40ModelDir") ||
	die("Can't open $OldLmcHome/$R40ModelDir\n");
@oldfiles = readdir(OLDDIR);
closedir(OLDDIR);
@oldfiles = sort @oldfiles;
opendir(NEWDIR, $LmcHome . "/models") ||
	die("Can't open $LmcHome/models\n");
@newfiles = readdir(NEWDIR);
closedir(NEWDIR);
@newfiles = sort @newfiles;
$newcount = 0;
$comparecount = $samecount = $highnew = $highold = 0;
for ($oldcount = 0; $oldcount < @oldfiles; )
{
    if ($newcount < @newfiles)
    {
	$cmpval = $oldfiles[$oldcount] cmp $newfiles[$newcount];
    }
    else
    {
	$cmpval = -1; # Force it to move to next old file
    }
    if ($cmpval == 0)
    {
	$cmpstr = substr($oldfiles[$oldcount],0,1);
	if ($cmpstr ne ".")
	{
	    print("Comparing $oldfiles[$oldcount]\n");

	    # Get the path to all the '.mdl' files for the model specified
	    @modellist = $oldfiles[$oldcount];
	    $MdlList = GetMdlPath( $Platform, $LmcHome, $LmcPath, $Model2Ver,
				   \@modellist );

	    unless( @$MdlList)
	    {
		die "ERROR running $ProgName: No '.mdl' files found for ",
		    "requested models.\n",
		    "Using model versions listed in lmc files: @$PathList\n";
	    }

	    $libfilename = "";
	    $extval = "";
	    foreach $MdlFile ( @$MdlList )
	    {
		if (open(MDLFILE, $MdlFile))
		{
		    $versionid = $MdlFile;
		    while (<MDLFILE>)
		    {
			@line = split;
			if ($line[0] eq "%MLB")
			{
			    $position = index($line[1], "L");
			    if ($position >= 0)
			    {
				# Use mdl path name to build path to library
				$position = rindex($MdlFile, "/");
				$libfilename = substr($MdlFile, 0,
						      $position + 1);
				$libfilename .= $line[2];
				$modelname = $line[2];
				# Chop off any file extension
				$position = rindex($modelname, ".");
				if ($position >= 0)
				{
				    # Save file extension for old style library
				    $extval = substr($modelname, $position);
				    $modelname = substr($modelname, 0,
							$position);
				}
				last;
			    }
			}
		    }
		    close(MDLFILE);
		}
	    }

	    if ($libfilename ne "")
	    {
		# The R41 model name contains a 5 digit version id, however
		# we do not know what the version will be that we are
		# looking for, so we wildcard it.
		$modelname = "$oldfiles[$oldcount]\\d{5}";

		# Get what string from new model
		$newwhatstr = &findwhat($modelname, $libfilename);

		# Get what string from old model
		$plat = $Platform;
		if ($Platform eq "solaris") {
		    $plat = "sun4Solaris";
		} elsif ($Platform eq "sunos") {
		    $plat = "sun4SunOS";
		} elsif ($Platform eq "pcnt") {
		    $plat = "win32";
		} elsif ($Platform eq "ibmrs") {
		    $extval = ".o";
		}

		$libfilename = $OldLmcHome . "/$R40ModelDir/" .
				    $oldfiles[$oldcount] . "/" .
				    $plat . $extval;
		$oldwhatstr = &findwhat($oldfiles[$oldcount], $libfilename);

		# Find the version number imbedded in the what string
		$left = index($newwhatstr, "\(");
		$right = index($newwhatstr, "\)");
		$newwhatstr = substr($newwhatstr, $left + 1,
				     $right - $left - 1);
		$left = index($oldwhatstr, "\(");
		$right = index($oldwhatstr, "\)");
		$oldwhatstr = substr($oldwhatstr, $left + 1,
				     $right - $left - 1);
		# Check for old style version numbers, old style number are of
		# the form: 16:5:12:8;tver:8 or v1.0.0;tver:8, NOT the new
		# style: v1.0;tver:8.  If we run into any version number of
		# the old style, we know that the SmartLink library is equal
		# or greater.
		@chkdot = split(/./,$oldwhatstr);
		@chkcol = split(/:/,$oldwhatstr);
		if ( @chkdot > 2 || @chkcol > 2 )
		{
		    # Force SmartLink library higher
		    $cmpstr = 1;
		}
		else
		{
		    $cmpstr = $newwhatstr cmp $oldwhatstr;
		}
		if ($cmpstr == 0)
		{
		    # Same version, no problem
		    $samecount++;
		}
		elsif ($cmpstr > 0)
		{
		    # SmartLink version higher, also no problem
		    $highnew++;
		}
		else
		{
		    # Old library is newer than SmartLink version, problem
		    push(@errlist, $oldfiles[$oldcount] . "\n");
		    $highold++;
		    $position = rindex($versionid, "/");
		    if ($position >= 0)
		    {
			$versionid = substr($versionid, $position + 1);
		    }
		    $position = rindex($versionid, ".");
		    if ($position >= 0)
		    {
			$versionid = substr($versionid, 0, $position);
		    }
		    $position = length($oldfiles[$oldcount]);
		    $versionid = substr($versionid, $position + 1);
		    print ("Model: $oldfiles[$oldcount], Version: $versionid, "
			   .  "Old library newer than LMC_HOME\n");
		    print ("    Binary version old library: $oldwhatstr\n");
		    print ("    Binary version new library: $newwhatstr\n");
		    print LOGFILE
			  ("Model: $oldfiles[$oldcount], Version: $versionid, "
			   .  "Old library newer than LMC_HOME\n");
		    print LOGFILE
			  ("    Binary version old library: $oldwhatstr\n");
		    print LOGFILE
			  ("    Binary version new library: $newwhatstr\n");
		}
	    }
	    else
	    {
		warn ("Could not find reference mdl file: " .
			$LmcHome/models/$oldfiles[$oldcount] . "\n");
	    }

	    # Increment compare total
	    $comparecount++;
	}
	# Move pointers in both lists
	$oldcount++;
	$newcount++;
    }
    elsif ($cmpval < 0)
    {
	$cmpstr = substr($oldfiles[$oldcount],0,1);
	if ($cmpstr ne ".")
	{
	    print ("Only in $OldLmcHome/$R40ModelDir: $oldfiles[$oldcount]\n");
	    print LOGFILE
		  ("Only in $OldLmcHome/$R40ModelDir: $oldfiles[$oldcount]\n");
	}
	$oldcount++;
    }
    else
    {
	$cmpstr = substr($newfiles[$newcount],0,1);
	if ($cmpstr ne ".")
	{
	    print ("Only in $LmcHome/models: $newfiles[$newcount]\n");
	    print LOGFILE ("Only in $LmcHome/models: $newfiles[$newcount]\n");
	}
	$newcount++;
    }
}

# Print statistics
$totnew = $#newfiles - 1;
$totold = $#oldfiles - 1;
print("\n\n");
print("Total models in LMC_HOME:                          $totnew\n");
print("Total models in old libary:                        $totold\n");
print("Total models compared:                             $comparecount\n");
print("Total models same:                                 $samecount\n");
print("Total models in LMC_HOME greater than old library: $highnew\n");
print("Total models in old library greater than LMC_HOME: $highold\n");
print("\n\n");
print LOGFILE ("\n\n");
if ($highold) {
    print("List of models in old library greater than LMC_HOME:\n ");
    print("@errlist\n");
    print LOGFILE ("List of models in old library greater than LMC_HOME:\n ");
    print LOGFILE ("@errlist\n");
}
print LOGFILE
     ("Total models in LMC_HOME:                          $totnew\n");
print LOGFILE
     ("Total models in old libary:                        $totold\n");
print LOGFILE
     ("Total models compared:                             $comparecount\n");
print LOGFILE
     ("Total models same:                                 $samecount\n");
print LOGFILE
     ("Total models in LMC_HOME greater than old library: $highnew\n");
print LOGFILE
     ("Total models in old library greater than LMC_HOME: $highold\n");
print LOGFILE ("\n\n");

exit(0);

sub findwhat {
    local ($modelname, $filename) = @_;
    local ($count, $line, @array, $retval);

    # Open file
    unless (open(MODELBIN, $filename)) {
	warn "Can't open $filename\n";
	$retval = "";
	return ($retval);
    }

    # Assume failure
    $retval = "No \"what\" string found in " . $filename;

    # Set binmode in case of DOS
    binmode(<MODELBIN>);

    # Read whole file into an array
    @array = <MODELBIN>;

    # Loop though array, looking for a substring that matches
    $position = 0;
    while ($count <= @array) {
	$line = $array[$count-1];
	# Note: the string we are looking for is: @(#) model_name(version_str)
	if ($line =~ /\@\(\#\) ($modelname\(.*?\))/) {
	    $retval = $1;
	    last;
	}
	else {
	    $count++;
	}
    }
    close(MODELBIN);
    return ($retval);
}
