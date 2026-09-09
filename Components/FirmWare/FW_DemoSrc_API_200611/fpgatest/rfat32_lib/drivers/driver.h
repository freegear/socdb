#ifndef _DRIVER_H_
#define	_DRIVER_H_


void 	InitUART( unsigned char baudrate );
void 	PutChar( unsigned char data );
int 	Printf(const char *format, ...);


#endif
