/*************************************************************************

   Header of the calculation the horizontal range

   file name : hrange.h
   created by gtlee
   data : 2006.7.4

   note :


   history :

************************************************************************/

// Global




#ifdef    __HRANGE__
//-------------------------------------------------
// local
void next_bline(int se, int new, int dx, int dy, int sposx, 
				int &posn, int &posn5);
void next_circle(int se, int new, int r, int &posn, int &posn5);
int cc_case(int sposx, int eposx, int cd);
void sbbl_edge(int width, int dy, int dx, int estyle, 
			   int *deltax, int *deltay);
void bl_edge(pos *le_pos, pos *l_pos, int width, int estyle);
void c_edge(pos *le_pos, pos *l_pos, int width, int ccase);
int bleng_posx(int sposx, int l, int dx, int dy);









#else
//--------------------------------------------------
// external




#endif
