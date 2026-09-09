

/* Where does filesystem start */
extern unsigned char *root_file;
#define ROOT_FILE ((struct file_struct *)root_file)//0x20000)

enum enum_file_type {
  /* Must be first file.  */
  FT_ROOT,
  /* Track number.  */
  FT_TRACK_NO,
  /* Track name.  */
  FT_TRACK_NAME,
  /* Track data.  */
  FT_TRACK_DATA,
  /* Last record.  */
  FT_END
};

struct file_struct {
  /* Length of file, including header.  */
  unsigned int length;
  
  /* File type.  */
  enum enum_file_type type;

  /* Actual file data.  */
  unsigned int data[1];
};

#define HEADER_SIZE (sizeof (struct file_struct) - sizeof (unsigned int))

/* Returns file, that holds track number.  */
extern struct file_struct *find_track_no (int no, struct file_struct *root);

/* Returns track name from file struct, pointing at FT_TRACK_NO.  */
extern char *track_name (struct file_struct *fs);

/* Returns track data from file struct, pointing at FT_TRACK_NO.  */
extern struct file_struct *track_data (struct file_struct *fs);

/* Finds last record.  */
extern struct file_struct * end_file (struct file_struct *root);

/* Adds file to the end of file list.  Returns new file address, if
   sucessful, otherwise NULL.  */
extern struct file_struct *add_file (struct file_struct *root,
			      struct file_struct *file);
/* Initializes filesystem at root.  */
extern void init_fsyst (struct file_struct *root);

#ifdef EMBED
#define swap(x) (x)
#else
extern unsigned int swap (unsigned int x);
#endif
