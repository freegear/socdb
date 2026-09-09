// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech 
// -----------------------------------------------------------------
// Version and Release information: NetWorkBus Ver 0.2
// File Name           : genDef.c 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : main function source for RTL gen
//  ----------------------------------------------------------------


//  =================================================================
//      Include 
//  ----------------------------------------------------------------
#include <stdio.h>
#define _EXTERN
#include "Bus.h"
#include "genDef.h"
#include "MkFile.h"

//  =================================================================
//      Function declaration
//  ----------------------------------------------------------------

//  ----------------------------------------------------------------
//  counting the bits function
//  unsigned int DefBit(unsigned int In)//
//  ----------------------------------------------------------------
unsigned int DefBit(unsigned int In)
{
    char VAL[50];
    int i;

    if(In == 0)
        return 1;

    for(i=31; i >= 0; i--)
        if(((In >> i) & 0x00000001) == 0x1) 
        {
            return i+1;
        }

}

//  ----------------------------------------------------------------
//  getting the max id number function
//  unsigned int getMaxID(DefSlave *VAL_SLAVE) 
//  ----------------------------------------------------------------
/* 
 * Largest slave interface ID width + 
 * log2(total number of slave interface 
 */
unsigned int getMaxID(DefSlave *VAL_SLAVE) {

    int i,j;
    int conWRCHMasterCnt=0;
    int conRDCHMasterCnt=0;
    int conMasterCnt=0;
    unsigned int maxWriteIdWid=0;
    unsigned int maxReadIdWid=0;

    for(i=0;ValMAIN.MasterNumber > i; i++){
        for(j=0;ValMAIN.SlaveNumber>j; j++){

            if(strcmp(ValMASTER[i].ConnectSlave[j],VAL_SLAVE->name)==0)
            {
                strcpy(VAL_SLAVE->ConnectMaster[conMasterCnt],ValMASTER[i].name);
                conMasterCnt++;
            //Write ch________________________________________________
                if(ValMASTER[i].WriteChPort.ChannelEnable == ENABLE)
                {
                    conWRCHMasterCnt++;
                    if(ValMASTER[i].writeidwid > maxWriteIdWid)
                        maxWriteIdWid = ValMASTER[i].writeidwid;
                }

            //Read ch_________________________________________________
                if(ValMASTER[i].ReadChPort.ChannelEnable == ENABLE)
                {
                    conRDCHMasterCnt++;
                    if(ValMASTER[i].readidwid > maxReadIdWid)
                        maxReadIdWid = ValMASTER[i].readidwid;
                }
            }

        } //forloop j
    } //forloop i


    VAL_SLAVE->writeidwid = (maxWriteIdWid + DefBit(conWRCHMasterCnt-1));
    VAL_SLAVE->readidwid  = (maxReadIdWid + DefBit(conRDCHMasterCnt-1));

    VAL_SLAVE->SelMasterWid = DefBit(conMasterCnt -1);
    VAL_SLAVE->SelWriteWid  = DefBit(conWRCHMasterCnt -1);
    VAL_SLAVE->SelReadWid   = DefBit(conRDCHMasterCnt -1);

    return VAL_SLAVE->SelMasterWid;
} //getMaxID

//  ----------------------------------------------------------------
//  getting the max id for default slave 
//  unsigned int getDefaultID(DefSlave *VAL_SLAVE);
//  ----------------------------------------------------------------
unsigned int getDefaultID(DefSlave *VAL_SLAVE) {

    int i;
    int conWRCHMasterCnt=0;
    int conRDCHMasterCnt=0;
    int conMasterCnt=0;
    unsigned int maxWriteIdWid=0;
    unsigned int maxReadIdWid=0;

    for(i=0;ValMAIN.MasterNumber > i; i++)
    {
        strcpy(VAL_SLAVE->ConnectMaster[conMasterCnt],ValMASTER[i].name);
        conMasterCnt++;
        //Write ch________________________________________________
                if(ValMASTER[i].WriteChPort.ChannelEnable == ENABLE)
                {
                    conWRCHMasterCnt++;
                    if(ValMASTER[i].writeidwid > maxWriteIdWid)
                        maxWriteIdWid = ValMASTER[i].writeidwid;
                }

        //Read ch_________________________________________________
                if(ValMASTER[i].ReadChPort.ChannelEnable == ENABLE)
                {
                    conRDCHMasterCnt++;
                    if(ValMASTER[i].readidwid > maxReadIdWid)
                        maxReadIdWid = ValMASTER[i].readidwid;
                }

        //priority setting
        strcpy(VAL_SLAVE->OperateArbiter.PriorityMaster[i],
               ValMASTER[i].name);
    }

    

    VAL_SLAVE->writeidwid = (maxWriteIdWid + DefBit(conWRCHMasterCnt-1));
    VAL_SLAVE->readidwid  = (maxReadIdWid + DefBit(conRDCHMasterCnt-1));

    VAL_SLAVE->SelMasterWid = DefBit(conMasterCnt -1);
    VAL_SLAVE->SelWriteWid  = DefBit(conWRCHMasterCnt -1);
    VAL_SLAVE->SelReadWid   = DefBit(conRDCHMasterCnt -1);

    //printf("defaultSlave_SelMasterWid[%d]\n", VAL_SLAVE->SelMasterWid);
    return VAL_SLAVE->SelMasterWid;
}

//  ----------------------------------------------------------------
//  generating the parameter value & definition to write PARA
//
//  unsigned int genDef(DefMain *VAL_MAIN, 
//                      DefMaster *VAL_MASTER,
//                      DefSlave *VAL_SLAVE,
//                      int ReadWrite)

/*
 * ReadWrite == 1  => Read
 * ReadWrite == 0  => Write
 * ReadWrite == 5  => Write/Read Chmerge
 *
 * VAL_MASTER == NULL --> Slave channel
 * VAL_SLAVE  == NULL --> Master channel
 */
//  ----------------------------------------------------------------

unsigned int genDef(DefMain *VAL_MAIN, DefMaster *VAL_MASTER ,
                    DefSlave *VAL_SLAVE,
                    int ReadWrite
                    )
{

    char writeBuff[MAX_PARAMETER][80];

    /*
    int masterNumWidth= (int)(VAL_MAIN->MasterNumber/2)+1;
    int slaveNumWidth = (int)(VAL_MAIN->SlaveNumber/2)+1;
    */
    int masterNumWidth= (int)DefBit(VAL_MAIN->MasterNumber);
    // '+1' ==> default slave count
    int slaveNumWidth = (int)DefBit(VAL_MAIN->SlaveNumber + 1);
    int masterWidth; 
    int slaveWidth;
    int selMasterWid  = (int)(VAL_SLAVE->SelMasterWid);
    int i;
    int Connect[MAXMASTER];
    int ReadWrite_int;

    if(ReadWrite == 5)  ReadWrite_int = 0;
    else                ReadWrite_int = ReadWrite;

    if(VAL_MASTER == NULL)
        getConnectMaster(VAL_SLAVE, Connect, ReadWrite_int);

    
    masterWidth = 0;
    slaveWidth = 0;
    if(VAL_MASTER != NULL)
    {
        //Read channel
        if(ReadWrite_int == 1) 
        {
            masterWidth = (int)(VAL_MASTER->readidwid);
        }
        else 
        //Write channel
        {
            masterWidth = (int)(VAL_MASTER->writeidwid);
        }

        //Read channel
        if(ReadWrite_int == 1) 
        {
            slaveWidth  = (int)(VAL_SLAVE->readidwid);
        }
        else 
        //Write channel
        {
            slaveWidth  = (int)(VAL_SLAVE->writeidwid);
        }
    }
    else
    {
        for(i=0 ; ValMAIN.MasterNumber > i ; i++)
        {
            //Read channel
            if((ReadWrite_int == 1) && (Connect[i] == 1))
            {
                if(ValMASTER[i].readidwid > masterWidth)
                    masterWidth = ValMASTER[i].readidwid;
            }
            //Write channel
            else if((ReadWrite_int == 0) && (Connect[i] == 1))
            {
                if(ValMASTER[i].writeidwid > masterWidth)
                    masterWidth = ValMASTER[i].writeidwid;
            }

            if(ReadWrite_int == 1)
                slaveWidth  = (int)(VAL_SLAVE->readidwid);
            else
                slaveWidth  = (int)(VAL_SLAVE->writeidwid);

        }
    }

    /* Bus width */
    if(snprintf(PARA[0][1],(sizeof(char)*4),"%d",VAL_MAIN->BusWidth)
        ==-1){
        printf("Error snprintf process :: Bus width");
        return FILE_PROCESS_ERROR;
    }

    /* Address width */
    if(snprintf(PARA[1][1],(sizeof(char)*4),"%d",VAL_MAIN->AddrWidth)
        ==-1){
        printf("Error snprintf process :: Address width");
        return FILE_PROCESS_ERROR;
    }

    /* Master ID width */
    if(snprintf(PARA[2][1],(sizeof(char)*4),"%d",masterWidth)
        ==-1){
        printf("Error snprintf process :: Master width");
        return FILE_PROCESS_ERROR;
    }

    /* Slave ID width */
    if(snprintf(PARA[3][1],(sizeof(char)*4),"%d",slaveWidth)
        ==-1){
        printf("Error snprintf process :: slaveWidth width");
        return FILE_PROCESS_ERROR;
    }

    /* WSTRB width */
    if(snprintf(PARA[10][1],(sizeof(char)*4),"%d",VAL_MAIN->BusWidth/8)
        ==-1){
        printf("Error snprintf process :: slaveWidth width");
        return FILE_PROCESS_ERROR;
    }

    /* MASTER Number width */
    if(snprintf(PARA[18][1],(sizeof(char)*4),"%d",masterNumWidth)
        ==-1){
        printf("Error snprintf process :: Master number width");
        return FILE_PROCESS_ERROR;
    }

    /* SLAVE Number width */
    if(snprintf(PARA[19][1],(sizeof(char)*4),"%d",slaveNumWidth)
        ==-1){
        printf("Error snprintf process :: Slave number width");
        return FILE_PROCESS_ERROR;
    }

    /* MASTER Number */
    if(snprintf(PARA[21][1],(sizeof(char)*4),"%d",VAL_MAIN->MasterNumber)
        ==-1){
        printf("Error snprintf process :: Master number ");
        return FILE_PROCESS_ERROR;
    }

    /* SLAVE Number */
    if(snprintf(PARA[20][1],(sizeof(char)*4),"%d",(1+VAL_MAIN->SlaveNumber))
        ==-1){
        printf("Error snprintf process :: Slave number ");
        return FILE_PROCESS_ERROR;
    }

    /* Select Master width */


    //VAL_SLAVE->SelWriteWid  = DefBit(conWRCHMasterCnt -1);
    //VAL_SLAVE->SelReadWid   = DefBit(conRDCHMasterCnt -1);
    if(VAL_MASTER == NULL && ReadWrite_int == 0)
    {
        if(snprintf(PARA[22][1],(sizeof(char)*4),"%d",VAL_SLAVE->SelWriteWid) ==-1){
            printf("Error snprintf process :: Select master width ");
            return FILE_PROCESS_ERROR;
        }
    }

    if(VAL_MASTER == NULL && ReadWrite_int == 1)
    {
        if(snprintf(PARA[22][1],(sizeof(char)*4),"%d",VAL_SLAVE->SelReadWid) ==-1){
            printf("Error snprintf process :: Select master width ");
            return FILE_PROCESS_ERROR;
        }
    }

    if(VAL_MASTER == NULL && ReadWrite == 5)
    {
        if(snprintf(PARA[28][1],(sizeof(char)*4),"%d",VAL_SLAVE->SelReadWid) ==-1){
            printf("Error snprintf process :: Select master width ");
            return FILE_PROCESS_ERROR;
        }
    }

    /* 
     * slave count width  :: Write channel permitCtl block 
     * WriteIssuingCap
     */
    if(VAL_MASTER != NULL)
    {
        if(snprintf(PARA[25][1],(sizeof(char)*4),"%d",VAL_MASTER->WriteIssuingCap) ==-1){
            printf("Error snprintf process :: WriteIssuingCap ");
            return FILE_PROCESS_ERROR;
        }

    /* 
     * slave count width  :: Read channel permitCtl block 
     * ReadIssuingCap
     */
        if(snprintf(PARA[26][1],(sizeof(char)*4),"%d",VAL_MASTER->ReadIssuingCap) ==-1){
            printf("Error snprintf process :: ReadIssuingCap ");
            return FILE_PROCESS_ERROR;
        }
    }

    /* 
     * master count width  :: write channel ReqInter block 
     * WriteIssuingCap
     */
    if(snprintf(PARA[23][1],(sizeof(char)*4),"%d",VAL_SLAVE->WriteIssuingCap) ==-1){
        printf("Error snprintf process :: WriteIssuingCap ");
        return FILE_PROCESS_ERROR;
    }

    /* 
     * master count width  :: read channel ReqInter block 
     * WriteIssuingCap
     */
    if(snprintf(PARA[24][1],(sizeof(char)*4),"%d",VAL_SLAVE->ReadIssuingCap) ==-1){
        printf("Error snprintf process :: ReadIssuingCap ");
        return FILE_PROCESS_ERROR;
    }

    /*
    if(snprintf(PARA[28][1],(sizeof(char)*4),"%d",VAL_SLAVE->ReadIssuingCap) ==-1){
        printf("Error snprintf process :: ReadIssuingCap ");
        return FILE_PROCESS_ERROR;
    }
    */

    return BUS_ERROR_NONE;
}

//  ----------------------------------------------------------------
//  generating the parameter value & definition to write file
//
//  unsigned int genPARA(void)
//  ----------------------------------------------------------------
unsigned int genPARA(void)
{

    FILE *Fp;
    char *buff;
    char *fileName;
    struct codeLine *head_ptr = NULL;
    int    endSlaveNum, i, j;

    buff = (char *)malloc(sizeof(char) * 300);
    fileName = (char *)malloc(sizeof(char) * 300);

    endSlaveNum  = (int)ValMAIN.SlaveNumber;

    //___________________________________________    PARAMETER generation
    for(i=0; endSlaveNum >i ; i++)
    {

        head_ptr = malloc(sizeof(struct codeLine));
        head_ptr->code = (char *)malloc(sizeof(char) * 120);
        head_ptr->next_ptr = NULL;
        strcpy(head_ptr->code,"//START_PARA\n");

        sprintf(fileName, "../%s/parameter/%s_PARA",ValMAIN.name,ValSLAVE[i].name);
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 1); //WriteChannel

        for(j=0; 17 > j; j++)
        {
            int temp;
            if(j == 2)
            {
                temp = sprintf(buff, "parameter WRITECH_ID_WID = %d;\n", ValSLAVE[i].writeidwid);
                inDataLink(head_ptr, buff);
                genDef(&ValMAIN, NULL, &ValSLAVE[i], 0); //ReadChannel
                temp = sprintf(buff, "parameter READCH_ID_WID = %d;\n", ValSLAVE[i].readidwid);
            }
            else
                temp = sprintf(buff, "%s %s;\n", PARA[j][0], PARA[j][1]);

            if(temp == -1)
            {
                printf("Error sprintf process :: Buffer remove ");
                free(buff);
                free(fileName);
                return FILE_PROCESS_ERROR;
            }
            inDataLink(head_ptr, buff);
        }
        fprintLink(head_ptr, NULL ,  fileName);
    }

    free(buff);
    free(fileName);

    return BUS_ERROR_NONE;
}
