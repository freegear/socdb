LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY FPGA_INTERFACE IS
	GENERIC( n : INTEGER := 446;
		 USER_SW_TYPE : STD_LOGIC:='1' );
	PORT ( CLK, nRST : IN STD_LOGIC;
	--USER-CHECK SWITCH
		USER_SW : IN STD_LOGIC;
	--U51 TO U60 : INTERFACE SIGNAL	
	       FPGA_CON_IN : IN STD_LOGIC_VECTOR( n DOWNTO 0 );
	--COUNTER-SIGNAL	       
		PIN_CLK    : OUT STD_LOGIC;
		ERR_CLK    : OUT STD_LOGIC;
	--PROCESSING COMPLETE SIGNAL		
		END_SIG    : OUT STD_LOGIC;
	--MONITORING DATA
		MODE : OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );		
	--U51 LATCH-SIGNAL
		U51_EN     : OUT STD_LOGIC;
		ERR_CLR    : OUT STD_LOGIC);
END FPGA_INTERFACE;
  
ARCHITECTURE BEHAVIORAL OF FPGA_INTERFACE IS
	TYPE STATUS IS ( IDLE, START_UP, START_DELAY, 								--STAN-BY
			 DATA_LOAD, DATA_COMPARE, DATA_LATCH, DATA_END, PROG_COMPLETE, --DATA_COMPARE-MODE
			 ERR_LATCH, ERR_COMPARE, ERR_SHIFT, ERR_END,    --ERROR-DETECT
			 ERR_CHECK, ERR_DELAY );						      --ERROR-CHECK
	SIGNAL STATE : STATUS;
	
	SIGNAL FPGA_CON_BUF : STD_LOGIC_VECTOR( n DOWNTO 0 );
	SIGNAL FPGA_CMP_BUF : STD_LOGIC_VECTOR( n DOWNTO 0 );
	SIGNAL FPGA_ERR_BUF : STD_LOGIC_VECTOR( n DOWNTO 0 );
	SIGNAL CON_CMP : INTEGER RANGE 0 TO n;
	
	SIGNAL ERR_BIT_A, ERR_BIT_B : STD_LOGIC;
	SIGNAL RUN_SIG : STD_LOGIC;
BEGIN
	PROCESS( CLK, nRST )
		VARIABLE ERR_CNT : INTEGER RANGE 0 TO n;
		VARIABLE DELAY_CNT : INTEGER RANGE 0 TO 1250000;
	BEGIN
		IF nRST='0' THEN
			STATE <= IDLE;
			CON_CMP <= 0;
			ERR_CNT := 0;
			DELAY_CNT := 0;
		ELSIF RISING_EDGE(CLK) THEN
			CASE STATE IS
				WHEN IDLE => STATE <= START_UP;
				WHEN START_UP => STATE <= START_DELAY;
				WHEN START_DELAY => IF RUN_SIG='1' THEN
							STATE <= DATA_LOAD;
						    ELSE
						    	STATE <= START_DELAY;
						    END IF;
				WHEN DATA_LOAD => STATE <= DATA_COMPARE;
				WHEN DATA_COMPARE =>
										IF (DELAY_CNT=1250000) THEN
											DELAY_CNT := 0;
											IF ( FPGA_CON_BUF = FPGA_CMP_BUF ) THEN
												STATE <= DATA_LATCH;
											ELSE
												STATE <= ERR_LATCH;
											END IF;
										ELSE
											DELAY_CNT := DELAY_CNT + 1;
										END IF;
				WHEN DATA_LATCH => STATE <= DATA_END;
						   ERR_CLR <= '0';
				WHEN DATA_END => IF (CON_CMP = n ) THEN
							STATE <= PROG_COMPLETE;
						 ELSE
						 	STATE <= DATA_LOAD;
						 	CON_CMP <= CON_CMP + 1;
						 END IF;
				WHEN PROG_COMPLETE => STATE <= PROG_COMPLETE;
				WHEN ERR_LATCH => STATE <= ERR_COMPARE;
				WHEN ERR_COMPARE => IF (DELAY_CNT=1250000) THEN
											DELAY_CNT := 0;
											IF ( ERR_BIT_A = ERR_BIT_B ) THEN
												STATE <= ERR_SHIFT;
											ELSE
												STATE <= ERR_CHECK;
											END IF;
										ELSE
											DELAY_CNT := DELAY_CNT + 1;
										END IF;			
				WHEN ERR_SHIFT => STATE <= ERR_END;
				WHEN ERR_END => IF ( ERR_CNT = n ) THEN
							ERR_CNT := 0;
							STATE <= DATA_LATCH;
							ERR_CLR <= '1';
						ELSE
							STATE <= ERR_LATCH;
							ERR_CNT := ERR_CNT + 1;
						END IF;
				WHEN ERR_CHECK => STATE <= ERR_DELAY;
				WHEN ERR_DELAY => IF RUN_SIG='1' THEN
							STATE <= ERR_LATCH;
						  ELSE
						  	STATE <= ERR_DELAY;
						  END IF;
				WHEN OTHERS => STATE <= STATE;
			END CASE;
		END IF;
	END PROCESS;
--MONITORING DELAY	
	PROCESS( CLK, nRST, USER_SW )
		VARIABLE CNT : INTEGER RANGE 0 TO 12500000;
		VARIABLE SEC : INTEGER RANGE 0 TO 5;
		VARIABLE RUN : STD_LOGIC;
	BEGIN
		IF nRST='0' THEN
			CNT := 0;
			SEC := 0;
			RUN := '0';
			RUN_SIG <= '0';
		ELSIF (USER_SW = USER_SW_TYPE) THEN
			RUN := '1';
		ELSIF RISING_EDGE(CLK) THEN
			IF RUN='1' THEN
				IF CNT=12499999 THEN
					IF SEC=5 THEN
						CNT := 0;
						SEC := 0;
						RUN := '0';
						RUN_SIG <= '1';
					ELSE
						SEC := SEC + 1;
						CNT := 0;
						RUN_SIG <= '0';
					END IF;
				ELSE
					CNT := CNT + 1;
					RUN_SIG <= '0';
				END IF;
			ELSE
				RUN_SIG <= '0';
				RUN := '0';
			END IF;
		END IF;
	END PROCESS;
	
--INTERFACE_PIN
	--FPGA_CON_IN : IN STD_LOGIC_VECTOR( n DOWNTO 0 );
--COUNTER-SIGNAL	       
	--PIN_CLK    : OUT STD_LOGIC;
	--ERR_CLK    : OUT STD_LOGIC;
--PROCESSING COMPLETE SIGNAL		
	--END_SIG    : OUT STD_LOGIC;
--MONITORING DATA
	--MODE : OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );		
--U51 LATCH-SIGNAL
	--U51_EN     : OUT STD_LOGIC);
--SIGNAL
	--FPGA_CON_BUF
	--FPGA_CMP_BUF				
	PROCESS( CLK, nRST )
	BEGIN
		IF nRST='0' THEN
			U51_EN <= '0';
			PIN_CLK <= '0';
			ERR_CLK <= '0';
			END_SIG <= '0';
			MODE <= "00";
			FPGA_CON_BUF <= ( OTHERS => '0' );
			FPGA_CMP_BUF( n DOWNTO 1 ) <= ( OTHERS => '0' );
			FPGA_CMP_BUF(0) <= '0';
		ELSIF RISING_EDGE(CLK) THEN
	
		CASE STATE IS
-----------------------------   MODE_0   ------------------------------------------
			WHEN IDLE => U51_EN <= '0';
			             PIN_CLK <= '0';
			             ERR_CLK <= '0';
			             END_SIG <= '0';
			             MODE <= "00";
			WHEN START_UP =>  U51_EN <= '0';
				          PIN_CLK <= '0';
				          ERR_CLK <= '0';
				          END_SIG <= '0';
				          MODE <= "00";
				          FPGA_CMP_BUF( n DOWNTO 1 ) <= ( OTHERS => '0' );
				          FPGA_CMP_BUF(0) <= '1';
			WHEN START_DELAY => U51_EN <= '0';
				            PIN_CLK <= '0';
				            ERR_CLK <= '0';
				            END_SIG <= '0';
				            MODE <= "00";
-------------------------------   MODE_1   -----------------------------------------				            
			WHEN DATA_LOAD =>  U51_EN <= '0';
				           PIN_CLK <= '0';
				           ERR_CLK <= '0';
				           END_SIG <= '0';
				           MODE <= "01";
					   FPGA_CON_BUF <= FPGA_CON_IN; 
			WHEN DATA_COMPARE => U51_EN <= '0';
				          	  PIN_CLK <= '0';
				             ERR_CLK <= '0';
				             END_SIG <= '0';
				             MODE <= "01";
				            FPGA_ERR_BUF <= FPGA_CMP_BUF;
			WHEN DATA_LATCH =>  U51_EN <= '1';
				          	 PIN_CLK <= '1';
				            ERR_CLK <= '0';
				            END_SIG <= '0';
				            MODE <= "01";
				            FPGA_CON_BUF <= FPGA_CON_IN;
			WHEN DATA_END =>   U51_EN <= '0';
				          	PIN_CLK <= '0';
				           ERR_CLK <= '0';
				           END_SIG <= '0';
				           MODE <= "01";
				           FPGA_CMP_BUF <= FPGA_CMP_BUF( n-1 DOWNTO 0 ) & '0';
------------------------------   COMPLETE   ----------------------------------------
			WHEN PROG_COMPLETE => U51_EN <= '0';
				             	PIN_CLK <= '0';
				              ERR_CLK <= '0';
				              END_SIG <= '1';
				              MODE <= "01";
-------------------------------   MODE_2   -----------------------------------------
			WHEN ERR_LATCH => ERR_BIT_A <= FPGA_CON_BUF(0);
					  ERR_BIT_B <= FPGA_ERR_BUF(0);
					  U51_EN <= '0';
				          PIN_CLK <= '0';
				          ERR_CLK <= '0';
				          END_SIG <= '0';
				          MODE <= "10";
			WHEN ERR_COMPARE =>   U51_EN <= '0';
				             	PIN_CLK <= '0';
				              ERR_CLK <= '0';
				              END_SIG <= '0';
				              MODE <= "10";
			WHEN ERR_SHIFT =>	U51_EN <= '0';
				          PIN_CLK <= '0';
				          ERR_CLK <= '1';
				          END_SIG <= '0';
				          MODE <= "10";
				          FPGA_ERR_BUF <= '0' & FPGA_ERR_BUF( n DOWNTO 1 );
				          FPGA_CON_BUF <= '0' & FPGA_CON_BUF( n DOWNTO 1 );			
			WHEN ERR_END => 	 U51_EN <= '0';
				          PIN_CLK <= '0';
				          ERR_CLK <= '0';
				          END_SIG <= '0';
				          MODE <= "10";
-------------------------------   MODE_3   -----------------------------------------			
			WHEN ERR_CHECK => U51_EN <= '0';
				          PIN_CLK <= '0';
				          ERR_CLK <= '0';
				          END_SIG <= '0';
				          MODE <= "11";		
			WHEN ERR_DELAY => U51_EN <= '0';
				          PIN_CLK <= '0';
				          ERR_CLK <= '0';
				          END_SIG <= '0';
				          MODE <= "11";
			WHEN OTHERS =>  U51_EN <= '0';
				        PIN_CLK <= '0';
				        ERR_CLK <= '0';
				        END_SIG <= '0';
				        MODE <= "11";
		END CASE;
		END IF;
	END PROCESS;
END BEHAVIORAL;	