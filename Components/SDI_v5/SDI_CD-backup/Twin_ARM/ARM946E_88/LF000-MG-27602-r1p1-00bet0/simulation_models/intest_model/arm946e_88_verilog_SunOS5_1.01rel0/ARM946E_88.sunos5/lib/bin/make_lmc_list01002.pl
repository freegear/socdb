#!/usr/local/bin/perl
#
# Copyright(C)2001 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
#
# make_lmc_list [-help]
#
#   The make_lmc_list script searches the LMC_HOME environment to determine 
#   which versions of components and models are currently installed.  It will
#   produce a file, lmc_list_list.<platform> in the current working directry.
#   This file can be interpreted by Synopsys Customer Support to determine the
#   exact contains of the LMC_HOME tree. The make_lmc_list script must be
#   executed on the target platform. If the LMC_CONFIG variable is used duruing
#   simulation it must be set prior to executing the make_lmc_list script.
#
#   -h[elp]         Print this message.
#

$LmcHome   = $ENV{ LMC_HOME };
$LmcConfig = $ENV{ LMC_CONFIG };
my $Cygwin = "NULL";
if ($ENV{ CYGWIN }) {
   $Cygwin = "CYGWIN";
}

die "ERROR running $0: ",
    "The LMC_HOME environment variable must be set.\n"
    unless( $LmcHome );

# Load the 'libmdl' library of subroutines
require "$LmcHome/lib/bin/libmdl01003.pl";

# Verify the environment variables are properly set
$ProgName = VerifyEnv( $LmcHome, "", $LmcConfig, "");

# Check for command line switches
for (my $i = 0; $i <= $#ARGV; $i++) { 
   if ( ($_ = $ARGV[$i]) =~ /^-/ ) {
      /^-h/ && Usage();
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

open(LMC_LIST, ">lmc_list.${Platform}") || die ("Can't open \"lmc_list.${Platform}\"");

if (${Platform} eq "pcnt") {

   my @lvdfilelist;
   my @dvdfilelist;

   if ($Cygwin ne "NULL") {
      @lvdfilelist = grep(/\.lvd/, `ls ${LmcHome}/data/${Platform}*.lvd`);
      @dvdfilelist = grep(/\.dvd/, `ls ${LmcHome}/data/*.dvd`);
   }
   else {
      @lvdfilelist = grep(/\.lvd/, `dir ${LmcHome}\\data\\${Platform}*.lvd`);
      @dvdfilelist = grep(/\.dvd/, `dir ${LmcHome}\\data\\*.dvd`);
   }
   for $filename(@lvdfilelist) {
      chop($filename);
      $filename =~ s=.*${Platform}==;
      print(LMC_LIST "LVD:$filename\n");
   }
   for $filename(@dvdfilelist) {
      chop($filename);
      $filename =~ s=.* ==;
      print(LMC_LIST "LVD:$filename\n");
   }
}
else {
   while (glob("${LmcHome}/data/${Platform}*.lvd")) {
      s=.*${Platform}==;
      print(LMC_LIST "LVD:$_\n");
   }
   while (glob("${LmcHome}/data/*.dvd")) {
      s=.*data/==;
      print(LMC_LIST "LVD:$_\n");
   }
}

# Read the contents of all the '.lmc' files in the path to get the
# list of versions of all models.
$Model2Ver = GetModelVer( $PathList );

my @array = "";
for $key (keys %$Model2Ver) {
   @array = split(/ /, $Model2Ver->{$key});
   if ($array[1] eq "memcore" ||
       $array[1] eq "fastm_model" ||
       $array[1] eq "fastm_timing_model" ||
       $array[1] eq "smartlib" ||
       -d "${LmcHome}/foundry/$array[1]") {
      next;
   }
   print(LMC_LIST "MODEL:$array[1]:$array[2]\n");
}
close(LMC_LIST);

#
# All done.
#
