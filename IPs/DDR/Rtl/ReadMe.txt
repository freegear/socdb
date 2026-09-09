Ver3.00 CT2000 (TSMC)
	변경사항 : 1. DDRRQ.v에서 ID width 변경으로 FIFO 를 레지스터로 변경 하였습니다.
		   2. DDRPara.v 에서 ID width 변경
	           3. DDRTop.v cell delay  추가됨
                   4. DDRCtl.v 에서 OutHzEn removed and COEN insert
		


// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech           
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// Version and Release information: 
//                                  
//      Ver3.00 :
//                  1. DDRRQ.v 
//                      FIFO register modifyed 
//                      because ID-widh were changed
//                  2. DDRPara.v 
//                      ID windth changed
//                  3. DDRTop.v 
//                      cell dealy function added
//                  4. DDRCtl.v
//                      OutHzEn is removed and COEN is added
// 
// File Name           : DDRTop.v 
// File Revision       : 3.0 - CT2000 (TSMC) 
//  ----------------------------------------------------------------
//  Purpose            : DDR Top block
//                       
//  ----------------------------------------------------------------

