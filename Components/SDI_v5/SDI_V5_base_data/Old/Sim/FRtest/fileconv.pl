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
# File Name           : fileconv.pl,v
# File Revision       : 1.4
#
# Release Information : ADK_REL1v1
#
###############################################################################
# Purpose             : Converts an ASCII command file into a hex format,
#                       suitable for import by the FileReader bus master.
#                       Checks that the specified commands are compatible
#                       with the FileReader.
#
#                       Options:
#                            --help
#                            --verbose (default)
#                            --quiet
#                            --infile=<input text file>  default = filestim.fri
#                            --outfile=<output hex file> default = filestim.frd
###############################################################################

use strict;
use Getopt::Long;

package main;

# default values for command-line options
my $verbose    = 1;
my $help       = 0;
$main::infile  = "filestim.fri";
$main::outfile = "filestim.frd";
 
GetOptions( "verbose"   => \$verbose,           
            "quiet"     => sub {$verbose = 0},
            "help"      => \$help, 
            "infile=s"  => \$main::infile,     
            "outfile=s" => \$main::outfile     
          );


my (%commands);          # hash (assoc. array) to store output commands
my $FileErrors      = 0; # total number of errors in input file
my $Cmd             = 0; # next command
my $PrevCmd         = 0; # previous command
my $CurrCmd         = 0; # current command

my $CurrBurst       = 0; # current burst type
my $trans_count     = 0; # no. of transfers remaining in defined-length burst
my $error           = 0; # command causing current error
my $TotalCmd        = 0; # total number of commands in file
my $oldfilehandle   = 0; # file handle for output file

my $output_count    = 0; # number of lines written to output file
my $LineNum         = 0; # line number
my $trans_size      = 0; # size of transfers in current burst
my $loop_count      = 0; # loop counter
my $start_addr      = 0; # start address for incr bursts

my $addr32to10      = 0; # top bit 31 downto 10 of address 
my $incr_count      = 0; # number of transfers for incr burst
my $size_field      = 0; # value of size field for current line
my $num_field       = 0; # value of number field for current line(loop commands)
my $w_invalid       = 1; # flag for invalid field(s) in write command
my $r_invalid       = 1; # flag for invalid field(s) in read command

my $s_invalid       = 1; # flag for invalid field(s) in sequential command
my $b_invalid       = 1; # flag for invalid field(s) in busy command
my $i_invalid       = 1; # flag for invalid field(s) in idle command
my $p_invalid       = 1; # flag for invalid field(s) in poll command
my $l_invalid       = 1; # flag for invalid field(s) in loop command




#  get run date
my ($sec, $min, $hour, $mday, $mon, $year) = localtime(time);
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


###############################################################################
#
#                       Command file error checks
# 
# The following IF statement contains checks for errors in each field of a 
# command which are made as it is read from the input file.
#
# Commands are detected by searching for the first non-whitespace character on 
# a line.
#
# For each command, first the required fields are retrieved and checked, then
# any optional fields which are present. If a required field is invalid or 
# missing then an error is raised. If an optional field is invalid or not
# recognised then a warning is raised.
###############################################################################


if ($help == 1)
  {
   print "Purpose : Converts an ASCII command file into a hex format,\n";
   print "          suitable for import by the FileReader bus master.\n";
   print "          Checks that the specified commands are compatible\n";
   print "          with the FileReader.\n";
   print "Usage:\n".
         "   Reads in a text file,        default = filestim.fri\n".
         "   Prints hex output to a file, default = filestim.frd\n\n".
         "Options:\n".
         "   --help\n   --verbose\n   --quiet\n   --infile=<input file>\n".
         "   --outfile=<output file>\n".
         "==============================================================\n";    
  }

if ($help != 1) # continue 
  {

# Check that input and output filenames are not the same
if ($main::infile eq $main::outfile)
  {
    printf "ERROR : Input and output file names are identical\n\n";
    $FileErrors++;
  }


# open input file and extract commands
if (open(INPUTFILE, "$main::infile"))
{
  if ($verbose eq "1")
    {
      printf "Reading from text file: %s\n\n", $main::infile;
    }
 
  else{}
  
  # while there are lines remaining to be read from the file
  while (<INPUTFILE>)
  {
    $LineNum++;

    # if a character exists on this line then decode command
    if (/^\s*./) 
    {   
      if (/^\s*S/i) 
        {
         # if a burst is not in progress (defined- or undefined-length)      
          if ($trans_count == 0 && ($incr_count == 0))
            {
              ($error) = /(^\s*.)/;
              printf "Line %3d: ERROR : Sequential cmd outside burst ".
                     "(check burst size): %s\n", $LineNum, $error;
              $FileErrors++;
            } 
        }
      elsif (/^\s*B/i)
        {
          # if a burst is not in progress (defined- or undefined-length)
          if ($trans_count == 0 && ($incr_count == 0))
            {
              ($error) = /(^\s*.)/;
              printf "Line %3d: ERROR : Busy cmd outside burst ".
                      "(check burst size): %s\n", $LineNum, $error;
              $FileErrors++;
            } 
        }
      else 
        {
          # if a defined-length burst is in progress and current command
          # starts a new burst
          if (($trans_count > 0) && /^\s*W|^\s*R|^\s*I|^\s*P/i)
            {
              ($error) = /(^\s*.)/;
              printf "Line %3d: WARNING : Incompatible cmd inside burst ".
                     "(check burst size): %s\n", $LineNum, $error;
            }
        }



      if (/^\s*W/i) 
      {
        # Write command will end an incr-type burst so reset incr_count 
        $incr_count = 0;

        $commands{$Cmd,"CMD"}  = "00000000";
        # get required fields
        if (/^\s*[wW]\s+([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})/)
          {
            ($commands{$Cmd,"ADDR"}, $commands{$Cmd,"DATA"})= 
              /^\s*[wW]\s+([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})/;
         
            # check for invalid fields for write commands
            $w_invalid = GetWInvalid($_,$LineNum);
            if (($w_invalid eq "0") && ($verbose eq "1"))
               {
                  printf "\nLine %3d: WARNING : Invalid field checking".
                         " did not complete\n",$LineNum;
               }
            else {}
            
            # remove Address and Data fields
            s/^\s*[wW]\s+([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})//; 
            
            # get optional fields
            $size_field             = GetSizeField($_,$LineNum);
            $CurrBurst              = GetBurstField($_,$LineNum); 
            $commands{$Cmd,"LOCK"}  = GetLockField($_,$LineNum);
            $commands{$Cmd,"PROT"}  = GetProtField($_,$LineNum);
            
            $commands{$Cmd,"SIZE"}  = $size_field;
            $commands{$Cmd,"BUR"}   = $CurrBurst; 

            # check address alignment
            if (($size_field == "00000002") && 
                ($commands{$Cmd,"ADDR"} !~ /([A-Fa-f0-9]{7})[0|4|8|c|C]/))
              {  
                printf "Line %3d: ERROR : Address is not word-aligned".
                        " : W\n",$LineNum;
                $FileErrors++;
              }
            elsif (($size_field == "00000001") && 
                   ($commands{$Cmd,"ADDR"} !~ 
                      /([A-Fa-f0-9]{7})[0|2|4|6|8|a|A|c|C|e|E|]/))
              {
                printf "Line %3d: ERROR : Address is not".
                        " halfword-aligned : W\n",$LineNum;
                $FileErrors++;
              }

            
            # assign trans_count which stores no. of transfers
            if    ($CurrBurst == "00000000") {$trans_count = 0;}  # single
            elsif ($CurrBurst == "00000001") {$trans_count = 0;}  # incr     
            elsif ($CurrBurst == "00000002") {$trans_count = 3;}  # wrap4          
            elsif ($CurrBurst == "00000003") {$trans_count = 3;}  # incr4    
            elsif ($CurrBurst == "00000004") {$trans_count = 7;}  # wrap8   
            elsif ($CurrBurst == "00000005") {$trans_count = 7;}  # incr8    
            elsif ($CurrBurst == "00000006") {$trans_count = 15;} # wrap16     
            elsif ($CurrBurst == "00000007") {$trans_count = 15;} # incr16     
            else  {$trans_count = 0;}                             # incr
                 
            # assign trans_size 
            if    ($size_field == '00000000') {$trans_size = 1;}
            elsif ($size_field == '00000001') {$trans_size = 2;}
            elsif ($size_field == '00000002') {$trans_size = 4;}
            
            $addr32to10 = hex("0x".$commands{$Cmd,"ADDR"}) & hex("0xFFFFFC00");
            # stores address at start of incr burst
            $start_addr = hex("0x".$commands{$Cmd,"ADDR"});
            
            # check for burst exceeding 1kB boundary
            if ($CurrBurst == "00000001") # for an undefined-length burst
              {    
                $incr_count      = 1;
              }
            # for a defined-length burst
            elsif ($CurrBurst == "00000003" || 
                   $CurrBurst == "00000005" ||
                   $CurrBurst == "00000007")
              {
                if (((($trans_count * $trans_size) + $start_addr) 
                    & hex("0xFFFFFC00")) != $addr32to10 )
                  {
                    printf "Line %3d: ERROR : Burst would exceed".
                      " 1kB boundary : R\n",$LineNum;
                    $FileErrors++;
                  }
              }

            $Cmd++;                 # increment command counter
            $PrevCmd   = $CurrCmd;  # update previous command variables
            $CurrCmd   = 'W';
          }
        else # essential fields missing
          {
            ($error) = /(^\s*.)/;
            printf "Line %3d: ERROR : Required field is missing or".
                    " in wrong format : %s\n",$LineNum, $error;
            $FileErrors++;
            $Cmd++;                 # increment command counter
            $PrevCmd   = $CurrCmd;  # update previous command variables
            $CurrCmd   = 'W';
          }
      }



      elsif (/^\s*R/i)
      {
        # Read command will end an incr-type burst so reset incr_count 
        $incr_count = 0;

        $commands{$Cmd,"CMD"} = "00000001";
        # get required fields
        if (/^\s*[rR]\s+([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})/)
          {
            ($commands{$Cmd,"ADDR"}, $commands{$Cmd,"DATA"})= 
              /^\s*[rR]\s+([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})/;

            # check for invalid fields for read commands
            $r_invalid = GetRInvalid($_,$LineNum);
            
            if (($r_invalid eq "0") && ($verbose eq "1")) 
               {
                  printf "\nLine %3d: WARNING : Invalid field checking".
                         " did not complete\n",$LineNum;
               }
            else {}

            # remove Address and Data fields
            s/^\s*[rR]\s+([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})//; 
            # get optional fields
            $commands{$Cmd,"MASK"}  = GetMaskField($_,$LineNum);        
            $size_field             = GetSizeField($_,$LineNum);
            $CurrBurst              = GetBurstField($_,$LineNum);   
            $commands{$Cmd,"LOCK"}  = GetLockField($_,$LineNum);
            $commands{$Cmd,"PROT"}  = GetProtField($_,$LineNum);
            
            $commands{$Cmd,"SIZE"}  = $size_field;
            $commands{$Cmd,"BUR"}   = $CurrBurst;

            # check address alignment 
            if (($size_field == "00000002") &&
                ($commands{$Cmd,"ADDR"} !~ /([A-Fa-f0-9]{7})[0|4|8|c|C]/))
              {  
                printf "Line %3d: ERROR : Address is not".
                        " word-aligned : R\n",$LineNum,$error;
                $FileErrors++;
              }
            elsif (($size_field == "00000001") &&
                   ($commands{$Cmd,"ADDR"} !~
                    /([A-Fa-f0-9]{7})[0|2|4|6|8|a|A|c|C|e|E|]/))
              {
                printf "Line %3d: ERROR : Address is not".
                        " halfword-aligned : R\n",$LineNum,$error;
                $FileErrors++;
              } 
            

            # assign trans_count which stores no. of transfers
            if    ($CurrBurst == "00000000") {$trans_count = 0;}  # single
            elsif ($CurrBurst == "00000001") {$trans_count = 0;}  # incr     
            elsif ($CurrBurst == "00000002") {$trans_count = 3;}  # wrap4          
            elsif ($CurrBurst == "00000003") {$trans_count = 3;}  # incr4    
            elsif ($CurrBurst == "00000004") {$trans_count = 7;}  # wrap8   
            elsif ($CurrBurst == "00000005") {$trans_count = 7;}  # incr8    
            elsif ($CurrBurst == "00000006") {$trans_count = 15;} # wrap16     
            elsif ($CurrBurst == "00000007") {$trans_count = 15;} # incr16     
            else  {$trans_count = 0;}                             # incr
                 
            # assign trans_size 
            if    ($size_field == '00000000') {$trans_size = 1;}
            elsif ($size_field == '00000001') {$trans_size = 2;}
            elsif ($size_field == '00000002') {$trans_size = 4;}

            $addr32to10 = hex("0x".$commands{$Cmd,"ADDR"}) & hex("0xFFFFFC00");
            # stores address at start of incr burst
            $start_addr = hex("0x".$commands{$Cmd,"ADDR"});
            
            # check for burst exceeding 1kB boundary
            if ($CurrBurst == "00000001") # for an undefined-length burst
              {
                
                $incr_count      = 1;
              }
            # for a defined-length burst
            elsif ($CurrBurst == "00000003" || 
                   $CurrBurst == "00000005" ||
                   $CurrBurst == "00000007")
              {
                if (((($trans_count * $trans_size) + $start_addr) 
                    & hex("0xFFFFFC00")) != $addr32to10 )
                  {
                    printf "Line %3d: ERROR : Burst would exceed".
                      " 1kB boundary : R\n",$LineNum;
                    $FileErrors++;
                  }
              }
        
            $Cmd++;                      # increment command counter
            $PrevCmd   = $CurrCmd;       # update previous command variables
            $CurrCmd   = 'R';
          }

        else # essential field(s) missing
          {
            ($error) = /(^\s*.)/;
            printf "Line %3d: ERROR : Required field is missing".
                    " or in wrong format: %s\n",$LineNum,$error;
            $FileErrors++;
            $Cmd++;                      # increment command counter
            $PrevCmd   = $CurrCmd;       # update previous command variables
            $CurrCmd   = 'R';
          }
      }



      elsif (/^\s*S/i)
      {   
        if ($CurrCmd =~ /[I|P]/i)
          {
            ($error) = /(^\s*.)/;
            printf "Line %3d: ERROR : Sequential cmd outside burst ".
                    "(check burst size): %s\n",$LineNum,$error;

            # reset error-checking variables
            $CurrBurst   = "00000000";
            $trans_count = 0;
            $FileErrors++;
          }
         
        elsif ($CurrCmd =~ /L/i && $PrevCmd =~ /[I|P]/i )
          {
            ($error) = /(^\s*.)/;
            printf "Line %3d: ERROR : Sequential cmd outside burst ".
                    "(check burst size): %s\n",$LineNum,$error;

            # reset error-checking variables
            $CurrBurst   = "00000000";
            $trans_count = 0;
            $FileErrors++;
          }

        else
          {
            $commands{$Cmd,"CMD"} = "00000002";
            # get required fields
            if (/^\s*[sS]\s+([0-9A-Fa-f]{8})/)
              {
                ($commands{$Cmd,"DATA"}) = /^\s*[sS]\s+([0-9A-Fa-f]{8})/;
             
                # check for invalid fields for seq commands
                $s_invalid = GetSInvalid($_,$LineNum);
                if (($s_invalid eq "0") && ($verbose eq "1"))
                   {
                      printf "\nLine %3d: WARNING : Invalid field".
                             " checking did not complete\n",$LineNum;
                   }
                else {}

                # remove Address and Data fields
                s/^\s*[sS]\s+([0-9A-Fa-f]{8})//; 
                # get optional fields
                $commands{$Cmd,"MASK"}  = GetMaskField($_,$LineNum);  
              
                if ($CurrBurst == "00000001") # if undefined length burst
                  {
                    if (((($incr_count * $trans_size) + $start_addr)
                         & hex("0xFFFFFC00")) != $addr32to10 )
                      {
                        printf "Line %3d: ERROR : Burst would exceed".
                          " 1kB boundary : R\n",$LineNum;
                        $FileErrors++;
                      }
                    $incr_count++;
                  }
                else
                  {
                    $trans_count--;
                  }
                $Cmd++;                   # increment command counter
                $PrevCmd  = $CurrCmd;     # update previous command variables
                $CurrCmd  = 'S';
              }

            else  # essential field(s) missing
              {
                ($error) = /(^\s*.)/;
                printf "Line %3d: ERROR : Required field is missing or".
                        " in wrong format : %s\n",$LineNum,$error;
                $FileErrors++;
                $Cmd++;                    # increment command counter
                $PrevCmd   = $CurrCmd;     # update previous command variables
                $CurrCmd   = 'S';
              }
          }
      }


      elsif (/^\s*B/i)
      {

       if ($CurrCmd =~ /[I|P]/i)
          {
            ($error) = /(^\s*.)/;
            printf "Line %3d: ERROR : Busy cmd outside burst ".
                   "(check burst size): %s\n",$LineNum,$error;

            # reset error-checking variables
            $CurrBurst   = "00000000";
            $trans_count = 0;
            $FileErrors++;
          }         
        elsif (($CurrCmd =~ /L/i) && ($PrevCmd =~ /[I|P]/i ))
          {
            ($error) = /(^\s*.)/;
            printf "Line %3d: ERROR : Busy cmd outside burst ".
                   "(check burst size): %s\n",$LineNum,$error;

            # reset error-checking variables
            $CurrBurst   = "00000000";
            $trans_count = 0;
            $FileErrors++;
          } 
        else
          {
            # check for invalid fields for busy commands
            $b_invalid = GetBInvalid($_,$LineNum);
            if (($b_invalid eq "0") && ($verbose eq "1"))
               {
                  printf "\nLine %3d: WARNING : Invalid field checking".
                         " did not complete\n",$LineNum;
               }
            else {}
            $commands{$Cmd,"CMD"}  = "00000003";
            $Cmd++;
            $PrevCmd = $CurrCmd;
            $CurrCmd = 'B';
          }
       
      }



      elsif (/^\s*I/i)
      {
        # Idle command will end an incr-type burst so reset incr_count 
        $incr_count = 0;
  
        # check for invalid fields for idle commands
        $i_invalid = GetIInvalid($_,$LineNum);
        if (($i_invalid eq "0") && ($verbose eq "1"))
          {
             printf "\nLine %3d: WARNING : Invalid field checking".
                    " did not complete\n",$LineNum;
          }
        else {}
        $commands{$Cmd,"CMD"}   = "00000004";
        $commands{$Cmd,"ADDR"}  = GetAddrField($_,$LineNum);
        $commands{$Cmd,"DIR"}   = GetDirField($_,$LineNum);
        $commands{$Cmd,"SIZE"}  = GetSizeField($_,$LineNum);
        $commands{$Cmd,"BUR"}   = GetBurstField($_,$LineNum);
        $commands{$Cmd,"LOCK"}  = GetLockField($_,$LineNum);
        $commands{$Cmd,"PROT"}  = GetProtField($_,$LineNum);
        $CurrBurst              = GetBurstField($_,$LineNum);
        $Cmd++;
        $PrevCmd                = $CurrCmd;
        $CurrCmd                = 'I';     
      }



      elsif (/^\s*P/i)
      {
        # Poll command will end an incr-type burst so reset incr_count 
        $incr_count = 0;

        $commands{$Cmd,"CMD"} = "00000005";
        # get required fields
        if (/^\s*[pP]\s+([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})/)
          {
            ($commands{$Cmd,"ADDR"}, $commands{$Cmd,"DATA"})= 
              /^\s*[pP]\s+([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})/;
         
            # check for invalid fields for poll commands
            $p_invalid = GetPInvalid($_,$LineNum);
            if (($p_invalid eq "0") && ($verbose eq "1"))
               {
                  printf "\nLine %3d: WARNING : Invalid field checking".
                         " did not complete\n",$LineNum;
               }
            else {}
            
            # remove Address and Data fields
            s/^\s*[pP]\s+([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})//; 
            # get optional fields
            $commands{$Cmd,"MASK"}  = GetMaskField($_,$LineNum);        
            $size_field             = GetSizeField($_,$LineNum);
            $commands{$Cmd,"SIZE"}  = $size_field;
            $commands{$Cmd,"BUR"}   = GetBurstField($_,$LineNum);
            $commands{$Cmd,"PROT"}  = GetProtField($_,$LineNum);
            $CurrBurst              = GetBurstField($_,$LineNum);
            
            # for undefined length bursts, stores start address
            if ($CurrBurst == "00000001")
              {
                # stores address at start of incr burst
                $start_addr = $commands{$Cmd,"ADDR"};  
                $incr_count      = 1;
              } 

            # assigns trans_count
            if    ($CurrBurst == "00000000") {$trans_count = 0;}  # single
            elsif ($CurrBurst == "00000001") {$trans_count = 0;}  # incr, undefined length burst
            else                              
              {
                printf "Line %3d: ERROR : Incompatible".          # incompatible burst type
                       " burst type  : P\n",$LineNum;
                $FileErrors++;
                $trans_count = 0;                                 # default type is incr
              }
            
            # assigns trans_size
            if    ($size_field == '00000000') {$trans_size = 1;}
            elsif ($size_field == '00000001') {$trans_size = 2;}
            elsif ($size_field == '00000002') {$trans_size = 4;}
            else                              {$trans_size = 4;}   # defaults to 4
             

            # check address alignment 
            if (($size_field == "00000002") &&
                ($commands{$Cmd,"ADDR"} !~ /([0-9A-Fa-f]{7})[0|4|8|c|C]/))
              {          
                printf "Line %3d: ERROR : Address is not".
                       " word-aligned : P\n",$LineNum;
                $FileErrors++;
              }
            elsif (($size_field == "00000001") &&
                   ($commands{$Cmd,"ADDR"} !~
                    /([0-9A-Fa-f]{7})[0|2|4|6|8|a|A|c|C|e|E|]/))
              {
                printf "Line %3d: ERROR : Address is not".
                       " halfword-aligned : P\n",$LineNum;
                $FileErrors++;
              }

            # check for burst exceeding 1kB boundary
            if (((hex("0x".$commands{$Cmd,"ADDR"}) & 1023) +
                  $trans_size * ($trans_count + 1)) > 1023)
              {
                printf "Line %3d: ERROR : Burst would".
                       " exceed 1kB boundary : P\n",$LineNum;
                $FileErrors++;
              }
            $Cmd++;
            $PrevCmd = $CurrCmd;
            $CurrCmd = 'P';
          }

        else # essential field(s) missing
          {
            ($error) = /(^\s*.)/;
            printf "Line %3d: ERROR : Required field is missing".
                   " or in wrong format : %s\n",$LineNum,$error;
            $FileErrors++;
            $Cmd++;
            $PrevCmd = $CurrCmd;
            $CurrCmd = 'P';
          }
      }



      elsif (/^\s*L/i)
      {
        $commands{$Cmd,"CMD"}    = "00000006";
        $num_field         = GetNumberField($_,$LineNum);
        if ($num_field =~ "00000000")
          {
            $Cmd++;
            $PrevCmd = $CurrCmd;
            $CurrCmd = 'L'    
          }
        else
          {
            # check for invalid fields for loop commands
            $l_invalid = GetLInvalid($_,$LineNum);
            if (($l_invalid eq "0") && ($verbose eq "1"))
                {
                  printf "\nLine %3d: WARNING : Invalid field checking".
                         " did not complete\n",$LineNum;
                }
            else {}

            $commands{$Cmd,"NUMBER"} = $num_field;
            if ($CurrCmd =~ 'S')
              {
                $loop_count = $num_field;
                $incr_count = $incr_count + $num_field;

                # check for boundary overflow by incr burst
                if ($CurrBurst == "00000001") # if undefined length burst
                  {
                    if (((($incr_count * $trans_size) + $start_addr)
                         & hex("0xFFFFFC00")) != $addr32to10 )
                      {
                        printf "Line %3d: ERROR : Burst would exceed".
                          " 1kB boundary : R\n",$LineNum;
                        $FileErrors++;
                      }
                  }

                # check no. of loops does not exceed no. of remaining transfers
                while ($loop_count > 0)
                  {
                    if ($trans_count == 0 && $CurrBurst !~ '00000001')
                      {
                        printf "Line %3d: ERROR : Loop number exceeds".
                               " number of remaining transfers : L\n",
                                $LineNum;
                        $FileErrors++;
                        last;
                      }
                    else
                      {
                        $loop_count--;
                        $trans_count--;
                      }
                  }
              }
            $Cmd++;
            $PrevCmd = $CurrCmd;
            $CurrCmd = 'L'    
          }
      }



      elsif (/^\s*C/i)   # bustalk Comment command
      {
          printf "Line %3d: WARNING : Comment command will be ignored\n",$LineNum;
      }



      elsif (/^\s*M/i)   # bustalk Memory command
      {
          printf "Line %3d: WARNING : Memory command will be ignored\n",$LineNum;
      }



      elsif (/^\s*\#|^\s*;|^\s*\/\/|^\s*--/)
      {
        # comment characters ignored
      }
      
     

      elsif (/^\s*\S+/) # any other non-whitespace character is on a line
      {
        ($error) = /(^\S*.)/;
        printf "Line %3d: ERROR : Unknown command".
               " : %s\n",$LineNum,$error;
        $FileErrors++;
        $PrevCmd = $CurrCmd;
        $CurrCmd = '$error';
      }



      else
      {
        # whitespace lines ignored
      }
    }
  }


  # At End Of File, check for an unfinished defined-length burst 
  if ($trans_count > 00000000)
    {
      printf "Line %3d: WARNING : EOF! Expecting further".
             " transfers  : %s\n", $LineNum, $CurrCmd;
    }

  $TotalCmd = $Cmd;
  close(INPUTFILE);

###############################################################################

#                      End of command error-checking

###############################################################################
}



else  # failed to open input file
  {
    printf "Line ???: ERROR : Input file does not exist".
           " or cannot be accessed\n";
    $FileErrors++;
  }



###############################################################################
##  Writing hex output to file
###############################################################################

if ($FileErrors == 0)
{
  if ($verbose eq "1")
  { 
    printf "\n==============================================================\n";
    printf "Total Errors = %d\n",$FileErrors;
    printf "Creating output file %s\n",$main::outfile;
    printf "==============================================================\n";
  }
  open (FILEOUT, ">$main::outfile") || 
    die "Cannot create output file $main::outfile\n";
    
  $oldfilehandle = select FILEOUT;
  
  for ($output_count = 0; $output_count < $TotalCmd; $output_count++)
  {
    $Cmd = $output_count;
    if    ($commands{$Cmd,"CMD"} eq "00000000") {$~ = "WRITECMD";}
    elsif ($commands{$Cmd,"CMD"} eq "00000001") {$~ = "READCMD";} 
    elsif ($commands{$Cmd,"CMD"} eq "00000002") {$~ = "SEQCMD";} 
    elsif ($commands{$Cmd,"CMD"} eq "00000003") {$~ = "BUSYCMD";} 
    elsif ($commands{$Cmd,"CMD"} eq "00000004") {$~ = "IDLECMD";} 
    elsif ($commands{$Cmd,"CMD"} eq "00000005") {$~ = "POLLCMD";} 
    elsif ($commands{$Cmd,"CMD"} eq "00000006") {$~ = "LOOPCMD";}
    else  { # default
            printf "Cmd undefined, defaulting to IDLE";
            $~ = "IDLECMD";
          }
    write (FILEOUT);
  }

  select ($oldfilehandle);
  close (FILEOUT);  
  exit(0);
}
else
{
  if ($verbose eq "1")
  {
    printf "\n==============================================================\n";
    printf "Total Errors = %d\n",$FileErrors;
    printf "fileconv exit with errors\n";
    printf "==============================================================\n";
    printf "Usage:\n";
    printf "   Reads in a text file,        default = filestim.fri\n";
    printf "   Prints hex output to a file, default = filestim.frd\n";
    printf "Options:\n";
    printf "   --help\n   --verbose\n   --quiet\n   --infile=<input file>\n";
    printf "   --outfile=<output file>\n";
    printf "==============================================================\n";
  }
  exit(1);
}



} # else $help = 0


###############################################################################
##  Get size field value
#
# I/O: searches along the current line for a valid size field value
#      returns the value of the size field
###############################################################################


sub GetSizeField {
  
  my($size) = "00000002";

  # strip off any comment at end of line
  s/(\#|\/\/|;|--).*//;

  if ($_[0] =~ /\bb\b|\bbyte\b|\bsize8\b/i)
  {
    $size = "00000000";
  }
  elsif ($_[0] =~ /\bh\b|\bhword\b|\bsize16\b/i) 
  {
    $size = "00000001";
  }  
  elsif ($_[0] =~ /\bd\b|\bdword\b|\bsize64\b/i)
  {
    printf "Line %3d: ERROR   : size64 not supported".
           " by AHB File Reader\n",$_[1];
    $FileErrors++;  
    $size = "00000002";
  }
  elsif ($_[0] =~ /\bw\b|\bword\b|\bsize32\b/i)
  {
    $size = "00000002";
  }
  else
  {
    # if size is not specified or not recognised then size32 is assumed
    $size = "00000002";
  }
  return $size;
}

###############################################################################
##  Get burst type
#
# I/O: searches along the current line for a valid burst field value
#      returns the value of the burst field
###############################################################################


sub GetBurstField {
  
  my($burst) = "00000001";

  # strip off any comment at end of line
  s/(\#|\/\/|;|--).*//;

  if ($_[0] =~ /\ssing|\ssingle/i)
  {
    $burst = "00000000";
  }
  elsif ($_[0] =~ /\sincr[^0-9]/i) 
  {
    $burst = "00000001";
  }
  elsif ($_[0] =~ /\swrap4/i)
  {
    $burst = "00000002";
  }
  elsif ($_[0] =~ /\sincr4/i)
  {
    $burst = "00000003";
  }
  elsif ($_[0] =~ /\swrap8/i)
  {
    $burst = "00000004";
  }
  elsif ($_[0] =~ /\sincr8/i)
  {
    $burst = "00000005";
  }
  elsif ($_[0] =~ /\swrap16/i)
  {
    $burst = "00000006";
  }
  elsif ($_[0] =~ /\sincr16/i)
  {
    $burst = "00000007";
  }
  else
  {
    $burst = "00000001";
  }
  return $burst;
}


###############################################################################
##  Get protection field value
#
# I/O: searches along the current line for a valid protection field value
#      returns the value of the protection field
###############################################################################

# Over-writes $_
sub GetProtField {
  
  my($prot,$value) = "00000000";

  # strip off any comment at end of line
  s/(\#|\/\/|;|--).*//;

  if ($_[0] =~ /\s[0-1]{4}[\s\n]/i)
  {
     ($prot) = $_[0] =~ /(\s[0-1]{4})[\s\n]/i;
     $value = 0;
  for ($main::i=1; $main::i<5; $main::i++)
     {
       if (substr($prot,$main::i,1) eq "1")
       {
         if    ($main::i == 1) {$value += 8;}
         elsif ($main::i == 2) {$value += 4;}
         elsif ($main::i == 3) {$value += 2;}
         elsif ($main::i == 4) {$value += 1;}
       }
     }
     $prot = sprintf("%08x\n",$value);
  }
  else
  {
    # if prot is not specified then "0000" is assumed
    $prot = "00000000";
  }
  return $prot;
}

###############################################################################
##  Get lock field value
#
# I/O: searches along the current line for a valid lock field value
#      returns the value of the lock field
###############################################################################


sub GetLockField {
  
  my($lock) = "00000000";

  # strip off any comment at end of line
  s/(\#|\/\/|;|--).*//;

 if ($_[0] =~ /\block\b/i)
  {
    $lock = "00000001";
  }
  elsif ($_[0] =~ /\bnolock\b/i) 
  {
    $lock = "00000000";
  }
  else
  {
    $lock = "00000000";
  }
  return $lock;
}


###############################################################################
##  Get mask field value
#
# I/O: searches along the current line for a valid mask field value
#      returns the value of the mask field
###############################################################################


sub GetMaskField {

  my($mask) = "FFFFFFFF";

  # strip off any comment at end of line
  s/(\#|\/\/|;|--).*//;

  if ($_[0] =~ /\b[0-9A-Fa-f]{8}\b/i)
  {
    ($mask)= /\b([0-9A-Fa-f]{8})\b/i;
  }
  else
  {
    $mask = "FFFFFFFF";
  }

  return $mask;

}

###############################################################################
##  Get address field value
#
# I/O: searches along the current line for a valid address field value
#      returns the value of the address field
###############################################################################


sub GetAddrField {

  my($addr) = "00000000";

  # strip off any comment at end of line
  s/(\#|\/\/|;|--).*//;

  if ($_[0] =~ /\b[0-9A-Fa-f]{8}\b/i)
  {
    ($addr) = /\b([0-9A-Fa-f]{8})\b/i;
  }
  else
  {
    $addr = "00000000";
  }

  return $addr;

}


###############################################################################
##  Get Direction field value
#
# I/O: searches along the current line for a valid direction field value
#      returns the value of the direction field
###############################################################################


sub GetDirField {
  
  my($dir)= "00000000";

  # strip off any comment at end of line
  s/(\#|\/\/|;|--).*//;

  if ($_[0] =~ /\bread\b/i)
  {
    $dir = "00000000";
  }
  elsif ($_[0] =~ /\bwrite\b/i) 
  {
   $dir = "00000001";
  }
  else
  {
    $dir = "00000000";
  }
  return $dir;
}

###############################################################################
##  Get number field value
#
# I/O: searches along the current line for a valid number field value
#      returns the value of the number field
###############################################################################


sub GetNumberField {

  my($num_chr,$num) = "00000000";

  # strip off any comment at end of line
  s/(\#|\/\/|;|--).*//;


  if ($_[0] =~ /[0-9]{1,4}/i)
  {
    ($num_chr)= /([0-9]{1,4})/i;
  }
  else
  {
    printf "Line %3d: ERROR   : Loop command must".
           " have number specified\n",$_[1];   
    $FileErrors++;  
    $num = "00000000";
    return $num;
  }
  
  if ($num_chr > 1023 or $num_chr < 1)
  {
    printf "Line %3d: ERROR   : Loop number out".
           " of range [1 to 1023]\n",$_[1];   
    $FileErrors++;  
    $num = "00000000";
    return $num;
  }
  else
  {
    $num = sprintf("%08x",$num_chr);
    return $num;
  }
}




###############################################################################
##  Get invalid fields for Write command
#      Splits the current line into an array and removes any whitespace at the 
#      start of the line. Also removes the command character and then checks
#      the remaining elements for invalid field values.
#
#      Returns $check_ok which is TRUE if checking is completed and FALSE if 
#      checking does not complete.
###############################################################################

sub GetWInvalid {

  my $match         = 0; 
  my $value         = 0;
  my $item          = 0;
  my $check_ok      = 0;
  my $comment_flag  = 0;
  # loads fields of command into elements of array
  my @split_results = split(/\s+/, $_[0]);  

  # defines valid field values
  my @valid_values  =
    ('\bb\b','\bbyte\b','\bh\b','\bhword\b','\bw\b','\bword\b','\bd\b',# size
     '\bdword\b','\bsize8\b','\bsize16\b','\bsize32\b','\bsize64\b',  
     '\bsing\b','\bsingle\b','\bincr\b','\bincr4\b','\bwrap4\b',       # burst 
     '\bincr8\b','\bwrap8\b','\bincr16\b','\bwrap16\b',               
     '\b([0-1]{4})\b',                                                 # prot
     '\bnolock\b','\block\b'                                           # lock
    ); 

  # removes whitespace chars. and command char. from array
  $item = shift (@split_results);
  while ($item !~ /\w/)
    {
      $item = shift (@split_results);
    }  
  $item = shift (@split_results);
   
  if ($item !~ /([0-9A-Fa-f]{8})/)
    {
      if ($verbose eq "1")
        {
          printf "Line %3d: WARNING : $item is an".
                 " invalid address value\n",$LineNum;
        }
      else
        {}
    }

  $item = shift (@split_results);
  if ($item !~ /([0-9A-Fa-f]{8})/)
    {
     if ($verbose eq "1")
        {
          printf "Line %3d: WARNING : $item is an".
                 " invalid data value\n",$LineNum;
        }
     else
       {}  
    }

  foreach $item (@split_results)
    {
      $match = 0; # reset match flag
      foreach $value(@valid_values)
        {
         if ($item =~ /$value/i)
           {
             $match = 1;       # set match flag
           }
         else
           {}
       }

      if (($match eq "0") && ($verbose eq "1")) # no match found - invalid field
        {
          if ($item =~ /\#|\/\/|;|--/) {$comment_flag = 1;}   # rest of line is a comment
 
          if ($comment_flag == '0')
            {
             printf "Line %3d: WARNING : $item is an invalid field\n",$LineNum;}
        }
      else
        {}      
    }

  $check_ok = 1; # invalid field checks complete
  return $check_ok;
}


###############################################################################
##  Get invalid fields for Read command
#      Splits the current line into an array and removes any whitespace at the 
#      start of the line. Also removes the command character and then checks
#      the remaining elements for invalid field values.
#
#      Returns $check_ok which is TRUE if checking is completed and FALSE if 
#      checking does not complete.
###############################################################################

sub GetRInvalid {

  my $match         = 0; 
  my $value         = 0;
  my $item          = 0;
  my $check_ok      = 0;
  my $comment_flag  = 0;
  # loads fields of command into elements of array
  my @split_results = split(/\s+/, $_[0]);  

  # defines valid field values
  my @valid_values  =
   ('\b([0-9A-Fa-f]{8})\b',                                           # mask
    '\bb\b','\bbyte\b','\bh\b','\bhword\b','\bw\b','\bword\b','\bd\b',# size
    '\bdword\b','\bsize8\b','\bsize16\b','\bsize32\b','\bsize64\b',  
    '\bsing\b','\bsingle\b','\bincr\b','\bincr4\b','\bwrap4\b',       # burst
    '\bincr8\b','\bwrap8\b','\bincr16\b','\bwrap16\b',               
    '\b([0-1]{4})\b',                                                 # prot
    '\bnolock\b','\block\b'                                           # lock
   ); 

  # removes whitespace chars. and command char. from array
  $item = shift (@split_results);
  while ($item !~ /\w/)
    {
      $item = shift (@split_results);
    }  
  $item = shift (@split_results); 

  if ($item !~ /([0-9A-Fa-f]{8})/)
    {
      if ($verbose eq "1")
        {
          printf "Line %3d: WARNING : $item is an invalid".
                 " address value\n",$LineNum;
        }
      else
        {}
    }

  $item = shift (@split_results);
  if ($item !~ /([0-9A-Fa-f]{8})/)
    {
     if ($verbose eq "1")
        {
          printf "Line %3d: WARNING : $item is an".
                 " invalid data value\n",$LineNum;
        }
     else
       {}  
    }

  foreach $item (@split_results)
    {
      $match = 0; # reset match flag
      foreach $value(@valid_values)
        {
         if ($item =~ /$value/i)
           {
             $match = 1;       # set match flag
           }
         else
           {}
        }

      if (($match eq "0") && ($verbose eq "1")) # no match found - invalid field
        {
          if ($item =~ /\#|\/\/|;|--/) {$comment_flag = 1;}   # rest of line is a comment
 
          if ($comment_flag == '0')
            {
             printf "Line %3d: WARNING : $item is an invalid field\n",$LineNum;}
        }
     
      else
        {}    
    }

  $check_ok = 1; # invalid field checks complete
  return $check_ok;
}


###############################################################################
##  Get invalid fields for Sequential command
#      Splits the current line into an array and removes any whitespace at the 
#      start of the line. Also removes the command character and then checks
#      the remaining elements for invalid field values.
#
#      Returns $check_ok which is TRUE if checking is completed and FALSE if 
#      checking does not complete.
###############################################################################

sub GetSInvalid {

  my $match         = 0; 
  my $value         = 0;
  my $item          = 0;
  my $check_ok      = 0;
  my $comment_flag  = 0;
  # loads fields of command into elements of array
  my @split_results = split(/\s+/, $_[0]);  

  # defines valid field values
  my @valid_values  = ('\b([0-9A-Fa-f]{8})\b');    # mask


  # removes whitespace chars. and command char. from array
  $item = shift (@split_results);
  while ($item !~ /\w/)
    {
      $item = shift (@split_results);
    }  
  $item = shift (@split_results);

  if ($item !~ /([0-9A-Fa-f]{8})/)
    {
     if ($verbose eq "1")
        {
          printf "Line %3d: WARNING : $item is an invalid".
                 " data value\n",$LineNum;
        }
     else
       {}  
    }

  foreach $item (@split_results)
    {
      $match = 0; # reset match flag
      foreach $value(@valid_values)
        {
         if ($item =~ /$value/i)
           {
             $match = 1;       # set match flag
           }
         else
           {}
        }

      if (($match eq "0") && ($verbose eq "1")) # no match found - invalid field
        {
          if ($item =~ /\#|\/\/|;|--/) {$comment_flag = 1;}   # rest of line is a comment
 
          if ($comment_flag == '0')
            {
             printf "Line %3d: WARNING : $item is an invalid field\n",$LineNum;}
        }
     
      else
        {}    
    }

  $check_ok = 1; # invalid field checks complete
  return $check_ok;
}


###############################################################################
##  Get invalid fields for Busy command
#      Splits the current line into an array and removes any whitespace at the 
#      start of the line. Also removes the command character and then checks
#      the remaining elements for invalid field values.
#
#      Returns $check_ok which is TRUE if checking is completed and FALSE if 
#      checking does not complete.
###############################################################################

sub GetBInvalid {

  my $match         = 0; 
  my $value         = 0;
  my $item          = 0;
  my $check_ok      = 0;
  my $comment_flag  = 0;
  # loads fields of command into elements of array
  my @split_results = split(/\s+/, $_[0]);  

  # defines valid field values
  my @valid_values  = (''); 

    
 # removes whitespace chars. and command char. from array
  $item = shift (@split_results);
  while ($item !~ /\w/)
    {
      $item = shift (@split_results);
    }  
  #$item = shift (@split_results);

  foreach $item (@split_results)
    {
      $match = 0; # reset match flag
      foreach $value(@valid_values)
        {
         if ($item =~ /$value/i)
           {
             $match = 1;       # set match flag
           }
         else
           {}
       }

      if (($match eq "0") && ($verbose eq "1")) # no match found - invalid field
        {
          if ($item =~ /\#|\/\/|;|--/)  # rest of line is a comment
              {last;}                   # skip rest of line
 
          else
            {
             printf "Line %3d: WARNING : $item is an invalid field\n",$LineNum;
            }
        }
      
      else
        {}    
    }

  $check_ok = 1; # invalid field checks complete
  return $check_ok;
}


###############################################################################
##  Get invalid fields for Idle command
#      Splits the current line into an array and removes any whitespace at the 
#      start of the line. Also removes the command character and then checks
#      the remaining elements for invalid field values.
#
#      Returns $check_ok which is TRUE if checking is completed and FALSE if 
#      checking does not complete.
###############################################################################

sub GetIInvalid {

  my $match         = 0; 
  my $value         = 0;
  my $item          = 0;
  my $check_ok      = 0;
  my $comment_flag  = 0;
  # loads fields of command into elements of array
  my @split_results = split(/\s+/, $_[0]);  

  # defines valid field values
  my @valid_values  =
   ('\b([0-9A-Fa-f]{8})\b',                                           # address
    '\bread\b','\bwrite\b',                                           # dir
    '\bb\b','\bbyte\b','\bh\b','\bhword\b','\bw\b','\bword\b','\bd\b',# size
    '\bdword\b','\bsize8\b','\bsize16\b','\bsize32\b','\bsize64\b',   
    '\bsing\b','\bsingle\b','\bincr\b','\bincr4\b','\bwrap4\b',       # burst
    '\bincr8\b','\bwrap8\b','\bincr16\b','\bwrap16\b', 
    '\bnolock\b','\block\b',                                          # lock               
    '\b([0-1]{4})\b'                                                  # prot 
   ); 

    
  # removes whitespace chars. and command char. from array
  $item = shift (@split_results);
  while ($item !~ /\w/)
    {
      $item = shift (@split_results);
    }  
  #$item = shift (@split_results);

  foreach $item (@split_results)
    {
      $match = 0; # reset match flag
      foreach $value(@valid_values)
        {
         if ($item =~ /$value/i)
           {
             $match = 1;       # set match flag
           }
         else
           {}
        }
     
      if (($match eq "0") && ($verbose eq "1")) # no match found - invalid field
        {
          if ($item =~ /\#|\/\/|;|--/) # rest of line is a comment
             {
              last;                    # skip checking rest of line
             }                   
 
          else
            {
             printf "Line %3d: WARNING : $item is an invalid field\n",$LineNum;
            }
        }
     
      else
        {}    
    }

  $check_ok = 1; # invalid field checks complete
  return $check_ok;
}


###############################################################################
##  Get invalid fields for Poll command
#      Splits the current line into an array and removes any whitespace at the 
#      start of the line. Also removes the command character and then checks
#      the remaining elements for invalid field values.
#
#      Returns $check_ok which is TRUE if checking is completed and FALSE if 
#      checking does not complete.
###############################################################################

sub GetPInvalid {

  my $match         = 0; 
  my $value         = 0;
  my $item          = 0;
  my $check_ok      = 0;
  my $comment_flag  = 0;
  # loads fields of command into elements of array
  my @split_results = split(/\s+/, $_[0]);  

  # defines valid field values
  my @valid_values  =
   ('\b([0-9A-Fa-f]{8})\b',                                           # mask
    '\bb\b','\bbyte\b','\bh\b','\bhword\b','\bw\b','\bword\b','\bd\b',# size
    '\bdword\b','\bsize8\b','\bsize16\b','\bsize32\b','\bsize64\b',  
    '\bincr\b','\bsing\b','\bsingle\b',                               # burst
    '\b([0-1]{4})\b'                                                  # prot
   );
 
  # removes whitespace chars. and command char. from array
  $item = shift (@split_results);
  while ($item !~ /\w/)
    {
      $item = shift (@split_results);
    }  
  $item = shift (@split_results);
  
  if ($item !~ /([0-9A-Fa-f]{8})/)
    {
      if ($verbose eq "1")
        {
          printf "Line %3d: WARNING : $item is an".
                 " invalid address value\n",$LineNum;
        }
      else
        {}
    }

  $item = shift (@split_results);
  if ($item !~ /([0-9A-Fa-f]{8})/)
    {
     if ($verbose eq "1")
        {
          printf "Line %3d: WARNING : $item is an".
                 " invalid data value\n",$LineNum;
        }
     else
       {}  
    }

  foreach $item (@split_results)
    {
      $match = 0; # reset match flag
      foreach $value(@valid_values)
        {
         if ($item =~ /$value/i)
           {
             $match = 1;       # set match flag
           }
         else
           {}
        }

      if (($match eq "0") && ($verbose eq "1")) # no match found - invalid field
        {
          if ($item =~ /\#|\/\/|;|--/) {$comment_flag = 1;}   # rest of line is a comment
 
          if ($comment_flag == '0')
            {
             printf "Line %3d: WARNING : $item is an invalid field\n",$LineNum;}
        }
     
      else
        {}    
    }

  $check_ok = 1; # invalid field checks complete
  return $check_ok;
}


###############################################################################
##  Get invalid fields for Loop command
#      Splits the current line into an array and removes any whitespace at the 
#      start of the line. Also removes the command character and then checks
#      the remaining elements for invalid field values.
#
#      Returns $check_ok which is TRUE if checking is completed and FALSE if 
#      checking does not complete.
###############################################################################

sub GetLInvalid {

  my $match         = 0; 
  my $value         = 0;
  my $item          = 0;
  my $check_ok      = 0;
  my $comment_flag  = 0;
  # loads fields of command into elements of array
  my @split_results = split(/\s+/, $_[0]);  
  # defines valid field values
  my @valid_values  = (''); 

  # removes whitespace chars. and command char. from array
  $item = shift (@split_results);
  while ($item !~ /\w/)
    {
      $item = shift (@split_results);
    }  
  $item = shift (@split_results);
   
  if ($item !~ /([0-9]{1,4})/)     # 1 to 4 digit number
    {
      if ($verbose eq "1")
        {
          printf "Line %3d: WARNING : $item is an".
                 " invalid number value\n",$LineNum;
        }
      else
        {}
    }

  foreach $item (@split_results)
    {
      $match = 0; # reset match flag
      foreach $value(@valid_values)
        {
         if ($item =~ /$value/i)
           {
             $match = 1;       # set match flag
           }
         else
           {}
        }

       if (($match eq "0") && ($verbose eq "1")) # no match found - invalid field
        {
          if ($item =~ /\#|\/\/|;|--/) {$comment_flag = 1;}   # rest of line is a comment
 
          if ($comment_flag == '0')
            {
             printf "Line %3d: WARNING : $item is an invalid field\n",$LineNum;}
        }
      
      else
        {}    
    }

  $check_ok = 1; # invalid field checks complete
  return $check_ok;
}


################################################################################
## Output format definitions
################################################################################

format WRITECMD =
@<<<<<<<
$commands{$Cmd,"CMD"}
@<<<<<<<
$commands{$Cmd,"ADDR"}
@<<<<<<<
$commands{$Cmd,"DATA"}
@<<<<<<<
$commands{$Cmd,"SIZE"}
@<<<<<<<
$commands{$Cmd,"BUR"}
@<<<<<<<
$commands{$Cmd,"PROT"}
@<<<<<<<
$commands{$Cmd,"LOCK"}
.

format READCMD =
@<<<<<<<
$commands{$Cmd,"CMD"}
@<<<<<<<
$commands{$Cmd,"ADDR"}
@<<<<<<<
$commands{$Cmd,"DATA"}
@<<<<<<<
$commands{$Cmd,"MASK"}
@<<<<<<<
$commands{$Cmd,"SIZE"}
@<<<<<<<
$commands{$Cmd,"BUR"}
@<<<<<<<
$commands{$Cmd,"PROT"}
@<<<<<<<
$commands{$Cmd,"LOCK"}
.

format SEQCMD =
@<<<<<<<
$commands{$Cmd,"CMD"}
@<<<<<<<
$commands{$Cmd,"DATA"}
@<<<<<<<
$commands{$Cmd,"MASK"}
.

format BUSYCMD =
@<<<<<<<
$commands{$Cmd,"CMD"}
.

format IDLECMD =
@<<<<<<<
$commands{$Cmd,"CMD"}
@<<<<<<<
$commands{$Cmd,"ADDR"}
@<<<<<<<
$commands{$Cmd,"DIR"}
@<<<<<<<
$commands{$Cmd,"SIZE"}
@<<<<<<<
$commands{$Cmd,"BUR"}
@<<<<<<<
$commands{$Cmd,"PROT"}
@<<<<<<<
$commands{$Cmd,"LOCK"}
.

format POLLCMD =
@<<<<<<<
$commands{$Cmd,"CMD"}
@<<<<<<<
$commands{$Cmd,"ADDR"} 
@<<<<<<<
$commands{$Cmd,"DATA"}
@<<<<<<<
$commands{$Cmd,"MASK"}
@<<<<<<<
$commands{$Cmd,"SIZE"}
@<<<<<<<
$commands{$Cmd,"BUR"}
@<<<<<<<
$commands{$Cmd,"PROT"}
.

format LOOPCMD =
@<<<<<<<
$commands{$Cmd,"CMD"}
@<<<<<<<
$commands{$Cmd,"NUMBER"}
.
