// Gtx buffer management Test

#include	"uhal.h"
#include	"types.h"
#include	"gtx.h"

/*
typedef	struct gtx_reg_tag {
	UWORD	...reg;
	UWORD	...reg;
}gtx_reg;


typedef	struct sap_tbl_tag {
	UWORD	start_list_addr;
	UWORD	current_list_addr;
	UINT	buf_size;
	...
}sap_tbl;

typedef	struct buf_alloc_tbl_tag {
	UWORD	...;
	UWORD	...;
}buf_alloc_tbl;

typedef	struct intr_que_tag {
	UINT	sapid;
	UCHAR	src_num;
	UCHAR	type;
	UWORD	buf_addr;
	UINT	length;
	UCHAR	rsvd;
	UCHAR	rx_sts;
	UCHAR	cpi;
	UCHAR	cpcs_uu;
}
*/

typedef struct list_tag {
	UCHAR	*buf_addr;
	UCHAR	buf_size;
	list	*next_link;
	UWORD	rsvd;	
}list;



/*
// When Host make Tx packet, Tx Buffer linked list should be implemented.
void Gtx_Host_Buf_Link(void)
{
	gtx_reg			*Gtx_Reg;
	sap_tbl			*Sap_Tbl;	
	buf_alloc_tbl	*Buf_Alloc_Tbl;
	
	int		sapid;
	UINT	size;
	UCHAR	*addr;
	
	sapid = Gtx_Reg->SAP_REG...;	// HOST_SAPID
	Sap_Tbl = GTX_BASE + sapid * SAP_TBL_SIZE;
	
	addr = uHAL_Alloc(size);
}

void Gtx_Buf_Alloc(void)
{
	gtx_reg			*Gtx_Reg;
	sap_tbl			*Sap_Tbl;	
	buf_alloc_tbl	*Buf_Alloc_Tbl;

	int		sapid;
	UINT	size;
	UCHAR	*addr;
	
	
	sapid = Gtx_Reg->SAP_REG...;
	Sap_Tbl = GTX_BASE + sapid * SAP_TBL_SIZE;
	Buf_Alloc_Tbl = GTX_BASE + GTX_ALLOC_TBL_ADDR;
	
	size = Gtx_Reg->buf_size;
	addr = uHAL_malloc(size);
	
	// Write the Allocated Buffer Address to the Buffer Allocation Table
	Buf_Alloc_Tbl->... = addr;
	// Increment the Write index
	Gtx_Reg->BUF_WR_INDEX_REG... = ...;
}
*/

list	*test_first_link, *test_last_link;

// Buffer Allocation Test : linked list
void GtxBufAllocTest(void)
{
	UCHAR	*link_ptr, *buf_ptr;
	link	*test_new_link;
	
	if ((link_ptr = uHAL_Alloc(16)) == NULL) {
		return;
	}
	test_new_link = link_ptr;
	
	if ((buf_ptr = uHAL_Alloc(0x400)) == NULL) {
		return;
	}
	test_new_link->buf_addr = buf_ptr;
	test_new_link->buf_size = 0x400;
	test_new_link->next_link = NULL;
	
	if (test_first_link == NULL) {
		test_first_link = (list *)test_new_link;
		test_last_link = (list *)test_new_link;
		
	}
	else {
		test_last_link->next_link = test_new_link;
		test_last_link = test_new_link;
	}
}

list	*test_first_link;
// After interworking, Allocated Buffer is freed.
void GtxBufFree(UCHAR *link_ptr)
{
	list	*next_link;
	
	free_link = (list *)link_ptr;	
	
	do {
		next_link = free_link->next_link;
		uHAL_free(free_link->buf_addr);		// free Data buffer
		uHAL_free(free_link);				// free Descriptor buffer
		free_link = next_link;
		
	} while(free_link != NULL);
}

void main(void)
{
	int		i;
	
	for (i = 0; i < 16; i++) {
		GtxBufAllocTest();
	}
	#ifdef GTX_DBG
		uHAL_Alloc("Gtx Buffers was allocated\n");
	#endif
	
	GtxBufFree(test_first_link);	
	#ifdef GTX_DBG
		uHAL_Alloc("Gtx Buffers was freed.\n");
	#endif
}
