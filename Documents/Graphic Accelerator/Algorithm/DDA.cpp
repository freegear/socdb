// DDA Line Algorithm

// used by myLine
void myPixel(SURFACE* surface, int x,int y) {
	// PLOT x,y point on surface

}


// DDA Line Algorithm
void myLine(SURFACE* surface, int x1, int y1, int x2, int y2) {
  int length,i;
  double x,y;
  double xincrement;
  double yincrement;

  length = abs(x2 - x1);
  if (abs(y2 - y1) > length) length = abs(y2 - y1);
  xincrement = (double)(x2 - x1)/(double)length;
  yincrement = (double)(y2 - y1)/(double)length;
  x = x1 + 0.5; 
  y = y1 + 0.5;
  for (i = 1; i<= length;++i) {
     myPixel(surface,(int)x, (int)y);
     x = x + xincrement;
     y = y + yincrement;
  }

}
