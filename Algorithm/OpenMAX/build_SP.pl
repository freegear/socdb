#!/usr/bin/perl
#
# $Copyright$
#
# This file builds the OpenMAX DL Signal Processing domain library omxSP.
#

use strict;
my ($CC, $CC_OPTS, $LIB, $LIB_OPTS, $LIB_TYPE);

# The C Compiler and its options
$CC       = "gcc";
$CC_OPTS  = "-pedantic -Wno-long-long -Wall -c -o ";

# The library generator (linker), its options, and its file type.
$LIB      = "ar";
$LIB_OPTS = "-rcs";
$LIB_TYPE = ".a";

#------------------------
my (@headerlist, @filelist, $hd, $file, $ofile, $command, $objlist);

# Define the list of directories containing included header files.
@headerlist = (
    "./api",
    "sp/api"
);

# Define the list of C source files to compile.
@filelist = (
    "./src/armCOMM_Bitstream.c",
    "./src/armCOMM.c",
    "sp/src/omxSP_BlockExp_S16.c",
    "sp/src/omxSP_BlockExp_S32.c",
    "sp/src/omxSP_Copy_S16.c",
    "sp/src/omxSP_DotProd_S16.c",
    "sp/src/omxSP_DotProd_S16_Sfs.c",
    "sp/src/omxSP_FFTFwd_CToC_SC16_Sfs.c",
    "sp/src/omxSP_FFTFwd_CToC_SC32_Sfs.c",
    "sp/src/omxSP_FFTFwd_RToCCS_S16S32_Sfs.c",
    "sp/src/omxSP_FFTFwd_RToCCS_S32_Sfs.c",
    "sp/src/omxSP_FFTGetBufSize_C_SC16.c",
    "sp/src/omxSP_FFTGetBufSize_C_SC32.c",
    "sp/src/omxSP_FFTGetBufSize_R_S16S32.c",
    "sp/src/omxSP_FFTGetBufSize_R_S32.c",
    "sp/src/omxSP_FFTInit_C_SC16.c",
    "sp/src/omxSP_FFTInit_C_SC32.c",
    "sp/src/omxSP_FFTInit_R_S16S32.c",
    "sp/src/omxSP_FFTInit_R_S32.c",
    "sp/src/omxSP_FFTInv_CCSToR_S32_Sfs.c",
    "sp/src/omxSP_FFTInv_CCSToR_S32S16_Sfs.c",
    "sp/src/omxSP_FFTInv_CToC_SC16_Sfs.c",
    "sp/src/omxSP_FFTInv_CToC_SC32_Sfs.c",
    "sp/src/omxSP_FilterMedian_S32_I.c",
    "sp/src/omxSP_FilterMedian_S32.c",
    "sp/src/omxSP_FIR_Direct_S16_I.c",
    "sp/src/omxSP_FIR_Direct_S16_ISfs.c",
    "sp/src/omxSP_FIR_Direct_S16.c",
    "sp/src/omxSP_FIR_Direct_S16_Sfs.c",
    "sp/src/omxSP_FIROne_Direct_S16_I.c",
    "sp/src/omxSP_FIROne_Direct_S16_ISfs.c",
    "sp/src/omxSP_FIROne_Direct_S16.c",
    "sp/src/omxSP_FIROne_Direct_S16_Sfs.c",
    "sp/src/omxSP_IIR_BiQuadDirect_S16_I.c",
    "sp/src/omxSP_IIR_BiQuadDirect_S16.c",
    "sp/src/omxSP_IIR_Direct_S16_I.c",
    "sp/src/omxSP_IIR_Direct_S16.c",
    "sp/src/omxSP_IIROne_BiQuadDirect_S16_I.c",
    "sp/src/omxSP_IIROne_BiQuadDirect_S16.c",
    "sp/src/omxSP_IIROne_Direct_S16_I.c",
    "sp/src/omxSP_IIROne_Direct_S16.c"
);

# Create the include path to be passed to the compiler
$hd = '-I';
$hd .= join(' -I', @headerlist);

# Create the build directories "/lib/" and "/obj/" (if they are not there already)
mkdir "obj", 0777 if (! -d "obj");
mkdir "lib", 0777 if (! -d "lib");


# Compile each C file in turn, and build a list of the object files for the later linking stage.
$objlist = '';
foreach $file (@filelist)
{
    # The object file name is the same as the C file name, but with the filetype changed
    # from .c to .o. The path however is changed to /obj/ in the project root.
    $file=~m/(.*)[\/\\]([^.]*)\.c/;
    $ofile="obj/$2.o";
    $objlist.=$ofile.' ';
	$command = $CC.' '.$CC_OPTS.' '.$ofile.' '.$hd.' '.$file;
	print "$command\n";
	system($command);
}


# Do the final link stage to create the libraries.
$command = $LIB.' '.$LIB_OPTS.' lib/omxSP'.$LIB_TYPE.' '.$objlist;
print "$command\n";
system($command);







