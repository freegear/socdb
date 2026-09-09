/*********************************************************************
*
*   This confidential and proprietary software may be used only as
*   authorised by a licensing agreement from CORERIVER Semiconductor
* 	Co., Ltd.
*
*   (c) Copyright 2006 CORERIVER Semiconductor Co., Ltd.
*     All Rights Reserved
*
*   The entire notice above must be reproduced on all authorised
*   copies and copies may only be made to the extent permitted
*   by a licensing agreement from CORERIVER Semiconductor Co., Ltd.
*
* -------------------------------------------------------------------
*
*   FILE             : sound_test.c
*   AUTHOR           : CORERIVER
*   DESCRIPTION      : Sound Engine Test
*   VERSION          : $Revision: $ ($Date: $)
*   COMMENT          :
*
*********************************************************************/

#include "grim5k.h"

int int_num;

void __irq your_irq (void)
{
	mem(SECON_) &= 0x005F;					// clear interrupt
	mem(IRQMASKCLR_) = 0x00001000;	// interrupt disable 
	while (mem(IRQMASK_) != 0x00000000);
	mem(GPIO_OUT1_) = mem(GPIO_OUT1_) + 0x1;
}

void __irq your_fiq (void)
{
}

#define SEIPBase_			0xFFE02000

void init_pll (void);

int your_test (void)
{
	int k;
	int addr;
	int l;

	init_pll();

	mem(GPIO_AUX1_) |= 0x00000060; 	// for WROM_nWEN, WROM_nOEN
	mem(GPIO_OE1_) |= 0x00000060; 	// for WROM_nWEN, WROM_nOEN

	addr = 0xFFE01504;
	write(addr, 0x00000000);
	write(addr, 0xCCCC3333);
	write(addr, 0x66669999);
	write(addr, 0xFFFF0000);

	l = 0;
	write(SECON_, 0x0001);		// reset SE                                       

	write_half(SEIPBase_ +0x000, 0x0040);                                       
	write_half(SEIPBase_ +0x100, 0x0847);
	write_half(SEIPBase_ +0x101, 0x0800);
	write_half(SEIPBase_ +0x102, 0x0860);
	write_half(SEIPBase_ +0x103, 0x0944);
	write_half(SEIPBase_ +0x104, 0x0D65);
	write_half(SEIPBase_ +0x105, 0x1257);
	write_half(SEIPBase_ +0x106, 0x1911);
	write_half(SEIPBase_ +0x107, 0x2531);
	write_half(SEIPBase_ +0x108, 0x1E77);
	write_half(SEIPBase_ +0x109, 0x2D3D);
	write_half(SEIPBase_ +0x10A, 0x3039);
	write_half(SEIPBase_ +0x10B, 0x3C50);
	write_half(SEIPBase_ +0x10C, 0x2861);
	write_half(SEIPBase_ +0x10D, 0x302D);
write_half(SEIPBase_ +0x10E, 0x3C32);
write_half(SEIPBase_ +0x10F, 0x3F04);
write_half(SEIPBase_ +0x110, 0x3380);
write_half(SEIPBase_ +0x111, 0x304B);
write_half(SEIPBase_ +0x112, 0x204C);
write_half(SEIPBase_ +0x113, 0x2315);
write_half(SEIPBase_ +0x114, 0x3018);
write_half(SEIPBase_ +0x115, 0x234A);
write_half(SEIPBase_ +0x116, 0x2445);
write_half(SEIPBase_ +0x117, 0x3B5C);
write_half(SEIPBase_ +0x118, 0x321D);
write_half(SEIPBase_ +0x119, 0x3F7F);
write_half(SEIPBase_ +0x11A, 0x0D8E);
write_half(SEIPBase_ +0x11B, 0x2ADD);
write_half(SEIPBase_ +0x11C, 0x145A);
write_half(SEIPBase_ +0x11D, 0x22DD);
write_half(SEIPBase_ +0x11E, 0x2DCC);
write_half(SEIPBase_ +0x11F, 0x35D3);
write_half(SEIPBase_ +0x120, 0x0000);
write_half(SEIPBase_ +0x121, 0x1111);
write_half(SEIPBase_ +0x122, 0x2222);
write_half(SEIPBase_ +0x123, 0x3333);
write_half(SEIPBase_ +0x124, 0x4444);
write_half(SEIPBase_ +0x125, 0x5555);
write_half(SEIPBase_ +0x126, 0x6666);
write_half(SEIPBase_ +0x127, 0x7777);
write_half(SEIPBase_ +0x128, 0x8888);
write_half(SEIPBase_ +0x129, 0x9999);
write_half(SEIPBase_ +0x12A, 0xAAAA);
write_half(SEIPBase_ +0x12B, 0xBBBB);
write_half(SEIPBase_ +0x12C, 0xCCCC);
write_half(SEIPBase_ +0x12D, 0xDDDD);
write_half(SEIPBase_ +0x12E, 0xEEEE);
write_half(SEIPBase_ +0x12F, 0xFFFF);
write_half(SEIPBase_ +0x130, 0x0000);
write_half(SEIPBase_ +0x131, 0x0000);
write_half(SEIPBase_ +0x132, 0x0000);
write_half(SEIPBase_ +0x133, 0x0000);
write_half(SEIPBase_ +0x134, 0x0000);
write_half(SEIPBase_ +0x135, 0x0000);
write_half(SEIPBase_ +0x136, 0x0000);
write_half(SEIPBase_ +0x137, 0x0000);
write_half(SEIPBase_ +0x138, 0x0000);
write_half(SEIPBase_ +0x139, 0x0000);
write_half(SEIPBase_ +0x13A, 0x0000);
write_half(SEIPBase_ +0x13B, 0x0000);
write_half(SEIPBase_ +0x13C, 0x0000);
write_half(SEIPBase_ +0x13D, 0x0000);
write_half(SEIPBase_ +0X13E, 0x0000);
write_half(SEIPBase_ +0X13F, 0x0000);
write_half(SEIPBase_ +0x140, 0x4621);
write_half(SEIPBase_ +0x141, 0x404D);
write_half(SEIPBase_ +0x142, 0x42D4);
write_half(SEIPBase_ +0x143, 0x5648);
write_half(SEIPBase_ +0x144, 0x54AE);
write_half(SEIPBase_ +0x145, 0x5E79);
write_half(SEIPBase_ +0X146, 0x6D60);
write_half(SEIPBase_ +0x147, 0x6B4C);
write_half(SEIPBase_ +0x148, 0x6C4A);
write_half(SEIPBase_ +0x149, 0x6ADB);
write_half(SEIPBase_ +0x14A, 0x5EB7);
write_half(SEIPBase_ +0x14B, 0x4360);
write_half(SEIPBase_ +0x14C, 0x4C3D);
write_half(SEIPBase_ +0x14D, 0x7371);
write_half(SEIPBase_ +0x14E, 0x6406);
write_half(SEIPBase_ +0x14F, 0x73AD);
write_half(SEIPBase_ +0x150, 0x4065);
write_half(SEIPBase_ +0x151, 0x41BD);
write_half(SEIPBase_ +0x152, 0x446F);
write_half(SEIPBase_ +0x153, 0x5040);
write_half(SEIPBase_ +0x154, 0x5F5A);
write_half(SEIPBase_ +0x155, 0x6A2B);
write_half(SEIPBase_ +0x156, 0x51FF);
write_half(SEIPBase_ +0x157, 0x4A21);
write_half(SEIPBase_ +0x158, 0x734A);
write_half(SEIPBase_ +0x159, 0x51D3);
write_half(SEIPBase_ +0x15A, 0x6F56);
write_half(SEIPBase_ +0x15B, 0x6E42);
write_half(SEIPBase_ +0x15C, 0x4CEA);
write_half(SEIPBase_ +0x15D, 0x5EDD);
write_half(SEIPBase_ +0x15E, 0x74D2);
write_half(SEIPBase_ +0x15F, 0x7711);
write_half(SEIPBase_ +0x160, 0x0000);
write_half(SEIPBase_ +0x161, 0x0000);
write_half(SEIPBase_ +0x162, 0x0000);
write_half(SEIPBase_ +0x163, 0x0000);
write_half(SEIPBase_ +0x164, 0x0000);
write_half(SEIPBase_ +0x165, 0x0000);
write_half(SEIPBase_ +0x166, 0x0000);
write_half(SEIPBase_ +0x167, 0x0000);
write_half(SEIPBase_ +0x168, 0x0000);
write_half(SEIPBase_ +0x169, 0x0000);
write_half(SEIPBase_ +0x16A, 0x0000);
write_half(SEIPBase_ +0x16B, 0x0000);
write_half(SEIPBase_ +0x16C, 0x0000);
write_half(SEIPBase_ +0x16D, 0x0000);
write_half(SEIPBase_ +0x16E, 0x0000);
write_half(SEIPBase_ +0x16F, 0x0000);
write_half(SEIPBase_ +0x170, 0x0000);
write_half(SEIPBase_ +0x171, 0x0000);
write_half(SEIPBase_ +0x172, 0x0000);
write_half(SEIPBase_ +0x173, 0x0000);
write_half(SEIPBase_ +0x174, 0x0000);
write_half(SEIPBase_ +0x175, 0x0000);
write_half(SEIPBase_ +0x176, 0x0000);
write_half(SEIPBase_ +0x177, 0x0000);
write_half(SEIPBase_ +0x178, 0x0000);
write_half(SEIPBase_ +0x179, 0x0000);
write_half(SEIPBase_ +0x17A, 0x0000);
write_half(SEIPBase_ +0x17B, 0x0000);
write_half(SEIPBase_ +0x17C, 0x0000);
write_half(SEIPBase_ +0x17D, 0x0000);
write_half(SEIPBase_ +0x17E, 0x0000);
write_half(SEIPBase_ +0x17F, 0x0000);
write_half(SEIPBase_ +0x180, 0x4436);
write_half(SEIPBase_ +0x181, 0x3847);
write_half(SEIPBase_ +0x182, 0x3531);
write_half(SEIPBase_ +0x183, 0xF344);
write_half(SEIPBase_ +0x184, 0x155E);
write_half(SEIPBase_ +0x185, 0x2436);
write_half(SEIPBase_ +0x186, 0x443F);
write_half(SEIPBase_ +0x187, 0x005F);
write_half(SEIPBase_ +0x188, 0x0043);
write_half(SEIPBase_ +0x189, 0x005D);
write_half(SEIPBase_ +0x18A, 0x207B);
write_half(SEIPBase_ +0x18B, 0x3D40);
write_half(SEIPBase_ +0x18C, 0x144F);
write_half(SEIPBase_ +0x18D, 0x6D13);
write_half(SEIPBase_ +0x18E, 0x225F);
write_half(SEIPBase_ +0x18F, 0x3F44);
write_half(SEIPBase_ +0x190, 0x0034);
write_half(SEIPBase_ +0x191, 0x6000);
write_half(SEIPBase_ +0x192, 0x0100);
write_half(SEIPBase_ +0x193, 0x5001);
write_half(SEIPBase_ +0x194, 0x6A3B);
write_half(SEIPBase_ +0x195, 0x00D4);
write_half(SEIPBase_ +0x196, 0x3F5D);
write_half(SEIPBase_ +0x197, 0x0047);
write_half(SEIPBase_ +0x198, 0x6000);
write_half(SEIPBase_ +0x199, 0x4000);
write_half(SEIPBase_ +0x19A, 0x5A7F);
write_half(SEIPBase_ +0x19B, 0x2F50);
write_half(SEIPBase_ +0x19C, 0x336D);
write_half(SEIPBase_ +0x19D, 0x145D);
write_half(SEIPBase_ +0x19E, 0x3530);
write_half(SEIPBase_ +0x19F, 0x5A56);
write_half(SEIPBase_ +0x1A0, 0x844F);
write_half(SEIPBase_ +0x1A1, 0x4C6B);
write_half(SEIPBase_ +0x1A2, 0x3366);
write_half(SEIPBase_ +0x1A3, 0xD43C);
write_half(SEIPBase_ +0x1A4, 0xC53B);
write_half(SEIPBase_ +0x1A5, 0xAF35);
write_half(SEIPBase_ +0x1A6, 0x1F5A);
write_half(SEIPBase_ +0x1A7, 0x2B4D);
write_half(SEIPBase_ +0x1A8, 0x483D);
write_half(SEIPBase_ +0x1A9, 0x0354);
write_half(SEIPBase_ +0x1AA, 0x7A4C);
write_half(SEIPBase_ +0x1AB, 0x0000);
write_half(SEIPBase_ +0x1AC, 0x473F);
write_half(SEIPBase_ +0x1AD, 0x3351);
write_half(SEIPBase_ +0x1AE, 0x6D21);
write_half(SEIPBase_ +0x1AF, 0x3321);
write_half(SEIPBase_ +0x1B0, 0x4040);
write_half(SEIPBase_ +0x1B1, 0x3415);
write_half(SEIPBase_ +0x1B2, 0x673B);
write_half(SEIPBase_ +0x1B3, 0xD25A);
write_half(SEIPBase_ +0x1B4, 0x73A3);
write_half(SEIPBase_ +0x1B5, 0x345F);
write_half(SEIPBase_ +0x1B6, 0x1421);
write_half(SEIPBase_ +0x1B7, 0x4483);
write_half(SEIPBase_ +0x1B8, 0x0043);
write_half(SEIPBase_ +0x1B9, 0x0011);
write_half(SEIPBase_ +0x1BA, 0x002F);
write_half(SEIPBase_ +0x1BB, 0x0034);
write_half(SEIPBase_ +0x1BC, 0x003E);
write_half(SEIPBase_ +0x1BD, 0x00A4);
write_half(SEIPBase_ +0x1BE, 0x00F4);
write_half(SEIPBase_ +0x1BF, 0x004D);
write_half(SEIPBase_ +0x1C0, 0x0022);
write_half(SEIPBase_ +0x1C1, 0x5A2F);
write_half(SEIPBase_ +0x1C2, 0x0040);
write_half(SEIPBase_ +0x1C3, 0x0010);
write_half(SEIPBase_ +0x1C4, 0x0025);
write_half(SEIPBase_ +0x1C5, 0x004D);
write_half(SEIPBase_ +0x1C6, 0x006D);
write_half(SEIPBase_ +0x1C7, 0x574C);
write_half(SEIPBase_ +0x1C8, 0x0000);
write_half(SEIPBase_ +0x1C9, 0x0000);
write_half(SEIPBase_ +0x1CA, 0x0000);
write_half(SEIPBase_ +0x1CB, 0x0000);
write_half(SEIPBase_ +0x1CC, 0x0000);
write_half(SEIPBase_ +0x1CD, 0x0000);
write_half(SEIPBase_ +0x1CE, 0x0000);
write_half(SEIPBase_ +0x1CF, 0x0000);
write_half(SEIPBase_ +0x1D0, 0x0000);
write_half(SEIPBase_ +0x1D1, 0x0000);
write_half(SEIPBase_ +0x1D2, 0x0000);
write_half(SEIPBase_ +0x1D3, 0x0000);
write_half(SEIPBase_ +0x1D4, 0x0000);
write_half(SEIPBase_ +0x1D5, 0x0000);
write_half(SEIPBase_ +0x1D6, 0x0000);
write_half(SEIPBase_ +0x1D7, 0x0000);
write_half(SEIPBase_ +0x1D8, 0x0000);
write_half(SEIPBase_ +0x1D9, 0x0000);
write_half(SEIPBase_ +0x1DA, 0x0000);
write_half(SEIPBase_ +0x1DB, 0x0000);
write_half(SEIPBase_ +0x1DC, 0x0000);
write_half(SEIPBase_ +0x1DD, 0x0000);
write_half(SEIPBase_ +0x1DE, 0x0000);
write_half(SEIPBase_ +0x1DF, 0x0000);
write_half(SEIPBase_ +0x1E0, 0x024D);
write_half(SEIPBase_ +0x1E1, 0x024E);
write_half(SEIPBase_ +0x1E2, 0x01D4);
write_half(SEIPBase_ +0x1E3, 0x01D5);
write_half(SEIPBase_ +0x1E4, 0x0000);
write_half(SEIPBase_ +0x1E5, 0x05A7);
write_half(SEIPBase_ +0x1E6, 0x05A8);
write_half(SEIPBase_ +0x1E7, 0x024B);
write_half(SEIPBase_ +0x1E8, 0x024C);
write_half(SEIPBase_ +0x1E9, 0x4000);
write_half(SEIPBase_ +0x1EA, 0xAD4D);
write_half(SEIPBase_ +0x1EB, 0x8000);
write_half(SEIPBase_ +0x1EC, 0xCCC5);
write_half(SEIPBase_ +0x1ED, 0xBA32);
write_half(SEIPBase_ +0x1EE, 0x0000);
write_half(SEIPBase_ +0x1EF, 0x0000);
write_half(SEIPBase_ +0x1F0, 0x2A34);
write_half(SEIPBase_ +0x1F1, 0x1F40);
write_half(SEIPBase_ +0x1F2, 0xF4F6);
write_half(SEIPBase_ +0x1F3, 0xE670);
write_half(SEIPBase_ +0x1F4, 0x2B4A);
write_half(SEIPBase_ +0x1F5, 0x314D);
write_half(SEIPBase_ +0x1F6, 0x21DF);
write_half(SEIPBase_ +0x1F7, 0xC523);
write_half(SEIPBase_ +0x1F8, 0x3CA2);
write_half(SEIPBase_ +0x1F9, 0x1D44);
write_half(SEIPBase_ +0x1FA, 0x30D4);
write_half(SEIPBase_ +0x1FB, 0x11D4);
write_half(SEIPBase_ +0x1FC, 0x33AA);
write_half(SEIPBase_ +0x1FD, 0x2456);
write_half(SEIPBase_ +0x1FE, 0x0000);
write_half(SEIPBase_ +0x1FF, 0x0000);
write_half(SEIPBase_ +0x200, 0x0000);
write_half(SEIPBase_ +0x201, 0x0000);

// [PIA 0x202 to 0x21F   PIDI=0x0000]
	for (addr =  2; addr <= 0x1F; addr++) {
		write_half(SEIPBase_ +0x200 + addr, 0x0000);
	}


write_half(SEIPBase_ +0x220, 0x0010);
write_half(SEIPBase_ +0x221, 0x00B0);
write_half(SEIPBase_ +0x222, 0x0000);
write_half(SEIPBase_ +0x223, 0x0000);
write_half(SEIPBase_ +0x224, 0x001F);
write_half(SEIPBase_ +0x225, 0x000F);
//write_half(SEIPBase_ +0x226, 0xC8D0);
write_half(SEIPBase_ +0x226, 0x2340);
write_half(SEIPBase_ +0x227, 0x0000);

// [PIA 0x228 to 0x24F    PIDI = 0x0000]
	for (addr =  8; addr <= 0x2F; addr++) {
		write_half(SEIPBase_ +0x220 + addr, 0x0000);
	}
 
write_half(SEIPBase_ +0x250, 0x1100);
write_half(SEIPBase_ +0x251, 0x000E);
write_half(SEIPBase_ +0x252, 0x1000);
write_half(SEIPBase_ +0x253, 0x1000);
write_half(SEIPBase_ +0x254, 0x1111);
write_half(SEIPBase_ +0x255, 0x1000);
//write_half(SEIPBase_ +0x256, 0xDC3D);
write_half(SEIPBase_ +0x256, 0x70FD);
write_half(SEIPBase_ +0x257, 0x4000);

// [PIA 0x258 to 0x297     PIDI = 0x0000]
	for (addr =  8; addr <= 0x47; addr++) {
		write_half(SEIPBase_ +0x250 + addr, 0x0000);
	}


write_half(SEIPBase_ +0x298, 0x2218);
write_half(SEIPBase_ +0x299, 0x0008);
write_half(SEIPBase_ +0x29A, 0x2071);
write_half(SEIPBase_ +0x29B, 0x2000);
write_half(SEIPBase_ +0x29C, 0x2222);
write_half(SEIPBase_ +0x29D, 0x2100);
//write_half(SEIPBase_ +0x29E, 0xB62A);
write_half(SEIPBase_ +0x29E, 0x2C54);
write_half(SEIPBase_ +0x29F, 0x0000);

 //[PIA 0x2A0 to 0x2DF     PIDI = 0x0000]
	for (addr =  0; addr <= 0x3F; addr++) {
		write_half(SEIPBase_ +0x2A0 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x2E0, 0x3330);
write_half(SEIPBase_ +0x2E1, 0x000D);
write_half(SEIPBase_ +0x2E2, 0x30B0);
write_half(SEIPBase_ +0x2E3, 0x3000);
write_half(SEIPBase_ +0x2E4, 0x3333);
write_half(SEIPBase_ +0x2E5, 0x322A);
//write_half(SEIPBase_ +0x2E6, 0xE2EA);
write_half(SEIPBase_ +0x2E6, 0x1750);
write_half(SEIPBase_ +0x2E7, 0x0000);

 //[PIA 0x2E8 to 0x36F     PIDI = 0x0000]
	for (addr =  8; addr <= 0x8F; addr++) {
		write_half(SEIPBase_ +0x2E0 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x370, 0x5550);
write_half(SEIPBase_ +0x371, 0x0008);
write_half(SEIPBase_ +0x372, 0x5022);
write_half(SEIPBase_ +0x373, 0x5000);
write_half(SEIPBase_ +0x374, 0x5555);
write_half(SEIPBase_ +0x375, 0x51F2);
//write_half(SEIPBase_ +0x376, 0xDD32);
write_half(SEIPBase_ +0x376, 0x74C8);
write_half(SEIPBase_ +0x377, 0x0000);

 //[PIA 0x378 to 0x3A7     PIDI = 0x0000]
	for (addr =  8; addr <= 0x37; addr++) {
		write_half(SEIPBase_ +0x370 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x3A8, 0x6600);
write_half(SEIPBase_ +0x3A9, 0x004E);
write_half(SEIPBase_ +0x3AA, 0x6003);
write_half(SEIPBase_ +0x3AB, 0x6000);
write_half(SEIPBase_ +0x3AC, 0x6666);
write_half(SEIPBase_ +0x3AD, 0x65F0);
//write_half(SEIPBase_ +0x3AE, 0xF92D);
write_half(SEIPBase_ +0x3AE, 0x9C81);
write_half(SEIPBase_ +0x3AF, 0x0000);

 //[PIA 0x3B0 to 0x3F7     PIDI = 0x0000]
	for (addr =  0; addr <= 0x47; addr++) {
		write_half(SEIPBase_ +0x3B0 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x3F8, 0x7772);
write_half(SEIPBase_ +0x3F9, 0x000E);
write_half(SEIPBase_ +0x3FA, 0x7000);
write_half(SEIPBase_ +0x3FB, 0x7000);
write_half(SEIPBase_ +0x3FC, 0x7777);
write_half(SEIPBase_ +0x3FD, 0x7224);
//write_half(SEIPBase_ +0x3FE, 0x6D84);
write_half(SEIPBase_ +0x3FE, 0x06C2);
write_half(SEIPBase_ +0x3FF, 0x0000);

 //[PIA 0x400 to 0x41F    PIDI = 0x0000]
	for (addr =  0; addr <= 0x1F; addr++) {
		write_half(SEIPBase_ +0x400 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x420, 0x0000);
write_half(SEIPBase_ +0x421, 0x0000);
//write_half(SEIPBase_ +0x422, 0x0000);
write_half(SEIPBase_ +0x422, 0x0001);
write_half(SEIPBase_ +0x423, 0x06D0);
write_half(SEIPBase_ +0x424, 0x05D4);
write_half(SEIPBase_ +0x425, 0x07D8);
//write_half(SEIPBase_ +0x426, 0x007A);
write_half(SEIPBase_ +0x426, 0x2F58);
write_half(SEIPBase_ +0x427, 0x006D);

 //[PIA 0x428 to 0x44F     PIDI = 0x0000]
	for (addr =  8; addr <= 0x2F; addr++) {
		write_half(SEIPBase_ +0x420 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x450, 0x0000);
write_half(SEIPBase_ +0x451, 0x0000);
write_half(SEIPBase_ +0x452, 0x0000);
write_half(SEIPBase_ +0x453, 0x0400);
write_half(SEIPBase_ +0x454, 0x056C);
write_half(SEIPBase_ +0x455, 0x0068);
//write_half(SEIPBase_ +0x456, 0x0038);
write_half(SEIPBase_ +0x456, 0x0718);
write_half(SEIPBase_ +0x457, 0x0060);

 //[PIA 0x458 to 0x497     PIDI = 0x0000]
	for (addr =  8; addr <= 0x47; addr++) {
		write_half(SEIPBase_ +0x450 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x498, 0x0000);
write_half(SEIPBase_ +0x499, 0x0000);
write_half(SEIPBase_ +0x49A, 0x0000);
write_half(SEIPBase_ +0x49B, 0x06DF);
write_half(SEIPBase_ +0x49C, 0x06F2);
write_half(SEIPBase_ +0x49D, 0x0645);
//write_half(SEIPBase_ +0x49E, 0x7710);
write_half(SEIPBase_ +0x49E, 0x0B88);
write_half(SEIPBase_ +0x49F, 0x4032);

 //[PIA 0x4A0 to 0x4DF     PIDI = 0x0000]
	for (addr =  0; addr <= 0x3F; addr++) {
		write_half(SEIPBase_ +0x4A0 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x4E0, 0x0000);
write_half(SEIPBase_ +0x4E1, 0x0000);
//write_half(SEIPBase_ +0x4E2, 0x0000);
write_half(SEIPBase_ +0x4E2, 0x0003);
write_half(SEIPBase_ +0x4E3, 0x0645);
write_half(SEIPBase_ +0x4E4, 0x0645);
write_half(SEIPBase_ +0x4E5, 0x0773);
//write_half(SEIPBase_ +0x4E6, 0x6554);
write_half(SEIPBase_ +0x4E6, 0x2CCC);
write_half(SEIPBase_ +0x4E7, 0x0020);

 //[PIA 0x4E8 to 0x56F     PIDI = 0x0000]
	for (addr =  8; addr <= 0x8F; addr++) {
		write_half(SEIPBase_ +0x4E0 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x570, 0x0000);
write_half(SEIPBase_ +0x571, 0x0000);
write_half(SEIPBase_ +0x572, 0x0000);
write_half(SEIPBase_ +0x573, 0x0640);
write_half(SEIPBase_ +0x574, 0x05C6);
write_half(SEIPBase_ +0x575, 0x0432);
write_half(SEIPBase_ +0x576, 0x0070);
write_half(SEIPBase_ +0x577, 0x4350);

 //[PIA 0x578 to 0x5A7     PIDI = 0x0000]
	for (addr =  8; addr <= 0x37; addr++) {
		write_half(SEIPBase_ +0x570 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x5A8, 0x0000);
write_half(SEIPBase_ +0x5A9, 0x0000);
write_half(SEIPBase_ +0x5AA, 0x0000);
write_half(SEIPBase_ +0x5AB, 0x0700);
write_half(SEIPBase_ +0x5AC, 0x0770);
write_half(SEIPBase_ +0x5AD, 0x7670);
write_half(SEIPBase_ +0x5AE, 0x004D);
write_half(SEIPBase_ +0x5AF, 0x0070);

 //[PIA 0x5B0 to 0x5F7     PIDI = 0x0000]
	for (addr =  0; addr <= 0x47; addr++) {
		write_half(SEIPBase_ +0x5B0 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x5F8, 0x0000);
write_half(SEIPBase_ +0x5F9, 0x0ECD);
write_half(SEIPBase_ +0x5FA, 0x028D);
write_half(SEIPBase_ +0x5FB, 0x06ED);
write_half(SEIPBase_ +0x5FC, 0x06F0);
write_half(SEIPBase_ +0x5FD, 0x6645);
write_half(SEIPBase_ +0x5FE, 0x0077);
write_half(SEIPBase_ +0x5FF, 0x4D3D);

 //[PIA 0x600 to 0x61F     PIDI = 0x0000]
 /*
	for (addr =  0; addr <= 0x1F; addr++) {
		write_half(SEIPBase_ +0x600 + addr, 0x0000);
	}
*/
write_half(SEIPBase_ +0x600, 0x0000);
write_half(SEIPBase_ +0x601, 0x0000);
write_half(SEIPBase_ +0x602, 0x0000);
write_half(SEIPBase_ +0x603, 0x0481);
write_half(SEIPBase_ +0x604, 0x06FD);
write_half(SEIPBase_ +0x605, 0x0000);
write_half(SEIPBase_ +0x606, 0x0710);
write_half(SEIPBase_ +0x607, 0x0000);
	for (addr =  0x08; addr <= 0x1F; addr++) {
		write_half(SEIPBase_ +0x600 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x620, 0x0000);
write_half(SEIPBase_ +0x621, 0x027E);
write_half(SEIPBase_ +0x622, 0x03DD);
write_half(SEIPBase_ +0x623, 0x024D);
write_half(SEIPBase_ +0x624, 0x04D0);
write_half(SEIPBase_ +0x625, 0x0770);
write_half(SEIPBase_ +0x626, 0x0698);
write_half(SEIPBase_ +0x627, 0x0054);

 //[PIA 0x628 to 0x63F     PIDI = 0x0000]
	for (addr =  8; addr <= 0x1F; addr++) {
		write_half(SEIPBase_ +0x620 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x640, 0x0000);
write_half(SEIPBase_ +0x641, 0x0E83);
write_half(SEIPBase_ +0x642, 0x0D29);
write_half(SEIPBase_ +0x643, 0x05D3);
write_half(SEIPBase_ +0x644, 0x03C4);
write_half(SEIPBase_ +0x645, 0x0770);
write_half(SEIPBase_ +0x646, 0x0700);
write_half(SEIPBase_ +0x647, 0x0000);

 //[PIA 0x648 to 0x64F     PIDI = 0x0000]
	for (addr =  8; addr <= 0xF; addr++) {
		write_half(SEIPBase_ +0x640 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x650, 0x0000);
write_half(SEIPBase_ +0x651, 0x0000);
write_half(SEIPBase_ +0x652, 0x02BD);
write_half(SEIPBase_ +0x653, 0x0104);
write_half(SEIPBase_ +0x654, 0x034C);
write_half(SEIPBase_ +0x655, 0x0220);
write_half(SEIPBase_ +0x656, 0x004F);
write_half(SEIPBase_ +0x657, 0x0204);

 //[PIA 0x658 to 0x697     PIDI = 0x0000]
	for (addr =  8; addr <= 0x47; addr++) {
		write_half(SEIPBase_ +0x650 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x698, 0x0000);
write_half(SEIPBase_ +0x699, 0x0222);
write_half(SEIPBase_ +0x69A, 0x030E);
write_half(SEIPBase_ +0x69B, 0x02F5);
write_half(SEIPBase_ +0x69C, 0x0D72);
write_half(SEIPBase_ +0x69D, 0x049A);
write_half(SEIPBase_ +0x69E, 0x050D);
write_half(SEIPBase_ +0x69F, 0x0303);

 //[PIA 0x6A0 to 0x6DF     PIDI = 0x0000]
	for (addr =  0; addr <= 0x3F; addr++) {
		write_half(SEIPBase_ +0x6A0 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x6E0, 0x0000);
write_half(SEIPBase_ +0x6E1, 0x0000);
write_half(SEIPBase_ +0x6E2, 0x0000);
write_half(SEIPBase_ +0x6E3, 0x0000);
write_half(SEIPBase_ +0x6E4, 0x0000);
write_half(SEIPBase_ +0x6E5, 0x0000);
write_half(SEIPBase_ +0x6E6, 0x0700);
write_half(SEIPBase_ +0x6E7, 0x0205);

 //[PIA 0x6E8 to 0x76F     PIDI = 0x0000]
	for (addr =  8; addr <= 0x8F; addr++) {
		write_half(SEIPBase_ +0x6E0 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x770, 0x0000);
write_half(SEIPBase_ +0x771, 0x0000);
write_half(SEIPBase_ +0x772, 0x0000);
write_half(SEIPBase_ +0x773, 0x0000);
write_half(SEIPBase_ +0x774, 0x0000);
write_half(SEIPBase_ +0x775, 0x0000);
write_half(SEIPBase_ +0x776, 0x0504);
write_half(SEIPBase_ +0x777, 0x0102);

 //[PIA 0x778 to 0x7A7     PIDI = 0x0000]
	for (addr =  8; addr <= 0x37; addr++) {
		write_half(SEIPBase_ +0x770 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x7A8, 0x0000);
write_half(SEIPBase_ +0x7A9, 0x0000);
write_half(SEIPBase_ +0x7AA, 0x0000);
write_half(SEIPBase_ +0x7AB, 0x0000);
write_half(SEIPBase_ +0x7AC, 0x0000);
write_half(SEIPBase_ +0x7AD, 0x0000);
write_half(SEIPBase_ +0x7AE, 0x060D);
write_half(SEIPBase_ +0x7AF, 0X0406);

 //[PIA 0x7B0 to 0x7F7     PIDI = 0x0000]
	for (addr =  0; addr <= 0x47; addr++) {
		write_half(SEIPBase_ +0x7B0 + addr, 0x0000);
	}

write_half(SEIPBase_ +0x7F8, 0x0000);
write_half(SEIPBase_ +0x7F9, 0x0000);
write_half(SEIPBase_ +0x7FA, 0x0000);
write_half(SEIPBase_ +0x7FB, 0x0480);
write_half(SEIPBase_ +0x7FC, 0x06D0);
write_half(SEIPBase_ +0x7FD, 0x0620);
write_half(SEIPBase_ +0x7FE, 0x0500);
write_half(SEIPBase_ +0x7FF, 0x0300);

write_half(SEIPBase_ +0x020, 0x00AA);
write_half(SEIPBase_ +0x021, 0xAAAA);
write_half(SEIPBase_ +0x022, 0x0055);
write_half(SEIPBase_ +0x020, 0x0055);
write_half(SEIPBase_ +0x021, 0x5555);
write_half(SEIPBase_ +0x022, 0x00AA);
write_half(SEIPBase_ +0x020, 0x00AA);
write_half(SEIPBase_ +0x021, 0xAAAA);   
	      
read_half(SEIPBase_ + 0x022);			
write_half(SEIPBase_ +0x020, 0x0055);
write_half(SEIPBase_ +0x021, 0x5555);
read_half(SEIPBase_ + 0x022);	                


		for (k = 0; k < 5; k++) ;
		for (k = 0; k < 5; k++) ;

	mem(GPIO_OUT1_) = 0x00000000;
	l++;
	mem(IRQMASKSET_) = 0x00001000;	// interrupt enable 

	write_half(SECON_, 0x0001);		// reset SE                                       

	mem(SECON_) |= 0x0040;		// interrupt enable
write_half(SEIPBase_ +0x000, 0x001D);                 		

	while (mem(GPIO_OUT1_) != l);

write_half(SEIPBase_ +0x001, 0x00DF);
//write_half(SEIPBase_ +0x002, 0x0038);
write_half(SEIPBase_ +0x014, 0x0010);
write_half(SEIPBase_ +0x015, 0x1000);
write_half(SEIPBase_ +0x016, 0x0040);
write_half(SEIPBase_ +0x017, 0x8000);
write_half(SEIPBase_ +0x148, 0xAAAA);
write_half(SEIPBase_ +0x018, 0x0000);
write_half(SEIPBase_ +0x330, 0x4440);
write_half(SEIPBase_ +0x331, 0x000E);
write_half(SEIPBase_ +0x332, 0x4001);
write_half(SEIPBase_ +0x333, 0x4000);
write_half(SEIPBase_ +0x334, 0x4444);
write_half(SEIPBase_ +0x335, 0x41DE);
write_half(SEIPBase_ +0x336, 0xA5A5);
write_half(SEIPBase_ +0x534, 0x7070);
write_half(SEIPBase_ +0x535, 0x7676);
write_half(SEIPBase_ +0x536, 0x4040);
write_half(SEIPBase_ +0x537, 0x7070);
write_half(SEIPBase_ +0x732, 0x0660);
write_half(SEIPBase_ +0x733, 0x0660);
write_half(SEIPBase_ +0x734, 0x0660);
write_half(SEIPBase_ +0x735, 0x0740);
write_half(SEIPBase_ +0x736, 0x060D);
write_half(SEIPBase_ +0x737, 0x4060);		
write_half(SEIPBase_ +0x2D4, 0x7777);

read_half(SEIPBase_ + 0x010);
read_half(SEIPBase_ + 0x011);
read_half(SEIPBase_ + 0x012);
read_half(SEIPBase_ + 0x013);

	l++;
	mem(IRQMASKSET_) = 0x00001000;	// interrupt enable 
	while (mem(GPIO_OUT1_) != l);

write_half(SEIPBase_ +0x010, 0x0410);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x011, 0x1008);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x012, 0x4040);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x013, 0x8020);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
 				
write_half(SEIPBase_ +0x1CA, 0x4444);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x1DB, 0x0000);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x1BC, 0x3333);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x1CD, 0x5555); 
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x19D, 0x7777);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x494, 0x7070);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;

write_half(SEIPBase_ +0x6E3, 0x4444);	
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x385, 0x3333);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x180, 0x6666);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x591, 0x1111);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
                                
	l++;
	mem(IRQMASKSET_) = 0x00001000;	// interrupt enable 
	while (mem(GPIO_OUT1_) != l);

write_half(SEIPBase_ +0x777, 0x7777);

while (read_half(SEIPBase_ + 0x010) != 0x0410);
while (read_half(SEIPBase_ + 0x011) != 0x1008);
	// 0x4040 -> 0x0004 after time elapsed
while (read_half(SEIPBase_ + 0x012) != 0x0040);
while (read_half(SEIPBase_ + 0x013) != 0x8020);

write_half(SEIPBase_ +0x011, 0x0008);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;
write_half(SEIPBase_ +0x013, 0x0020);
	mem(GPIO_OUT0_) = mem(GPIO_OUT0_) + 1;

	for (k = 0; k < 100; k++) ;
	return 0;
}

void init_pll (void) {
	// set PLL
	write (PLL1PARM_, 0x06A0);
	while (read(PLL1PARM_) != 0x06A0);
	write (PLL1CON_, 0x0001);
	while (read(PLL1CON_) != 0x0001);

	// waiting PLL locking
	while (read(PLL1CON_) != 0x0003);

	// switching Sound clock
	write (PLL1CON_, 0x0005);
	while (read(PLL1CON_) != 0x0007);
}

