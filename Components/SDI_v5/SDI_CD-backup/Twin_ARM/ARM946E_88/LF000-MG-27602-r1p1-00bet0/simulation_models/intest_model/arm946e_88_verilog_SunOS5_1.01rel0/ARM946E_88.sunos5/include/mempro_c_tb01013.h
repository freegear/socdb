
#ifndef MEMPRO_C_TB_H
#define MEMPRO_C_TB_H

#if defined ( pcnt ) || defined ( alphant )
#pragma comment(exestr, "LAI_SVTAG_mempro_c_tb_h[] = @(#) mempro_c_tb.h[/main/6] ; Logic Modeling" )
#else
static char LAI_SVTAG_mempro_c_tb_h[] = "@(#) mempro_c_tb.h[/main/6] ; Logic Modeling";
#endif

typedef unsigned int slm_addr_t;
typedef char slm_data_t;
typedef unsigned int slm_handle_t;
typedef int slm_status_t;
typedef int slm_memory_format_t;
typedef int slm_message_t;

/*
 *  Maximum length of instance and class names
 */
#define SLM_MAX_NAME_LENGTH  1024 

/*
 *  Return status codes
 */
#define SLM_TESTBENCH_WARNING  1
#define SLM_TESTBENCH_SUCCESS  0
#define SLM_TESTBENCH_FAILURE -1

/* 
 *  Memory file formats 
 */
#define SLM_MIF_FORMAT     0
#define SLM_VLOG_FORMAT    3

/*
 *  Message masks
 */
#define SLM_ERROR         0x1
#define SLM_WARNING       0x2
#define SLM_TIMING        0x4
#define SLM_XHANDLING     0x8
#define SLM_INFO          0x10
#define SLM_ALL_MESSAGES  0x0fffffff
#define SLM_NO_MESSAGES   0x0

/*
 *  Function prototypes
 */

#ifdef __STDC__

void slm_find_instance(
    int instance_id,      /* Instance id to find */
    slm_handle_t* inst,   /* Handle return */
    slm_status_t* status  /* Status return */
);

void slm_find_instancebyname(
    char *instance_name,  /* Instance name to find */
    slm_handle_t* inst,   /* Handle return */
    slm_status_t* status  /* Status return */
);

void slm_mem_instance_info(
    slm_handle_t handle,  /* Instance to query */
    int* data_width,      /* Data width return */
    int* addr_width,      /* Address width return */
    char* instance_name,  /* Instance name return */
    char* class_name,     /* Class name return */
    slm_status_t* status  /* Status return */
);

void slm_mem_load(
    slm_handle_t handle,  /* Instance to load */
    char* filename,       /* File to load */
    slm_status_t* status  /* Status return */
);

void slm_mem_dump(
    slm_handle_t handle,         /* Instance to dump */
    char* filename,              /* File to dump */
    slm_memory_format_t format,  /* Format to write */
    slm_addr_t* low_addr,        /* First address to dump */
    slm_addr_t* high_addr,       /* Last address to dump */
    slm_status_t* status         /* Status return */
);

void slm_mem_unload(
    slm_handle_t handle,    /* Instance to unload */
    slm_addr_t* low_addr,   /* First address to free */
    slm_addr_t* high_addr,  /* Last address to free */
    slm_status_t* status    /* Status return */
);

void slm_mem_peek(
    slm_handle_t handle,  /* Instance to access */
    slm_addr_t* address,  /* Address to examine */
    slm_data_t* data,     /* Data return */
    slm_status_t* status  /* Status return  */
);

void slm_mem_poke(
    slm_handle_t handle,  /* Instance to access */
    slm_addr_t* address,  /* Address to modify */
    slm_data_t* data,     /* Data to write */
    slm_status_t* status  /* Status return */
);

void slm_mem_trace(
    slm_handle_t handle,   /* Instance to access */
    slm_addr_t* low_addr,  /* First address of trace */
    slm_addr_t* high_addr, /* Last address of trace  */
    char* signalname,        /* Signal name for trace */
    slm_status_t* status   /* Status return */
);

void slm_mem_untrace(
    slm_handle_t handle,   /* Instance to access */
    slm_addr_t* low_addr,  /* First address to untrace */
    slm_addr_t* high_addr, /* Last address to untrace */
    slm_status_t* status   /* Status return */
);

void slm_mem_lastop(
    int rw_handle,          /* Instance accessed */
    slm_addr_t* addr,       /* Address of access */
    slm_data_t* data,       /* Data from access */
    int rw_flag,            /* Acess type */
    slm_status_t* status    /* Status return */
);

void slm_get_message_level(
    slm_handle_t handle,   /* Instance to access */
    slm_message_t* mask,   /* Message mask return */
    slm_status_t* status   /* Status return */
);

void slm_set_message_level(
    slm_handle_t handle,  /* Instance to access */
    slm_message_t mask,   /* Message mask to set */
    slm_status_t* status  /* Status return */
);

void slm_create_db(
    char* filename,       /* File to create or load */
    char* comment,         /* File comment */
    slm_status_t* status   /* Status return */
);

void slm_begin_history(
    char* filename,       /* File create */
    slm_status_t* status   /* Status return */
);

void slm_end_history(
    slm_status_t* status   /* Status return */
);

#else /* not __STDC__ */

void slm_find_instance();
void slm_find_instancebyname();
void slm_mem_instance_info();
void slm_mem_load();
void slm_mem_dump();
void slm_mem_unload();
void slm_mem_peek();
void slm_mem_poke();
void slm_mem_trace();
void slm_mem_untrace();
void slm_get_message_level();
void slm_set_message_level();
void slm_create_db();
void slm_begin_history();
void slm_end_history();

#endif /* __STDC__ */

#endif /* MEMPRO_C_TB_H */
