// DumpRegs.h

{
	ONION	o, o2, o3;

#if DEBUG_REGS_VERBOSE
	UsbDumpByte(usbSave.intStatus, usbSave.intEnable, pStatus);
	UsbDumpByte(usbSave.errorStatus, usbSave.errorEnable, pError);
#endif

#if 0
	putc('$');
	putb(USB_HOST_STATE);
	putSpace();
#endif

#if 1
	putb(usbSave.intStatus);
	putSpace();

	putb(usbSave.intEnable);
	putSpace();

	putb(usbSave.errorStatus);
	putSpace();

	putb(usbSave.errorEnable);
	putSpace();

	o.b.l = usbSave.status;
	putb(usbSave.status);
	putSpace();

	putb(usbSave.control);
	putSpace();

	putb(usbSave.address);
	putSpace();

	o.b.h = usbSave.bdtPage;
	putb(usbSave.bdtPage);
#else
	o.b.l = usbSave.status;
	o.b.h = usbSave.bdtPage;
#endif

	if (usbSave.intStatus & INT_STAT_MASK_TOKEN_DONE)
		{
		putc('>');
		putb(o.pb[0]);
		putb(o.pb[1]);

		if ((o.pb[0] & 0x03) || o.pb[1])	// if bch or bcl, dump buffer
			{
			putb(o.pb[2]);
			putb(o.pb[3]);
			putc('>');

			o2.b.l = o.pb[2];
			o2.b.h = o.pb[3];

			o3.b.l = o.pb[1];
			o3.b.h = o.pb[0] & 0x03;

			if (((o.pb[0] & 0x3c) == 0x34) && (o3.w >= 2))
				{	// if setup and packet length >= 2 show type
				puts(o2.pb[0] & 0x80 ? "H>D " : "D>H ");
				switch (o2.pb[0] & 0x60)
					{
					case 0x00: puts("Std ");	break;
					case 0x20: puts("Cls ");	break;
					case 0x40: puts("Vnd ");	break;
					case 0x60: puts("Rsv ");	break;
					}
				switch (o2.pb[0] & 0x1f)
					{
					case 0x00: puts("Dev ");	break;
					case 0x01: puts("Int ");	break;
					case 0x02: puts("End ");	break;
					case 0x03: puts("Oth ");	break;
					default:   puts("Rsv ");	break;
					}
				switch (o2.pb[1])
					{
					case 0: puts("GET_STAT ");	break;
					case 1: puts("CLR_FEAT ");	break;
					case 2: puts("reserved ");	break;
					case 3: puts("SET_FEAT ");	break;
					case 4: puts("reserved ");	break;
					case 5: puts("SET_ADDR ");	break;
					case 6: puts("GET_DESC ");	break;
					case 7: puts("SET_DESC ");	break;
					case 8: puts("GET_CONF ");	break;
					case 9: puts("SET_CONF ");	break;
					case 10: puts("GET_IFC  ");	break;
					case 11: puts("SET_IFC  ");	break;
					case 12: puts("SYNCH_FR ");	break;
					default: puts("unknown  ");	break;
					}
				}

			while (o3.w--)
				{
				putb(*o2.pb++);
				}
			}
		}

	putCrlf();

#if DEBUG_ENDPOINTS
	{
	BYTE	b;
	
	puts("Endpt regs:");
	for (b=0; b<4; b++)
		{
		putSpace();
		putb(ENDPT_RG[b]);
		}
	putCrlf();
	}
#endif

	putFlush();
	return;
}

