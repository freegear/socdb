#!/usr/local/bin/perl -w

###############################################################################
# This confidential and proprietary software may be used only as
# authorised by a licensing agreement from ARM Limited
#   (C) COPYRIGHT 2001 ARM Limited
#       ALL RIGHTS RESERVED
# The entire notice above must be reproduced on all authorised
# copies and copies may only be made to the extent permitted
# by a licensing agreement from ARM Limited.
#
###############################################################################
# Version and Release Control Information:
#
# Version and Release Control Information:
#
# File Name           : configmatrix.pl,v
# File Revision       : 1.4
#
# Release Information : BusMatrix-REL1v0
#
###############################################################################
# Purpose             : Builds particular configurations of the BusMatrix    
#                       component.
#
###############################################################################
# Usage:                                                         
#    Builds a BusMatrix component with a given number of input   
#    ports <inports>, a given number of output ports <outports>  
#    and a particular arbitration scheme.                        
# Options:
#    --inports=NUM           Number of input ports (2,3..8)      
#    --outports=NUM          Number of output ports (1,2..8)     
#    --arb=SCHEME            Arbitration scheme (f - fixed,      
#                            r - round-robin)                    
#    --all                   Builds all possible configurations
#    --verbose               Prints run information
#    --help                  Prints this help
#    --src=DIRNAME           Directory name where source files are located
#                            (defaults to ./src)
#    --dest=DIRNAME          Directory name where source files are located
#                            (defaults to ./built)
#    --data=WIDTH            Width of data bus (32, 64, etc.)
###############################################################################

#use strict;
use Getopt::Long;

package main;

$rtl = "v";

# default values for command-line options
$inports    = 0;
$outports   = 0;
$all        = 0;
$help       = 0;
$verbose    = 0;
$errors     = 0;

$arb        = 0;
$datawidth  = 32;
$srcdir     = "./src";
$destdir    = "./built";


GetOptions("inports=i"  => \$inports,
           "outports=i" => \$outports,
           "arb=s"      => \$arb,
           "all"        => \$all,
           "help"       => \$help,
           "verbose"    => \$verbose,
           "src=s"      => \$srcdir,
           "dest=s"     => \$destdir,
           "data=i"     => \$datawidth
           );

#  get run date
($sec, $min, $hour, $mday, $mon, $year) = localtime(time);
$year += 1900;
$mon  += 01;

if ($verbose eq "1")
{
print "\n==============================================================\n".
      "= This confidential and proprietary software may be used only\n".
       "= as authorised by a licensing agreement from ARM Limited\n".
       "=    (C) COPYRIGHT 2001 ARM Limited\n".
       "=          ALL RIGHTS RESERVED\n".
       "= The entire notice above must be reproduced on all authorised\n".
       "= copies and copies may only be made to the extent permitted\n".
       "= by a licensing agreement from ARM Limited\n".
       "=\n";    
printf "= Run Date : %02d/%02d/%04d %02d:%02d:%02d",
        $mday, $mon, $year, $hour, $min, $sec;
print "\n==============================================================\n\n"; 
}

# Check and process command line options

if ($help == 1 or ($all ==0 and $inports ==0 and $outports ==0 and $arb ==0)) {
  print "Purpose : Builds particular configurations of the BusMatrix      \n";
  print "          component.                                             \n";
  print "Usage:                                                           \n".
        "   Builds a BusMatrix component with a given number of input     \n".
        "   ports <inports>, a given number of output ports <outports>    \n".
        "   and a particular arbitration scheme.                          \n".
        "Options:                                                         \n".
        "   --inports=NUM           Number of input ports (2,3..8)        \n".
        "   --outports=NUM          Number of output ports (1,2..8)       \n".
        "   --arb=SCHEME            Arbitration scheme (f - fixed,        \n".
        "                           r - round-robin)                      \n".
        "   --all                   Builds all possible configurations    \n".
        "   --verbose               Prints progress information           \n".
        "   --help                  Prints this help                      \n".
#       "   --src=DIRNAME           Directory name where source files are \n".
#       "                           located (defaults to ./src)           \n".
#       "   --dest=DIRNAME          Directory name where source files are \n". 
#       "                           located (defaults to ./built)         \n".
#       "   --data=WIDTH            Width of data bus (32, 64, etc.)      \n".
        "\n";
} else {
  if ($inports >= 2 and $inports <= 8) {
    @in = "input".($inports-1);
  } elsif ($inports != 0 or $all == 0) {
    print "Error: inports must be in the range from 2 to 8 \n";
    $errors += 1;
  } else {
    @in = ("input1", "input2", "input3", "input4", "input5", "input6",
           "input7");
  };

  if ($outports >= 1 and $outports <= 8) {
    @out = "output".($outports-1);
  } elsif ($outports != 0 or $all == 0) {
    print "Error: outports must be in the range from 1 to 8 \n";
    $errors += 1;
  } else {
    @out = ("output0", "output1", "output2", "output3", "output4", "output5",
            "output6", "output7");
  };

  $arb = lc $arb;

  if ($arb eq "f" or $arb eq "fix" or $arb eq "fixed") {
    @arb = "fixed";
  } elsif ($arb eq "r" or $arb eq "rou" or $arb eq "round") {
    @arb = "round";
  } elsif ($arb eq "0" and $all == 0) {
    print "Warning: No arbitration specified - Fixed arbitration will be used\n";
    @arb = "fixed";
  } elsif ($arb eq "0" and $all == 1) {
    @arb = ("fixed", "round");
  } else {
    print "Error: arb must be either r or f \n";
    $errors += 1;
  };
  
  if ($datawidth != 8  and $datawidth != 16  and $datawidth != 32 and
      $datawidth != 64 and $datawidth != 128 and $datawidth != 256 and
      $datawidth != 512 and $datawidth != 1024) {
    print "Warning: Non-standard data bus width of ".$datawidth." bits specified\n";
  };

  if ($errors == 0) {
    foreach $arb (@arb) {
      foreach $in (@in) {
        foreach $out (@out) {
          create_version();
        };
      };
    };

  } else {
    print "Build not started because of command line option errors\n";
  };
};

sub create_version {
  $dirname = "${destdir}/${in}_by_${out}_${arb}";

  if ($main::verbose == 1 ) {
    print "Building directory ".${in}."_by_".${out}."_".${arb}."\n";
  };

  system "rm -rf $dirname";
  system "mkdir -p $dirname";

  # Process the BusMatrix file

  $infile  = "${srcdir}/BusMatrix.${rtl}";
  $outfile = "${dirname}/BusMatrix.${rtl}";

  process_file();

  if ($main::datawidth != 32) {
    $datawidth_file  = $outfile;
    change_data_width();
  };

  # Process the InputStage file

  $infile  = "${srcdir}/InputStage.${rtl}";
  $outfile = "${dirname}/InputStage.${rtl}";
  process_file();

  # Process the MatrixDecode file

  $infile  = "${srcdir}/MatrixDecode.${rtl}";
  $outfile = "${dirname}/MatrixDecode.${rtl}";
  process_file();

  if ($main::datawidth != 32) {
    $datawidth_file  = $outfile;
    change_data_width();
  };

  # Process the OutputStage file

  $infile  = "${srcdir}/OutputStage.${rtl}";
  $outfile = "${dirname}/OutputStage.${rtl}";
  process_file();

  if ($main::datawidth != 32) {
    $datawidth_file  = $outfile;
    change_data_width();
  };

  # Process or select the Arbitration file

  if ($arb eq "fixed") {
    $infile  = "${srcdir}/FixedArb.${rtl}";
    $outfile = "${dirname}/OutputArb.${rtl}";
    process_file();
  } else {
    if ($main::in eq "input1") {
      system "cp ${srcdir}/RoundArb1.${rtl} ${dirname}/OutputArb.${rtl}";
    } elsif ($in eq "input2") {
      system "cp ${srcdir}/RoundArb2.${rtl} ${dirname}/OutputArb.${rtl}";
    } elsif ($in eq "input3") {
      system "cp ${srcdir}/RoundArb3.${rtl} ${dirname}/OutputArb.${rtl}";
    } elsif ($in eq "input4") {
      system "cp ${srcdir}/RoundArb4.${rtl} ${dirname}/OutputArb.${rtl}";
    } elsif ($in eq "input5") {
      system "cp ${srcdir}/RoundArb5.${rtl} ${dirname}/OutputArb.${rtl}";
    } elsif ($in eq "input6") {
      system "cp ${srcdir}/RoundArb6.${rtl} ${dirname}/OutputArb.${rtl}";
    } elsif ($in eq "input7") {
      system "cp ${srcdir}/RoundArb7.${rtl} ${dirname}/OutputArb.${rtl}";
    };
  };
      
};     

sub process_file {
  $stopout = 0;

  open(IN,"$infile");
  open(OUT,">$outfile");

  while(<IN>) {
    if (/$in/) {
      $stopout = $stopout + 1;
    };
    if (/$out/) {
      $stopout = $stopout + 1;
    };
    
    if ($stopout == 0) {
      if (/busswitch/) {
        # Don't print
      } else {
        print OUT $_;
      };
    };

    if (/input7/) {
      $stopout = $stopout - 1;
    };
    if (/output7/) {
      $stopout = $stopout - 1;
    };
    
  };
  
  close(IN);
  close(OUT);

};


sub change_data_width {
  $datawidth_infile  = $datawidth_file;
  $datawidth_outfile = $datawidth_file.".tmp";
  $new_max_bit       = $datawidth - 1;

  
  open(IN,"$datawidth_infile");
  open(OUT,">$datawidth_outfile");


  while(<IN>) {
    if (/data/i) {
      s/31/${new_max_bit}/;
    };
  
    print OUT $_;

  };
  
  close(IN);
  close(OUT);

  system "mv ${datawidth_outfile} ${datawidth_infile}";

};

