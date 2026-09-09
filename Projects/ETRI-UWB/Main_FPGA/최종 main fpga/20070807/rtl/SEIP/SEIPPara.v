
// FIFO Size
parameter RXAW = 4;
parameter TXAW = 4;

// Register Address
parameter RXCON		= 14'h2000>>2;
parameter RXSTS 	= 14'h2004>>2;
parameter RXDAT 	= 14'h2008>>2;

parameter TXCON		= 14'h2010>>2;
parameter TXSTS 	= 14'h2014>>2;
parameter TXDAT 	= 14'h2018>>2;

parameter SEIPRST 	= 14'h2020>>2;
parameter SEIPCKD 	= 14'h2024>>2;
