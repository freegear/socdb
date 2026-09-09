/* include forward declarations for serial i/o routines */
#if !defined(SER_H)
#define SER_H

/* read status :
   BIT:0 - transmit buffer empty
   BIT:1 - transmit buffer full
   BIT:2 - receive  buffer full
   BIT:3 - receive data available 
   BIT:4 - polled mode (interrupt disabled)*/
char ser_get_stat();
void set_set_polled(int);
void ser_set_stat(int);
void ser_set_baud(int);

/* write a character into the serial buffer 
   will block of transmit buffer is full */
void ser_put(char);
/* read a character from the serial buffer 
   will block if no data is available */
char ser_get();

/* send a string */
void ser_put_str(const char *);

#endif
