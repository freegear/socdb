
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>


#define __DEBUG__

#define  FAIL   0
#define  SUCC   1

typedef struct pos {
	int  h;
	int  v;
} pos_str;

typedef struct pixel {
	int  r;
	int  g;
	int  b;
} pixel_str;

// function discription
void exit_fun(void);

float rat_pos(float f, float s, float p);
int chk_inter(int s, int e, int p);
int open_pic(char **p, char *fname);

void blt(char *dst, int dhs, int dvs, int hp, int vp, char *src, int shs, int svs);
void  rd_pixel(pixel_str *pixel, int hp, int vp, char *pic, int hs, int vs);
void wr_pixel(pixel_str *pixel, int hp, int vp, char *pic, int hs, int vs);
void interp(pixel_str *pixel, float hp, float vp, pixel_str *pixels);
int line_est(pos_str *sp, pos_str *ep, int vp);

// global variables
// picture size
pos_str  text_s;
pos_str  dst_s;

/*
int  text_v;
int  text_h;
int  dst_v;
int  dst_h;
*/
FILE     *pfile; // pointer of a parameter file

char *texture = NULL;   // texture picture
char *dst_pic = NULL;
char *dst_fname = NULL; // destination picture file name

int   dst_pos[8];

pos_str  *topleft  = (pos_str*)&dst_pos[0];
pos_str  *topright = (pos_str*)&dst_pos[2];
pos_str  *botleft  = (pos_str*)&dst_pos[4];
pos_str  *botright = (pos_str*)&dst_pos[6];

//===========================================================
// Functions

// 두 점간의 거리 비율 계산.
float rat_pos(float f, float s, float p)
{
	float    rat;
	int      l, h;

#ifdef __DEBUG__1
	printf("\n f:%.3f  s:%.3f  p:%.3f",f,s,p);
#endif

	if(f == s) return 0;

	/*
	if( f < s ) {
		l = f;
		h = s;
	}
	else {
		l = s;
		h = f;
	}
	*/
	l = f;
	h = s;
	rat = (float)(p-l)/(float)(h-l);

	return rat;
}

// 두 점사이인지 검사.
int chk_inter(int s, int e, int p)
{
	if(s <= e) {
		if(p >= s && p <= e) return SUCC;
		else return FAIL;
	}
	else {
		if(p >= e && p <= s) return SUCC;
		else return FAIL;
	}
	return FAIL;
}


void blt(char *dst, int dhs, int dvs, int hp, int vp,
		 char *src, int shs, int svs)
{
	int    i, j;
	char   *dpixel, *spixel;

	for(i=0;i<svs;i++) {
		for(j=0;j<shs;j++) {

#ifdef __DEBUG__0
			printf("\n copy pixel");
#endif

			dpixel = dst + 3*(dhs*(vp+i)+hp+j);
			spixel = src + 3*(i*shs + j);
			*dpixel = *spixel;
			*(dpixel+1) = *(spixel+1);
			*(dpixel+2) = *(spixel+2);
		}
		
	}

#ifdef __DEBUG__
	printf("\n BLT end");
#endif

}


void  rd_pixel(pixel_str *pixel, int hp, int vp, char *pic, int hs, int vs)
{
	char *ppixel; // position of a pixel

/*
	if(hp >= hs || vp >= vs) {
		pixel->r = 0;
		pixel->g = 0;
		pixel->b = 0;

		return;
	}
*/
	if(hp >= hs) hp = hs-1;
	else if(hp < 0) hp = 0;

	if(vp >= vs) vp = vs-1;
	else if(vp < 0) vp = 0;

	
	ppixel = pic + 3*(hs*vp + hp);
	pixel->b = (0xff)& *ppixel;
	pixel->g = (0xff)& *(ppixel + 1);
	pixel->r = (0xff)& *(ppixel + 2);

#ifdef __DEBUG__4
	printf("\n Read pixel color R:%x, G:%x, B:%x.",pixel->r,pixel->g,pixel->b);
#endif

}


void wr_pixel(pixel_str *pixel, int hp, int vp, char *pic, int hs, int vs)
{
	char   *ppixel;

	if(hp >= hs || vp >= vs) {
		return;
	}

	ppixel = pic + 3*(hs*vp + hp);
	*ppixel = pixel->b;
	*(ppixel+1) = pixel->g;
	*(ppixel+2) = pixel->r;
}


void interp(pixel_str *pixel, float hp, float vp, pixel_str *pixels)
{
	pixel_str v1, v2;
	float     i;

	i = (float)vp - (float)((int)vp); // 소수만 남김.
	
	v1.r = (pixels[2].r - pixels[0].r)*i + pixels[0].r;
	v1.g = (pixels[2].g - pixels[0].g)*i + pixels[0].g;	
	v1.b = (pixels[2].b - pixels[0].b)*i + pixels[0].b;

	v2.r = (pixels[3].r - pixels[1].r)*i + pixels[1].r;
	v2.g = (pixels[3].g - pixels[1].g)*i + pixels[1].g;	
	v2.b = (pixels[3].b - pixels[1].b)*i + pixels[1].b;

	i = (float)hp - (float)((int)hp); // 소수만 남김.
	
	pixel->r = (v2.r - v1.r)*i + v1.r;
	pixel->g = (v2.g - v1.g)*i + v1.g;
	pixel->b = (v2.b - v1.b)*i + v1.b;

#ifdef __DEBUG__5
	if(pixel->r < 0 || pixel->r > 255 ||
	   pixel->g < 0 || pixel->g > 255 ||
	   pixel->b < 0 || pixel->b > 255)
	printf("\n Read pixel color R:%x, G:%x, B:%x.",pixel->r,pixel->g,pixel->b);
#endif

    // saturation
	pixel->r = (pixel->r > 255)?255:pixel->r;
	pixel->g = (pixel->g > 255)?255:pixel->g;
	pixel->b = (pixel->b > 255)?255:pixel->b;


	// under
	pixel->r = (pixel->r < 0)? 0:pixel->r;
	pixel->g = (pixel->g < 0)? 0:pixel->g;
	pixel->b = (pixel->b < 0)? 0:pixel->b;

}


// line estimation
int line_est(pos_str *sp, pos_str *ep, int vp)
{
	float    hp;
	pos_str  *lpv, *hpv;

	if(sp->v > ep->v) {
		lpv = ep;
		hpv = sp;
	}
	else {
		lpv = sp;
		hpv = ep;
	}
	
	if(vp < lpv->v || vp > hpv->v) {
		printf("\n over the vertical range.");
		return 0; // error
	}

	hp = lpv->h + (vp - lpv->v)*(hpv->h - lpv->h)/(hpv->v - lpv->v);

	if(sp->h > ep->h) {
		lpv = ep;
		hpv = sp;
	}
	else {
		lpv = sp;
		hpv = ep;
	}
	if(hp < lpv->h || hp > hpv->h) {
		printf("\n over the horizontal range.");
		return 0; // error
	}

#ifdef __DEBUG__
	printf("\n Horizontal Range :(%d,%d), (%d,%d)",lpv->h,lpv->v,hpv->h,hpv->v);
	printf("\n     called %d : %.3f",vp,hp);
#endif
	return (int)hp;
}



int open_pic(char **p, char *fname)
{
	struct stat   fstat;
	FILE          *pic = NULL;
	int           bcount;

	if(strlen(fname) <= 0) return FAIL;
	if((pic = fopen(fname,"rb")) == NULL) {
		printf("\n ERROR : Cannot open file : %s",fname);
		return FAIL;
	}
	if(stat(fname,&fstat) != 0) {
		printf("\n ERROR : Cannot get file state : %s",fname);
		fclose(pic);
		return FAIL;
	}
	
	if((*p = malloc(fstat.st_size+2)) == NULL) {
		printf("\n ERROR : Cannot allocate memory for file buffer");
		fclose(pic);
		return FAIL;
	}

	bcount = fread(*p,fstat.st_size,1,pic);
	if(bcount == 0) {
		printf("\n ERROR : Cannot copy picture from file to memory");
		fclose(pic);
		return FAIL;
	}
	fclose(pic);
	return SUCC;
}


void exit_fun(void)
{
	if(pfile != NULL)  fclose(pfile);
	if(texture != NULL)   free(texture);
	if(dst_pic != NULL)   free(dst_pic);
	if(dst_fname != NULL) free(dst_fname);
}

//===============================================================
//

int main(int argc, char **argv)
{
	int      i,j;
	int      position;
	int      v, h;
	char     str[4*20];
	
	pixel_str  src_pixel[4];
	pixel_str  dst_pixel;
	
	int       highest;

	int       hpos[4];
	int       sp, ep;// horizontal start and end point
	int       spl, epl; // start poiint line, end point line

	float     ratv1, ratv2, rath;

	float     posh1, posv1, posh2, posv2; // pixel position of sp, ep
	float     pposh, pposv; // pixel position
	

	if(argc <= 1) {
		return 0;
	}

	atexit(exit_fun);

#ifdef __DEBUG__
	printf("\n Read parameter file : %s",argv[1]);
#endif
	
	// read parameter file
	if((pfile = fopen(argv[1],"r")) == NULL) {
		printf("\n ERROR : Cannot open parameter file : %s",argv[1]);
		exit(0);
	}


	// picture read
	for(i=0;i<3;i++) {
		if(fscanf(pfile,"%d %d %s",&h,&v,str) == 0) {
			printf("\n ERROR : unexpected end of the parameter file");
			exit(0);
		}

#ifdef __DEBUG__
		printf("\n Read parameter : %d %d %s",h,v,str);
#endif

		switch(i) {
		case 0 :
			if(open_pic(&texture,str) == FAIL) {
				printf("\n ERROR : Cannot read texture picture.");
				exit(0);
			}
			text_s.v = v;
			text_s.h = h;
			break;
		case 1 :
			if(open_pic(&dst_pic,str) == FAIL) {
				printf("\n ERROR : Cannot read destination picture.");
				exit(0);
			}
			dst_s.v = v;
			dst_s.h = h;
			break;
		case 2 :
			dst_fname = malloc(strlen(str)+2);
			if(dst_fname == NULL) {
				printf("\n ERROR : Cannot allocate memory for dst_fname.");
				exit(0);
			}
			strcpy(dst_fname,str);
			printf("\n copied target file name");
			break;
		default : exit(0);
		} // end switch
	} // end for


	// Get target position
	for(i=0;i<8;i++) {
		if(fscanf(pfile,"%d",&position) == 0) {
			printf("\n ERROR : unexpected end of the parameter file");
			exit(0);
		}

#ifdef __DEBUG__
		printf("\n Read parameter : %d",position);
#endif
		
		dst_pos[i] = position;
	}
	
	fclose(pfile);
	pfile = NULL;

	//============================================================
	// copy source to dst
	blt(dst_pic, dst_s.h, dst_s.v, dst_s.h-text_s.h, dst_s.v-text_s.v, 
		texture, text_s.h, text_s.v);

#ifdef __DEBUG__
	printf("\n Texture copy end");

//	goto skip;
#endif

	//============================================================
	// texture mapping

	// search highest vertical position
	if(topleft->v < topright->v) i = topright->v;
	else i = topleft->v;
	if(botleft->v < botright->v) j = botright->v;
	else j = botleft->v;
	if( i < j ) highest = j;
	else highest = i;

	// search lowest vertical position
	if(topleft->v > topright->v) i = topright->v;
	else i = topleft->v;
	if(botleft->v > botright->v) j = botright->v;
	else j = botleft->v;
	if( i > j ) i = j;

#ifdef __DEBUG__
	printf("\n Searched start vertical position");
#endif
	
	for(;i<=highest;i++) {   // vertical line 단위로 처리.

#ifdef __DEBUG__
		printf("\n==============================================");
		printf("\n %d vertical line",i);
#endif
		// horizontal drawing range에 의해서 점 d와 점 b의 horizontal position은 알 수 있음.
		// 별도로 계산 불필요
		// 아래 4개중 2개는 -1
		if(chk_inter(topleft->v, topright->v, i) == SUCC) {
			hpos[0] = line_est(topleft, topright, i);
		}
		else hpos[0] = -1;

		if(chk_inter(topright->v, botright->v, i) == SUCC) {
			hpos[1] = line_est(topright, botright, i);
		}
		else hpos[1] = -1;

		if(chk_inter(botright->v, botleft->v, i) == SUCC) {
			hpos[2] = line_est(botright, botleft, i);
		}
		else hpos[2] = -1;

		if(chk_inter(botleft->v, topleft->v, i) == SUCC) {
			hpos[3] = line_est(botleft, topleft, i);
		}
		else hpos[3] = -1;


#ifdef __DEBUG__
		printf("\n Search horizontal start/end position");
		int k;
		for(k=0;k<4;k++) {
			printf("\n hpos[%d] = %d",k,hpos[k]);
		}
#endif
		
		// horizontal start position과 end position을 검색
		sp = dst_s.h; // max position
		ep = 0;
		for(j=0;j<4;j++) {
			if(hpos[j] < sp && hpos[j] >= 0) {
				sp = hpos[j];
				spl = j;
			}
			if(hpos[j] > ep && hpos[j] >= 0) {
				ep = hpos[j];
				epl = j;
			}
		}

		// source에서의 start, stop point position
		// veritical 1st
		switch(spl) {
		case 0 :
			ratv1 = rat_pos(topleft->v, topright->v, i);
			posh1 = (text_s.h-0)*ratv1 + 0;
			posv1 = (0-0)*ratv1 + 0;
			break;
		case 1 :
			ratv1 = rat_pos(topright->v, botright->v, i);
			posh1 = (text_s.h-text_s.h)*ratv1+text_s.h;
			posv1 = (text_s.v-0)*ratv1 + 0;
			break;
		case 2 :
			ratv1 = rat_pos(botleft->v, botright->v, i);
			posh1 = (text_s.h-0)*ratv1 + 0;
			posv1 = (text_s.v-text_s.v)*ratv1 + text_s.v;
			break;
		default :
			ratv1 = rat_pos(topleft->v, botleft->v, i);
			posh1 = (0-0)*ratv1 + 0;
			posv1 = (text_s.v-0)*ratv1 + 0;
		}

		switch(epl) {
		case 0 :
			ratv2 = rat_pos(topleft->v, topright->v, i);
			posh2 = (text_s.h-0)*ratv2 + 0;
			posv2 = (0-0)*ratv2 + 0;
			break;
		case 1 :
			ratv2 = rat_pos(topright->v, botright->v, i);
			posh2 = (text_s.h-text_s.h)*ratv2 + text_s.h;
			posv2 = (text_s.v-0)*ratv2 + 0;
			break;
		case 2 :
			ratv2 = rat_pos(botleft->v, botright->v, i);
			posh2 = (text_s.h-0)*ratv2 + 0;
			posv2 = (text_s.v-text_s.v)*ratv2 + text_s.v;
			break;
		default :
			ratv2 = rat_pos(topleft->v, botleft->v, i);
			posh2 = (0-0)*ratv2 + 0;
			posv2 = (text_s.v-0)*ratv2 + 0;
		}

#ifdef __DEBUG__
		printf("\n source horizontal start/end position");
		printf("\n posh1 = %.3f posv1 = %.3f",posh1,posv1);	
		printf("\n posh2 = %.3f posv2 = %.3f",posh2,posv2);
		//exit(0);
#endif


#ifdef __DEBUG__
		printf("\n target horizontal calc start");
		printf("\n Start point : %d  End point : %d",sp,ep);
		//exit(0);
#endif
		
#ifdef __DEBUG__3
		//fixed single color
		dst_pixel.r=255;
		dst_pixel.g=dst_pixel.b=0;
		wr_pixel(&dst_pixel,sp,i,dst_pic,dst_s.h,dst_s.v);
		dst_pixel.g=255;
		dst_pixel.r=dst_pixel.b=0;
		wr_pixel(&dst_pixel,ep,i,dst_pic,dst_s.h,dst_s.v);
		continue;
#endif
		//-----------------------------------------------------
		// pixel 단위 처리.
		for(j=sp;j<=ep;j++) {
			rath = rat_pos(sp, ep,j);
			// source에서의 target pixel과 대응되는 position
			pposh = (posh2-posh1)*rath + posh1;
			pposv = (posv2-posv1)*rath + posv1;

#ifdef __DEBUG__4
			printf("\n horizontal calc start");
			printf("\n H point : %d  V point : %d",j,i);
			printf("\n H ratio : %.3f",rath);
			printf("\n pposh = %.3f pposv = %.3f",pposh,pposv);
			//exit(0);
			if(rath < 0) exit(0);
#endif

			// read source pixels
			rd_pixel(&src_pixel[0],(int)pposh,(int)pposv,texture,text_s.h,text_s.v);
			rd_pixel(&src_pixel[1],(int)pposh+1,(int)pposv,texture,text_s.h,text_s.v);
			rd_pixel(&src_pixel[2],(int)pposh,(int)pposv+1,texture,text_s.h,text_s.v);
			rd_pixel(&src_pixel[3],(int)pposh+1,(int)pposv+1,texture,text_s.h,text_s.v);
			
			interp(&dst_pixel,pposh,pposv,src_pixel);
			
			wr_pixel(&dst_pixel,j,i,dst_pic,dst_s.h,dst_s.v);
		}
		
	}

  skip:
	
	// write to memory
	pfile = fopen(dst_fname,"wb");
	
	if(pfile == NULL) {
		printf("\n ERROR : Cannot open a file for writing : %s",dst_fname);
		exit(0);
	}

	fwrite(dst_pic ,3*dst_s.v*dst_s.h , 1, pfile);
	
	fclose (pfile);

	exit(0);

}
