#include <manik_system.h>

/* read status :
   BIT:0 - transmit buffer empty
   BIT:1 - transmit buffer full
   BIT:2 - receive  buffer full
   BIT:3 - receive data available 
   BIT:4 - polled mode (interrupt disabled)*/
char ser_get_stat()
{
	char rv;

	rv = *((char *)UART_BASE+1);
	return rv;
}

void ser_set_polled(int polled)
{
	if (polled)
		polled = 0x10;
	*((char *)UART_BASE+1) = (char) polled;
}

void ser_set_stat(int stat)
{
	*((char *)UART_BASE+1) = stat;
}

void ser_set_baud(int div)
{
	*((int *)UART_BASE+1) = div;
}

/* write a character into the serial buffer 
   will block of transmit buffer is full */
void ser_put(char p)
{
	*((char *)UART_BASE) = p;
}

/* read a character from the serial buffer 
* will block if no data is available */
char ser_get()
{
	char rv;
	rv = *((char *)UART_BASE);
	return rv;
}


/* send a string */
void ser_put_str(const char *s)
{
	while (*s) ser_put(*s++);
}

