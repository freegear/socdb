/*
 *   FILE: abs.c
 * AUTHOR: kma
 *  DESCR: absolute value; we need this
 */

#ident "$Id: abs.c,v 1.1.1.1 2001/09/10 07:43:56 simons Exp $"

int abs(int j)
{
	return (j<0)? -j : j;
}
