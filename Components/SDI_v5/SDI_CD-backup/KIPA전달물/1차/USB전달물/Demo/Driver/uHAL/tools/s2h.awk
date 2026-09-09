#/***************************************************************************
# * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
# * Copyright © ARM Limited 1998.  All rights reserved.
# ***************************************************************************/
#
# s2h.awk
#
#	$Id: s2h.awk,v 1.3 1999/01/21 18:18:48 mquinn Exp $
#
# 12-Jan-1996 NAC Created
#
# Take a .s file containing ;-delimited comments and EQUates
# and convert it to #defines and c-style comments for a c .h file
#
# 11-Nov-1996 MJQ to
# 18-Jun-1997 MJQ
# Various changes to improve comment handling, support for 'C' #defines,
# #ifdefs etc. and INCLUDE .s -> #include .h
#
# 15-Jan-1998 MJQ
# Fixed a bug on lines with a defined value which matched an earlier part
# of the line. eg this>1< EQU 1 ; first '1' matched by the line splitter

BEGIN {
  FALSE = 0
  TRUE = -1
  print("")
  print("/* DO NOT EDIT!! - this file automatically generated")
  print(" *                 from .s file by awk -f s2h.awk")
  print(" */")
  # This script can handle multi-line comments by flagging if the previous
  # line was a comment. However this obscures the basic function of the
  # script. If you want to understand this script better, it may help to
  # remove all reference to prev_comment and just treat each line seperately.
  prev_comment = 0
  comment = 0
  include = 0
  equate = 0
  c_comment = 0
  c_define = 0
  end_c_comment = 0
}

{
  comment = index ($0, ";")
  include = index ($0, "INCLUDE")
  equate = index ($0, "EQU")
  c_comment = index ($0, "/*")
  end_c_comment = index ($0, "*/")
  linelen = length($0)

  if (($2 == "EQU") && ((comment==0) || (comment > equate )))
  {
     # this line contains an equate, and the equate is not commented out.
     # The equate line may have a comment at the end of it.

     # Find the start of the define value (must be after the EQU)
     start = index(substr($0, equate+1, linelen), $3) + equate

     if (comment != 0)
     {
	if (prev_comment)
	{
	   prev_comment = 0
	   printf(" */\n");
	}
	# When it all goes pear-shaped, uncomment these printfs to get some
	# idea what's going on. Lists fields as found & offsets in the line.
	# printf("%d %s %d %s,", index($0, $1) , $1, equate, $2)
	# printf(" %d %d (%s)\n", start, comment, $3)

     	# Let's get the EQU to define out of the way..
	printf("#define %-30s  %s",$1, substr($0, start, comment - start))
	# there is a comment at the end of the line
	# Watch out for 'C'-style comments inside comments
	if (c_comment == 0)
	   printf(" /* %s", substr($0, comment+1, linelen))
	else
	   printf(" %s", substr($0, c_comment, linelen))

        if (end_c_comment == 0)
	{
	   prev_comment = 0
	   printf(" */");
	}
     }
     else
     {
	if (prev_comment)
	{
	   prev_comment = 0
	   printf(" */\n");
	}
	# When it all goes pear-shaped, uncomment these printfs to get some
	# idea what's going on. Lists fields as found & offsets in the line.
	# printf("%d %s %d %s,", index($0, $1) , $1, equate, $2)
	# printf(" %d %d (%s)\n", start, index($0, $3), $3)

	# No comment, just print the whole line..
	printf("#define %-30s  %s",$1, substr($0, start, linelen))

     }
     printf("\n");
  }
  else if ((include != 0) && ((comment==0) || (comment > include )))
  {
     # this line contains an include, and the include is not commented out.

     if (prev_comment)
     {
        prev_comment = 0
        printf(" */\n");
     }
     # Let's get the INCLUDE to include out of the way..
     printf("#include \"%sh\" ", substr($2, 1, index($2, ".")))
     printf("\n");
     # IGNORE COMMENTS (if any)
  }
  else
  {
     if (comment == 0)
     {
	if (prev_comment)
	{
	   prev_comment = 0
	   printf(" */\n");
	}
	# Can't have ANY comments with IF, ELSE, ENDIF
	if (($1 == "IF") || ($1 == "\[")) 
	{
	   # Convert 'IF :DEF: this' to '#ifdef this'
	   if ($2 == ":DEF:")
              printf("#ifdef %s\n",$3)
	   # else convert 'IF :LNOT: :DEF: this' to '#ifndef this'
	   else if (($2 == ":LNOT:") && ($3 == ":DEF:"))
              printf("#ifndef %s\n",$4)
	   # else convert 'IF this <> that' to '#if this != that'
	   else if ($3 == "<>")
              printf("#if %s != %s\n", $2, substr($0, index($0, $4), linelen))
	   # else, just a simple 'IF' to '#if'
	   else
              printf("#if %s\n", substr($0, index($0, $2), linelen))
	}
	else if (($1 == "ENDIF") || ($1 == "\]"))
           printf("#endif\n")
	else if (($1 == "ELSE") || ($1 == "\|"))
           printf("#else\n")

        # probably a blank line. Just echo it..
        else if (index ($0, "END") == 0)
           print($0)
        else
           printf("/* %s */\n",$0)
     }
     else
     {
        # the line is a comment line
        if (comment > index ($0, $1))
	{
	   # ..but there's some stuff before the semi-colon.

	   if (prev_comment)
	   {
	      prev_comment = 0
	      printf(" */\n");
	   }
	   # Watch out for END & a comment!
           end = index ($0, "END")
	   if ((end != 0) && (comment > end))
	   {
               printf("/* ")
	       # Don't print out another start of comment
	       if (c_comment == 0)
	          c_comment = comment + 1
	       else
	          c_comment = c_comment + 2
	   }
	   # echo upto start of comment
	   printf("%s ", substr($0, 1, comment-1));
	}
	# Do a special check for ;; as a single comment
	end_comment = index($0, ";;")
	if (end_comment == 0)
	   end_comment = comment 
	else
	   end_comment = end_comment + 1

	# Look for 'C' #defines etc. _inside_ comments
	c_define = index ($0, "#if")
	if (c_define == 0)
	   c_define = index ($0, "#endif")
	if (c_define == 0)
	   c_define = index ($0, "#else")
	if (c_define == 0)
	   c_define = index ($0, "#define")
	if (c_define == 0)
	   c_define = index ($0, "#include")
	if (c_define != 0)
	{
	   if (prev_comment)
	   {
	      prev_comment = 0
	      printf(" */\n");
	   }
           # It's really a 'C' #define - ignore before & print line
	   printf("%s", substr($0, c_define, linelen))
	}
	else
	{
	   # Whatever is left is just a comment.

	   # Watch out for 'C'-style comments inside comments
	   if (c_comment == 0)
	   {
	      if (prev_comment == 0)
	         printf("/");
	      else
	         printf(" ");

	      # if removing prev_comment, this line should be:
	      # printf("/* %s", substr($0, end_comment+1, linelen))
	      printf("* %s", substr($0, end_comment+1, linelen))
	   }
	   else
	   {
	      if (prev_comment)
	      {
	         prev_comment = 0
	         printf(" */\n");
	      }
	      printf("%s", substr($0, c_comment, linelen))
	   }

           if (end_c_comment == 0)
	      prev_comment = 1
	      # if removing prev_comment, this line should be:
	      # printf(" */");
	   else
	      prev_comment = 0
	}

     printf("\n");
     }
  }
}

END {
  if (prev_comment)
  {
     prev_comment = 0
     printf(" */\n");
  }
}
