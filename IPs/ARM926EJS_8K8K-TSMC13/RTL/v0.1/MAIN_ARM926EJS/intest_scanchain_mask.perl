#!/usr/bin/env perl
#  -------------------------------------------------------------------------
#  This confidential and proprietary software may be used only as authorised
#  by a licensing agreement from ARM Limited
#                 (c) COPYRIGHT 2003 ARM Limited
#                 ALL RIGHTS RESERVED
#  The entire notice above must be reproduced on all authorised copies and
#  copies may only be made to the extent permitted by a licensing agreement
#  from ARM Limited.
#  -------------------------------------------------------------------------
#  Version and Release Control Information:
# 
#  File Name           : intest_scanchain_mask.perl,v
#  File Revision       : 1.2
# 
#  Release Information : ARM926EJS_r0p5-00rel0
#  -------------------------------------------------------------------------
# This script generates mask.vh needed by the intest testbench
# (ARM926EJS_intest_testbench.v). It loads the file intest_output_regs and
# the report given in the command line:
#
# usage: intest_scanchain_mask.perl <timing report>

if ($#ARGV != 0)
  {
    print STDERR "usage: $0 <timing report>\n";
    exit 1;
  }

$report = $ARGV[0];

open (f, $report) || die "no open $report";

$foundsc = 0;
while (<f>)
  {
    $foundsc = 0 if (!/\-\>/);
    if ($foundsc)
      {
        s/^\s*//;
        s/\-\>//;
        s/\(\*\)//;
        s/\s*\n?$//;
        unshift(@sc, $_);
      }
    if (/INTESTSCANIN\s+\-\>/)
      {
        $foundsc = 1;
      }
  }

close(f);

open (f, "intest_output_regs") || die "no open intest_output_regs";
while (<f>)
  {
    next if /^\#/;
    chomp();
    $rm{$_} = 1;
  }
close(f);
# Last value out of the scan chain is captured by the last register
# in the list:
$i = 1;
open (f, ">mask.vh") || die "no open mask.vh";
print f "wire [820:0] MASK;\n";
print f "// Bit 0 of MASK is the first register in the scan chain and the last to reach INTESTSCANOUT.\n";
print f "// If a bit is 1 INTESTSCANOUT should be checked, if a bit is 0 INTESTSCANOUT should be ignored.\n";
print f "assign MASK[820:0] = 821\'b";
foreach (@sc)
  {
    if (exists($rm{$_}) || /OutFlop/ || /TCM.*Flop/)
      {
        print "    masking \#$i $_\n";
        print f "0";
        delete($rm{$_})
      }
    else
      {
        print "not masking \#$i $_\n";
        print f "1";
      }
    $i++;
  }
print f ";\n";
print join(" ", keys(%rm)), "\n";
close (f);

