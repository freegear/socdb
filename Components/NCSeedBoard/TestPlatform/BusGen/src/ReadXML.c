#include <stdio.h>
#include <libxml/xmlreader.h>
#include <string.h>

# ifndef BUS_H
#include "Bus.h"
# endif

#define MAIN_MaxParaNum 17
#define MASTER_MaxParaNum 20
#define SLAVE_MaxParaNum 20

static unsigned int GetValueCnt=0;
static unsigned int slaveCnt;
static unsigned int masterCnt;
unsigned int errCnt=0;


//Format description
static char MainGetValue[MAIN_MaxParaNum][MAXNAMELEN]  = {
    //Main parameter
    {"name"},         //0
    {"width"},        //1
    {"buswidth"},     //2
    {"addresswidth"}, //3
    {"channel_connection"}, //4
    {"write_addr"},         //5
    {"write_data"},         //6
    {"write_resp"},         //7
    {"read_addr"},          //8
    {"read_data"},          //9
    {"memory_map"},         //10
    {"remap_enable"},       //11
    {"map0"},               //12
    {"slave"},              //13
    {"map1"},               //14
    {"slave"},              //15
    {"map1"}                //16
    };

static char MasterGetValue[MASTER_MaxParaNum][MAXNAMELEN]  = {
    //Main parameter
    {"Master"},                 //0
    {"conslave_name"},          //1
    {"method"},                 //2
    {"lock_access"},            //3
    {"write_issuing_cap"},      //4
    {"read_issuing_cap"},       //5
    {"writechannel"},           //6
    {"channel_enable"},         //7
    {"lock"},                   //8
    {"cache"},                  //9
    {"protect"},                //10
    {"wstrb"},                  //11
    {"readchannel"},            //12
    {"channel_enable"},         //13
    {"lock"},                   //14
    {"cache"},                  //15
    {"protect"},                //16
    {"mastertosi"},             //17
    {"sitomi"},                 //18
    {"Master"}                  //19
    };

static char SlaveGetValue[SLAVE_MaxParaNum][MAXNAMELEN]  = {
    //Main parameter
    {"Slave"},                  //0
    {"method"},                 //1
    {"mastername"},             //2
    {"write_issuing_cap"},      //3
    {"read_issuing_cap"},       //4
    {"FIXED"},                  //5
    {"INCR"},                   //6
    {"WRAP"},                   //7
    {"channel_enable"},         //8
    {"lock"},                   //9
    {"cache"},                  //10
    {"protect"},                //11
    {"wstrb"},                  //12
    {"channel_enable"},         //13
    {"lock"},                   //14
    {"cache"},                  //15
    {"protect"},                //16
    {"slavetomi"},              //17
    {"mitosi"},                 //18
    {"Slave"}                   //19
    };


int ErrSlaveCnt=0;
int ErrMasterCnt=0;
int ErrMainCnt=0;
int ErrDefault=0;

static void checkError(xmlTextReaderPtr reader) {
    const xmlChar *name, *value;

    name = xmlTextReaderConstName(reader);

    if (name == NULL)
	name = BAD_CAST "--";

    if(strcmp((char *)name, (char *)SlaveGetValue[0])==0) 
        ErrSlaveCnt++;

    if(strcmp((char *)name, (char *)MasterGetValue[0])==0) 
        ErrMasterCnt++;

    if(strcmp((char *)name, (char *)MainGetValue[0])==0) 
        ErrMainCnt++;

    if(xmlTextReaderHasAttributes(reader)==1 && 
       strcmp((char *)name, (char *)SlaveGetValue[0])==0 && 
       xmlTextReaderNodeType(reader)==1  &&
       strcmp((char*)xmlTextReaderGetAttribute (reader, "name"), "default")==0
       )
        ErrDefault = 1;
}


unsigned int defineCheckError(const char *filename) {
    xmlTextReaderPtr reader;
    int ret;

    /*
     * Pass some special parsing options to activate DTD attribute defaulting,
     * entities substitution and DTD validation
     */
    reader = xmlReaderForFile(filename, NULL,
                 XML_PARSE_DTDATTR |  /* default DTD attributes */
		         XML_PARSE_NOENT |    /* substitute entities */
		         XML_PARSE_DTDVALID); /* validate with the DTD */

    if (reader != NULL) {
        ret = xmlTextReaderRead(reader);
        while (ret == 1) {
            checkError(reader);
            ret = xmlTextReaderRead(reader);
        }


        if(ErrMainCnt != 2)
        {
            printf("Not suffcident main definition parameter, [%d] \n", (ErrMainCnt)/2);
            return BUS_ERROR_NOT_SUFFICIENT;
        }

        if(ErrDefault != 1)
        {
            printf("Don't find Default slave definition parameter\n"); 
            printf("The Default slave name must be \"default\" \n"); 
            return BUS_ERROR_NOT_SUFFICIENT;
        }


	/*
	 * Once the document has been fully parsed check the validation results
	 */
	if (xmlTextReaderIsValid(reader) != 1) {
	    fprintf(stderr, "Document %s does not validate\n", filename);
	}
        xmlFreeTextReader(reader);
        if (ret != 0) {
            fprintf(stderr, "%s : failed to parse\n", filename);
        }
    } else {
        fprintf(stderr, "Unable to open %s\n", filename);
    }

    return BUS_ERROR_NONE;
}



static unsigned int parsingDefSlave(xmlTextReaderPtr reader, DefSlave *VAL_SLAVE){
    const xmlChar *name, *value;
    int i;

    name = xmlTextReaderConstName(reader);

    if (name == NULL)
	    name = BAD_CAST "--";

    for(i=GetValueCnt; i <= SLAVE_MaxParaNum ; i++) 
    {
        if(strcmp((char *)name, (char *)SlaveGetValue[i])==0) 
        {
            //Last value detecting for end the master parsing
            if(i==SLAVE_MaxParaNum-1 ) 
            {
                masterCnt = 0;
                GetValueCnt = 0; 
                return BUS_ERROR_NONE_ENDSLAVE_PARSING;
            }
            GetValueCnt = i;
            break;
        }

        if(strcmp((char *)name, MasterGetValue[0])==0) 
        {
            printf("Incorrect :: definition parameter sequence\n");
            return BUS_ERROR_INVALID_PARA;
        }

    }
    value = xmlTextReaderConstValue(reader);

        if(xmlTextReaderHasAttributes(reader)==1 && 
        GetValueCnt == 0 && 
        xmlTextReaderNodeType(reader)==1 ){

        char *Temp;
        Temp = strcpy(VAL_SLAVE->name, (char*)xmlTextReaderGetAttribute (reader, "name"));
        printf("_____________________________________________\n");
        printf("Slave Name [%s] \n",VAL_SLAVE->name);
    }

    //parsing operate method normal method
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 1 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "normal") == 0)
            VAL_SLAVE->OperateArbiter.method = (unsigned int)NORMAL;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (only normal method support[%s])\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

    }

    //parsing Arbiter master name
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 2 &&
       xmlTextReaderNodeType(reader) == 3 ){

        char *Temp;
        Temp = strcpy(VAL_SLAVE->OperateArbiter.PriorityMaster[masterCnt], (char *)value);

        printf("Arbiter priority[%d] MasterName[%s]\n",masterCnt, VAL_SLAVE->OperateArbiter.PriorityMaster[masterCnt] );

        masterCnt++;
        //Error display 
        if(masterCnt > ValMAIN.MasterNumber){
            masterCnt = 0;
            printf("SlaveName[%s] priority master_name[%s]\n", VAL_SLAVE->name, value);
            return  BUS_ERROR_MASTERNUM_OVER;
        }
    }

    //parsing operate write issuing capablity (integer nember) 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 3 &&
       xmlTextReaderNodeType(reader) == 3 ){

        VAL_SLAVE->WriteIssuingCap =(unsigned int)(strtoul(value,NULL,10));
    }

    //parsing operate read issuing capablity (integer nember) 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 4 &&
       xmlTextReaderNodeType(reader) == 3 ){

        VAL_SLAVE->ReadIssuingCap =(unsigned int)(strtoul(value,NULL,10));
    }

    //parsing operate burst type FIXED (enable | disable) 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 5 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->OperateBurstFIXEDEnable = (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->OperateBurstFIXEDEnable = (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }
    }

    //parsing operate burst type INCR (enable | disable) 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 6 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->OperateBurstINCREnable = (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->OperateBurstINCREnable = (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }
    }

    //parsing operate burst type INCR (enable | disable) 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 7 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->OperateBurstWRAPEnable = (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->OperateBurstWRAPEnable = (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }
    }

    //Port configuration_________________________________________________
    //parsing writechannel enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 8 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->WriteChPort.ChannelEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->WriteChPort.ChannelEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel enable[%d]\n", 
                VAL_SLAVE->WriteChPort.ChannelEnable);
    }

    //parsing writechannel lock enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 9 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->WriteChPort.LockEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->WriteChPort.LockEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel Lock enable[%d]\n", 
                VAL_SLAVE->WriteChPort.LockEnable);

    }


    //parsing writechannel cache enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 10 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->WriteChPort.CacheEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->WriteChPort.CacheEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel Cache enable[%d]\n", 
                VAL_SLAVE->WriteChPort.CacheEnable);

    }


    //parsing writechannel protect enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 11 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->WriteChPort.ProtectEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->WriteChPort.ProtectEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel Protect enable[%d]\n", 
                VAL_SLAVE->WriteChPort.ProtectEnable);

    }


    //parsing writechannel Wstrb enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 12 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->WriteChPort.WstrbEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->WriteChPort.WstrbEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel WstrbEnable enable[%d]\n", 
                VAL_SLAVE->WriteChPort.WstrbEnable);

    }

    //Port configuration_________________________________________________
    //parsing readchannel enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 13 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->ReadChPort.ChannelEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->ReadChPort.ChannelEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration ReadChannel enable[%d]\n", 
                VAL_SLAVE->ReadChPort.ChannelEnable);
    }

    //parsing ReadChannel lock enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 14 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->ReadChPort.LockEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->ReadChPort.LockEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration ReadChannel Lock enable[%d]\n", 
                VAL_SLAVE->ReadChPort.LockEnable);

    }


    //parsing writechannel cache enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 15 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->ReadChPort.CacheEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->ReadChPort.CacheEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration ReadChannel Cache enable[%d]\n", 
                VAL_SLAVE->ReadChPort.CacheEnable);

    }


    //parsing writechannel protect enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 16 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_SLAVE->ReadChPort.ProtectEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->ReadChPort.ProtectEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("SlaveName[%s] not correct (enable or disable)[%s]\n", VAL_SLAVE->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration ReadChannel Protect enable[%d]\n", 
                VAL_SLAVE->ReadChPort.ProtectEnable);

    }

    //Register slice parsing slavetomi
    if(xmlTextReaderHasAttributes(reader)==1 && 
        GetValueCnt == 17 && 
        xmlTextReaderNodeType(reader)==1 ){

        char Temp[20];
        strcpy(Temp, (char*)xmlTextReaderGetAttribute (reader, "mode"));

        if(strcmp(Temp, "FULL") == 0)
        {
            VAL_SLAVE->modeStoMi = 1;
        } else if(strcmp(Temp, "FOWARD") == 0){
            VAL_SLAVE->modeStoMi = 2;
        } else {
           printf("registerslice mode[%s] not correct (FULL or FOWARD)[%s]\n", Temp, Temp);
           return BUS_ERROR_INVALID_PARA;   
        }

        strcpy(Temp, (char*)xmlTextReaderGetAttribute (reader, "rnum"));
        VAL_SLAVE->RegisterSliceStoMi = strtoul(Temp,NULL,10);

        printf("_____________________________________________\n");
        printf("Slave to master interface Register slice number [%d] \n",VAL_SLAVE->RegisterSliceStoMi);
    }

	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 17 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->modeStoMi = 0; //disable
        else if(strcmp((char *)value, "enable") != 0)/* Error output */
        {
           printf("slaveregisterslice[%s] not correct (enable or disable)[%s]\n", value, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("slave register slice [%s]\n", 
                value);
    }

    //Register slice parsing mitosi
    if(xmlTextReaderHasAttributes(reader)==1 && 
        GetValueCnt == 18 && 
        xmlTextReaderNodeType(reader)==1 ){

        char Temp[20];
        strcpy(Temp, (char*)xmlTextReaderGetAttribute (reader, "mode"));

        if(strcmp(Temp, "FULL") == 0)
        {
            VAL_SLAVE->modeMitoSi= 1;
        } else if(strcmp(Temp, "FOWARD") == 0){
            VAL_SLAVE->modeMitoSi= 2;
        } else {
           printf("registerslice mode[%s] not correct (FULL or FOWARD)[%s]\n", Temp, Temp);
           return BUS_ERROR_INVALID_PARA;   
        }

        strcpy(Temp, (char*)xmlTextReaderGetAttribute (reader, "rnum"));
        VAL_SLAVE->RegisterSliceMitoSi= strtoul(Temp,NULL,10);

        printf("_____________________________________________\n");
        printf("masterinterface to slaveinterface Register slice number [%d] \n",VAL_SLAVE->RegisterSliceMitoSi);
    }


	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 18 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "disable") == 0)
            VAL_SLAVE->modeMitoSi = 0; //disable
        else if(strcmp((char *)value, "enable") != 0)/* Error output */
        {
           printf("slaveregisterslice[%s] not correct (enable or disable)[%s]\n", value, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("Master interface to Master interface slice [%s]\n", 
                value);
    }

    return BUS_ERROR_NONE;

}//End slave parsing




static unsigned int parsingDefMaster(xmlTextReaderPtr reader, DefMaster *VAL_MASTER){
    const xmlChar *name, *value;
    int i, Bufferi;

    name = xmlTextReaderConstName(reader);

    if (name == NULL)
	    name = BAD_CAST "--";

    for(i=GetValueCnt; i <= MASTER_MaxParaNum ; i++) {
        if(strcmp((char *)name, (char *)MasterGetValue[i])==0) {
            //Last value detecting for ending the master parsing
            if(i==MASTER_MaxParaNum-1 ) {
                slaveCnt = 0;
                GetValueCnt = 0; return BUS_ERROR_NONE_ENDMASTER_PARSING;}
            GetValueCnt = i;
            break;
        }

        if(strcmp((char *)name, SlaveGetValue[0])==0) 
        {
            printf("Incorrect :: definition parameter sequence\n");
            return BUS_ERROR_INVALID_PARA;
        }

    }
    value = xmlTextReaderConstValue(reader);

    //parsing master name attribute 
        if(xmlTextReaderHasAttributes(reader)==1 && 
        GetValueCnt == 0 && 
        xmlTextReaderNodeType(reader)==1 ){

        char *Temp;
        Temp = strcpy(VAL_MASTER->name, (char*)xmlTextReaderGetAttribute (reader, "name"));
        Temp = (char*)xmlTextReaderGetAttribute (reader, "writeidwid");
        VAL_MASTER->writeidwid = strtoul(Temp,NULL,10);

        if(VAL_MASTER->writeidwid == 0)
        {
            VAL_MASTER->writeidwid = 1;
            VAL_MASTER->WriteChPort.IDEnable= (unsigned int)DISABLE;
        }
        else
            VAL_MASTER->WriteChPort.IDEnable= (unsigned int)ENABLE;


        Temp = (char*)xmlTextReaderGetAttribute (reader, "readidwid");
        VAL_MASTER->readidwid = strtoul(Temp,NULL,10);

        if(VAL_MASTER->readidwid == 0)
        {
            VAL_MASTER->readidwid = 1;
            VAL_MASTER->ReadChPort.IDEnable= (unsigned int)DISABLE;
        }
        else
            VAL_MASTER->ReadChPort.IDEnable= (unsigned int)ENABLE;

        //VAL_MASTER->name = xmlTextReaderGetAttribute (reader, "name");
        printf("_____________________________________________\n");
        printf("Master Name [%s] \n",VAL_MASTER->name);
        printf("Master Write ID WIDTH [%d] \n",VAL_MASTER->writeidwid);
        printf("Master Read ID WIDTH [%d] \n",VAL_MASTER->readidwid);
    }

    //parsing conslave name
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 1 &&
       xmlTextReaderNodeType(reader) == 3 ){

        char *Temp;
        Temp = strcpy(VAL_MASTER->ConnectSlave[slaveCnt], (char *)value);

        printf("SlaveName[%s][%d]\n",VAL_MASTER->ConnectSlave[slaveCnt],slaveCnt );

        slaveCnt++;
        //Error display 
        if(slaveCnt > ValMAIN.SlaveNumber){
            slaveCnt = 0;
            printf("MasterName[%s]/conslave_name[%s] is over slave number\n", VAL_MASTER->name, value);
            return  BUS_ERROR_SLAVENUM_OVER;
        }
    }

    strcpy(VAL_MASTER->ConnectSlave[slaveCnt], "END");

    //parsing operate method (advanced | simple) method
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 2 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "advanced") == 0)
            VAL_MASTER->OperateMethod = (unsigned int)ADVANCED;
        else if(strcmp((char *)value, "simple") == 0)
            VAL_MASTER->OperateMethod = (unsigned int)SIMPLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (simple or advanced)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("OperateMethod[%x]\n", VAL_MASTER->OperateMethod);
    }

    //parsing operate lock_access (enable | disable) 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 3 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->OperateLockEnable = (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->OperateLockEnable = (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }


    }


    //parsing operate write issuing capablity (integer nember) 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 4 &&
       xmlTextReaderNodeType(reader) == 3 ){

        VAL_MASTER->WriteIssuingCap =(unsigned int)(strtoul(value,NULL,10));
    }

    //parsing operate read issuing capablity (integer nember) 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 5 &&
       xmlTextReaderNodeType(reader) == 3 ){

        VAL_MASTER->ReadIssuingCap =(unsigned int)(strtoul(value,NULL,10));
    }

    //Port configuration_________________________________________________
    //parsing writechannel enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 7 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->WriteChPort.ChannelEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->WriteChPort.ChannelEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel enable[%d]\n", 
                VAL_MASTER->WriteChPort.ChannelEnable);
    }

    //parsing writechannel lock enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 8 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->WriteChPort.LockEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->WriteChPort.LockEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel Lock enable[%d]\n", 
                VAL_MASTER->WriteChPort.LockEnable);

    }


    //parsing writechannel cache enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 9 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->WriteChPort.CacheEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->WriteChPort.CacheEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel Cache enable[%d]\n", 
                VAL_MASTER->WriteChPort.CacheEnable);

    }


    //parsing writechannel protect enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 10 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->WriteChPort.ProtectEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->WriteChPort.ProtectEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel Protect enable[%d]\n", 
                VAL_MASTER->WriteChPort.ProtectEnable);

    }


    //parsing writechannel Wstrb enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 11 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->WriteChPort.WstrbEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->WriteChPort.WstrbEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration WriteChannel WstrbEnable enable[%d]\n", 
                VAL_MASTER->WriteChPort.WstrbEnable);

    }

    //Port configuration_________________________________________________
    //parsing readchannel enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 13 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->ReadChPort.ChannelEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->ReadChPort.ChannelEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration ReadChannel enable[%d]\n", 
                VAL_MASTER->ReadChPort.ChannelEnable);
    }

    //parsing ReadChannel lock enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 14 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->ReadChPort.LockEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->ReadChPort.LockEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration ReadChannel Lock enable[%d]\n", 
                VAL_MASTER->ReadChPort.LockEnable);

    }


    //parsing writechannel cache enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 15 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->ReadChPort.CacheEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->ReadChPort.CacheEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration ReadChannel Cache enable[%d]\n", 
                VAL_MASTER->ReadChPort.CacheEnable);

    }


    //parsing writechannel protect enable 
	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 16 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "enable") == 0)
            VAL_MASTER->ReadChPort.ProtectEnable= (unsigned int)ENABLE;
        else if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->ReadChPort.ProtectEnable= (unsigned int)DISABLE;
        else /* Error output */
        {
           printf("MasterName[%s] not correct (enable or disable)[%s]\n", VAL_MASTER->name, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("PortConfiguration ReadChannel Protect enable[%d]\n", 
                VAL_MASTER->ReadChPort.ProtectEnable);

    }


    //Register slice parsing mastertomi
    if(xmlTextReaderHasAttributes(reader)==1 && 
        GetValueCnt == 17 && 
        xmlTextReaderNodeType(reader)==1 ){

        char Temp[20];
        strcpy(Temp, (char*)xmlTextReaderGetAttribute (reader, "mode"));

        if(strcmp(Temp, "FULL") == 0)
        {
            VAL_MASTER->modeMtoSi = 1;
        } else if(strcmp(Temp, "FOWARD") == 0){
            VAL_MASTER->modeMtoSi = 2;
        } else {
           printf("registerslice mode[%s] not correct (FULL or FOWARD)[%s]\n", Temp, Temp);
           return BUS_ERROR_INVALID_PARA;   
        }

        strcpy(Temp, (char*)xmlTextReaderGetAttribute (reader, "rnum"));
        VAL_MASTER->RegisterSliceMtoSi = strtoul(Temp,NULL,10);

        //VAL_MASTER->name = xmlTextReaderGetAttribute (reader, "name");
        printf("_____________________________________________\n");
        printf("Master to slave interface Register slice number [%d] \n",VAL_MASTER->RegisterSliceMtoSi);
    }

	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 17 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->modeMtoSi = 0; //disable
        else if(strcmp((char *)value, "enable") != 0)/* Error output */
        {
           printf("masterregisterslice[%s] not correct (enable or disable)[%s]\n", value, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("master register slice [%s]\n", 
                value);
    }

    //Register slice parsing sitomi
    if(xmlTextReaderHasAttributes(reader)==1 && 
        GetValueCnt == 18 && 
        xmlTextReaderNodeType(reader)==1 ){

        char Temp[20];
        strcpy(Temp, (char*)xmlTextReaderGetAttribute (reader, "mode"));

        if(strcmp(Temp, "FULL") == 0)
        {
            VAL_MASTER->modeSitoMi= 1;
        } else if(strcmp(Temp, "FOWARD") == 0){
            VAL_MASTER->modeSitoMi= 2;
        } else {
           printf("registerslice mode[%s] not correct (FULL or FOWARD)[%s]\n", Temp, Temp);
           return BUS_ERROR_INVALID_PARA;   
        }

        strcpy(Temp, (char*)xmlTextReaderGetAttribute (reader, "rnum"));
        VAL_MASTER->RegisterSliceSitoMi= strtoul(Temp,NULL,10);

        //VAL_MASTER->name = xmlTextReaderGetAttribute (reader, "name");
        printf("_____________________________________________\n");
        printf("slaveinterface to masterinterface Register slice number [%d] \n",VAL_MASTER->RegisterSliceSitoMi);
    }


	if(xmlTextReaderHasValue(reader)== 1 && 
       GetValueCnt == 18 &&
       xmlTextReaderNodeType(reader) == 3 ){

        if(strcmp((char *)value, "disable") == 0)
            VAL_MASTER->modeSitoMi = 0; //disable
        else if(strcmp((char *)value, "enable") != 0)/* Error output */
        {
           printf("masterregisterslice[%s] not correct (enable or disable)[%s]\n", value, value);
           return BUS_ERROR_INVALID_PARA;   
        }

        printf("Slave interface to Master interface slice [%s]\n", 
                value);
    }

    return BUS_ERROR_NONE;

}//parsing master end

static unsigned int parsingDefMain(xmlTextReaderPtr reader, DefMain *VAL_MAIN) {
    const xmlChar *name, *value;
    int i, Bufferi;

    name = xmlTextReaderConstName(reader);

    if (name == NULL)
	    name = BAD_CAST "--";

    for(i=GetValueCnt; i <= MAIN_MaxParaNum ; i++) 
    {
        if(strcmp((char *)name, MainGetValue[i])==0) {

            //Last value detecting for end the main parsing
            if(i==MAIN_MaxParaNum-1 ) {
                strcpy(VAL_MAIN->Map0[slaveCnt].name,  "END");
                strcpy(VAL_MAIN->Map1[slaveCnt].name,  "END");
                GetValueCnt = 0; 
                slaveCnt = 0;
                return BUS_ERROR_NONE_ENDMAIN_PARSING;
            }
            GetValueCnt = i;
            break;
        } 


    }
    value = xmlTextReaderConstValue(reader);

    //parsing data name
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 0 &&
      xmlTextReaderNodeType(reader) == 3 ){

        strcpy(VAL_MAIN->name ,value);
        printf("BUS NAME[%s]\n", VAL_MAIN->name);
    }

    //parsing data name attribute 
    //Masternumber, Slavenumber
    if(xmlTextReaderHasAttributes(reader)==1 && GetValueCnt == 0 &&
       xmlTextReaderNodeType(reader)==1 ){

        VAL_MAIN->MasterNumber = strtoul(xmlTextReaderGetAttribute
                                (reader, "masternum"),NULL,10);

        VAL_MAIN->SlaveNumber = strtoul(xmlTextReaderGetAttribute
                                (reader, "slavenum"),NULL,10);

        printf("_____________________________________________\n");
        printf("MasterNumber[%d]\n", VAL_MAIN->MasterNumber);
        printf("SlaveNumber[%d]\n", VAL_MAIN->SlaveNumber);

        if(VAL_MAIN->MasterNumber != ErrMasterCnt/2)
        {
            printf("Not suffcident master definition parameter, %d is requied definition but only %d \n", ValMAIN.MasterNumber, ErrMasterCnt/2);
            return BUS_ERROR_NOT_SUFFICIENT;
        }

        if(VAL_MAIN->SlaveNumber != (ErrSlaveCnt-2)/2)
        {
            printf("Not suffcident slave definition parameter, %d is requied definition but only %d \n", ValMAIN.SlaveNumber, (ErrSlaveCnt-2)/2);
            return BUS_ERROR_NOT_SUFFICIENT;
        }
    }

    //parsing data BusWidth
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 2 &&
      xmlTextReaderNodeType(reader) == 3 ){

        VAL_MAIN->BusWidth = strtoul( (char*)value,NULL,10);
        printf("AddressWidth[%d]\n", VAL_MAIN->BusWidth);
    }

    //parsing data AddrWidth
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 3 &&
      xmlTextReaderNodeType(reader) == 3 ){

        VAL_MAIN->AddrWidth = strtoul( (char*)value,NULL,10);
        printf("AddressWidth[%d]\n", VAL_MAIN->AddrWidth);
    }

    //parsing data WriteChConnect.WriteAddress
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 5 &&
      xmlTextReaderNodeType(reader) == 3 ){

        unsigned int TempVal;


        if(strcmp((char*)value, "cross_bar") == 0)
            TempVal = MAIN_CROSS_BAR_BUS;
        else if(strcmp((char*)value, "shared_bus") == 0)
            TempVal = MAIN_SHARED_BUS;
        else
            TempVal = BUS_ERROR_CH_CONNECT;

        VAL_MAIN->WriteChConnect.WriteAddress = TempVal;
        printf("Channel connection WriteAddress[%d]\n", VAL_MAIN->WriteChConnect.WriteAddress );
    }

    //parsing data WriteChConnect.WriteData
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 6 &&
      xmlTextReaderNodeType(reader) == 3 ){

        unsigned int TempVal;

        if(strcmp((char*)value, "cross_bar") == 0)
            TempVal = MAIN_CROSS_BAR_BUS;
        else if(strcmp((char*)value, "shared_bus") == 0)
            TempVal = MAIN_SHARED_BUS;
        else
            TempVal = BUS_ERROR_CH_CONNECT;

        VAL_MAIN->WriteChConnect.WriteData = TempVal;
        printf("Channel connection WriteData[%d]\n", VAL_MAIN->WriteChConnect.WriteData );
    }

    //parsing data WriteChConnect.WriteRes
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 7 &&
      xmlTextReaderNodeType(reader) == 3 ){

        unsigned int TempVal;

        if(strcmp((char*)value, "cross_bar") == 0)
            TempVal = MAIN_CROSS_BAR_BUS;
        else if(strcmp((char*)value, "shared_bus") == 0)
            TempVal = MAIN_SHARED_BUS;
        else
            TempVal = BUS_ERROR_CH_CONNECT;

        VAL_MAIN->WriteChConnect.WriteRes = TempVal;
        printf("Channel connection WriteResponse[%d]\n", VAL_MAIN->WriteChConnect.WriteRes );
    }

    //parsing data ReadChConnect.ReadAddress
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 8 &&
      xmlTextReaderNodeType(reader) == 3 ){

        unsigned int TempVal;

        if(strcmp((char*)value, "cross_bar") == 0)
            TempVal = MAIN_CROSS_BAR_BUS;
        else if(strcmp((char*)value, "shared_bus") == 0)
            TempVal = MAIN_SHARED_BUS;
        else
            TempVal = BUS_ERROR_CH_CONNECT;

        VAL_MAIN->ReadChConnect.ReadAddress = TempVal;
        printf("Channel connection ReadAddress[%d]\n", VAL_MAIN->ReadChConnect.ReadAddress );
    }

    //parsing data ReadChConnect.ReadData
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 9 &&
      xmlTextReaderNodeType(reader) == 3 ){

        unsigned int TempVal;

        if(strcmp((char*)value, "cross_bar") == 0)
            TempVal = MAIN_CROSS_BAR_BUS;
        else if(strcmp((char*)value, "shared_bus") == 0)
            TempVal = MAIN_SHARED_BUS;
        else
            TempVal = BUS_ERROR_CH_CONNECT;

        VAL_MAIN->ReadChConnect.ReadData = TempVal;
        printf("Channel connection ReadData[%d]\n", VAL_MAIN->ReadChConnect.ReadData );
    }

    //parsing data Remap enable
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 11 &&
      xmlTextReaderNodeType(reader) == 3 ){

        unsigned int TempVal;

        if(strcmp((char*)value, "disalbe") == 0)
            TempVal = DISABLE;
        else if(strcmp((char*)value, "enable") == 0)
            TempVal = ENABLE;
        else
            TempVal = BUS_ERROR_REMAP_CHOICE;

        VAL_MAIN->ReMapEnable = TempVal;
        printf("Channel connection ReMapEnable[%d]\n", VAL_MAIN->ReMapEnable );
    }

    //parsing data map0 / map1
	if( xmlTextReaderHasValue(reader) == 0 &&
        xmlTextReaderNodeType(reader) == 1 ){


        if(GetValueCnt == 12){
            slaveCnt = 0;
        }else if(GetValueCnt == 14){
            slaveCnt = 0;
        }
    }

    //parsing slave name
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 13 &&
      xmlTextReaderNodeType(reader) == 3 ){

        strcpy(VAL_MAIN->Map0[slaveCnt].name,  (char *)value);
        printf("Slave[%d]-->Map0 name::%s\n",slaveCnt, VAL_MAIN->Map0[slaveCnt].name);
        slaveCnt++;
    }

    //parsing data slave attribute 
    //StarAddress, AreaAddress, EndAddress
    if(xmlTextReaderHasAttributes(reader)==1 && GetValueCnt == 13 &&
       xmlTextReaderNodeType(reader)==1 ){

        VAL_MAIN->Map0[slaveCnt].StartAddr = strtoul(xmlTextReaderGetAttribute (reader, "start_addr"),NULL,16);
        VAL_MAIN->Map0[slaveCnt].AreaAddr  = strtoul(xmlTextReaderGetAttribute (reader, "area_addr"),NULL,16);
        VAL_MAIN->Map0[slaveCnt].EndAddr  = strtoul(xmlTextReaderGetAttribute (reader, "end_addr"),NULL,16);

        printf("Slave[%d] :: StarADDR[%x] :: AreaADDR[%x] :: EndADDR[%x] \n", slaveCnt,
            VAL_MAIN->Map0[slaveCnt].StartAddr,
            VAL_MAIN->Map0[slaveCnt].AreaAddr,
            VAL_MAIN->Map0[slaveCnt].EndAddr);


        if(VAL_MAIN->Map0[slaveCnt].AreaAddr 
                <= VAL_MAIN->Map0[slaveCnt].StartAddr)
        {
            printf("Error :: memory area incorrect (StartAddress is lager than EndAddress)\n");
            return BUS_ERROR_INVALID_PARA;
        }

        if(VAL_MAIN->Map0[slaveCnt].EndAddr 
                <= VAL_MAIN->Map0[slaveCnt].StartAddr)
        {
            printf("Error :: memory area incorrect (StartAddress is lager than EndAddress)\n");
            return BUS_ERROR_INVALID_PARA;
        }

        if(VAL_MAIN->Map0[slaveCnt].AreaAddr 
                > VAL_MAIN->Map0[slaveCnt].EndAddr)
        {
            printf("Error :: memory area incorrect (AreaAddress is lager than EndAddress)\n");
            return BUS_ERROR_INVALID_PARA;
        }


    }


    //parsing slave name
	if(xmlTextReaderHasValue(reader)== 1 && GetValueCnt == 15 &&
      xmlTextReaderNodeType(reader) == 3 ){

        strcpy(VAL_MAIN->Map1[slaveCnt].name , (char *)value);
        printf("Slave[%d]-->Map1 name::%s\n",slaveCnt, VAL_MAIN->Map1[slaveCnt].name);
        slaveCnt++;
    }

    //parsing data slave attribute 
    //StarAddress, AreaAddress, EndAddress
    if(xmlTextReaderHasAttributes(reader)==1 && GetValueCnt == 15 &&
       xmlTextReaderNodeType(reader)==1 ){

        VAL_MAIN->Map1[slaveCnt].StartAddr = strtoul(xmlTextReaderGetAttribute (reader, "start_addr"),NULL,16);
        VAL_MAIN->Map1[slaveCnt].AreaAddr  = strtoul(xmlTextReaderGetAttribute (reader, "area_addr"),NULL,16);
        VAL_MAIN->Map1[slaveCnt].EndAddr  = strtoul(xmlTextReaderGetAttribute (reader, "end_addr"),NULL,16);

        printf("Slave[%d] :: StarADDR[%x] :: AreaADDR[%x] :: EndADDR[%x] \n", slaveCnt,
            VAL_MAIN->Map1[slaveCnt].StartAddr,
            VAL_MAIN->Map1[slaveCnt].AreaAddr,
            VAL_MAIN->Map1[slaveCnt].EndAddr);



        if(VAL_MAIN->Map1[slaveCnt].AreaAddr 
                <= VAL_MAIN->Map1[slaveCnt].StartAddr)
        {
            printf("Error :: memory area incorrect (StartAddress is lager than EndAddress)\n");
            return BUS_ERROR_INVALID_PARA;
        }

        if(VAL_MAIN->Map1[slaveCnt].EndAddr 
                <= VAL_MAIN->Map1[slaveCnt].StartAddr)
        {
            printf("Error :: memory area incorrect (StartAddress is lager than EndAddress)\n");
            return BUS_ERROR_INVALID_PARA;
        }

        if(VAL_MAIN->Map1[slaveCnt].AreaAddr 
                > VAL_MAIN->Map1[slaveCnt].EndAddr)
        {
            printf("Error :: memory area incorrect (AreaAddress is lager than EndAddress)\n");
            return BUS_ERROR_INVALID_PARA;
        }



    }


    return BUS_ERROR_NONE;
}

unsigned int streamXML(const char *filename) {
    xmlTextReaderPtr reader;
    int ret;
    unsigned int processRes;
    unsigned int StatusNext = MAIN_PARSING;

    /*
     * Pass some special parsing options to activate DTD attribute defaulting,
     * entities substitution and DTD validation
     */
    reader = xmlReaderForFile(filename, NULL,
                XML_PARSE_DTDATTR |  /* default DTD attributes */
		        XML_PARSE_NOENT |    /* substitute entities */
		        XML_PARSE_DTDVALID); /* validate with the DTD */

    if (reader != NULL) {
        ret = xmlTextReaderRead(reader);
        while (ret == 1) {

            switch(StatusNext) {

                case MAIN_PARSING:
                        processRes = parsingDefMain(reader, &ValMAIN);
                        break;
                case MASTER_PARSING:
                        processRes = parsingDefMaster(reader, &ValMASTER[masterCnt]);
                        break;
                case SLAVE_PARSING:
                        processRes = parsingDefSlave(reader, &ValSLAVE[slaveCnt]);
                        break;
                case END_PARSING:
                        printf("END parsing ....\n");
                        break;
                default:
                        break;
            }

            
            if(processRes == BUS_ERROR_NONE)
                StatusNext = StatusNext;
            else if(processRes == BUS_ERROR_NONE_ENDMAIN_PARSING){
                StatusNext = MASTER_PARSING;
                masterCnt = 0;
                slaveCnt = 0;
                printf("Main parsing end _____Next parsing\n");
            }
            else if(processRes == BUS_ERROR_NONE_ENDMASTER_PARSING){
                if(masterCnt == ValMAIN.MasterNumber-1){
                    StatusNext = SLAVE_PARSING;
                    printf("masterN[%d/%d]\n",(masterCnt+1),ValMAIN.MasterNumber);
                    printf("Master parsing end _____Next parsing\n");
                    masterCnt = 0;
                    slaveCnt = 0;
                } else {
                    printf("masterN[%d/%d]\n",(masterCnt+1),ValMAIN.MasterNumber);
                    StatusNext = StatusNext;
                    masterCnt++;
                }
            }
            else if(processRes == BUS_ERROR_NONE_ENDSLAVE_PARSING){
                //if(slaveCnt == ValMAIN.SlaveNumber-1){
                if(slaveCnt == ValMAIN.SlaveNumber){
                    StatusNext = END_PARSING;
                    printf("slaveN[%d/%d]\n",(slaveCnt+1),ValMAIN.SlaveNumber);
                    printf("Slave parsing end _____Next parsing\n");
                    //Default slave parsing
                    printf("Default Slave parsing \n");
                    //parsingDefSlave(reader, &ValDefaultSLAVE);
                    //Default parsing end
                    slaveCnt = 0;
                    masterCnt = 0;
                    printf("Default Slave parsing end \n");

                } else {
                    printf("slaveN[%d/%d]\n",(slaveCnt+1),ValMAIN.SlaveNumber);
                    StatusNext = StatusNext;
                    slaveCnt++;
                }
            } else {
                /* Error print process */
                printf("(S->%x)%x --Error\n",StatusNext, processRes);
                StackError[errCnt] = processRes;
                errCnt++;
                return BUS_ERROR_PARSING;
            }

            if(StatusNext == END_PARSING) {
                printf("END parsing ....\n");
                ret = 0;
                return BUS_ERROR_NONE;
            } else
                ret = xmlTextReaderRead(reader);
        }
	/*
	 * Once the document has been fully parsed check the validation results
	 */
	    if (xmlTextReaderIsValid(reader) != 1) {
	        fprintf(stderr, "Document %s does not validate\n", filename);
            return BUS_ERROR_PARSING;
	    }
            xmlFreeTextReader(reader);
            if (ret != 0) {
                fprintf(stderr, "%s : failed to parse\n", filename);
                return BUS_ERROR_PARSING;
            }
    } else {
        fprintf(stderr, "Unable to open %s\n", filename);
        return BUS_ERROR_PARSING;
    }

    return BUS_ERROR_PARSING;
}
