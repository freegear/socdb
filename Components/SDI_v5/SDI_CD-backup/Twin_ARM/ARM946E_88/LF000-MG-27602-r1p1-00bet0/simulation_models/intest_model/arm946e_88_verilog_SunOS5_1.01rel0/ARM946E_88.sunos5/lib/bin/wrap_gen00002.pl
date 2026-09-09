#!/usr/local/bin/perl
# Copyright(C)2001 Logic Modeling, Synopsys Inc. ALL RIGHTS RESERVED
# Wrapper Generator v0.1
#
# Usage
#
#
# wrap_gen   -sim vcs [| vss | scirocco | verilog_xl |  nc_verilog | nc_vhdl | mti_verilog | mti_vhdl | systemc] 
#            -module <module name>
#	   [ -path <path> ]
#	   [ -name <name.[v|vhd|cpp]> ]
#	     -config <configuration name>
#            -h produce this text
#
#  Options description:
#
#  -sim  [vcs | vss | scirocco | verilog-xl | nc-verilog | nc-vhdl | mti-verilog | mti-vhdl | systemc] 
#        specifies simulator to generate wrapper. 
#        Only one simulator can be specified at a time.
#
#  -module <mod. name>      module name to generate wrapper file. 
#                           <module name> is a case sensitive, 
#                           so the module name is generated exactly as specified;
#
#  -path <path>	            path for wrapper file.
#                           The default is to generate the file in the 
#                           <current_working_directory>/model_src
#
#  -name                    name for wrapper file. 
#                           Default name is <model name>_<sim>.[v|vhd]
#
#  -config <config. name>   name of configuration. Used only for VHDL simulators



my $LmcHome   = $ENV{ LMC_HOME };

die "ERROR: running $0: ",
    "The LMC_HOME environment variable must be set.\n"
    unless( $LmcHome );

# Load the 'libmdl' library of subroutines
require "$LmcHome/lib/bin/libmdl01003.pl";


######################################################################
#
# Print usage.
#
sub PrintUsage
{
  print ("$ProgName: Copyright(C)2001 Synopsys Inc. ALL RIGHTS RESERVED\n"); 
  Usage();
}




######################################################################
#
# Main program
#
# Process the command line switches.  Allow switches on either 
# end of file names.
$ProgName="wrap_gen";

$module="";
$path="./model_src";
$wrapper_name="";
$config="";
$architecture="";
#$library="";
$simulator="";
$ext="";
$req_name=0;
$platform = GetPlatform();

for( $Arg = 0; $_ = $ARGV[$Arg]; $Arg++ ) {

    if( /^-module/i ) {                 # -module name
         if( $Arg < $#ARGV ) {
            $Arg++;
            $module = $ARGV[$Arg];
            if( $Arg < $#ARGV ) {
              while( !($ARGV[$Arg+1] =~ /-/) &&  $Arg < $#ARGV )
              {
                #print "reading: $ARGV[$Arg+1] \n";
                $module = $module." ".$ARGV[$Arg+1];
                $Arg++;
                $req_name=1;
              }
            }
        } 
        else
        {
            Usage();
            die "ERROR: running $ProgName: -model switch requires a model name\n";
        }
        next;
    }
    if( /^-path$/i ) {                  # path for wrapper
        if( $Arg < $#ARGV ) {
            $Arg++;
            $path = $ARGV[$Arg];
        } else {
            Usage();
            die "ERROR: running $ProgName: -path switch requires an argument\n";
        }
        next;
    }
    if( /^-name$/i ) {                  # name of the wrapper file
        if( $Arg < $#ARGV ) {
            $Arg++;
            $wrapper_name = $ARGV[$Arg];
        } else {
            Usage();
            die "ERROR: running $ProgName: -name switch requires an argument\n";
        }
        next;
    }
    if( /^-config$/i ) {                  # configuration name, used only for VHDL simulators
        if( $Arg < $#ARGV ) {
            $Arg++;
            $config = $ARGV[$Arg];
        } else {
            Usage();
            die "ERROR: running $ProgName: -config switch requires an argument\n";
        }
        next;
    }
    if( /^-sim$/i ) {                  # simulator
        if( $Arg < $#ARGV ) {
            $Arg++;
            $simulator = lc( $ARGV[$Arg]);
        } else {
            Usage();
            die "ERROR: running $ProgName: -sim switch requires an argument\n";
        }
        next;
    }
    if( /^-h$/i ) {    
        PrintUsage();
    }
}

check_simulator();

if( $module eq "")
{
  die "\nERROR: running $ProgName: empty module list\n";
  #PrintUsage();

}


if ($wrapper_name eq "")
{
  if ($req_name eq 0)
  {
     $wrapper_name=lc($module)."_".$simulator.".".$ext;
  } else 
  {
     my( @list ) = split(" ", $module );
     $wrapper_name=lc($list[0])."_".$simulator.".".$ext;
  }
}

if( ($req_name eq 1) &&  ($config ne "") )
{
  print "WARNNING running $ProgName: switch -config is ignored for multiple models\n";
  $config="";
}



$model=lc($module);

print " module(s) name:  $module \n";
print " path:            $path \n";
print " wrapper name:    $wrapper_name \n";
print " configuration:   $config \n";
print " simulator:       $simulator \n";
print " platform:        $platform \n";

$Res=create_wrapper();
if( $Res eq 0) 
{
  print "Exiting $ProgName successfully.\n";
}
else
{
  print "Exiting $ProgName unsuccessfully, status: $Res.\n";
}
exit( $Retval );



# subroutines

sub check_simulator
{
    if ($simulator eq "vcs" ){
       $ext="v";
       die "ERROR: running $ProgName: ", "The VCS_HOME environment variable must be set.\n"
         unless( $ENV{ VCS_HOME } );
       return 0;
    }
    if ($simulator eq "vss" || $simulator eq "scirocco") {
       $ext="vhd";
       die "ERROR: running $ProgName: ", "The SYNOPSYS_SIM environment variable must be set.\n"
         unless( $ENV{ SYNOPSYS_SIM } );
       $arch= `$ENV{SYNOPSYS_SIM}/admin/install/sim/bin/getarch`;
       chomp($arch);
       if( $ENV{PATH} !~ m#$ENV{SYNOPSYS_SIM}/$arch/sim/bin# )
       {
          die "Coudn't find file: create_smartmodel_lib.\nPlease make sure you source setup file $SYNOPSYS_SIM/admin/setup/environ.csh.\n";
       }
       return 0;
    }
    if ($simulator eq "verilog_xl"){
       $ext="v";
       #die "ERROR: running $ProgName: ", "The VERILOG_HOME environment variable must be set.\n"
       #  unless( $ENV{ VERILOG_HOME } );
       return 0;
    }
    if ($simulator eq "nc_verilog"){
       $ext="v";
       #die "ERROR: running $ProgName: ", "The VERILOG_HOME environment variable must be set.\n"
       #  unless( $ENV{ VERILOG_HOME } );
       return 0;
    }
    if ($simulator eq "nc_vhdl"){
       $ext="vhd";
       die "ERROR: running $ProgName: ", "The CDSDIR environment variable must be set.\n"
         unless( $ENV{ CDS_INST_DIR } );
       return 0;
    }
    if ($simulator eq "mti_verilog"){
       $ext="v";
       #die "ERROR: running $ProgName: ", "The MTI_HOME environment variable must be set.\n"
       #  unless( $ENV{ MTI_HOME } );
       return 0;
    }
    if ($simulator eq "mti_vhdl"){
       $ext="vhd";
       die "ERROR: running $ProgName: ", "The MTI_HOME environment variable must be set.\n"
         unless( $ENV{ MTI_HOME } );
       return 0;
    }
    if ($simulator eq "systemc"){
       $ext="";
       return 0;
    }
    if ($simulator eq ""){
       die "ERROR: running $ProgName: ", "simulator is not specified.\n"
    }
    else{
      die "ERROR: running $ProgName: specified simulator: $simulator is not supported.\n";
    }
    if( ($ext eq "v") && ($config ne "") )
    {
      print "WARNING running $ProgName: -config should be used only for VHDL simulators: -config $$config is ignored.\n";
      $config="";
    }
}

sub replace
{
  my( $wrapper, $src, $dest ) = @_;

  open( wrap_new, "> $wrapper.tmp");
  open( wrap, "< $wrapper" ) ;
  select(wrap_new);

  while( <wrap> ) 
  {
     $_ =~ s/$src/$dest/;
     print wrap_new $_ or die "can't write $wrapper.tmp: $!";
  }
  close( wrap );
  close( wrap_new );
  unlink($wrapper);
  rename("$wrapper.tmp", $wrapper);
  select (STDOUT);
}


sub get_model_list
{
  $model_list="";
  my( @list ) = split(" ", $model );
  foreach $m (@list)
  {
    $model_list=$model_list." -model $m";
  }
  return $model_list;
} 

sub select_msini
{
  $strlibsm=   "libsm = \\\$MODEL_TECH/libsm.sl";
  $strlibhm=   "libhm = \\\$MODEL_TECH/libhm.sl";

  if ($platform eq "solaris") 
  {
     $strlibswift="libswift = \\\$LMC_HOME/lib/sun4Solaris.lib/libswift.so";
     $strlibsfi=  "libsfi   = \\\$LM_HOME/lib/sun4.solaris/libsfi.so";
  }
  if ($platform eq "hp700") 
  {
     $strlibswift="libswift = \\\$LMC_HOME/lib/hp700.lib/libswift.sl";
     $strlibsfi=  "libsfi   = \\\$LM_HOME/lib/hp700/libsfi.sl";
  }
  if ($platform eq "ibmrs") 
  {
     $strlibswift="libswift = \\\$LMC_HOME/lib/ibmrs.lib/swift.o";
     $strlibsfi=  "libsfi   = \\\$LM_HOME/lib/rs6000/libsfi.a";
  }
  if ($platform eq "pcnt") 
  {
     $strlibsm=   "libsm    = \\\$MODEL_TECH/libsm.dll";
     $strlibswift="libswift = \\\$LMC_HOME/lib/pcnt.lib/libswift.dll";
     $strlibhm=   "";
     $strlibsfi=  "";
  }
  system("echo \"[Library] \" > modelsim.ini" );
  system("echo \"work = ./work  \" >> modelsim.ini" );
  system("echo \"std = \\\$MODEL_TECH/../std\" >> modelsim.ini" );
  system("echo \"ieee = \\\$MODEL_TECH/../ieee\" >> modelsim.ini" );
  system("echo \"verilog = \\\$MODEL_TECH/../verilog\" >> modelsim.ini" );
  system("echo \"others = \\\$MODEL_TECH/../modelsim.ini\" >> modelsim.ini" );

  system("echo \"\n[vcom]\" >> modelsim.ini" );
  system("echo \"VHDL93 = 1\" >> modelsim.ini" );
  system("echo \"Show_source = 1\" >> modelsim.ini" );

  system("echo \"\n[vsim]\" >> modelsim.ini" );
  system("echo \"Resolution = ps\" >> modelsim.ini" );
  system("echo \"UserTimeUnit = default\" >> modelsim.ini" );
  system("echo \"RunLength = 100\" >> modelsim.ini" );
  system("echo \"IterationLimit = 5000\" >> modelsim.ini" );
  system("echo \"BreakOnAssertion = 3\" >> modelsim.ini" );
  system("echo \"DefaultRadix = symbolic\" >> modelsim.ini" );
  system("echo \"TranscriptFile = transcript\" >> modelsim.ini" );
  system("echo \"PathSeparator = / \" >> modelsim.ini" );

  system("echo \"\n[lmc]\" >> modelsim.ini" );
  system("echo \"$strlibsm    \" >> modelsim.ini" );
  system("echo \"$strlibswift \" >> modelsim.ini" );
  system("echo \"$strlibhm    \" >> modelsim.ini" );
  system("echo \"$strlibsfi   \" >> modelsim.ini" );

}

sub create_wrapper
{
    if(!(-e $path))
    {
       mkdir("$path",0777);
    }
    if ($simulator eq "vcs"){
       $Res=system("$ENV{VCS_HOME}/bin/vcs -lmc-swift-template $model > wrapper.log 2>&1 ");
       if ($Res > 0)
       {
         print "ERROR: VCS wrapper generator returned error status $Res. See wrapper.log for details.\n";
       }
       #call name replacer         
       $file_list="";
       my( @list ) = split(" ", $module );
       system("echo \"\n\n\" > empty.v" );
       foreach $m (@list)
       {
         $m_uc=uc($m);
         $m_lc=lc($m);
         if( $m ne $m_uc )
         {
           replace("$m_lc.swift.v", "module $m_uc", "module $m");
         }
         $file_list=$file_list." $m_lc.swift.v"." empty.v ";
       }
       $Res+=system("cat $file_list > $path/$wrapper_name ");
       system("rm  $file_list >> wrapper.log 2>&1");
       #vcs gen can accept space separated list of modelnames as cmd arg
    }
    if ($simulator eq "vss" || $simulator eq "scirocco" ){
       $model_list=get_model_list(); 
       $Res=system("create_smartmodel_lib -create -srcdir . $model_list > wrapper.log 2>&1 ");
       if ($Res > 0)
       {
         print "ERROR: VSS/Scirocco wrapper generator returned error status $Res. See wrapper.log for details.\n";
       }
       if($config ne "")
       {
         replace("entities.vhd", "CFG_$model", "$config");
       }
       $Res+=system("mv entities.vhd $path/$wrapper_name");
       $Res+=system("rm components.vhd");
       #vss gen can exept file with modelnames as "-modelfile file" option or  -model modelname1 -model modelname2 ...
    }  
    if ($simulator eq "verilog_xl" || $simulator eq "nc_verilog" || $simulator eq "mti_verilog"){
       $Res=system(" $ENV{LMC_HOME}/bin/vsg -s  $model > wrapper.log 2>&1 ");
       if ($Res > 0)
       {
         print "ERROR: VSG wrapper generator returned error status $Res. See wrapper.log for details.\n";
       }
       $Res=system(" $ENV{LMC_HOME}/bin/vsg -bit2bus verilog $model > vsg.log 2>&1 ");
       #call name replacer         
       $file_list="";
       my( @list ) = split(" ", $module );
       system("echo \"\n\n\" > empty.v" );
       foreach $m (@list)
       {
         $m_lc=lc($m);
         $m_bit=$m_lc."_bit";
         $m_bus=$m_lc."_bw";
         $wbus=system("cat vsg.log | grep \"$m_lc does not contain any busses\" 2>&1 >/dev/null ");
         if($wbus > 0)
         {           
           replace("$m_lc.v", "module $m_lc", "module $m_bit");
           replace("$m_bus.v", "$m_lc ", "$m_bit ");           
           replace("$m_bus.v", "module $m_bus", "module $m");
           $file_list=$file_list." $m_lc.v "." $m_bus.v "." empty.v ";
         }
         else
         {
           replace("$m_lc.v", "module $m_lc", "module $m");
           $file_list=$file_list." $m_lc.v "." empty.v ";
         }
       }
       $Res+=system("cat $file_list > $path/$wrapper_name ");
       $Res+=system("rm  $file_list >> wrapper.log 2>&1");
       #vsg can exept file with modelnames as "-z file" option or space separated list of modelnames as cmd arg
    }
    if ($simulator eq "mti_vhdl"){
       select_msini();
       $Res=system(" sm_entity $model >  $wrapper_name 2> wrapper.log");
       if ($Res > 0)
       {
         print "ERROR: MTI VHDL wrapper generator returned error status $Res. See wrapper.log for details.\n";
       }
       #generate bus wrapper and if model has bus(es) then use this extra wrapper
       $Res+=system(" $ENV{LMC_HOME}/bin/vsg -bit2bus vhdl $model > vsg.log 2>&1 ");
       $file_list="$wrapper_name";
       my( @list ) = split(" ", $module );
       foreach $m (@list)
       { 
         $m_lc=lc($m);
         $m_bus=$m_lc."_bw";
         $m_bit=$m_lc."_bit";
         #wbus: 0-no busses, >0 there are busses
         $wbus=system("cat vsg.log | grep \"$m_lc does not contain any busses\" 2>&1 >/dev/null ");
         if($wbus > 0)
         {           
           replace("$wrapper_name", "entity $m_lc is", "entity $m_bit is");
           replace("$wrapper_name", "architecture SmartModel of $m_lc is", "architecture SmartModel of $m_bit is");
           replace("$m_bus.vhd", "component $m_lc", "component $m_bit");
           replace("$m_bus.vhd", ": $m_lc", ": $m_bit");
           replace("$m_bus.vhd", "$m_bus", "$m_lc");
           replace("$m_bus.vhd", "//", "--");
           $file_list=$file_list." $m_bus.vhd ";
         }
         else
         {
           $Res+=system("rm $m_bus.vhd");
         }
       }
       $Res+=system("cat $file_list > $path/$wrapper_name ");
       $Res+=system("rm  $file_list modelsim.ini vsg.log >> wrapper.log 2>&1");
       #sm_entity can except space separated list of modelnames as cmd arg
    }
    if ($simulator eq "nc_vhdl"){
       system("echo \"SOFTINCLUDE \\\$CDS_INST_DIR/tools/inca/files/hdl.var \" > hdl.var" );
       system("echo \"SOFTINCLUDE \\\$CDS_INST_DIR/tools/inca/files/cds.lib \" > cds.lib" );

       $Res=system(" $ENV{LMC_HOME}/bin/vsg -bit2bus vhdl $model > vsg.log 2>&1 ");
       if ($Res > 0)
       {
         print "ERROR: VSG wrapper generator returned error status $Res. See vsg.log for details.\n";
       }
       my( @list ) = split(" ", $module );
       foreach $m (@list)
       { 
         $m_lc=lc($m);
         $m_bus=$m_lc."_bw";
         $m_bit=$m_lc."_bit";
         $lres=system("ncshell -BACKWARD -import swift -into vhdl $m -nocompile -work slm_lib > wrapper.log 2>&1 ");
         $Res+=$lres;
         if ($lres > 0)
         {
           print "NC VHDL wrapper generator returned error status $lres. See wrapper.log for details.\n";
         }
         $rm_list=$rm_list." $m"."_comp.vhd ";
         #wbus: 0-no busses, >0 there are busses
         $wbus=system("cat vsg.log | grep \"$m_lc does not contain any busses\" 2>&1 >/dev/null ");
         if($wbus > 0)
         {           
           replace("$m_bus.vhd", "//", "--");
           print "Note: NC_VHDL wrapper doesn't support bus port.\n";
           print "Entity name for module $m is $m_bus with busses and $m_lc bit-blasted\n";
           $file_list=$file_list." $m_bus.vhd "." $m.vhd ";
         }
         else
         {
           $Res+=system("rm $m_bus.vhd");
           print "entity name for module $m is $m_lc.\nNote: module $m doesn't have any busses.\n";
           $file_list=$file_list." $m.vhd ";
         }
       }
       $Res+=system("cat $file_list > $path/$wrapper_name ");
       $Res+=system("rm $rm_list $file_list  vsg.log");
       #ncshell can do only 1 model at a time.... 
    }
    if ($simulator eq "systemc"){
       $Res=system("$LmcHome/bin/scsg $model > wrapper.log 2>&1 ");
       if ($Res > 0)
       {
         print "ERROR: SystemC wrapper generator returned error status $Res. See wrapper.log for details.\n";
       }

       #scsg can except space separated list of modelnames as cmd arg
       $file_list_cpp="top.cpp ";
       $file_list_h="top.h ";
       my( @list ) = split(" ", $module );
       system("echo \"#include \\\"lsc_SwiftModel.h\\\"\n\" > top.h" );       
       system("echo \"\#include \\\"$wrapper_name"."h\\\" \"  > top.cpp" );
       foreach $m (@list)
       {
         $m_lc=lc($m);

         $file_list_h=$file_list_h." $m_lc.h ";
         replace("$m_lc.h", "#include \\\"lsc_SwiftModel.h\\\"", "");
         replace("$m_lc.h", "$m_lc", "$m");

         $file_list_cpp=$file_list_cpp." $m_lc.cpp ";
         replace("$m_lc.cpp", "#include \\\"$m_lc.h\\\"", "");
         replace("$m_lc.cpp", "$m_lc", "$m");
       }
       $Res+=system("cat $file_list_h > $path/$wrapper_name"."h ");
       $Res+=system("cat $file_list_cpp > $path/$wrapper_name"."cpp ");
       $Res+=system("rm  $file_list_h $file_list_cpp  2>&1 >/dev/null");
    }
  return $Res;
}
