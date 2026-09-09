/***************************************************************************
 * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 * Copyright © ARM Limited 1998/1999.  All rights reserved.
 ***************************************************************************/
/*
 * This is a simple heap allocator.  It allocates memory in fixed "chunk" 
 * sizes.  The chunk size is a power of 2, for example 128.  It allocates
 * as many chunks as it takes to hold the memory size requested and a chunk
 * header which describes the block of chunks.  All blocks of chunks are kept
 * in the memory list pointed at by "first".  The header describes the number 
 * of chunks in this block, whether or not it is free and how much memory
 * the caller asked for.  It also contains a magic pattern that allows the
 * deallocation code to check for memory corruption.  The smaller the chunk
 * size the less wasted memory, however a chunk must be bigger than the chunk
 * header.
 *
 * The memory allocation algorithm is to find the first block of chunks big
 * enough.  If this block of chunks is too large, the block is broken into 
 * two blocks.  The first block of chunks is used for the memory and second
 * is made free.  This is a "first found" algorithm, it could be more efficient
 * but the search would take longer.
 *
 * When freeing memory we could check to see if the block of chunks being
 * freed could be merged with either the previous or next block of chunks (or
 * both) if they are already free.  This collects the memory back into larger
 * chunks and helps prevent excessive fragmentation.  Rather than do this 
 * every time memory is deallocated, we wait until either we cannot find a 
 * free block of chunks big enough or we are concerned that there is too much
 * fragmentation.
 *
 *****************************************************************************/

#include "uhal.h"

#if uHAL_HEAP != 0

/* memory chunk descriptor */
typedef struct chunkHeader
{
    unsigned int Magic;         // magic number

    unsigned int chunkSize;     // size of chunk in chunks

    unsigned int allocatedSize; // allocated size in bytes

    struct chunkHeader *next;   // next chunk in the list

}
chunkHeader_t;

struct chunkStatistics
{
    unsigned int totalMemory;
    unsigned int allocatedMemory;
    unsigned int maxChunks;
    unsigned int totalBlocks;
};

static struct chunkStatistics statistics;

#define HEADER_SIZE sizeof(chunkHeader_t)
#define CHUNK_MAGIC 0xDEADBEEF

/* minimum size of memory to be allocated */
#define CHUNK_SIZE_IN_BITS 7
#define CHUNK_SIZE (1 << CHUNK_SIZE_IN_BITS)

/* How many times to try and merge the chunks when freeing them */
#define MAX_MERGE_ATTEMPTS 2

/* How many times do we try to allocate memory when there are not any 
 * blocks of chunks big enough */
#define MAX_ALLOCATE_ATTEMPTS 5

/* first memory chunk pointers (held in ascending memory order) */
chunkHeader_t *first = NULL;

/* local (static) routines */
static int easyMergeChunks(chunkHeader_t * blockP);
static void mergeChunks(void);
static chunkHeader_t *firstFit(unsigned int chunks);

/* ----------------------- static source code ----------------------------- */
static void mergeChunks(void)
{
    chunkHeader_t *blockP;
    int i;
    int count;

    /* See if you can merge this freed chunk with another one */
    for (i = 0; i < MAX_MERGE_ATTEMPTS; i++)
    {

        count = 0;
        blockP = first;

        while (blockP)
        {
            count += easyMergeChunks(blockP);
            blockP = blockP->next;
        }

        /* if we didn't merge any chunks this pass, then give up */
        if (count == 0)
            return;
    }
}

static chunkHeader_t *firstFit(unsigned int chunks)
{
    chunkHeader_t *blockP = first;

    /* very, very simple algorithm, find the first chunk big enough */
    while (blockP)
    {
#ifdef DEBUG
        if (blockP->Magic != CHUNK_MAGIC)
        {
            uHALr_printf("ERROR: corrupt heap @ 0x%x\n", blockP);
            return NULL;
        }
#endif
        if ((blockP->chunkSize > chunks) && (blockP->allocatedSize == 0))
        {
            return blockP;
        }
        blockP = blockP->next;
    }
    return NULL;
}

/* merge this chunk and the next, if they are both free */
static int easyMergeChunks(chunkHeader_t * blockP)
{
    chunkHeader_t *nextP = blockP->next;

    if (nextP)
    {
        if ((blockP->allocatedSize == 0) && (nextP->allocatedSize == 0))
        {

            /* swallow (merge) the next chunk. */
            blockP->next = nextP->next;
            blockP->chunkSize += nextP->chunkSize;
            nextP->Magic = ~CHUNK_MAGIC;

            /* account for the death of a block of chunks */
            statistics.totalBlocks--;
            return 1;
        }
    }
    return 0;
}

/* ------------------ externally available routines ------------------------ */
int uHALr_HeapAvailable(void)
{
    return TRUE;
}

#if USE_C_LIBRARY != 0
extern void uHALir_InitCLibraryMalloc(void);
#endif
/* initialize the heap allocation scheme */
void uHALr_InitHeap(void)
{
    void *test_support = NULL;
    unsigned int heap_size;

#ifdef DEBUG
    uHALr_printf("uHALr_InitHeap() called, uHAL_HEAP_BASE = 0x%x\n",
                uHAL_HEAP_BASE);
#endif

	/*Tests to see if the library version of malloc is avaliable */
	/*but does not allocate any memory size = 0. */
	test_support = lib_support_malloc(0);
  	if (test_support == (void *)-1)
  	{
   /* if we're using the C library, init it's heap usage */
#ifndef ADS_BUILD
	    uHALir_InitCLibraryMalloc();
#else
  		heap_size = uHALr_SizeOfFreeRam();

  		/* set up the free block (one big one to start with) */
	  	first = (chunkHeader_t *) uHALr_StartOfFreeRam();
  		first->Magic = CHUNK_MAGIC;
	  	first->allocatedSize = 0;
  		first->chunkSize = heap_size >> CHUNK_SIZE_IN_BITS;
	  	first->next = NULL;

   	/* set up the statistics */
	   	statistics.totalMemory = heap_size;
   	statistics.allocatedMemory = 0;
	 	statistics.maxChunks = heap_size >> CHUNK_SIZE_IN_BITS;
  		statistics.totalBlocks = 1;
#endif
	}
}

/* allocate memory, make this as quick as possible */
void *uHALr_malloc(unsigned int size)
{
    unsigned int chunks;
    void *test_support_ptr = NULL;
    chunkHeader_t *blockP;
    int tries;

    if (size != 0)
    {
    	test_support_ptr = lib_support_malloc(size);
    	if (test_support_ptr == (void *)-1)
    	{
			test_support_ptr = NULL;
      		/* figure out the number of chunks we need */
      		chunks = (~(CHUNK_SIZE - 1) &
           (CHUNK_SIZE + size + sizeof(chunkHeader_t))) >> CHUNK_SIZE_IN_BITS;

        	/* find the best fit for this number of blocks (retry if neccessary) */
        	for (tries = 0; tries < MAX_ALLOCATE_ATTEMPTS; tries++)
        	{

           	/* find the first block that fits */
            	blockP = firstFit(chunks);

            	/* if we got a chunk, do we need to break it into smaller 
				 * * chunks? */
            	if (blockP)
            	{
               	if (blockP->chunkSize > chunks)
                	{
           	       	chunkHeader_t *newP;

                    /* make a new chunk and thread it into the list, make sure
                     * * that the allocator gets the chunk at the end, this
                     * * tends to keep the freeblocks of chunks at the start of
					  * * the memory list. */
                   	newP = (chunkHeader_t *) ((char *)blockP
                                              + ((blockP->chunkSize - chunks)
                                                 * CHUNK_SIZE));
                    	newP->Magic = CHUNK_MAGIC;
                    	newP->next = blockP->next;
                    	newP->allocatedSize = 0;
                    	newP->chunkSize = blockP->chunkSize - chunks;

                    	blockP->next = newP;
                    	blockP->chunkSize -= chunks;

                    	/* account for the birth of a chunk */
                    	statistics.totalBlocks++;

                    	/* Use the new block of chunks */
                    	blockP = newP;
                	}
                	/* account for this memory */
                	statistics.allocatedMemory += (chunks * CHUNK_SIZE);
	
	                /* mark this memory allocated */
                	blockP->Magic = CHUNK_MAGIC;
                	blockP->allocatedSize = size;
                	blockP->chunkSize = chunks;

                	/* return the caller a pointer to its memory */
                	return (void *)((unsigned char *)blockP + 
							sizeof(chunkHeader_t));
            	}

           	/* try and merge any free chunks that are next to each other 
             	* * and then retry the allocate */
            	mergeChunks();
        	}
    	}                           /* ran out of retries, give up */
    }	 

    return test_support_ptr;
}

void uHALr_free(void *where)
{
    /* Check if memory was really allocated. */
    if (where != NULL)
    {
        if (lib_support_free(where) == -1)
        {
            chunkHeader_t *blockP = (chunkHeader_t *) ((char *)where - sizeof(chunkHeader_t));

            /* check the magic header number */
            if (blockP->Magic != CHUNK_MAGIC)
            {
                return;
            }

            /* check that this block is indeed allocated */
            if (blockP->allocatedSize == 0)
            {
                return;
            }

            /* account for this memory */
            statistics.allocatedMemory -= (blockP->chunkSize * CHUNK_SIZE);

            /* mark this block of chunks as free, don't attempt to merge (yet) */
            blockP->allocatedSize = 0;
        }
    }
    return;
}

#else
/* ------------------ externally available routines ------------------------ */
int uHALr_HeapAvailable(void)
{
    return FALSE;
}

#endif
