#!/usr/bin/perl
#
# $Copyright$
#
# This file builds the OpenMAX DL Audio Codecs domain library omxAC.
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
    "ac/api",
    "ac/aac/api",
    "ac/mp3/api"
);

# Define the list of C source files to compile.
@filelist = (
    "./src/armCOMM_Bitstream.c",
    "./src/armCOMM.c",
    "ac/aac/src/armACAAC_CodeBook.c",
    "ac/aac/src/armACAAC_DecodeIcsInfoData.c",
    "ac/aac/src/armACAAC_DecodeLtpData.c",
    "ac/aac/src/armACAAC_IMDCTWindow.c",
    "ac/aac/src/armACAAC_LtpTable.c",
    "ac/aac/src/armACAAC_MaxBands.c",
    "ac/aac/src/armACAAC_OffsetTable.c",
    "ac/aac/src/armACAAC_SineLookUp.c",
    "ac/aac/src/armACAAC_TnsDecodeCoef.c",
    "ac/aac/src/armACAAC_TnsFilter.c",
    "ac/aac/src/omxACAAC_DecodeChanPairElt.c",
    "ac/aac/src/omxACAAC_DecodeDatStrElt.c",
    "ac/aac/src/omxACAAC_DecodeFillElt.c",
    "ac/aac/src/omxACAAC_DecodeIsStereo_S32.c",
    "ac/aac/src/omxACAAC_DecodeMsPNS_S32.c",
    "ac/aac/src/omxACAAC_DecodeMsStereo_S32_I.c",
    "ac/aac/src/omxACAAC_DecodePrgCfgElt.c",
    "ac/aac/src/omxACAAC_DecodeTNS_S32_I.c",
    "ac/aac/src/omxACAAC_DeinterleaveSpectrum_S32.c",
    "ac/aac/src/omxACAAC_EncodeTNS_S32_I.c",
    "ac/aac/src/omxACAAC_LongTermPredict_S32.c",
    "ac/aac/src/omxACAAC_LongTermReconstruct_S32.c",
    "ac/aac/src/omxACAAC_MDCTFwd_S32.c",
    "ac/aac/src/omxACAAC_MDCTInv_S32_S16.c",
    "ac/aac/src/omxACAAC_NoiselessDecode.c",
    "ac/aac/src/omxACAAC_QuantInv_S32_I.c",
    "ac/aac/src/omxACAAC_UnpackADIFHeader.c",
    "ac/aac/src/omxACAAC_UnpackADTSFrameHeader.c",
    "ac/mp3/src/armACMP3_Tables.c",
    "ac/mp3/src/omxACMP3_HuffmanDecode_S32.c",
    "ac/mp3/src/omxACMP3_HuffmanDecodeSfb_S32.c",
    "ac/mp3/src/omxACMP3_HuffmanDecodeSfbMbp_S32.c",
    "ac/mp3/src/omxACMP3_MDCTInv_S32.c",
    "ac/mp3/src/omxACMP3_ReQuantize_S32_I.c",
    "ac/mp3/src/omxACMP3_ReQuantizeSfb_S32_I.c",
    "ac/mp3/src/omxACMP3_SynthPQMF_S32_S16.c",
    "ac/mp3/src/omxACMP3_UnpackFrameHeader.c",
    "ac/mp3/src/omxACMP3_UnpackScaleFactors_S8.c",
    "ac/mp3/src/omxACMP3_UnpackSideInfo.c"
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
$command = $LIB.' '.$LIB_OPTS.' lib/omxAC'.$LIB_TYPE.' '.$objlist;
print "$command\n";
system($command);







