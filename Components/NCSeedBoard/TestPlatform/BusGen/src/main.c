#include "main.h"


const char  *MAIN_NAME = ValMAIN.name;

#define RTLDIR              "../GEN/rtl/BUS"
#define RTLDIR_WRCH         "../GEN/rtl/BUS/WriteChannel"
#define RTLDIR_RDCH         "../GEN/rtl/BUS/ReadChannel"
#define RTLDIR_TOP          "../GEN/rtl/BUS/TOP"
#define RTLDIR_WRCHTOP      "../GEN/rtl/BUS/WriteChannel/TOP"
#define RTLDIR_RDCHTOP      "../GEN/rtl/BUS/ReadChannel/TOP"

#define SimRTLDIR           "../rtl/BUS"
#define SimRTLDIR_WRCH      "../rtl/BUS/WriteChannel"
#define SimRTLDIR_RDCH      "../rtl/BUS/ReadChannel"
#define SimRTLDIR_TOP       "../rtl/BUS/TOP"
#define SimRTLDIR_WRCHTOP   "../rtl/BUS/WriteChannel/TOP"
#define SimRTLDIR_RDCHTOP   "../rtl/BUS/ReadChannel/TOP"


#define OUTDIR              "../GEN/rtl"
#define BENCH               "../GEN/bench"
#define MSIMDIR             "../GEN/msim"

#define SimOUTDIR           "../rtl"
#define SimBENCH            "../bench"
#define SimMSIMDIR          "../msim"

const char *ErrorPrint(unsigned int VAL){

    switch(VAL){
        /* channel connection define fault */
        case BUS_ERROR_CH_CONNECT:           return "Bus channel selection is only [shared_bus] or [cross_bar] "; break;
        /* remap choice error (enalbe or disable) */
        case BUS_ERROR_REMAP_CHOICE:         return "REMAP is not [enalbe] or [disable]"; break;
        /* slave area error */
        case BUS_ERROR_SLAVEAREA_OVERRAP:    return "In Memory maping, your must separte tha slave memory area"; break;
        /* slave number over error */
        case BUS_ERROR_SLAVENUM_OVER:        return "Slave number exceed more than the value of Main parameter" ; break;
        /* master number over error */
        case BUS_ERROR_MASTERNUM_OVER:       return "Master number exceed more than the value of Main parameter" ; break;
        /* invalid parameter */
        case BUS_ERROR_INVALID_PARA:         return "Using the invalid parameter"; break;
        /* Exceed naming rule */
        case BUS_ERROR_EXCEED_PARA:          return "over the parameter length rule"; break;
        /* XML data parsing */
        case BUS_ERROR_PARSING:              return "XML data parsing error"; break;
        /* file error */
        case FILE_PROCESS_ERROR:             return "File porcess error"; break;

        default:                             return "ERROR"; break;
    }

} //ErrorPrint end

unsigned int copyTest(struct codeLine *head_ptr)
{

    unsigned int returnCode;
    char *DirFileName;

    DirFileName = (char *)malloc(sizeof(char) * 300);


    sprintf(DirFileName, "../%s/bench/DefaultSlave.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/TestBench/DefaultSlave.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/bench/SSRAM32bit.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/TestBench/SSRAM32bit.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

//modified 
    /*
    sprintf(DirFileName, "../%s/bench/IntSRAMController.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/TestBench/IntSRAMController.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;
    */

    //AxiPC protocol checker
    sprintf(DirFileName, "../%s/rtl/BUS/protocol_checker/AxiPC.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/protocol_checker/AxiPC.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    //OVL file copy
    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/assert_implication.vlib", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/assert_implication.vlib",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/assert_win_unchange.vlib", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/assert_win_unchange.vlib",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/assert_next.vlib", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/assert_next.vlib",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/assert_frame.vlib", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/assert_frame.vlib",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/assert_never.vlib", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/assert_never.vlib",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/assert_always.vlib", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/assert_always.vlib",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/assert_frame.vlib", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/assert_frame.vlib",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;


    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/assert_quiescent_state.vlib", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/assert_quiescent_state.vlib",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/assert_proposition.vlib", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/assert_proposition.vlib",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;


    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/std_ovl_task.h", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/std_ovl_task.h",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;


    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/std_ovl_defines.h", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/std_ovl_defines.h",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/std_ovl_count.h", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/std_ovl_count.h",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/vlog95/assert_implication_logic.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/vlog95/assert_implication_logic.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/vlog95/assert_win_unchange_logic.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/vlog95/assert_win_unchange_logic.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/vlog95/assert_next_logic.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/vlog95/assert_next_logic.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/vlog95/assert_frame_logic.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/vlog95/assert_frame_logic.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/vlog95/assert_never_logic.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/vlog95/assert_never_logic.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/vlog95/assert_always_logic.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/vlog95/assert_always_logic.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/vlog95/assert_frame_logic.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/vlog95/assert_frame_logic.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;


    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/vlog95/assert_quiescent_state_logic.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/vlog95/assert_quiescent_state_logic.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;

    sprintf(DirFileName, "../%s/rtl/BUS/std_ovl/vlog95/assert_proposition_logic.v", ValMAIN.name);
    returnCode = fileCopy("./dataSample/std_ovl/vlog95/assert_proposition_logic.v",
                            DirFileName);
    if(returnCode != BUS_ERROR_NONE) return returnCode;


    inDataLink(head_ptr, "../bench/DefaultSlave.v\n");
    inDataLink(head_ptr, "../bench/SSRAM32bit.v\n");
    //inDataLink(head_ptr, "../bench/IntSRAMController.v\n");
    inDataLink(head_ptr, "../rtl/BUS/protocol_checker/AxiPC.v\n");
    inDataLink(head_ptr, "../rtl/BUS/std_ovl/assert_implication.vlib\n");
    inDataLink(head_ptr, "../rtl/BUS/std_ovl/assert_next.vlib\n");
    inDataLink(head_ptr, "../rtl/BUS/std_ovl/assert_win_unchange.vlib\n");
    inDataLink(head_ptr, "../rtl/BUS/std_ovl/assert_frame.vlib\n");
    inDataLink(head_ptr, "../rtl/BUS/std_ovl/assert_never.vlib\n");
    inDataLink(head_ptr, "../rtl/BUS/std_ovl/assert_always.vlib\n");
    inDataLink(head_ptr, "../rtl/BUS/std_ovl/assert_frame.vlib\n");
    inDataLink(head_ptr, "../rtl/BUS/std_ovl/assert_quiescent_state.vlib\n");
    inDataLink(head_ptr, "../rtl/BUS/std_ovl/assert_proposition.vlib\n");

    free(DirFileName);
    return BUS_ERROR_NONE;
}
unsigned int checkError()
{
    int endSlaveNum, i,j,k;
    int endMasterNum;

    endSlaveNum  = (int)ValMAIN.SlaveNumber; //defalult slave
    endMasterNum = (int)ValMAIN.MasterNumber;

    /* Memor Area check flow */
    for(i=0 ; endSlaveNum >i ; i++)
    {
        for(j=0 ; endSlaveNum >j ; j++)
        {

            if(i == j) break;

            if((ValMAIN.Map0[i].StartAddr < ValMAIN.Map0[j].EndAddr) &&
               (ValMAIN.Map0[i].EndAddr > ValMAIN.Map0[j].StartAddr))
            {
                printf("overlapping the memory area  between %s and %s\n", 
                                ValSLAVE[i].name, ValSLAVE[j].name );
                return BUS_ERROR_INVALID_PARA;
            }
        }
    }

    /* SlaveName and MasterName are conflicted check */
    /* Connection slave name duplicated */
    int check = 0;
    for(i=0 ; endMasterNum >i ; i++)
    {
        int tmpj=0;
        for(j=0 ; endSlaveNum >j ; j++)
        {

            check = 0;
            for(k=0 ; endSlaveNum >k ; k++)
            {
                if(strcmp(ValMASTER[i].ConnectSlave[j], "END") == 0)
                {
                    k = endSlaveNum; 
                    j = endSlaveNum;
                    check = 1;

                }
                else if(strcmp(ValMASTER[i].ConnectSlave[j], ValSLAVE[k].name) == 0)
                {
                    check = 1;
                }

                if((strcmp(ValMASTER[i].ConnectSlave[j],
                    ValMASTER[i].ConnectSlave[k])==0) &&
                    (j != k)
                    ) 
                {
                    printf("Master connection slave names are duplicated\n"); 
                    printf("[%s]Connect Slave name using several times \"%s\" \n", ValMASTER[i].name,ValMASTER[i].ConnectSlave[k]);
                    return BUS_ERROR_INVALID_PARA;
                }
            }

            if(check == 0)
            {
                printf("Master connection slave name is not found in slave name\n"); 
                printf("[%s] Not find the Connect Slave name \"%s\" \n", 
                    ValMASTER[i].name,ValMASTER[i].ConnectSlave[j]);
                return BUS_ERROR_INVALID_PARA;
            }
        }
    }


    /* Address map check */
    check = 0;
    int check0 = 0;
    for(i=0 ; endSlaveNum >i ; i++)
    {
        if(strcmp(ValSLAVE[i].name,ValMAIN.Map0[i].name)!=0) 
        {
           printf("incorrect :: ordering sequence slave \"%s\" / mamory_map map0\" %s\" \n", ValSLAVE[i].name, ValMAIN.Map0[i].name); 
           return BUS_ERROR_INVALID_PARA;
        }

        if(strcmp(ValSLAVE[i].name,ValMAIN.Map1[i].name)!=0) 
        {
           printf("incorrect :: ordering sequence slave \"%s\" / mamory_map map1\" %s\" \n", ValSLAVE[i].name, ValMAIN.Map1[i].name); 
           return BUS_ERROR_INVALID_PARA;
        }

        /*
        check = 0;
        check0 = 0;
        for(k=0 ; endSlaveNum >k ; k++)
        {
            if(strcmp(ValSLAVE[i].name,ValMAIN.Map0[k].name)==0) 
                check = 1;
            if(strcmp(ValSLAVE[i].name,ValMAIN.Map1[k].name)==0) 
                check0 = 1;

        }

        if(check == 0)
        {
           printf("Don't find Slave name \"%s\" in memory_map / map0\n",
                   ValSLAVE[i].name); 
           return BUS_ERROR_INVALID_PARA;
        }

        if(check0 == 0)
        {
           printf("Don't find Slave name \"%s\" in memory_map / map1\n",
                   ValSLAVE[i].name); 
           return BUS_ERROR_INVALID_PARA;
        }
        */
    }

    return BUS_ERROR_NONE;
}

unsigned int XMLProcess(char *fileName)
{
    unsigned int streamExit;

    /*
     * this initialize the library and check potential ABI mismatches
     * between the version it was compiled for and the actual shared
     * library used.
     */
    LIBXML_TEST_VERSION
    defineCheckError(fileName);
    streamExit = streamXML(fileName);

    /*
     * Cleanup function for the XML library.
     */
    xmlCleanupParser();

    /*
     * this is to debug memory for regression tests
     */
    xmlMemoryDump();

    return streamExit;
}


void Initial()
{
    int i;

    initDir();

    for(i=0;ValMAIN.SlaveNumber > i;i++)
    {
        getMaxID(&ValSLAVE[i]);
        //printf("%d_MAXID [%d]\n", i, getMaxID(&ValSLAVE[i]));
    }

    getDefaultID(&ValSLAVE[ValMAIN.SlaveNumber]);
    /*
    printf("%d_MAXID_default [%d]\n", ValMAIN.SlaveNumber, 
                    getDefaultID(&ValSLAVE[ValMAIN.SlaveNumber]));
                    */
}

unsigned int RtlGenerate()
{

    int endMasterNum, endSlaveNum, i;
    char *DirFileName;
    char *DirFileName1;
    unsigned int returnCode;

    struct codeLine *head_ptr = NULL;
    
    head_ptr = (struct codeLine *)malloc(sizeof(struct codeLine));
    head_ptr->code = (char *)malloc(sizeof(char) * 120);
    head_ptr->next_ptr = NULL;
    strcpy(head_ptr->code,"#RTL file list\n");

    endSlaveNum  = (int)ValMAIN.SlaveNumber + 1; //defalult slave
    endMasterNum = (int)ValMAIN.MasterNumber;
    DirFileName  = (char *)malloc(sizeof(DirFileName) * 300);
    DirFileName1 = (char *)malloc(sizeof(DirFileName) * 300);

    Initial();
    //_________________________________________________ Read channel generation
    
    //Request count generation
    for(i=0; endSlaveNum >i ; i++)
    {
        genDef(&ValMAIN,NULL, &ValSLAVE[i], 1);

        sprintf(DirFileName, "../%s/rtl/BUS/ReadChannel/%s_ReqCnt.v",ValMAIN.name, ValSLAVE[i].name);
        genReqCnt(DirFileName, &ValSLAVE[i]);
        sprintf(DirFileName, "%s/%s_ReqCnt.v\n",SimRTLDIR_RDCH, ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);
    }


    //Lock control generation
    for(i=0; endSlaveNum >i ; i++)
    {
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 1);
        sprintf(DirFileName, "../%s/rtl/BUS/ReadChannel/%s_LockCtlRdmi.v",ValMAIN.name, ValSLAVE[i].name);
        genLockCtl(DirFileName, &ValSLAVE[i], 0); // 0 -> read channel master port
        sprintf(DirFileName, "%s/%s_LockCtlRdmi.v\n",SimRTLDIR_RDCH, ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);
    }

    //Read Channel Master Interface generation
    for(i=0; endSlaveNum >i ; i++)
    {
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 1);
        sprintf(DirFileName, "../%s/rtl/BUS/ReadChannel/%s_ReadChannelmi.v",ValMAIN.name, ValSLAVE[i].name);
        genReadChMi(DirFileName, &ValMASTER[0] , &ValSLAVE[i]);
        sprintf(DirFileName, "%s/%s_ReadChannelmi.v\n",SimRTLDIR_RDCH, ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);
    }

    //Advance mode
    //Read Channel Slave Interface generation
    //Read permit control genertation
    for(i=0; endMasterNum >i ; i++)
    {

        //2006-9-1-Channel_disable_start
        if(ValMASTER[i].ReadChPort.ChannelEnable == ENABLE)
        {
        //______________________________

        genDef(&ValMAIN, &ValMASTER[i], &ValSLAVE[0], 1);
        sprintf(DirFileName, "../%s/rtl/BUS/ReadChannel/%s_ReadChannelsi.v",ValMAIN.name, ValMASTER[i].name);
        genReadChSi(DirFileName, &ValMASTER[i] , &ValSLAVE[0]);
        sprintf(DirFileName, "%s/%s_ReadChannelsi.v\n",SimRTLDIR_RDCH, ValMASTER[i].name);
        inDataLink(head_ptr, DirFileName);


            sprintf(DirFileName, 
                    "../%s/rtl/BUS/ReadChannel/RDCH_%s_PermitCtl.v",
                    ValMAIN.name, ValMASTER[i].name);
            genAdPermitCtl(DirFileName, 
                    &ValMASTER[i], RDCH); //Read channel permit control
            sprintf(DirFileName, 
                    "%s/RDCH_%s_PermitCtl.v\n",
                    SimRTLDIR_RDCH, ValMASTER[i].name);
            inDataLink(head_ptr, DirFileName);
        }

    }
    
    //Read Channel Top generation
    sprintf(DirFileName, "../%s/rtl/BUS/ReadChannel/TOP/ReadChannel.v",ValMAIN.name);
    genReadCh(DirFileName);
    sprintf(DirFileName, "%s/ReadChannel.v\n",SimRTLDIR_RDCHTOP);
    inDataLink(head_ptr, DirFileName);


    //_________________________________________________ Write channel generation

    //Request count generation
    for(i=0; endSlaveNum >i ; i++)
    {
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 0);
        sprintf(DirFileName, "../%s/rtl/BUS/WriteChannel/%s_ReqInter.v", ValMAIN.name, ValSLAVE[i].name);
        genReqInter(DirFileName, ValSLAVE[i].name);
        sprintf(DirFileName, "%s/%s_ReqInter.v\n", SimRTLDIR_WRCH, ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);
    }

    //Lock control generation
    for(i=0; endSlaveNum >i ; i++)
    {
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 0);
        sprintf(DirFileName, "../%s/rtl/BUS/WriteChannel/%s_LockCtlWrmi.v",ValMAIN.name, ValSLAVE[i].name);
        genLockCtl(DirFileName, &ValSLAVE[i], 1); // 1 -> write channel master port
        sprintf(DirFileName, "%s/%s_LockCtlWrmi.v\n",SimRTLDIR_WRCH, ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);
    }

    //Write Channel Master Interface generation
    for(i=0; endSlaveNum >i ; i++)
    {
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 0);
        sprintf(DirFileName, "../%s/rtl/BUS/WriteChannel/%s_WriteChannelmi.v",ValMAIN.name, ValSLAVE[i].name);
        genWriteChMi(DirFileName, &ValMASTER[0] , &ValSLAVE[i]);
        sprintf(DirFileName, "%s/%s_WriteChannelmi.v\n",SimRTLDIR_WRCH, ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);
    }

    //Advance mode
    //Write Channel Slave Interface generation
    //Write permit control genertation
    for(i=0; endMasterNum >i ; i++)
    {

        //2006-9-1-Channel_disable_start
        if(ValMASTER[i].WriteChPort.ChannelEnable == ENABLE)
        {
        //______________________________

        genDef(&ValMAIN, &ValMASTER[i], &ValSLAVE[0], 0);
        sprintf(DirFileName, "../%s/rtl/BUS/WriteChannel/%s_WriteChannelsi.v",ValMAIN.name, ValMASTER[i].name);
        genWriteChSi(DirFileName, &ValMASTER[i] , &ValSLAVE[0]);
        sprintf(DirFileName, "%s/%s_WriteChannelsi.v\n",SimRTLDIR_WRCH, ValMASTER[i].name);
        inDataLink(head_ptr, DirFileName);

            sprintf(DirFileName, 
                    "../%s/rtl/BUS/WriteChannel/WRCH_%s_PermitCtl.v",
                    ValMAIN.name, ValMASTER[i].name);
            genAdPermitCtl(DirFileName, &ValMASTER[i], WRCH); 
                    //Write channel permit control
            sprintf(DirFileName, "%s/WRCH_%s_PermitCtl.v\n",
                    SimRTLDIR_WRCH, ValMASTER[i].name);
            inDataLink(head_ptr, DirFileName);

        } //2006-9-1-Channel_disable
    }
    
    //Write Channel Top generation
    sprintf(DirFileName, "../%s/rtl/BUS/WriteChannel/TOP/WriteChannel.v",ValMAIN.name);
    genWriteCh(DirFileName);
    sprintf(DirFileName, "%s/WriteChannel.v\n",SimRTLDIR_WRCHTOP);
    inDataLink(head_ptr, DirFileName);

    //TEST Register Slice
    for(i=0 ; endMasterNum >i ; i++)
    {
        //2006-9-1-Channel_disable_start
        if(ValMASTER[i].WriteChPort.ChannelEnable == ENABLE)
        {
        //______________________________
        
        //WRITE Channel master
        genDef(&ValMAIN, &ValMASTER[i], &ValSLAVE[0], 0);
        sprintf(DirFileName, 
                "../%s/rtl/BUS/WriteChannel/%s_RS_WriteChannelsi.v",
                ValMAIN.name, ValMASTER[i].name);
        genWriteRsSi(DirFileName, &ValMASTER[i] , &ValSLAVE[0]);
        sprintf(DirFileName, 
                "%s/%s_RS_WriteChannelsi.v\n",
                SimRTLDIR_WRCH,ValMASTER[i].name);
        inDataLink(head_ptr, DirFileName);

        mkWriteRS(&ValMASTER[i], NULL, head_ptr, 1);
        } //2006-9-1-Channel_disable


        //2006-9-1-Channel_disable_start
        if(ValMASTER[i].ReadChPort.ChannelEnable == ENABLE)
        {
        //______________________________
        
        //READ Channel master
        genDef(&ValMAIN, &ValMASTER[i], &ValSLAVE[0], 1);
        sprintf(DirFileName, 
                "../%s/rtl/BUS/ReadChannel/%s_RS_ReadChannelsi.v",
                ValMAIN.name, ValMASTER[i].name);
        genReadRsSi(DirFileName, &ValMASTER[i] , &ValSLAVE[0]);
        sprintf(DirFileName, 
                "%s/%s_RS_ReadChannelsi.v\n",
                SimRTLDIR_RDCH,ValMASTER[i].name);
        inDataLink(head_ptr, DirFileName);

        mkReadRS(&ValMASTER[i], NULL, head_ptr, 1);
        } //2006-9-1-Channel_disable


    }

    for(i=0 ; endSlaveNum >i ; i++)
    {
        //WRITE Channel slave
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 0);
        sprintf(DirFileName, "../%s/rtl/BUS/WriteChannel/%s_RS_WriteChannelmi.v",
                ValMAIN.name, ValSLAVE[i].name);
        genWriteRsMi(DirFileName, &ValMASTER[0] , &ValSLAVE[i]);
        sprintf(DirFileName, "%s/%s_RS_WriteChannelmi.v\n",SimRTLDIR_WRCH,ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);

        //READ Channel slave
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 1);
        sprintf(DirFileName, "../%s/rtl/BUS/ReadChannel/%s_RS_ReadChannelmi.v",
                ValMAIN.name, ValSLAVE[i].name);
        genReadRsMi(DirFileName, &ValMASTER[0] , &ValSLAVE[i]);
        sprintf(DirFileName, "%s/%s_RS_ReadChannelmi.v\n",SimRTLDIR_RDCH,ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);

        mkWriteRS(NULL, &ValSLAVE[i], head_ptr,0);
        mkReadRS(NULL, &ValSLAVE[i], head_ptr,0);
    }

    //_________________________________________________ TOP block generation
    sprintf(DirFileName, "../%s/rtl/BUS/TOP/SBUS.v",ValMAIN.name);
    genBusTop(DirFileName);
    sprintf(DirFileName, "%s/SBUS.v\n",SimRTLDIR_TOP);
    inDataLink(head_ptr, DirFileName);

    //_________________________________________________ Testbnech generation
    sprintf(DirFileName, "../%s/bench/tb.v",ValMAIN.name);
    genTestbench(DirFileName);
    sprintf(DirFileName, "%s/tb.v\n",SimBENCH);
    inDataLink(head_ptr, DirFileName);

    //___________________________________________    plateform TOP generation
    sprintf(DirFileName, "../%s/rtl/TOP_SBUS.v",ValMAIN.name);
    genTOPBlock(DirFileName);


    //___________________________________________ PARAMETER generation
    genPARA();

    inDataLink(head_ptr, "#TEST bench files\n");
    for(i=0; endMasterNum >i ; i++)
    {
        sprintf(DirFileName, "../%s/bench/%s_TestMaster_bus.v",ValMAIN.name,ValMASTER[i].name);
        genTestMaster(&ValMASTER[i],  DirFileName);
        sprintf(DirFileName, "%s/%s_TestMaster_bus.v\n",SimBENCH,ValMASTER[i].name);
        inDataLink(head_ptr, DirFileName);
    }

    //test Slave generation (Internal ram controller)
    for(i=0 ; endSlaveNum -1 >i ; i++)
    {
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 0);
        sprintf(DirFileName, "../%s/bench/%s_IntSRAMController.v",
                ValMAIN.name, ValSLAVE[i].name);
        genIntSRAMController(DirFileName, &ValSLAVE[i]);
        sprintf(DirFileName, "%s/%s_IntSRAMController.v\n",SimBENCH,
                ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);
    }

    //TestSlave SSRAM generation
    for(i=0 ; endSlaveNum -1 >i ; i++)
    {
        genDef(&ValMAIN, NULL, &ValSLAVE[i], 0);
        sprintf(DirFileName, "../%s/bench/%s_SSRAM32bit.v",
                ValMAIN.name, ValSLAVE[i].name);
        genTestSSRAM(&ValSLAVE[i], DirFileName);
        sprintf(DirFileName, "%s/%s_SSRAM32bit.v\n",SimBENCH,
                ValSLAVE[i].name);
        inDataLink(head_ptr, DirFileName);
    }


    //genWriteChSi(&ValMAIN, &ValMASTER[0] , &ValSLAVE[0]);
    
    //genReqCnt(&ValMAIN, &ValMASTER[0], &ValSLAVE[0]);
    //genReqInter(&ValMAIN, &ValMASTER[0], &ValSLAVE[0]);
    //genSimPermitCtl(&ValMAIN, &ValMASTER[0], &ValSLAVE[0], WRCH);
    //genAdPermitCtl(&ValMASTER[0], WRCH);

    //genWriteChSi(&ValMAIN, &ValMASTER[0] , &ValSLAVE[0]);
    //genWriteChMi(&ValMAIN, &ValMASTER[0] , &ValSLAVE[0]);
    //genReadChMi(&ValMAIN, &ValMASTER[0] , &ValSLAVE[0]);
    //genReadChSi(&ValMAIN, &ValMASTER[0] , &ValSLAVE[0]);
    //genWriteCh();
    //genReadCh();
    //genBusTop();

    returnCode = copyTest(head_ptr);

    if(returnCode != BUS_ERROR_NONE)
        return returnCode;

    inDataLink(head_ptr, "#END\n");
    sprintf(DirFileName1, "../%s/rtl/FileList",ValMAIN.name);
    fprintLink(head_ptr, NULL, DirFileName1);
    sprintf(DirFileName, "../%s/msim/run.sh",ValMAIN.name);
    genScript(DirFileName1, DirFileName);

    free(DirFileName);
    free(DirFileName1);  
    return BUS_ERROR_NONE;
}

int main(int argc, char **argv) {

    int i;
    unsigned int streamExit;

    if (argc != 2)
    {
        printf("Input File :: Error\n");
        return(-1);
    }

    streamExit = XMLProcess(argv[1]);

    if(streamExit == BUS_ERROR_NONE){
        printf("XML parsing end.....\n");
    } else { 
        printf("Error ::::  ");
        printf("%s \n", ErrorPrint(streamExit));
        return (-1);
    }

    streamExit = checkError();

    if(streamExit == BUS_ERROR_NONE){
        printf("Error check end.....\n");
    } else { 
        printf("Error ::::  ");
        printf("%s \n", ErrorPrint(streamExit));
        return (-1);
    }

    streamExit = RtlGenerate();

    if(streamExit == BUS_ERROR_NONE){
        printf("Bus generation end.....\n");
    } else { 
        printf("Error ::::  ");
        printf("%s \n", ErrorPrint(streamExit));
        return (-1);
    }

    return(0);
}
