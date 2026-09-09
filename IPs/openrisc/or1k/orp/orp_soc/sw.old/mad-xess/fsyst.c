#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#ifndef EMBED
# include <assert.h>
# include <string.h>
#else
# warning assert checking disabled
# define assert(x)
#endif

#include "fsyst.h"

/* Return next file.  */

inline struct file_struct *
next_file (struct file_struct *file) {
  return (struct file_struct *)((unsigned char *)file + swap(file->length));
}

/* Returns file, that holds track number.  */

struct file_struct *
find_track_no (int no, struct file_struct *root) {
  assert(swap(root->type) == FT_ROOT);
  while (swap(root->type) != FT_END) {
    if (swap(root->type) == FT_TRACK_NO && swap(root->data[0]) == no)
      return root;
    root = next_file (root);
  }
  return 0;
}

/* Returns track name from file struct, pointing at FT_TRACK_NO.  */

char *
track_name (struct file_struct *fs) {
  assert(swap(fs->type) == FT_TRACK_NO);
  fs = next_file (fs);
  if (swap(fs->type) == FT_TRACK_NAME)
    return (char *)&fs->data[0];
  else
    return "";
}

/* Returns track data from file struct, pointing at FT_TRACK_NO.  */

struct file_struct *
track_data (struct file_struct *fs) {
  assert(swap(fs->type) == FT_TRACK_NO);
  fs = next_file (fs);
  if (swap(fs->type) == FT_TRACK_NAME)
    fs = next_file (fs);
  assert (swap(fs->type) == FT_TRACK_DATA);
  return fs;
}

/* Finds last record.  */

inline struct file_struct *
end_file (struct file_struct *root) {
  assert(swap(root->type) == FT_ROOT);
  while (swap(root->type) != FT_END)
    root = next_file (root);
  return root;  
}

/* Adds file to the end of file list.  Returns new file address, if
   sucessful, otherwise NULL.  */

struct file_struct *
add_file (struct file_struct *root, struct file_struct *file) {
  struct file_struct *end = end_file (root);
  memcpy (end, file, file->length);
  file = end;
  end = next_file (end);
  end->type = swap(FT_END);
  end->length = swap(0);
  return file;
}

/* Initializes filesystem at root.  */

void
init_fsyst (struct file_struct *root) {
  root->type = swap(FT_ROOT);
  root->length = swap(sizeof (struct file_struct) - sizeof (unsigned int));
  root = next_file (root);
  root->type = swap(FT_END);
  root->length = swap(0);
}

#ifndef EMBED
unsigned int swap (unsigned int x) {
  return (x & 0xFF) << 24
    | (x & 0xFF00) << 8
    | (x & 0xFF0000) >> 8
    | (x & 0xFF000000) >> 24;
}
#endif

