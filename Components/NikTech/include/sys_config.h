#if !defined(SYS_CONFIG_H)
#define SYS_CONFIG_H
#define CLK_FREQ (50*1000*1000)
#define CLOCKS_PER_SEC (50*1000*1000)

#define MANIK_CACHEABLE_MAX (1<<(17+11))-1
#define MANIK_DCACHE_SIZE 	4096
#define MANIK_DCACHE_LINE_SIZE 	4

#define MANIK_ICACHE_SIZE 	4096
#define MANIK_ICACHE_LINE_SIZE 	4

/* UART BEGIN */

#define UART_PRESENT
#if defined(UART_PRESENT)
#define UART_BASE 0x80000000
#define UART_IRQ  0
#endif

/* UART END */


/* Easy Ethernet MAC */
#define EEMAC
#if defined(EEMAC)
#define EEMAC_BASE 0x80020000
#define EEMAC_IRQ  1
#endif /* EEMAC */

/* Intel Strata Flash */
#define STRATA_FLASH
#if defined(STRATA_FLASH)
#define STRATA_FLASH_BASE 0x08000000
#endif

#endif /* SYS_CONFIG_H */
