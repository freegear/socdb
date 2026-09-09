
`include "../Rtl/DM/DmPara.v"

task LcdRegSet;
begin

	// Cursor Palette Memory
	for(i=0;i<=255;i=i+1) begin
	CPalMemData = i;	// Should be Replaced
	APBWrite(2'b10, CPALM, {4{CPalMemData}});
	end
	
	for(i=0;i<=255;i=i+1) begin
	CPalMemData = i;
	APBRead(2'b10, CPALM);
	end

	// Graphic Palette Memory
	for(i=0;i<=255;i=i+1) begin
	GPalMemData = i;	// Should be Replaced
	APBWrite(2'b10, GPALM, {4{GPalMemData}});
	end
	
	for(i=0;i<=255;i=i+1) begin
	GPalMemData = i;
	APBRead(2'b10, GPALM);
	end

	// LCD Master Control
	APBWrite(2'b10, DMCON, {PrioritySel, ErrIntEn, IntEn, 1'b0});
	APBWrite(2'b10, BGCOL, BPlaneDataIn);

	// Cursor Plane
	APBWrite(2'b10, CCON,  {CPlaneEn, 2'b0, CPlanePixFormat, 6'b0, CPlaneXSize, 1'b0, CPlaneYSize});
	APBWrite(2'b10, CBLND, {CPlaneAlphaValue, CPlaneChromaKey});
	APBWrite(2'b10, CBMOD, {1'b0, CPlaneChromaKeyEn, 1'b0, CPlaneAlphaMode, 5'b0, CPlaneXPos, CPlaneYPos});
	APBWrite(2'b10, CBASE, {CPlaneXRef});
	APBWrite(2'b10, CADDR, {CPlaneStartAddr});
	APBWrite(2'b10, CADDR2,{CPlaneStartAddr2});
	APBWrite(2'b10, CBLINK,{CPlaneAddrSwEn, 25'b0, CPlaneAddrSwVal});

	// Graphic Plane
	APBWrite(2'b10, GCON,  {GPlaneEn, 1'b0, GPlanePixFormat, GPlaneGammaEn, 4'b0, GPlaneXSize, GPlaneYSize});
	APBWrite(2'b10, GBLND, {GPlaneAlphaValue, GPlaneChromaKey});
	APBWrite(2'b10, GBMOD, {1'b0, GPlaneChromaKeyEn, 1'b0, GPlaneAlphaMode, 5'b0, GPlaneXPos, GPlaneYPos});
	APBWrite(2'b10, GBASE, {GPlaneXRef});
	APBWrite(2'b10, GADDR, {GPlaneStartAddr});

	// Video Plane
	APBWrite(2'b10, VCON,  {VPlaneEn, VPlaneInterlaceEn, VPlaneN2PUpEn, VPlanePixFormat, VPlaneGammaEn, 4'b0, VPlaneXSize, VPlaneYSize});
	APBWrite(2'b10, VBLND, {VPlaneAlphaValue, VPlaneChromaKey});
	APBWrite(2'b10, VBMOD, {1'b0, VPlaneChromaKeyEn, 1'b0, VPlaneAlphaMode, 5'b0, VPlaneXPos, VPlaneYPos});
	APBWrite(2'b10, VBASE, {VPlaneXRef});
	APBWrite(2'b10, VADDR, {VPlaneStartAddr});
	APBWrite(2'b10, VADDR2, VPlaneStartAddr2);

	// Scaler
  	APBWrite(2'b10, SCON,   {UpScaleEn, PreFilterEn, 29'b0, DnScaleEn});
  	APBWrite(2'b10, SSIZE,  {10'b0, ScaleInXSize, ScaleInYSize});
  	APBWrite(2'b10, SRATIO, {ScaleXRatio, ScaleYRatio});

	// LCD Timing
	APBWrite(2'b10, HSYNC0, {16'b0, LCDHBP, LCDHFP});
	APBWrite(2'b10, HSYNC1, {LCDHSW, LCDCPL});
	APBWrite(2'b10, VSYNC0, {16'b0, LCDVBP, LCDVFP});
	APBWrite(2'b10, VSYNC1, {LCDVSW, LCDLPS});
//	APBWrite(2'b10, VIDCON, {VideoSyncEn, VideoBP, 18'b0, VideoBPWait});
	APBWrite(2'b10, LCDCON,   {LCDEn, LCDPwrEn, 20'b0, LCDBPP, LCDBGR, LCDIEO, LCDIVS, LCDIHS, 4'b0});

	// Graphic Gamma
	APBWrite(2'b10, GGAMMA00, GPlaneGamma00);
	APBWrite(2'b10, GGAMMA01, GPlaneGamma01);
	APBWrite(2'b10, GGAMMA02, GPlaneGamma02);
	APBWrite(2'b10, GGAMMA03, GPlaneGamma03);
	APBWrite(2'b10, GGAMMA04, GPlaneGamma04);
	APBWrite(2'b10, GGAMMA05, GPlaneGamma05);
	APBWrite(2'b10, GGAMMA06, GPlaneGamma06);
	APBWrite(2'b10, GGAMMA07, GPlaneGamma07);
	APBWrite(2'b10, GGAMMA08, GPlaneGamma08);
	APBWrite(2'b10, GGAMMA09, GPlaneGamma09);
	APBWrite(2'b10, GGAMMA0A, GPlaneGamma0A);
	APBWrite(2'b10, GGAMMA0B, GPlaneGamma0B);
	APBWrite(2'b10, GGAMMA0C, GPlaneGamma0C);
	APBWrite(2'b10, GGAMMA0D, GPlaneGamma0D);
	APBWrite(2'b10, GGAMMA0E, GPlaneGamma0E);
	APBWrite(2'b10, GGAMMA0F, GPlaneGamma0F);
	APBWrite(2'b10, GGAMMA10, GPlaneGamma10);

	// Video Gamma
	APBWrite(2'b10, VGAMMA00, VPlaneGamma00);
	APBWrite(2'b10, VGAMMA01, VPlaneGamma01);
	APBWrite(2'b10, VGAMMA02, VPlaneGamma02);
	APBWrite(2'b10, VGAMMA03, VPlaneGamma03);
	APBWrite(2'b10, VGAMMA04, VPlaneGamma04);
	APBWrite(2'b10, VGAMMA05, VPlaneGamma05);
	APBWrite(2'b10, VGAMMA06, VPlaneGamma06);
	APBWrite(2'b10, VGAMMA07, VPlaneGamma07);
	APBWrite(2'b10, VGAMMA08, VPlaneGamma08);
	APBWrite(2'b10, VGAMMA09, VPlaneGamma09);
	APBWrite(2'b10, VGAMMA0A, VPlaneGamma0A);
	APBWrite(2'b10, VGAMMA0B, VPlaneGamma0B);
	APBWrite(2'b10, VGAMMA0C, VPlaneGamma0C);
	APBWrite(2'b10, VGAMMA0D, VPlaneGamma0D);
	APBWrite(2'b10, VGAMMA0E, VPlaneGamma0E);
	APBWrite(2'b10, VGAMMA0F, VPlaneGamma0F);
	APBWrite(2'b10, VGAMMA10, VPlaneGamma10);
end
endtask