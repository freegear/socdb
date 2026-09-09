#!/usr/bin/perl
#
# $Copyright$
#
# This file builds the OpenMAX DL Image Processing domain library omxIP.
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
    "ip/api"
);

# Define the list of C source files to compile.
@filelist = (
    "./src/armCOMM_Bitstream.c",
    "./src/armCOMM.c",
    "ip/src/armIPCS_ComputeColourComponents.c",
    "ip/src/armIPCS_Flip.c",
    "ip/src/armIPCS_HelperRGB.c",
    "ip/src/armIPCS_InterpPixel_Bilinear.c",
    "ip/src/armIPPP_ComputeBinomialCoeff.c",
    "ip/bm/src/omxIPBM_AddC_U8_C1R_Sfs.c",
    "ip/bm/src/omxIPBM_Copy_U8_C1R.c",
    "ip/bm/src/omxIPBM_Copy_U8_C3R.c",
    "ip/bm/src/omxIPBM_Mirror_U8_C1R.c",
    "ip/bm/src/omxIPBM_MulC_U8_C1R_Sfs.c",
    "ip/cs/src/omxIPCS_ColorTwistQ14_U8_C3R.c",
    "ip/cs/src/omxIPCS_RGB565ToYCbCr420LS_MCU_U16_S16_C3P3R.c",
    "ip/cs/src/omxIPCS_RGB565ToYCbCr422LS_MCU_U16_S16_C3P3R.c",
    "ip/cs/src/omxIPCS_RGB565ToYCbCr444LS_MCU_U16_S16_C3P3R.c",
    "ip/cs/src/omxIPCS_RGB888ToYCbCr420LS_MCU_U8_S16_C3P3R.c",
    "ip/cs/src/omxIPCS_RGB888ToYCbCr422LS_MCU_U8_S16_C3P3R.c",
    "ip/cs/src/omxIPCS_RGB888ToYCbCr444LS_MCU_U8_S16_C3P3R.c",
    "ip/cs/src/omxIPCS_YCbCr420RszCscRotRGB_U8_P3C3R.c",
    "ip/cs/src/omxIPCS_YCbCr420RszRot_U8_P3R.c",
    "ip/cs/src/omxIPCS_YCbCr420ToRGB565_U8_U16_P3C3R.c",
    "ip/cs/src/omxIPCS_YCbCr420ToRGB565LS_MCU_S16_U16_P3C3R.c",
    "ip/cs/src/omxIPCS_YCbCr420ToRGB888LS_MCU_S16_U8_P3C3R.c",
    "ip/cs/src/omxIPCS_YCbCr422RszCscRotRGB_U8_P3C3R.c",
    "ip/cs/src/omxIPCS_YCbCr422RszCscRotRGB_U8_U16_C2R.c",
    "ip/cs/src/omxIPCS_YCbCr422RszRot_U8_P3R.c",
    "ip/cs/src/omxIPCS_YCbCr422ToRGB565_U8_U16_C2C3R.c",
    "ip/cs/src/omxIPCS_YCbCr422ToRGB565LS_MCU_S16_U16_P3C3R.c",
    "ip/cs/src/omxIPCS_YCbCr422ToRGB888_U8_C2C3R.c",
    "ip/cs/src/omxIPCS_YCbCr422ToRGB888LS_MCU_S16_U8_P3C3R.c",
    "ip/cs/src/omxIPCS_YCbCr422ToYCbCr420Rotate_U8_C2P3R.c",
    "ip/cs/src/omxIPCS_YCbCr422ToYCbCr420Rotate_U8_P3R.c",
    "ip/cs/src/omxIPCS_YCbCr444ToRGB565_U8_U16_C3R.c",
    "ip/cs/src/omxIPCS_YCbCr444ToRGB565_U8_U16_P3C3R.c",
    "ip/cs/src/omxIPCS_YCbCr444ToRGB565LS_MCU_S16_U16_P3C3R.c",
    "ip/cs/src/omxIPCS_YCbCr444ToRGB888_U8_C3R.c",
    "ip/cs/src/omxIPCS_YCbCr444ToRGB888LS_MCU_S16_U8_P3C3R.c",
    "ip/pp/src/armIPPP_DeblockEdge.c",
    "ip/pp/src/armIPPP_strengthTable.c",
    "ip/pp/src/omxIPPP_Deblock_HorEdge_U8_I.c",
    "ip/pp/src/omxIPPP_Deblock_VerEdge_U8_I.c",
    "ip/pp/src/omxIPPP_FilterFIR_U8_C1R.c",
    "ip/pp/src/omxIPPP_FilterMedian_U8_C1R.c",
    "ip/pp/src/omxIPPP_GetCentralMoment_S64.c",
    "ip/pp/src/omxIPPP_GetSpatialMoment_S64.c",
    "ip/pp/src/omxIPPP_MomentGetStateSize.c",
    "ip/pp/src/omxIPPP_MomentInit.c",
    "ip/pp/src/omxIPPP_Moments_U8_C1R.c",
    "ip/pp/src/omxIPPP_Moments_U8_C3R.c"
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
$command = $LIB.' '.$LIB_OPTS.' lib/omxIP'.$LIB_TYPE.' '.$objlist;
print "$command\n";
system($command);







