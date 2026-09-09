#!/usr/bin/perl
#
# $Copyright$
#
# This file builds the OpenMAX DL Image Codecs domain library omxIC.
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
    "ic/api"
);

# Define the list of C source files to compile.
@filelist = (
    "./src/armCOMM_Bitstream.c",
    "./src/armCOMM.c",
    "ic/jp/src/armICJP_CosTable.c",
    "ic/jp/src/armICJP_DCTQuantFwd_S16.c",
    "ic/jp/src/armICJP_DCTQuantInv_S16.c",
    "ic/jp/src/armICJP_GenerateTable.c",
    "ic/jp/src/armICJP_HuffmanCategoryTable.c",
    "ic/jp/src/armICJP_QuantTable.c",
    "ic/jp/src/armICJP_ZigZagTable.c",
    "ic/jp/src/omxICJP_CopyExpand_U8_C3.c",
    "ic/jp/src/omxICJP_DCTFwd_S16_I.c",
    "ic/jp/src/omxICJP_DCTFwd_S16.c",
    "ic/jp/src/omxICJP_DCTInv_S16_I.c",
    "ic/jp/src/omxICJP_DCTInv_S16.c",
    "ic/jp/src/omxICJP_DCTQuantFwd_Multiple_S16.c",
    "ic/jp/src/omxICJP_DCTQuantFwd_S16_I.c",
    "ic/jp/src/omxICJP_DCTQuantFwd_S16.c",
    "ic/jp/src/omxICJP_DCTQuantFwdTableInit.c",
    "ic/jp/src/omxICJP_DCTQuantInv_Multiple_S16.c",
    "ic/jp/src/omxICJP_DCTQuantInv_S16_I.c",
    "ic/jp/src/omxICJP_DCTQuantInv_S16.c",
    "ic/jp/src/omxICJP_DCTQuantInvTableInit.c",
    "ic/jp/src/omxICJP_DecodeHuffman8x8_Direct_S16_C1.c",
    "ic/jp/src/omxICJP_DecodeHuffmanSpecGetBufSize_U8.c",
    "ic/jp/src/omxICJP_DecodeHuffmanSpecInit_U8.c",
    "ic/jp/src/omxICJP_EncodeHuffman8x8_Direct_S16_U1_C1.c",
    "ic/jp/src/omxICJP_EncodeHuffmanSpecGetBufSize_U8.c",
    "ic/jp/src/omxICJP_EncodeHuffmanSpecInit_U8.c"
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
$command = $LIB.' '.$LIB_OPTS.' lib/omxIC'.$LIB_TYPE.' '.$objlist;
print "$command\n";
system($command);







