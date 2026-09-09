# 1 "readdir.c"
# 1 "../include/dirent.h" 1
 

















 






# 1 "../include/features.h" 1









 














 



 





# 1 "../include/sys/cdefs.h" 1



# 1 "../include/features.h" 1

# 38 "../include/features.h"


# 4 "../include/sys/cdefs.h" 2







 

typedef long double __long_double_t;

# 26 "../include/sys/cdefs.h"


 



 




# 35 "../include/features.h" 2





# 26 "../include/dirent.h" 2


 

# 1 "../include/gnu/types.h" 1
 






















 
typedef unsigned char __u_char;
typedef unsigned short __u_short;
typedef unsigned int __u_int;
typedef unsigned long __u_long;
typedef struct
{
  long val[2];
} __quad;
typedef struct
{
  __u_long val[2];
} __u_quad;


typedef unsigned short __dev_t;	 
typedef unsigned short __gid_t;	 
typedef unsigned short __uid_t;	 
typedef unsigned short __mode_t; 
typedef long	__daddr_t;	 
typedef long	__off_t;	 

typedef long long __loff_t;	 

typedef unsigned long __ino_t;	 
typedef unsigned short __nlink_t;	 
typedef long	__time_t;
# 61 "../include/gnu/types.h"


typedef int __pid_t;		 
typedef int __ssize_t;		 
typedef __quad __fsid_t;	 

 
typedef char *__caddr_t;
typedef long int __swblk_t;	 


 





# 1 "../include/linux/posix_types.h" 1



 









 










 























typedef struct {
	unsigned long fds_bits [(1024 / (8 * sizeof(unsigned long)) ) ];
} __kernel_fd_set;

# 1 "../include/asm/posix_types.h" 1



 





typedef unsigned short	__kernel_dev_t;
typedef unsigned long	__kernel_ino_t;
typedef unsigned short	__kernel_mode_t;
typedef unsigned short	__kernel_nlink_t;
typedef long		__kernel_off_t;
typedef int		__kernel_pid_t;
typedef unsigned short	__kernel_uid_t;
typedef unsigned short	__kernel_gid_t;
typedef unsigned long	__kernel_size_t;
typedef int		__kernel_ssize_t;
typedef int		__kernel_ptrdiff_t;
typedef long		__kernel_time_t;
typedef long		__kernel_clock_t;
typedef int		__kernel_daddr_t;
typedef char *		__kernel_caddr_t;

 
 



typedef long       __kernel_loff_t;

typedef struct {



	int	__val[2];

} __kernel_fsid_t;














# 53 "../include/linux/posix_types.h" 2



# 78 "../include/gnu/types.h" 2






typedef struct __fd_set {
        unsigned long fds_bits [(1024 / (8 * sizeof(unsigned long)) ) ];
} __fd_set;

# 128 "../include/gnu/types.h"


# 152 "../include/gnu/types.h"



# 30 "../include/dirent.h" 2



# 1 "../include/stddef.h" 1
 



 






 







typedef unsigned long size_t;








# 33 "../include/dirent.h" 2


# 1 "../include/sys/types.h" 1
# 1 "../include/stddef.h" 1
 



 






 


# 27 "../include/stddef.h"


# 1 "../include/sys/types.h" 2

# 1 "../include/sys/bitypes.h" 1
 



 






















































 



 











	 



	typedef   char            int8_t;
	typedef unsigned char            u_int8_t;
	typedef short                     int16_t;
	typedef unsigned short          u_int16_t;
	typedef int                       int32_t;
	typedef unsigned int            u_int32_t;


	typedef long long                 int64_t;
	typedef unsigned long long      u_int64_t;




 
# 2 "../include/sys/types.h" 2

# 1 "../include/linux/types.h" 1



# 14 "../include/linux/types.h"



# 1 "../include/asm/types.h" 1



 







typedef unsigned short umode_t;

 




typedef __signed__ char __s8;
typedef unsigned char __u8;

typedef __signed__ short __s16;
typedef unsigned short __u16;

typedef __signed__ int __s32;
typedef unsigned int __u32;


typedef __signed__ long long __s64;
typedef unsigned long long __u64;


 


# 50 "../include/asm/types.h"



# 17 "../include/linux/types.h" 2




typedef __kernel_fd_set		fd_set;
typedef __kernel_dev_t		dev_t;
typedef __kernel_ino_t		ino_t;
typedef __kernel_mode_t		mode_t;
typedef __kernel_nlink_t	nlink_t;
typedef __kernel_off_t		off_t;
typedef __kernel_pid_t		pid_t;
typedef __kernel_uid_t		uid_t;
typedef __kernel_gid_t		gid_t;
typedef __kernel_daddr_t	daddr_t;


typedef __kernel_loff_t		loff_t;


 










typedef __kernel_ssize_t	ssize_t;




typedef __kernel_ptrdiff_t	ptrdiff_t;




typedef __kernel_time_t		time_t;




typedef __kernel_clock_t	clock_t;




typedef __kernel_caddr_t	caddr_t;


 
typedef unsigned char		u_char;
typedef unsigned short		u_short;
typedef unsigned int		u_int;
typedef unsigned long		u_long;

 
typedef unsigned char		unchar;
typedef unsigned short		ushort;
typedef unsigned int		uint;
typedef unsigned long		ulong;



 




struct ustat {
	__kernel_daddr_t	f_tfree;
	__kernel_ino_t		f_tinode;
	char			f_fname[6];
	char			f_fpack[6];
};


# 3 "../include/sys/types.h" 2

# 35 "../include/dirent.h" 2

# 1 "../include/linux/limits.h" 1



# 1 "../include/linux/config.h" 1



# 1 "../include/linux/autoconf.h" 1
 





 




 




 






 











 





 









 


















 






 



# 4 "../include/linux/config.h" 2


 


















 




 

 





 





# 4 "../include/linux/limits.h" 2



























# 36 "../include/dirent.h" 2

# 1 "../include/linux/dirent.h" 1



struct dirent {
	long		d_ino;
	__kernel_off_t	d_off;
	unsigned short	d_reclen;
	char		d_name[256];  
};


# 37 "../include/dirent.h" 2









# 65 "../include/dirent.h"


 
typedef struct DIR DIR;




 

extern DIR *opendir  (const  char *__name)  ;

 

extern int closedir  (DIR * __dirp)  ;

 



extern struct dirent *readdir  (DIR * __dirp)  ;

 
extern void rewinddir  (DIR * __dirp)  ;

# 146 "../include/dirent.h"



extern int readdir_r  (DIR *__dirp, struct dirent *__entry,
		struct dirent **__result)  ;


 


# 1 "readdir.c" 2

# 1 "../include/errno.h" 1




# 1 "../include/linux/errno.h" 1



# 1 "../include/asm/errno.h" 1






































































































































# 4 "../include/linux/errno.h" 2


# 14 "../include/linux/errno.h"



# 5 "../include/errno.h" 2











extern int	errno;

 

extern void	perror  (const  char* __s)  ;
extern char*	strerror  (int __errno)  ;

 


# 2 "readdir.c" 2

# 1 "../include/sys/syscall.h" 1






















































































































































































# 3 "readdir.c" 2


# 1 "dirstream.h" 1
 

















 












 











 
struct DIR {
   
  int dd_fd;

   
  off_t dd_nextloc;

   
  size_t dd_size;

   
  struct dirent *dd_buf;

   
  off_t dd_nextoff;

   
  size_t dd_max;
 
  enum {unknown, have_getdents, no_getdents} dd_getdents;

   



  void *dd_lock;

};				 


# 5 "readdir.c" 2


static inline
_syscall3(int, getdents, int, __fildes, struct dirent *, __buf, size_t, __nbyte);

struct dirent *
readdir (DIR *dir)
{
  int result;
  struct dirent *de;

  if (!dir)
    {
      errno = 9 ;
      return ((void *) 0) ; 
    }

  if (dir->dd_size <= dir->dd_nextloc)
    {
       
      result = getdents(dir->dd_fd, dir->dd_buf, dir->dd_max);
 










       
      dir->dd_getdents = have_getdents;
      if (result <= 0)
	{
	  errno = -result;
	  return ((void *) 0) ;
	}

      dir->dd_size = result;
      dir->dd_nextloc = 0;
    }

  de = (struct dirent *) ((char *) dir->dd_buf + dir->dd_nextloc);

   
  dir->dd_nextloc += de->d_reclen;

   
  dir->dd_nextoff = de->d_off;

  return de;
}
