
#include "sysinc.h"
#include "commonmacro.h"


#define WAIT_TIMEOUT		500
#define NOR_SECTOR_SZ		(128*1024)

#define GET_SECTOR(addr)	(addr&0xFFFE0000)
#define GET_SECTOR_SZ(addr)	NOR_SECTOR_SZ

#define	NOR_BASE			(0x08000000)
#define	NOR_W(addr, data)	(*((volatile unsigned char*)(NOR_BASE+addr))=data)
#define	NOR_R(addr)			(*((volatile unsigned char*)(NOR_BASE+addr)))


smtBoolean smtNorEraseSector(smtUint32 sector_addr);
smtBoolean smtNorReset(void);
smtBoolean smtNorStatus(smtUint32 adress);
smtBoolean smtNorWriteSector(smtUint32 address,smtUint8 *data,smtUint32 datalen);


smtBoolean smtNorWriteBlock(smtUint32 address,smtUint8 *data,smtUint32 datalen)
{
	smtUint32 wlen, wrtotlen;
	smtBoolean ret;
	smtUint8 *pData = data;
	
	wrtotlen = datalen;
		
	while(1)
	{
	
		if(wrtotlen > NOR_SECTOR_SZ)
			wlen = NOR_SECTOR_SZ;
		else
			wlen = wrtotlen;
				
		ret = smtNorWriteSector(address,pData,wlen);
		
		if(ret==SMT_FALSE)
			return ret;
			
		address += wlen;
		pData = pData + wlen;
		wrtotlen -= wlen;
		
		smt2UartPrint(11, "Sector Write Complete\n");
		
		if(wrtotlen == 0) break;		
	}
	
	return SMT_TRUE;
}

smtBoolean smtNorWriteSector(smtUint32 address,smtUint8 *data,smtUint32 datalen)
{
	smtUint32 sector, offset;
	smtUint32 wlen, wrtotlen;
	
	smtUint8 *pData = data;
	smtUint8 srcdata, dstdata;
	
	smtUint32 ret = SMT_TRUE;

	sector		= GET_SECTOR(address);
	wrtotlen	= datalen;

	
	smt2UartPrint(11,"address = 0x%08x\n",address);
	smt2UartPrint(11,"sector  = 0x%08x\n",sector);
	
	ret = smtNorEraseSector(sector);
	
	if(ret==SMT_FALSE)
		return ret;

	while(1)
	{
		if(wrtotlen > 32)
			wlen = 32;
		else
			wlen = wrtotlen;		
			
		NOR_W(0xAAA, 0xAA);
		NOR_W(0x555, 0x55);
		NOR_W(sector, 0x25);		
		NOR_W(sector, (wlen-1));	

		for(offset=0; offset<wlen; offset++) 
		{
			NOR_W(address+offset , pData[offset]);			
		}
		NOR_W(sector, 0x29);
		
		if(smtNorStatus(address+offset)!=SMT_TRUE)
		{
			smt2UartPrint(11, "Status Check failure\n");
			return SMT_FALSE;
		}
				
		for(offset=0; offset < wlen; offset++) 
		{
			srcdata = NOR_R(address + offset);
			dstdata = pData[offset];
			if(srcdata!=dstdata)
			{
				smt2UartPrint(11, "[%d]Write Failure\n",__LINE__);
			}
		}
		
		address  += wlen;
		wrtotlen -= wlen;	
		pData += wlen;		
								
		if(wrtotlen==0) break;
	}
	
	return SMT_TRUE;

}



smtBoolean smtNorEraseSector(smtUint32 sector)
{
	smtUint32 timeout;
	smtUint8 data;
	
	NOR_W(0xAAA, 0xAA);
	NOR_W(0x555, 0x55);
	NOR_W(0xAAA, 0x80);	
	
	NOR_W(0xAAA, 0xAA);
	NOR_W(0x555, 0x55);
	NOR_W(sector, 0x30);	
		
	
	for(timeout = 0; timeout < WAIT_TIMEOUT; timeout++)
	{
		smtNorStatus(sector);
		
		data = NOR_R(sector);
		if(data==0xFF)
			return SMT_TRUE;
	}
	
	smt2UartPrint(11, "Nor Erase Failure\n");
	
    return SMT_FALSE;
}


smtBoolean smtNorReset(void)
{	
	NOR_W(0x0, 0xF0);
	
	return SMT_TRUE;
}


smtBoolean smtNorReadID(smtUint8 *mID, smtUint8 *dID)
{
	// Manufacture ID
	NOR_W(0xAAA, 0xAA);
	NOR_W(0x555, 0x55);
	NOR_W(0xAAA, 0x90);

	*mID = NOR_R(0);
	*dID = NOR_R(2);
	
	return SMT_TRUE;
}



smtBoolean smtNorStatus(smtUint32 adress)
{
	smtUint32 timeout, data1, data2;
	smtUint32 togglemask = (1 << 6); /* DQ 6 */	

	for(timeout = 0; timeout < WAIT_TIMEOUT; timeout++) 
	{
		data1 = NOR_R(adress);
		data2 = NOR_R(adress);

		if((data1&togglemask)==(data2&togglemask)) /* no toggle */
			return SMT_TRUE;
	}
	
	return SMT_FALSE;
}

