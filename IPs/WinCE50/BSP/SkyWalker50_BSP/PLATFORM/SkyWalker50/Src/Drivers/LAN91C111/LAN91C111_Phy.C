/*
 *
 *    Copyright (c) Standard MicroSystems Corporation.  All Rights Reserved.
 *
 *				    LAN91C111 Driver for Windows CE .NET
 *
 *							 Revision History
 *_______________________________________________________________________________
 *     Author		  Date		Version		Description
 *_______________________________________________________________________________
 * Pramod Bhardwaj  6/18/2002	  0.1		Beta Release
 * Pramod Bhardwaj	7/15/2002	  1.0       Release 
 *_______________________________________________________________________________
 *
 *
 *Description:
 *            Functions for accessing the phy. And contains the Autonegotiating
 *  procedure for establishing the link
 *
 *
 */
#define NDIS_MINIPORT_DRIVER
#define NDIS50_MINIPORT


//NDIS Version Declaration
#define DRIVER_NDIS_MAJOR_VERSION 5
#define DRIVER_NDIS_MINOR_VERSION 0

#include <Ndis.h>
#include "LAN91C111_Adapter.h"

/*
 Function Name : InputMDO
 Description   :
                 Reads MII serial data bit, using the Management Interface reg.
 Parameters    :    
                 UINT IOAddress - IOAddress to read (or the IOAddr, for Manag. Intr. Reg
 Return Value  :
                 Value in the Management Interface register. Note that this is the 
                 value of the complete register not just the MDI
 */

USHORT	InputMDO			( UINT IOAddress )
{
	USHORT phydat;
	//DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111==> InputMDO\r\n")));	
	NdisRawWritePortUshort( IOAddress, (USHORT) 0 );
	NdisRawWritePortUshort( IOAddress, (USHORT) MGMT_MCLK );
	NdisRawReadPortUshort( IOAddress, &phydat );
	NdisRawWritePortUshort( IOAddress, (USHORT) 0 );
	//DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== InputMDO\r\n")));
	return( phydat );
}


/*
 Function Name : OutputMDO
 Description   :
                 Write a bit to the MII. The value to write is based on the second
   Parameter. If the second parameter is 0 then 0 is written to the MII, similarly 1 
   if the second parameter is 1. When the second parameter is 2 the output is tristated
   on the MII.
 Parameters    :    UINT IOAddress - Address to write
                    UCHAR lev - if 0 - write 0
                                if 1 - write 1
                                if 2 - write Z (tristate)
 Return Value  :
                 VOID
 */

VOID	OutputMDO			( UINT IOAddress, UCHAR lev )
{
	//DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 ==> OutputMDO  \r\n")));
    if( lev == 0 ) 
	{
        NdisRawWritePortUshort( IOAddress, (USHORT) MGMT_MDOE );
        NdisRawWritePortUshort( IOAddress, (USHORT) ( MGMT_MCLK + MGMT_MDOE ) );
        NdisRawWritePortUshort( IOAddress, (USHORT) MGMT_MDOE );
    }
    else 
	{
		if( lev == 1 )
		{
			NdisRawWritePortUshort( IOAddress, (USHORT) ( MGMT_MDO + MGMT_MDOE ) );
			NdisRawWritePortUshort( IOAddress, (USHORT) ( MGMT_MCLK + MGMT_MDO + MGMT_MDOE ) );
			NdisRawWritePortUshort( IOAddress, (USHORT) ( MGMT_MDO + MGMT_MDOE ) );
		}
		if (lev==2)
		{
			NdisRawWritePortUshort( IOAddress, (USHORT) 0 );
			NdisRawWritePortUshort( IOAddress, (USHORT) (MGMT_MCLK) );
			NdisRawWritePortUshort( IOAddress, (USHORT) 0 );
		}
	}
	//DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <<= OutputMDO  \r\n")));
}



/*
 Function Name : ReadPhyRegister
 Description   :
                 Reads the PHY register using the PHY read procedure, described in 
                 the Application Notes/Tech. Ref. Manual
 Parameters    :    
                  UINT IOBase - Base address of the chip
                  UCHAR PhyReg - Register to read
 Return Value  :
                   UINT - Value read from the phy register specified by PhyReg
 */
UINT	ReadPhyRegister		( UINT IOBase, UCHAR  PhyReg)
{
	UINT Counter;
	USHORT PhyVal, PhyData;
	
	//DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 ==> ReadPhyRegister  \r\n")));
	
	// 32 consecutive ones on MDO to establish sync
	NdisRawWritePortUshort( IOBase + BANK_SELECT, (USHORT) 3 );
    NdisRawWritePortUshort( IOBase + BANK3_MGMT,  (USHORT) ( MGMT_MDOE + MGMT_MDO ) );
    for( Counter = 1; Counter <= 32; Counter++ ) 
	{
        NdisRawWritePortUshort( IOBase + BANK3_MGMT,(USHORT) ( MGMT_MDOE + MGMT_MDO ) );
        NdisRawWritePortUshort( IOBase + BANK3_MGMT,(USHORT) ( MGMT_MCLK + MGMT_MDOE + MGMT_MDO ) );
    }
    NdisRawWritePortUshort( IOBase + BANK3_MGMT, (USHORT) MGMT_MDOE );
	
	// start code <01>
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 0 );
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 1 );
	
	// read command <10>
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 1 );
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 0 );
	
	// write the phyaddress - which is five 0s for LAN91C111
	for ( Counter = 1; Counter <= 5; Counter++)
		OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 0 );
	
	//Write the phy register to read
	//Highest bit goes out first..... :)
	for (Counter = 1; Counter <= 5; Counter++)
	{
        if( ( PhyReg & 0x10 ) != 0 )  // outmdo(1); 
			OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 1 );
		else
			OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 0 );
		PhyReg <<= 1;
	}
	
	// turnaround mdo is tristated
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 2 ); 
	
	//Read the data...
	PhyData	=	0; // Stores the bit value
	PhyVal	=	0; // Stores the complete value of the phy register
	for( Counter = 0; Counter <= 0xf; Counter++ ) 
	{
		PhyVal <<= 1;
        PhyData = InputMDO( (UINT)( IOBase + BANK3_MGMT ) );
        if(0x2 & PhyData)		
			PhyVal |= 1;
    }
	
	// turnaround mdo is tristated
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 2 );
	//DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== ReadPhyRegister  \r\n")));
	return (PhyVal);	
}



/*
 Function Name : WritePhyRegister
 Description   :
                 Writes the PHY register using the PHY Write procedure, described in 
                 the Application Notes/Tech. Ref. Manual
 Parameters    :    
                 UINT IOBase - Base address of the chip
                 UCHAR PhyReg - Register to Write
                 USHORT value - Value to write
 Return Value  :
                   void
 */
void	WritePhyRegister		( UINT IOBase, UCHAR  PhyReg, USHORT Value)
{
	UINT Counter;
	USHORT PhyVal, PhyData;
	
	//DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 ==> WritePhyRegister  \r\n")));
	// 32 consecutive ones on MDO to establish sync
	NdisRawWritePortUshort( IOBase + BANK_SELECT, (USHORT) 3 );
    NdisRawWritePortUshort( IOBase + BANK3_MGMT,  (USHORT) ( MGMT_MDOE + MGMT_MDO ) );
    for( Counter = 1; Counter <= 32; Counter++ ) 
	{
        NdisRawWritePortUshort( IOBase + BANK3_MGMT,(USHORT) ( MGMT_MDOE + MGMT_MDO ) );
        NdisRawWritePortUshort( IOBase + BANK3_MGMT,(USHORT) ( MGMT_MCLK + MGMT_MDOE + MGMT_MDO ) );
    }
    NdisRawWritePortUshort( IOBase + BANK3_MGMT, (USHORT) MGMT_MDOE );
	
	// start code <01>
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 0 );
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 1 );
	
	// write command <01>
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 0 );
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 1 );
	
	// write the phyaddress - which is five 0s for LAN91C111
	for ( Counter = 1; Counter <= 5; Counter++)
		OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 0 );
	
	//Write the phy register to read
	//Highest bit goes out first..... :)
	for (Counter = 1; Counter <= 5; Counter++)
	{
        if( ( PhyReg & 0x10 ) != 0 )
			OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 1 );
		else
			OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 0 );
		PhyReg <<= 1;
	}
	
	// turnaround mdo
    OutputMDO( (UINT) ( IOBase + BANK3_MGMT ), 1 );
    OutputMDO( (UINT) ( IOBase + BANK3_MGMT ), 0 );
	
	//Read the data...
	PhyData	=	0; // Stores the bit value
	PhyVal	=	0; // Stores the complete value of the phy register
	for( Counter = 0; Counter <= 0xf; Counter++ ) 
	{
		if (Value & 0x8000)
			OutputMDO( (UINT) ( IOBase + BANK3_MGMT ), 1 );
		else
			OutputMDO( (UINT) ( IOBase + BANK3_MGMT ), 0 );
		Value <<= 1;		
    }
	
	// turnaround mdo is tristated
    OutputMDO( (UINT)( IOBase + BANK3_MGMT ), 2 );
	
	//DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== WritePhyRegister  \r\n")));
}


/*
 Function Name : EstablishLink
 Description   : 
                 This function establishes a link based on the Auto_Negotiation variable
                 in the adapter structure. If the variable is true then auto negotiation is
                 enabled. If the variable is false then the link is manually established
                 by setting the speed and duplex bits. Note that the manual mode can only
                 select speed but the duplex is always half duplex.
                 
 Parameters    :    
                 MINIPORT_ADAPTER *Adapter - Pointer to the adapter structure
 Return Value  :
                 BOOLEAN - True is succesful, else false
 */
BOOLEAN EstablishLink(MINIPORT_ADAPTER *Adapter)
{
	USHORT	temp;
	DWORD	LocalTimer;
	if (Adapter->Auto_Negotiation)
	{
RestartAutoNegotiation:
		//Reset the PHY
		WritePhyRegister(Adapter->IOBase, 0, 0x8000);
		while ( 0x8000 & ReadPhyRegister(Adapter->IOBase, 0));
		Sleep(350);
		
		//Set the MAC Register to AutoNeg
		NdisRawWritePortUshort( Adapter->IOBase + BANK_SELECT, (USHORT) 0 );
		NdisRawWritePortUshort( Adapter->IOBase + BANK0_RPCR, RPCR_ANEG);
		
		//Set the PHY Register to AutoNeg
		WritePhyRegister(Adapter->IOBase, 0, 0x1000);
		
		temp = 1;
		LocalTimer = GetTickCount();
		do
		{
			temp = ReadPhyRegister(Adapter->IOBase, 1);
			if (temp & 0x10) goto RestartAutoNegotiation;		
			if (temp & 0x20) temp = 0;
			if ((GetTickCount() - LocalTimer) > 2000) break; //Wait for approx 3 seconds.. then break..
		}
		while (temp);
			
		//Check for the status of the autoneg
		temp = 0x4000;
		LocalTimer = GetTickCount();
		while (temp & 0x4000)
		{
			temp = ReadPhyRegister(Adapter->IOBase, 18);
			if ((GetTickCount() - LocalTimer) > 2000) break; //Wait for approx 3 seconds.. then break..
		}
		
		if (!(temp & 0x4000))
		{
			if (temp & 0x0080)
			{
				Adapter->Speed = SPEED100;
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== 100BASE-TX Link Detected\r\n")));
			}
			else
			{
				Adapter->Speed = SPEED10;
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== 10BASE-TX Link Detected\r\n")));
			}
			
			if (temp & 0x0040)
			{
				Adapter->Duplex = FULL_DUPLEX;
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== FULL DUPLEX Link Detected\r\n")));
			}
			else
			{
				Adapter->Duplex = HALF_DUPLEX;
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== HALF DUPLEX Link Detected\r\n")));
			}
			
			Adapter->LinkStatus = MEDIA_CONNECTED;
		}	
		else
		{
			DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== MEDIA IS DISCONNECTED ..........\r\n")));
			Adapter->LinkStatus = MEDIA_DISCONNECTED;
		}		
	}
	else
	{
		//Clear MII_DIS if set, after the reset
		temp = ReadPhyRegister(Adapter->IOBase, 0);
		if (temp & 0x0400)
			WritePhyRegister(Adapter->IOBase, 0, (USHORT)(temp&0x0BFF));

		//Manual Selection...
		NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT, (USHORT) 0);
		NdisRawReadPortUshort(Adapter->IOBase + BANK0_RPCR, &temp);
		temp &= ~RPCR_ANEG; //Clear the ANET bit
	
		if (Adapter->Speed == SPEED100)
			temp |= RPCR_SPEED;	//Set the bit
		else
			temp &= ~RPCR_SPEED;	//Clear the bit

		if (Adapter->Duplex == FULL_DUPLEX)
			temp |= RPCR_DPLX; //Set to full duplex
		else
			temp &= ~RPCR_DPLX; //Test.. for 10hdx
		NdisRawWritePortUshort( Adapter->IOBase + BANK0_RPCR, temp);
		
		//Clear MII_DIS if set, after the reset
		temp = ReadPhyRegister(Adapter->IOBase, 0);
		if (temp & 0x0400)
			WritePhyRegister(Adapter->IOBase, 0, (USHORT)(temp&0xFBFF));
		temp = 0x4000;
		LocalTimer = GetTickCount();
		while (temp & 0x4000)
		{
			temp = ReadPhyRegister(Adapter->IOBase, 18);
			if ((GetTickCount() - LocalTimer) > 3000) break; //Wait for approx 3 seconds.. then break..
		}
		if (!(temp & 0x4000))
		{
			if (temp & 0x0080)
			{
				Adapter->Speed = SPEED100;
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== 100BASE-TX Link Detected\r\n")));
			}
			else
			{
				Adapter->Speed = SPEED10;
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== 10BASE-TX Link Detected\r\n")));
			}
			
			if (temp & 0x0040)
			{
				Adapter->Duplex = FULL_DUPLEX;
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== FULL DUPLEX Link Detected\r\n")));
			}
			else
			{
				Adapter->Duplex = HALF_DUPLEX;
				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== HALF DUPLEX Link Detected\r\n")));
			}
			
			Adapter->LinkStatus = MEDIA_CONNECTED;
		}	
		else
		{
			DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== MEDIA IS DISCONNECTED ..........\r\n")));
			Adapter->LinkStatus = MEDIA_DISCONNECTED;			
		}		
	}
	
	//Setup the phy for link interrupts
	WritePhyRegister(Adapter->IOBase, 19, (PHY_MASK_BASE & PHY_MASK_INT & PHY_MASK_LINK));
	ReadPhyRegister(Adapter->IOBase, 18); //To clear an pending interrupts..

	return TRUE;
}    