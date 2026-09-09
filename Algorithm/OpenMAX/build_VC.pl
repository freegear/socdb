#!/usr/bin/perl
#
# $Copyright$
#
# This file builds the OpenMAX DL Video Codecs domain library omxVC.
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
    "vc/api",
    "vc/m4p2/api",
    "vc/m4p10/api"
);

# Define the list of C source files to compile.
@filelist = (
    "./src/armCOMM_Bitstream.c",
    "./src/armCOMM.c",
    "vc/m4p2/src/armVCM4P2_ACDCPredict.c",
    "vc/m4p2/src/armVCM4P2_BlockMatch_Half.c",
    "vc/m4p2/src/armVCM4P2_BlockMatch_Integer.c",
    "vc/m4p2/src/armVCM4P2_CheckVLCEscapeMode.c",
    "vc/m4p2/src/armVCM4P2_CompareMV.c",
    "vc/m4p2/src/armVCM4P2_DCT_Table.c",
    "vc/m4p2/src/armVCM4P2_DecodeVLCZigzag_intra.c",
    "vc/m4p2/src/armVCM4P2_EncodeVLCZigzag_intra.c",
    "vc/m4p2/src/armVCM4P2_FillVLCBuffer.c",
    "vc/m4p2/src/armVCM4P2_FillVLDBuffer.c",
    "vc/m4p2/src/armVCM4P2_GetVLCBits.c",
    "vc/m4p2/src/armVCM4P2_Huff_Tables_VLC.c",
    "vc/m4p2/src/armVCM4P2_PutVLCBits.c",
    "vc/m4p2/src/armVCM4P2_SetPredDir.c",
    "vc/m4p2/src/armVCM4P2_Zigzag_Tables.c",
    "vc/m4p2/src/omxVCM4P2_BlockMatch_Half_16x16.c",
    "vc/m4p2/src/omxVCM4P2_BlockMatch_Half_8x8.c",
    "vc/m4p2/src/omxVCM4P2_BlockMatch_Integer_16x16.c",
    "vc/m4p2/src/omxVCM4P2_BlockMatch_Integer_8x8.c",
    "vc/m4p2/src/omxVCM4P2_DCT8x8blk.c",
    "vc/m4p2/src/omxVCM4P2_DecodeBlockCoef_Inter.c",
    "vc/m4p2/src/omxVCM4P2_DecodeBlockCoef_Intra.c",
    "vc/m4p2/src/omxVCM4P2_DecodePadMV_PVOP.c",
    "vc/m4p2/src/omxVCM4P2_DecodeVLCZigzag_Inter.c",
    "vc/m4p2/src/omxVCM4P2_DecodeVLCZigzag_IntraACVLC.c",
    "vc/m4p2/src/omxVCM4P2_DecodeVLCZigzag_IntraDCVLC.c",
    "vc/m4p2/src/omxVCM4P2_EncodeMV.c",
    "vc/m4p2/src/omxVCM4P2_EncodeVLCZigzag_Inter.c",
    "vc/m4p2/src/omxVCM4P2_EncodeVLCZigzag_IntraACVLC.c",
    "vc/m4p2/src/omxVCM4P2_EncodeVLCZigzag_IntraDCVLC.c",
    "vc/m4p2/src/omxVCM4P2_FindMVpred.c",
    "vc/m4p2/src/omxVCM4P2_IDCT8x8blk.c",
    "vc/m4p2/src/omxVCM4P2_MCReconBlock.c",
    "vc/m4p2/src/omxVCM4P2_MEGetBufSize.c",
    "vc/m4p2/src/omxVCM4P2_MEInit.c",
    "vc/m4p2/src/omxVCM4P2_MotionEstimationMB.c",
    "vc/m4p2/src/omxVCM4P2_PredictReconCoefIntra.c",
    "vc/m4p2/src/omxVCM4P2_QuantInter_I.c",
    "vc/m4p2/src/omxVCM4P2_QuantIntra_I.c",
    "vc/m4p2/src/omxVCM4P2_QuantInvInter_I.c",
    "vc/m4p2/src/omxVCM4P2_QuantInvIntra_I.c",
    "vc/m4p2/src/omxVCM4P2_TransRecBlockCoef_inter.c",
    "vc/m4p2/src/omxVCM4P2_TransRecBlockCoef_intra.c",
    "vc/m4p10/src/armVCM4P10_CAVLCTables.c",
    "vc/m4p10/src/armVCM4P10_CompareMotionCostToMV.c",
    "vc/m4p10/src/armVCM4P10_DeBlockPixel.c",
    "vc/m4p10/src/armVCM4P10_DecodeCoeffsToPair.c",
    "vc/m4p10/src/armVCM4P10_DequantTables.c",
    "vc/m4p10/src/armVCM4P10_FwdTransformResidual4x4.c",
    "vc/m4p10/src/armVCM4P10_Interpolate_Chroma.c",
    "vc/m4p10/src/armVCM4P10_Interpolate_Luma.c",
    "vc/m4p10/src/armVCM4P10_InterpolateHalfDiag_Luma.c",
    "vc/m4p10/src/armVCM4P10_InterpolateHalfHor_Luma.c",
    "vc/m4p10/src/armVCM4P10_InterpolateHalfVer_Luma.c",
    "vc/m4p10/src/armVCM4P10_PredictIntraDC4x4.c",
    "vc/m4p10/src/armVCM4P10_QuantTables.c",
    "vc/m4p10/src/armVCM4P10_SADQuar.c",
    "vc/m4p10/src/armVCM4P10_TransformResidual4x4.c",
    "vc/m4p10/src/armVCM4P10_UnpackBlock2x2.c",
    "vc/m4p10/src/armVCM4P10_UnpackBlock4x4.c",
    "vc/m4p10/src/omxVCM4P10_Average_4x.c",
    "vc/m4p10/src/omxVCM4P10_BlockMatch_Half.c",
    "vc/m4p10/src/omxVCM4P10_BlockMatch_Integer.c",
    "vc/m4p10/src/omxVCM4P10_BlockMatch_Quarter.c",
    "vc/m4p10/src/omxVCM4P10_DeblockChroma_I.c",
    "vc/m4p10/src/omxVCM4P10_DeblockLuma_I.c",
    "vc/m4p10/src/omxVCM4P10_DecodeChromaDcCoeffsToPairCAVLC.c",
    "vc/m4p10/src/omxVCM4P10_DecodeCoeffsToPairCAVLC.c",
    "vc/m4p10/src/omxVCM4P10_DequantTransformResidualFromPairAndAdd.c",
    "vc/m4p10/src/omxVCM4P10_FilterDeblockingChroma_HorEdge_I.c",
    "vc/m4p10/src/omxVCM4P10_FilterDeblockingChroma_VerEdge_I.c",
    "vc/m4p10/src/omxVCM4P10_FilterDeblockingLuma_HorEdge_I.c",
    "vc/m4p10/src/omxVCM4P10_FilterDeblockingLuma_VerEdge_I.c",
    "vc/m4p10/src/omxVCM4P10_GetVlcInfo.c",
    "vc/m4p10/src/omxVCM4P10_InterpolateChroma.c",
    "vc/m4p10/src/omxVCM4P10_InterpolateHalfHor_Luma.c",
    "vc/m4p10/src/omxVCM4P10_InterpolateHalfVer_Luma.c",
    "vc/m4p10/src/omxVCM4P10_InterpolateLuma.c",
    "vc/m4p10/src/omxVCM4P10_InvTransformDequant_ChromaDC.c",
    "vc/m4p10/src/omxVCM4P10_InvTransformDequant_LumaDC.c",
    "vc/m4p10/src/omxVCM4P10_InvTransformResidualAndAdd.c",
    "vc/m4p10/src/omxVCM4P10_MEGetBufSize.c",
    "vc/m4p10/src/omxVCM4P10_MEInit.c",
    "vc/m4p10/src/omxVCM4P10_MotionEstimationMB.c",
    "vc/m4p10/src/omxVCM4P10_PredictIntra_16x16.c",
    "vc/m4p10/src/omxVCM4P10_PredictIntra_4x4.c",
    "vc/m4p10/src/omxVCM4P10_PredictIntraChroma8x8.c",
    "vc/m4p10/src/omxVCM4P10_SAD_4x.c",
    "vc/m4p10/src/omxVCM4P10_SADQuar_16x.c",
    "vc/m4p10/src/omxVCM4P10_SADQuar_4x.c",
    "vc/m4p10/src/omxVCM4P10_SADQuar_8x.c",
    "vc/m4p10/src/omxVCM4P10_SATD_4x4.c",
    "vc/m4p10/src/omxVCM4P10_SubAndTransformQDQResidual.c",
    "vc/m4p10/src/omxVCM4P10_TransformDequantChromaDCFromPair.c",
    "vc/m4p10/src/omxVCM4P10_TransformDequantLumaDCFromPair.c",
    "vc/m4p10/src/omxVCM4P10_TransformQuant_ChromaDC.c",
    "vc/m4p10/src/omxVCM4P10_TransformQuant_LumaDC.c",
    "vc/comm/src/armVCCOMM_Average.c",
    "vc/comm/src/armVCCOMM_SAD.c",
    "vc/comm/src/omxVCCOMM_Average_16x.c",
    "vc/comm/src/omxVCCOMM_Average_8x.c",
    "vc/comm/src/omxVCCOMM_ComputeTextureErrorBlock.c",
    "vc/comm/src/omxVCCOMM_ComputeTextureErrorBlock_SAD.c",
    "vc/comm/src/omxVCCOMM_Copy16x16.c",
    "vc/comm/src/omxVCCOMM_Copy8x8.c",
    "vc/comm/src/omxVCCOMM_ExpandFrame.c",
    "vc/comm/src/omxVCCOMM_LimitMVToRect.c",
    "vc/comm/src/omxVCCOMM_SAD_16x.c",
    "vc/comm/src/omxVCCOMM_SAD_8x.c"
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
$command = $LIB.' '.$LIB_OPTS.' lib/omxVC'.$LIB_TYPE.' '.$objlist;
print "$command\n";
system($command);







