# srcscan.awk
#
#	$Id:
#
# 21-Nov-1997 MJQ Created
#
# Scans any file looking for comments, blank lines and source

BEGIN {
	FALSE = 0
	TRUE = -1

	comment = 0
	asm_comment = 0
	prev_comment = 0

	base1 = 0
	base2 = 0

	comments = 0
	blanks = 0
	lines = 0
	partial = 0
	linenum = 0
	file_count = 0
}

{
	# On the first line of each file, determine the comment style using
	# the extension of the filename
	if (FNR == 1) {
		name[1] = tolower(FILENAME)
		ext = index(name[1], ".")
		len = length(name[1])
		filetype[1] = substr(name[1], ext + 1)
		#printf("%d %s %d %s\n", len, name[1], ext, filetype[1])
		file_count += 1
		# *.s or *.asm is assembler, no multi-line comments
		if ((index(filetype[1], "s")) || (index(filetype[1], "asm"))) {
			asm_comment = TRUE
			multiline = FALSE
		}
		# otherwise, 'C' type comments, maybe multi-line
		else {
			asm_comment = FALSE
		}
	}

	end_comment = 0

	if (asm_comment == TRUE) {
		end_comment = comment = index ($0, ";")
	}
	else {
		# 2 types of 'C' comment - // is not multi-line
		comment = index ($0, "/*")
		comment2 = index ($0, "//")

		if (comment2 != 0) {
			multiline = FALSE
			comment = end_comment = comment2
		}
		if (comment2 == 0) {
			multiline = TRUE
			end_comment = index ($0, "*/")
		}
		if ((end_comment != 0) && (comment == 0))
			comment = 1
	}

	base1 = index($0, $1)
	base2 = index($0, $2)

	# Count blank lines as blanks, even if the previous line was a comment
	# If previously a comment or this line starts with a comment..
	if((prev_comment != 0 && base1 != 0) ||
		((comment != 0) && (comment <= base1))) {
		# It's a comment
		comments += 1
		#printf("c:%s\n", $0)
		if (end_comment != 0)
			prev_comment = 0
		else	prev_comment = 1
	}
	else if (base1 == 0) {
		# Blank line
		blanks += 1
		#printf(" :%s\n", $0)
	}
	else {
		# Actual source line
		lines += 1
		if (comment != 0) {
			partial += 1
			#printf("p:%s\n", $0)
		}
		#else printf("l:%s\n", $0)
	}

}

END {
	total = comments + blanks + lines
	commented = comments + partial
	active = comments + lines

	# Avoid divide by 0 errors
	if (total == 0)
		total = 1

	printf("\n%d files\n", file_count)
	printf("\nSource lines\t%6d\t(%4.1f%)", lines, (lines * 100) / total)
	printf("\t\t[%6d with comments (%4.1f%)]\n",
		partial, (partial * 100) / lines)
	printf("Commented lines\t%6d\t(%4.1f%)",
		commented, (commented * 100) / total)
	printf("\t\t[%6d just comments (%4.1f%)]\n",
		comments, (comments * 100) / total)
	printf("Blank lines\t%6d\t(%4.1f%)\n", blanks, (blanks * 100) / total)
	printf("\nTotal lines\t%6d\t\t\t[%6d active lines  (%4.1f%)]\n",
		total, active, (active * 100) / total)
	printf("\n")
}
