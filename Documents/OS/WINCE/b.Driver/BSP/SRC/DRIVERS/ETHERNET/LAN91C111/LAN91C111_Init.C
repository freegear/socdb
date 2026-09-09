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
 *Pramod Bhardwaj	7/15/2002	  1.0       Release 
 *_______________________________________________________________________________
 *
 *Description:
 *             Contains all the initialization functions required for the driver.
 *
 *
 */

#define NDIS_MINIPORT_DRIVER
#define NDIS50_MINIPORT

#include <Ndis.h>
#include "LAN91C111_Adapter.H"

extern NDIS_PHYSICAL_ADDRESS HighestAcceptedMax;

extern VOID		LAN91C111_MiniPortHandleInterrupt	(IN NDIS_HANDLE  AdapterContext);

NDIS_STATUS GetRegistrySettings(MINIPORT_ADAPTER *, NDIS_HANDLE);
BOOLEAN		AdapterVerify(MINIPORT_ADAPTER  *);
BOOLEAN     AdapterReset(MINIPORT_ADAPTER *);
void        BackOut(MINIPORT_ADAPTER *Adapter);
BOOLEAN		EstablishLink(MINIPORT_ADAPTER *Adapter);

/*
 Function Name : 	LAN91C111_MiniportInitialize
 Description   :	
					Called by the NDIS Wrapper to initialize the adapter. 
						0. Verify the Adapter v/s the driver
						1. Create and initilize the adapter structure
						2. Read and load the registry settings
						3. Initialize the chip
						4. Establish the link
 Parameters    :
					PNDIS_STATUS OpenErrorStatus - Additional error status, if return value is error
					       PUINT MediumIndex	 - specifies the medium type the driver or its network adapter uses
					PNDIS_MEDIUM MediumArray	 - Specifies an array of NdisMediumXXX values from which 
													MiniportInitialize selects one that its network adapter supports 
													or that the driver supports as an interface to higher-level drivers. 

						    UINT MediumArraySize - Specifies the number of elements at MediumArray
					 NDIS_HANDLE AdapterHandle   - Specifies a handle identifying the miniport’s network adapter, 
													which is assigned by the NDIS library
					 NDIS_HANDLE ConfigurationContext - Specifies a handle used only during initialization for 
														 calls to NdisXXX configuration and initialization functions

 Return Value  :
					NDIS_STATUS		Status
			
*/

NDIS_STATUS LAN91C111_MiniportInitialize(
											PNDIS_STATUS	OpenErrorStatus,
											PUINT			MediumIndex,
											PNDIS_MEDIUM	MediumArray,
											UINT			MediumArraySize,
											NDIS_HANDLE		AdapterHandle,
											NDIS_HANDLE		ConfigurationContext
										)
{
	NDIS_STATUS         Status=NDIS_STATUS_SUCCESS;
	UINT                ArrayIndex;
	PMINIPORT_ADAPTER   Adapter;
	USHORT				temp;


	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 ==> MiniportInitialize  \r\n")));

	//Check for the supported 802.3 media
	for(ArrayIndex = 0; ArrayIndex < MediumArraySize; ArrayIndex++)
           if(MediumArray[ArrayIndex] == NdisMedium802_3)   break;
    if(ArrayIndex == MediumArraySize)
    {
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 :  ERROR - No Supported Media types \r\n")));
        DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== MiniportInitialize  \r\n")));
        return(NDIS_STATUS_UNSUPPORTED_MEDIA);
    }
    *MediumIndex = ArrayIndex;
	
	//Allocate memory for the adapter structure
	temp = MINIPORT_ADAPTER_SIZE;
	Status = NdisAllocateMemory((PVOID *) &Adapter, MINIPORT_ADAPTER_SIZE, 0, HighestAcceptedMax);
    if(Status != NDIS_STATUS_SUCCESS)
    {
        DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:   ERROR - No Memory for Adapter Structure!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== MiniPort Initialize\r\n")));
        return(NDIS_STATUS_RESOURCES);
    }
    NdisZeroMemory(Adapter, MINIPORT_ADAPTER_SIZE); //Clean it up
	Adapter->AdapterHandle = AdapterHandle;
	Adapter->State = INITIALIZING_STATE;

	//Get the adapter information from the register
	Status = GetRegistrySettings(Adapter, ConfigurationContext);
	if(Status != NDIS_STATUS_SUCCESS)
    {
        DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ERROR - Configure Adapter failed!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== MiniPort Initialize\r\n")));
        BackOut(Adapter);
        return(NDIS_STATUS_FAILURE);
    }
	
	//Register the IOSpace and the interrupt
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Before Calling SetAttribute\r\n")));
	NdisMSetAttributes(Adapter->AdapterHandle, (NDIS_HANDLE) Adapter, FALSE, NdisInterfaceInternal);
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== after Calling SetAttribute\r\n")));
	Status = NdisMRegisterIoPortRange((PVOID *) &(Adapter->IOBase),
			Adapter->AdapterHandle,
			Adapter->IOBase,
			16);
	if(Status != NDIS_STATUS_SUCCESS)
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 : ERROR - Can't Register I/O Port Range!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== MiniPort Initialize\r\n")));
        BackOut(Adapter);
		return(NDIS_STATUS_RESOURCES);
	}
	Adapter->IsPortRegistered = TRUE;

	Status = NdisMRegisterInterrupt(&Adapter->InterruptInfo,
				Adapter->AdapterHandle,
				Adapter->InterruptLevel,
				2,
				TRUE,
				FALSE,
				NdisInterruptLatched
				);

	if(Status != NDIS_STATUS_SUCCESS)
    {
        DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 : ERROR - Can't Attach to Interrupt!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== MiniPort Initialize\r\n")));
        BackOut(Adapter);		
        return(Status);
    }
	else
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:Interrupt Registered !!! \r\n")));
	Adapter->IsInterruptSet = TRUE;
	
	//Allocate the Adapter Interface Memory.
    Status = NdisAllocateMemory((PVOID *) &Adapter->LookAheadBuffer,
		LOOK_AHEAD_BUFFER_SIZE,
		0,
		HighestAcceptedMax);
	if(Status != NDIS_STATUS_SUCCESS)
    {
        DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:ERROR : Can't Allocate LookAhead Buffer!\r\n")));
        BackOut(Adapter);
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== MiniPort Initialize\r\n")));
        return(NDIS_STATUS_FAILURE);
    }
	else
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:Allocated LookAhead Buffer Successfully!\r\n")));
	}	
	
	if(!AdapterVerify(Adapter))
	{
        DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:Adapter failed to Verify!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== MiniPort Initialize\r\n")));
        return(NDIS_STATUS_FAILURE);
    }

	//Disable all interrupts until the initzing is completed
	//This clears the mask and any generated interrupts !!
    NdisRawWritePortUshort(	Adapter->IOBase + BANK_SELECT, 2 );
    NdisRawWritePortUshort( Adapter->IOBase + BANK2_INT_STS, 0 );

	//Check for the MAC Address
	//If Adapter->MACAddress != NULL then we need to write the new mac address to the LAN91C111 register
	//Else read the LAN91C111 register and store the mac addr. in Adapter->MACAddress
	
	if (Adapter->MACAddress[0] == 0 &&
		Adapter->MACAddress[1] == 0 &&
		Adapter->MACAddress[2] == 0 &&
		Adapter->MACAddress[3] == 0 &&
		Adapter->MACAddress[4] == 0 &&
		Adapter->MACAddress[5] == 0)
	{
		//Read the MAC address from the register
		NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT, 1);
		NdisRawReadPortUshort(Adapter->IOBase + BANK1_IA0, &temp);
		Adapter->MACAddress[0] = temp & 0x00FF;
		Adapter->MACAddress[1] = (temp & 0xFF00) >> 8;
		NdisRawReadPortUshort(Adapter->IOBase + BANK1_IA2, &temp);
		Adapter->MACAddress[2] = temp & 0x00FF;
		Adapter->MACAddress[3] = (temp & 0xFF00) >> 8;
		NdisRawReadPortUshort(Adapter->IOBase + BANK1_IA4, &temp);
		Adapter->MACAddress[4] = temp & 0x00FF;
		Adapter->MACAddress[5] = (temp & 0xFF00) >> 8;
	}
	else
	{
		//Write the new MAC address to the register
		NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT, 1);
		temp = (Adapter->MACAddress[1] << 8) + Adapter->MACAddress[0];
		NdisRawWritePortUshort(Adapter->IOBase + BANK1_IA0, temp);
		temp = (Adapter->MACAddress[3] << 8) + Adapter->MACAddress[2];
		NdisRawWritePortUshort(Adapter->IOBase + BANK1_IA2, temp);
		temp = (Adapter->MACAddress[5] << 8) + Adapter->MACAddress[4];
		NdisRawWritePortUshort(Adapter->IOBase + BANK1_IA4, temp);
	}

	//Reset the card
    if(!AdapterReset(Adapter))
    {
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ERROR Can't Reset the Adapter!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== MiniPort Initialize\r\n")));
        BackOut(Adapter);
        return(NDIS_STATUS_FAILURE);
    }

	//Enable the interrupts !!
	NdisRawWritePortUshort(Adapter->IOBase + BANK_SELECT,(USHORT) 2);
	NdisRawWritePortUshort( Adapter->IOBase + BANK2_INT_STS,(USHORT)(ENABLED_INTS << 8));
	
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== MiniportInitialize  \r\n")));

	//Ready
	Adapter->State = NORMAL_STATE;
	return NDIS_STATUS_SUCCESS;
}

/*
 Function Name : 	GetRegistrySettings
 Description   :	
					Reads the registry values, and loads them into the adapter structure
 Parameters    :
					MINIPORT_ADAPTER *Adapter	- Pointer to the adapter structure
					NDIS_HANDLE       ConfigurationContext - Context handler, from the NDIS wrapper
			
 Return Value  :
					NDIS_STATUS		Status
*/

NDIS_STATUS GetRegistrySettings(MINIPORT_ADAPTER *Adapter,
							 NDIS_HANDLE       ConfigurationContext)
{
	NDIS_STATUS                   Status;
	NDIS_HANDLE                   ConfigurationHandle;
	PNDIS_CONFIGURATION_PARAMETER ConfigurationParameter;

	UCHAR                        * NewNetworkAddress=NULL;
    UINT                          NewNetworkAddressLength;

	NDIS_STRING                   BusTypeString		= NDIS_STRING_CONST("BusType");
	NDIS_STRING                   BusNumberString	= NDIS_STRING_CONST("BusNumber");
	NDIS_STRING                   DuplexString		= NDIS_STRING_CONST("DUPLEX");
	NDIS_STRING                   FullDupString		= NDIS_STRING_CONST("FULL");
    NDIS_STRING                   HalfDupString		= NDIS_STRING_CONST("HALF");
	NDIS_STRING                   SpeedString		= NDIS_STRING_CONST("SPEED");
    NDIS_STRING                   Speed100String	= NDIS_STRING_CONST("100");
    NDIS_STRING                   Speed10String		= NDIS_STRING_CONST("10");
    NDIS_STRING                   AutoNegString		= NDIS_STRING_CONST("AUTO-NEGOTIATION");
    NDIS_STRING                   DefDupString		= NDIS_STRING_CONST("DEFAULT");
	NDIS_STRING                   IOBase          = NDIS_STRING_CONST("IoBaseAddress");
    NDIS_STRING                   Interrupt       = NDIS_STRING_CONST("InterruptNumber");

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 ==> GetRegistrySettings  \r\n")));

	//Set up the default values
	// First set up defaults.
	Adapter->InterruptVector =
	Adapter->InterruptLevel  = DEFAULT_IRQ;
	Adapter->InterruptType   = CM_RESOURCE_INTERRUPT_LATCHED;
    Adapter->IOBase          = DEFAULT_IO_BASE;
    Adapter->LookAhead       = MAX_LOOKAHEAD_SIZE;
    Adapter->Sqet            = 
	Adapter->Speed           = SPEED100;
	Adapter->Auto_Negotiation = TRUE;
	Adapter->LinkStatus		 = MEDIA_DISCONNECTED;
	Adapter->MACAddress[0] = 
		Adapter->MACAddress[1] = 
		Adapter->MACAddress[2] = 
		Adapter->MACAddress[3] = 
		Adapter->MACAddress[4] = 
		Adapter->MACAddress[5] = 0;
		
	
	//Open the Registry tree for this adapter.
    NdisOpenConfiguration((PNDIS_STATUS) &Status,(PNDIS_HANDLE) &ConfigurationHandle,ConfigurationContext);
	if(Status != NDIS_STATUS_SUCCESS)
    {
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 : ERROR - No information for adapter!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Configure Adapter\r\n")));
        return(NDIS_STATUS_FAILURE);
    }

	//Get configured bus type value from registry,
	NdisReadConfiguration((PNDIS_STATUS) &Status,   
		&ConfigurationParameter,
		ConfigurationHandle,
		(PNDIS_STRING) &BusTypeString,
		NdisParameterInteger); 
	if(Status == NDIS_STATUS_SUCCESS)
	{
		Adapter->BusType = (USHORT) ConfigurationParameter->ParameterData.IntegerData;
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:BusType    = 0x%x\r\n"), Adapter->BusType));
	}
	else
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 : ERROR - BusType not in Registry!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== Configure Adapter\r\n")));
		NdisCloseConfiguration(ConfigurationHandle);
		return(NDIS_STATUS_FAILURE);
	}

	//Get bus number value from registry.
	NdisReadConfiguration((PNDIS_STATUS) &Status,
		&ConfigurationParameter,
		ConfigurationHandle,
		(PNDIS_STRING) &BusNumberString,
		NdisParameterInteger);
	if(Status == NDIS_STATUS_SUCCESS)
	{
		Adapter->BusNumber = (USHORT) ConfigurationParameter->ParameterData.IntegerData;
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:BusNumber    = 0x%x\r\n"), Adapter->BusNumber));
	}	
	else
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ERROR - BusNumber not in Registry!\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111<== Configure Adapter\r\n")));
		NdisCloseConfiguration(ConfigurationHandle);
		return(NDIS_STATUS_FAILURE);
	}

	
	//If both Duplex AND Speed are selected, in the registry, then Auto_Negotiation is false
	//If either of speed or duplex is default or AutoNeg then Auto_Negotiation is turned on !!
	Adapter->Duplex = DEFAULT_VALUE;
	NdisReadConfiguration((PNDIS_STATUS) &Status,
		&ConfigurationParameter,
		ConfigurationHandle,
		(PNDIS_STRING) &DuplexString,
		NdisParameterString);
	
	if(Status == NDIS_STATUS_SUCCESS)
	{
		if( NdisEqualString( (PNDIS_STRING) &ConfigurationParameter->ParameterData.StringData,(PNDIS_STRING) &AutoNegString,TRUE ) ) 
		{
			DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:Config is Auto-Negotiation\r\n")));
			Adapter->Duplex = AUTO_NEGOTIATION;
		}
		else
			if( NdisEqualString( (PNDIS_STRING) &ConfigurationParameter->ParameterData.StringData,(PNDIS_STRING) &DefDupString,	TRUE ) ) 
			{
				DEBUGMSG(ZONE_INIT, (TEXT("Config is Default\r\n")));
				Adapter->Duplex = DEFAULT_VALUE;
			}
			else
				if( NdisEqualString( (PNDIS_STRING) &ConfigurationParameter->ParameterData.StringData,(PNDIS_STRING) &FullDupString,TRUE ) ) 
				{
					DEBUGMSG(ZONE_INIT, (TEXT("Config is Full Duplex\r\n")));
					Adapter->Duplex = FULL_DUPLEX;
				}
				else
					if( NdisEqualString( (PNDIS_STRING) &ConfigurationParameter->ParameterData.StringData,(PNDIS_STRING) &HalfDupString,TRUE ) ) 
					{
						DEBUGMSG(ZONE_INIT, (TEXT("Config is Half Duplex\r\n")));
						Adapter->Duplex = HALF_DUPLEX;
					}
					
	}	
	
	Adapter->Speed = DEFAULT_VALUE;
	NdisReadConfiguration((PNDIS_STATUS) &Status, 
		&ConfigurationParameter, 
		ConfigurationHandle,
		(PNDIS_STRING) &SpeedString,
		NdisParameterString);
	if(Status == NDIS_STATUS_SUCCESS) 
	{
		if( NdisEqualString( (PNDIS_STRING) &ConfigurationParameter->ParameterData.StringData,(PNDIS_STRING) &AutoNegString,TRUE ) )
		{
			DEBUGMSG(ZONE_INIT, (TEXT("Config is Auto-Negotiation\r\n")));					
			Adapter->Speed = AUTO_NEGOTIATION;
		}
		else
			if( NdisEqualString( (PNDIS_STRING) &ConfigurationParameter->ParameterData.StringData,(PNDIS_STRING) &DefDupString,	TRUE ) )
			{
				DEBUGMSG(ZONE_INIT, (TEXT("Config is Default\r\n")));						
				Adapter->Speed = DEFAULT_VALUE;
			}
			else
				if( NdisEqualString( (PNDIS_STRING) &ConfigurationParameter->ParameterData.StringData,(PNDIS_STRING) &Speed100String,TRUE ) ) 
				{
					DEBUGMSG(ZONE_INIT, (TEXT("Config is 100 Mbps\r\n")));
					Adapter->Speed = SPEED100;
				}
				else
					if( NdisEqualString( (PNDIS_STRING) &ConfigurationParameter->ParameterData.StringData,(PNDIS_STRING) &Speed10String,TRUE ) )
					{
						DEBUGMSG(ZONE_INIT, (TEXT("Config is 10 Mbps\r\n")));
						Adapter->Speed = SPEED10;
					}
	}
	if ((Adapter->Speed == DEFAULT_VALUE)  || (Adapter->Speed == AUTO_NEGOTIATION) ||
	   ((Adapter->Duplex == DEFAULT_VALUE) || ( Adapter->Duplex == AUTO_NEGOTIATION )))
		Adapter->Auto_Negotiation = TRUE;
	else
		Adapter->Auto_Negotiation = FALSE;

	//Check for updates to IRQ value.
    NdisReadConfiguration((PNDIS_STATUS) &Status,
		&ConfigurationParameter,
		ConfigurationHandle,
		(PNDIS_STRING) &Interrupt,
		NdisParameterInteger);	
    if(Status == NDIS_STATUS_SUCCESS)
    {
        DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:New IRQ Value found in register.. overiding the default value\r\n")));
		Adapter->InterruptVector	=
		Adapter->InterruptLevel		= (USHORT) (ConfigurationParameter->ParameterData.IntegerData);
		Adapter->InterruptType = CM_RESOURCE_INTERRUPT_LATCHED;		
	}
	else
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:Unable to read Interrupt from Registry using default value!!!\r\n")));
	}	

	//Check for update IOBase address
	NdisReadConfiguration((PNDIS_STATUS) &Status,
		&ConfigurationParameter,
		ConfigurationHandle,
		(PNDIS_STRING) &IOBase,
		NdisParameterInteger);
	if (Status == NDIS_STATUS_SUCCESS)
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:New IOBase address found in register.. overiding the default value\r\n")));
		Adapter->IOBase = (UINT) (ConfigurationParameter->ParameterData.IntegerData);
	}

	//Make sure we're still okay.
	if(Status != NDIS_STATUS_SUCCESS)
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== Configure Adapter\r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:ERROR: Config Handler Failed!\n")));
		return(Status);
	}
				
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:BusNumber  = %d\r\n"), Adapter->BusNumber));
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:BusType    = %d\r\n"), Adapter->BusType));
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:IoBase     = %04x\r\n"), Adapter->IOBase));
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:Interrupt  = %d\r\n"), Adapter->InterruptLevel));
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:Speed		= %d\r\n"), Adapter->Speed));
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:Duplex		= %d\r\n"), Adapter->Duplex));
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:SQET       = %d\r\n"), Adapter->Sqet));
	
	//See if user has defined new MAC address.
	NdisReadNetworkAddress((PNDIS_STATUS) &Status,
		(PVOID *) &NewNetworkAddress,
		&NewNetworkAddressLength,
		ConfigurationHandle);
				
	if((Status == NDIS_STATUS_SUCCESS) && (NewNetworkAddressLength != 0))
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:H/W MAC Address over-ride!\r\n")));
		if((NewNetworkAddressLength != ETH_LENGTH_OF_ADDRESS)) 
		{
			DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:Invalid MAC address length!\r\n")));
		}
		else
		{
				Adapter->MACAddress[0] = NewNetworkAddress[0];
				Adapter->MACAddress[1] = NewNetworkAddress[1];
				Adapter->MACAddress[2] = NewNetworkAddress[2];
				Adapter->MACAddress[3] = NewNetworkAddress[3];
				Adapter->MACAddress[4] = NewNetworkAddress[4];
				Adapter->MACAddress[5] = NewNetworkAddress[5];

				DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:New MAC Address = %.2x-%.2x-%.2x-%.2x-%.2x-%.2x\r\n"),
							Adapter->MACAddress[0],
							Adapter->MACAddress[1],
							Adapter->MACAddress[2],
							Adapter->MACAddress[3],
							Adapter->MACAddress[4],
							Adapter->MACAddress[5]));				
		}
	}
	else
	{
		Status = NDIS_STATUS_SUCCESS;
	}
	Adapter->ConfigReg |= CFG_NO_WAIT;
	NdisCloseConfiguration(ConfigurationHandle);
				
	if(Status != NDIS_STATUS_SUCCESS)
	{
			DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:ERROR: Specific Configuration Handler Failed!\r\n")));
			DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== Configure Adapter\r\n")));
			return(Status);
	}
	
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111 <== GetRegistrySettings  \r\n")));
	return(Status);


}

/*
 Function Name : 	AdapterVerify
 Description   :    
                    Verifies if the current driver supports the chip.
                       This driver supports only LAN91C111/LAN91C113
 Parameters    :
                    MINIPORT_ADAPTER *Adapter - Pointer to the adapter structure
 Return Value  :
                    TRUE - Supported
                    FALSE - This driver doesn't support the chip.
*/

BOOLEAN AdapterVerify(MINIPORT_ADAPTER  *Adapter)
{
	USHORT      TempStore;
    UINT        IOBase;
	USHORT      ChipInfo;
    	
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:==> Adapter Verify \r\n")));
	IOBase = Adapter->IOBase;

	//Check for the correct bank select
	NdisRawReadPortUshort( IOBase + BANK_SELECT, (USHORT *) &TempStore );
    if((TempStore & BANK_ID_MASK) != BANK_UPPER)
    {
        DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:ERROR : Invalid BankSelect Constant===0x%x!\r\n"),IOBase));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== Adapter Verify \r\n")));
        return(FALSE);
    }

	//Store the current Config register value
    NdisRawWritePortUshort(IOBase + BANK_SELECT,(USHORT) 1);	
	NdisRawReadPortUshort(IOBase + BANK1_CONFIG,(PUSHORT) &Adapter->ConfigReg);

	//Get Chip ID and Revision.
    NdisRawWritePortUshort(IOBase + BANK_SELECT,(USHORT) 3);
	NdisRawReadPortUshort(IOBase + BANK3_REV,(USHORT *) &ChipInfo);
	Adapter->ChipID = (ChipInfo & REV_CHIP_ID) >> 4;
	Adapter->ChipRev = ChipInfo & REV_REV_ID;
    if (Adapter->ChipID != LAN91C111_CHIPID)
	{
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111: ERROR : Invalid LAN Chip and Driver Combination \r\n")));
		DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== Adapter Verify \r\n")));
		return (FALSE);
	}

	//Set the NO_WAIT in Bank1/Offset0
	NdisRawWritePortUshort( Adapter->IOBase + BANK_SELECT, (USHORT) 1 );
	Adapter->ConfigReg |= CFG_NO_WAIT; 
	NdisRawWritePortUshort( Adapter->IOBase +  BANK1_CONFIG, Adapter->ConfigReg);

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== Adapter Verify \r\n")));
	return TRUE;
	
}


/*
 Function Name : 	AdapterReset
 Description   :
                    Issues a soft reset to the chip. And re-initializes the adapter structure variables.
                        Also re-establishes the link.
 Parameters    :
                    MINIPORT_ADAPTER *Adapter - Pointer to the adapter structure
 Return Value  :
                    TRUE    - Reset is successful 
                        else FALSE

*/

BOOLEAN     AdapterReset(MINIPORT_ADAPTER *Adapter)
{

	UINT        IOBase, Counter;
    USHORT     *EthAddress;

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:==> Adapter Reset %x\r\n"), Adapter->IOBase));
	IOBase = Adapter->IOBase;

	//Clear the card's interrupt mask register
    NdisRawWritePortUshort( IOBase+BANK_SELECT, 2 );
    NdisRawWritePortUshort( IOBase + BANK2_INT_STS, (USHORT)0 );

	Adapter->State = RESET_STATE;

	//Output reset to the card.
    NdisRawWritePortUshort( IOBase+BANK_SELECT, 0 );
    NdisRawWritePortUshort( IOBase + BANK0_RCR, (USHORT) RCR_RESET );
	NdisStallExecution(1);  //Initiated by writing bit hight and terminated by writing low.
	NdisRawWritePortUshort( IOBase + BANK0_RCR, (USHORT) 0);
	
	//Write the MAC Address.
	//If the MAC address was stored in the registry then we write it to the LAN91C111 else
	//if the MAC address was from ROM then we store the value to the driver's storage
	EthAddress = (PUSHORT) &Adapter->MACAddress;
	NdisRawWritePortUshort(IOBase + BANK_SELECT,(USHORT) 1);
	if(((*EthAddress)|(*(EthAddress+2))|(*(EthAddress+4)))!=0)
    {
		
		NdisRawWritePortUshort(IOBase + BANK1_IA0,  *EthAddress++);
		NdisRawWritePortUshort(IOBase + BANK1_IA2,  *EthAddress++);
		NdisRawWritePortUshort(IOBase + BANK1_IA4,  *EthAddress);
    }
    else
    {
		NdisRawReadPortUshort(IOBase + BANK1_IA0,   EthAddress++);
		NdisRawReadPortUshort(IOBase + BANK1_IA2,   EthAddress++);
		NdisRawReadPortUshort(IOBase + BANK1_IA4,   EthAddress);
    }

	//Write to the Configuration register
	Adapter->ConfigReg = 0xA0B1;
	NdisRawWritePortUshort(IOBase + BANK_SELECT,(USHORT) 1);
    NdisRawWritePortUshort(IOBase + BANK1_CONFIG, Adapter->ConfigReg);
	
	//Restore Multicast Hash Table.
    NdisRawWritePortUshort(IOBase + BANK_SELECT, (USHORT) 3 );
 	for(Counter = 0;Counter < 8;Counter += 2)
		NdisRawWritePortUshort(IOBase + BANK3_MT01 + Counter, *(&Adapter->HashTable[Counter]));

	// Output control register.
    NdisRawWritePortUshort( IOBase + BANK_SELECT, (USHORT) 1 );
	Adapter->CtrlRegister = 0x1210 | CTL_LE_EN | CTL_CR_EN | CTL_TE_EN;
	NdisRawWritePortUshort(IOBase + BANK1_CTL, Adapter->CtrlRegister);

	//Setup Receive control Register
	Adapter->RCVAllMulticast = TRUE;
	Adapter->RCVBroadcast = TRUE;
	Adapter->PromiscuousMode = FALSE;
	Adapter->RCR = RCR_RX_EN;
	Adapter->RCR |= RCR_STRP_CRC;
	NdisRawWritePortUshort( IOBase + BANK_SELECT, (USHORT) 0);
	NdisRawWritePortUshort(IOBase + BANK0_RCR, Adapter->RCR);

	//Clear operational flags.
    Adapter->IsAllocateActive =          //  Allocate not in progress
    Adapter->IsDpcRunning     =          //  DPC not active
    Adapter->AllocateFlag     =          //  No allocations pending
    Adapter->IsWriteActive    = FALSE;   //  No writes pending
	Adapter->MaxXmits		  = 1;
	Adapter->TxUnderRunFixed  = FALSE;

	//Clear all the statistic counter
	Adapter->Stat_RxError		=
		Adapter->Stat_RxOK		=
		Adapter->Stat_RxOvrn	=
		Adapter->Stat_TxError	=
		Adapter->Stat_TxOK		= 
		Adapter->Stat_AlignError =
		Adapter->Stat_MultiColl = 
		Adapter->Stat_SingleColl = 0;

    //Initialize Queues.
    ClearPacketQue(Adapter->AllocPending);
    ClearPacketQue(Adapter->WritePending);
    ClearPacketQue(Adapter->AckPending);

    Adapter->TransmitQueueDepth	=
    Adapter->XmitPending		=
    Adapter->ChkHangCnt			= 0;

	Sleep(35);
	//Establish the Link
	EstablishLink(Adapter);

	//Setup Transmit Control Register
	Adapter->TCR = (USHORT)(TCR_TX_ENA | TCR_PAD_EN | TCR_MON_CSN);
	if (Adapter->Duplex == FULL_DUPLEX)
		Adapter->TCR |= TCR_SWFDUP;
	NdisRawWritePortUshort(IOBase+BANK_SELECT, (USHORT) 0);
	NdisRawWritePortUshort( IOBase + BANK0_TCR, Adapter->TCR);

	Adapter->State = NORMAL_STATE;

	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111:<== Adapter Reset %x\r\n"), Adapter->IOBase));
	return TRUE;
}

/*
 Function Name : 	BackOut				
 Description   :    
                    Called when the driver is unloaded. This releases all the OS resources
                     used by the chip and the driver.
 Parameters    :
                    MINIPORT_ADAPTER *Adapter
 Return Value  :
                    VOID
*/

void        BackOut				(MINIPORT_ADAPTER *Adapter)
{
	ULONG		IOBase; 
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111==> BackOut\r\n")));
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111==> Releasing all LAN91C111 resources\r\n")));
	
    IOBase = Adapter->IOBase;

	// Release the IRQ.                   
    NdisMDeregisterInterrupt(&Adapter->InterruptInfo);
	
    //Release the I/O Range.
    NdisMDeregisterIoPortRange(Adapter->AdapterHandle,IOBase,16, (PVOID)IOBase);
    
    //Release the LookAhead Buffer.
    NdisFreeMemory(Adapter->LookAheadBuffer, LOOK_AHEAD_BUFFER_SIZE,  0);

	//Put the PHY in low power mode
	NdisRawWritePortUshort( Adapter->IOBase + BANK_SELECT, (USHORT) 1 );
	NdisRawWritePortUshort( IOBase + BANK1_CONFIG, 0x20B1);
    
	//Release the adapter structure.
    NdisFreeMemory(Adapter, MINIPORT_ADAPTER_SIZE, 0);
	DEBUGMSG(ZONE_INIT, (TEXT("LAN91C111<== BackOut\r\n")));
    return;
}



/*
 Function Name : 	DumpRegisters
 Description   :
                    This function is used for debugging. This dumps the contents of the all 
                      the registers in the chip. This doesn't maintain the bank select status
                      This might affect some register values, which are sensitive to read.
 Parameters    :
                    MINIPORT_ADAPTER    *Adapter - Pointer to the adapter structure

 Return Value  :
                    VOID
*/


VOID		DumpRegisters		(MINIPORT_ADAPTER *Adapter)
{
	USHORT		Bank, 
		Offset;
	USHORT		Value;
	UINT		IOBase = Adapter->IOBase;	
	
	for (Bank=0; Bank <=3; Bank++)  //Cycle the banks
	{
		NdisRawWritePortUshort(IOBase + BANK_SELECT,Bank);
		for (Offset=0; Offset <= 0xE; Offset+=2)    //cycle the registers
		{
			NdisRawReadPortUshort(IOBase+Offset,(PUSHORT)&Value);
			RETAILMSG(ZONE_INIT, (TEXT("(%x,%x)=%4X\r\n"), Bank, Offset, Value));
		}
	}
}



/*
 Function Name : 	DumpBuffer
 Description   :    
                    This function dumps the contents of a buffer specified by the Buffer parameter of size Size.
                    This useful when it's required to dump the Tx/Rx packet buffers.
 Parameters    :
                    UCHAR *Buffer   - Pointer to the buffer to dump
                    INT     Size    - No. bytes to dump
 Return Value  :
                    VOID
*/

VOID DumpBuffer (UCHAR *Buffer, INT Size)
{
	int i;
	if (Buffer[0] == 0xFF) return; //Donot Print Broadcasted packet.

	DEBUGMSG(ZONE_INIT, (TEXT("Dumping Packet, Size=%d"), Size));	
	for (i=0; i<Size; i++)
		DEBUGMSG(ZONE_INIT, (TEXT("%d, %x"), i,Buffer[i]));	
}