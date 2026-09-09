-- VHDL Model Created from SGE Schematic toyarm_01a.sch -- Sep 24 14:12:08 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity TOYARM_TA01 is
      Port (  BIGEND : In    std_logic;
                 CLK : In    std_logic;
              DABORT : In    std_logic;
                DDIN : In    std_logic_vector (31 downto 0);
              DNWAIT : In    std_logic;
              HIVECS : In    std_logic;
              IABORT : In    std_logic;
                  ID : In    std_logic_vector (31 downto 0);
              INWAIT : In    std_logic;
                NFIQ : In    std_logic;
                NIRQ : In    std_logic;
              NRESET : In    std_logic;
                  DA : Out   std_logic_vector (31 downto 0);
               DDOUT : Out   std_logic_vector (31 downto 0);
                DMAS : Out   std_logic_vector (1 downto 0);
               DMORE : Out   std_logic;
              DNMREQ : Out   std_logic;
                DNRW : Out   std_logic;
                DSEQ : Out   std_logic;
                  IA : Out   std_logic_vector (31 downto 0);
              INMREQ : Out   std_logic;
                ISEQ : Out   std_logic );
end TOYARM_TA01;

architecture SCHEMATIC of TOYARM_TA01 is

   signal PIO_DDIN : std_logic_vector(31 downto 0);
   signal CACHE_DDIN : std_logic_vector(31 downto 0);
   signal STDIO_DDIN : std_logic_vector(31 downto 0);
   signal DDIN_INTERNAL : std_logic_vector(31 downto 0);
   signal NIRQ_INTERNAL : std_logic;
   signal NFIQ_INTERNAL : std_logic;
   signal DNMREQ_INTERNAL : std_logic;
   signal  DNMREQ3 : std_logic;
   signal  DNMREQ1 : std_logic;
   signal  DNMREQ2 : std_logic;
   signal    RESET : std_logic;
   signal    DDOUT_DUMMY : std_logic_vector (31 downto 0);
   signal       DA_DUMMY : std_logic_vector (31 downto 0);
   signal     DNRW_DUMMY : std_logic;
   signal   DNMREQ_DUMMY : std_logic;

   component ADDR_DEC_TA01
      Port (     CLK : In    std_logic;
                  DA : In    std_logic_vector (31 downto 0);
              DNMREQ : In    std_logic;
             DNMREQ0 : Out   std_logic;
             DNMREQ1 : Out   std_logic;
             DNMREQ2 : Out   std_logic;
             DNMREQ3 : Out   std_logic );
   end component;

   component STDIO_TA01
      Port (     CLK : In    std_logic;
                  DA : In    std_logic_vector (31 downto 0);
               DDOUT : In    std_logic_vector (31 downto 0);
              DNMREQ : In    std_logic;
                DNRW : In    std_logic;
               RESET : In    std_logic;
                DDIN : Out   std_logic_vector (31 downto 0) );
   end component;

   component PIO_TA01
      Port (     CLK : In    std_logic;
                  DA : In    std_logic_vector (31 downto 0);
               DDOUT : In    std_logic_vector (31 downto 0);
              DNMREQ : In    std_logic;
                DNRW : In    std_logic;
               RESET : In    std_logic;
                DDIN : Out   std_logic_vector (31 downto 0);
                NFIQ : Out   std_logic;
                NIRQ : Out   std_logic );
   end component;

   component DDIN_SEL_TA01
      Port (     CLK : In    std_logic;
               DDIN0 : In    std_logic_vector (31 downto 0);
               DDIN1 : In    std_logic_vector (31 downto 0);
               DDIN2 : In    std_logic_vector (31 downto 0);
               DDIN3 : In    std_logic_vector (31 downto 0);
             DNMREQ0 : In    std_logic;
             DNMREQ1 : In    std_logic;
             DNMREQ2 : In    std_logic;
             DNMREQ3 : In    std_logic;
                DDIN : Out   std_logic_vector (31 downto 0) );
   end component;

   component INV1
      Port (     IN1 : In    std_logic;
                OUT1 : Out   std_logic );
   end component;

   component TOYARM
      Port (  BIGEND : In    std_logic;
                 CLK : In    std_logic;
              DABORT : In    std_logic;
                DDIN : In    std_logic_vector (31 downto 0);
              DNWAIT : In    std_logic;
              HIVECS : In    std_logic;
              IABORT : In    std_logic;
                  ID : In    std_logic_vector (31 downto 0);
              INWAIT : In    std_logic;
                NFIQ : In    std_logic;
                NIRQ : In    std_logic;
              NRESET : In    std_logic;
                  DA : Out   std_logic_vector (31 downto 0);
               DDOUT : Out   std_logic_vector (31 downto 0);
                DMAS : Out   std_logic_vector (1 downto 0);
               DMORE : Out   std_logic;
              DNMREQ : Out   std_logic;
                DNRW : Out   std_logic;
                DSEQ : Out   std_logic;
                  IA : Out   std_logic_vector (31 downto 0);
              INMREQ : Out   std_logic;
                ISEQ : Out   std_logic );
   end component;

begin

   DDOUT <= DDOUT_DUMMY;
   DA <= DA_DUMMY;
   DNRW <= DNRW_DUMMY;
   DNMREQ <= DNMREQ_DUMMY;

   I_5 : ADDR_DEC_TA01
      Port Map ( CLK=>CLK, DA(31 downto 0)=>DA_DUMMY(31 downto 0),
                 DNMREQ=>DNMREQ_INTERNAL, DNMREQ0=>DNMREQ_DUMMY,
                 DNMREQ1=>DNMREQ1, DNMREQ2=>DNMREQ2, DNMREQ3=>DNMREQ3 );
   I_8 : STDIO_TA01
      Port Map ( CLK=>CLK, DA(31 downto 0)=>DA_DUMMY(31 downto 0),
                 DDOUT(31 downto 0)=>DDOUT_DUMMY(31 downto 0),
                 DNMREQ=>DNMREQ2, DNRW=>DNRW_DUMMY, RESET=>RESET,
                 DDIN(31 downto 0)=>STDIO_DDIN(31 downto 0) );
   I_7 : PIO_TA01
      Port Map ( CLK=>CLK, DA(31 downto 0)=>DA_DUMMY(31 downto 0),
                 DDOUT(31 downto 0)=>DDOUT_DUMMY(31 downto 0),
                 DNMREQ=>DNMREQ1, DNRW=>DNRW_DUMMY, RESET=>RESET,
                 DDIN(31 downto 0)=>PIO_DDIN(31 downto 0),
                 NFIQ=>NFIQ_INTERNAL, NIRQ=>NIRQ_INTERNAL );
   I_6 : DDIN_SEL_TA01
      Port Map ( CLK=>CLK, DDIN0(31 downto 0)=>DDIN(31 downto 0),
                 DDIN1(31 downto 0)=>PIO_DDIN(31 downto 0),
                 DDIN2(31 downto 0)=>STDIO_DDIN(31 downto 0),
                 DDIN3(31 downto 0)=>CACHE_DDIN(31 downto 0),
                 DNMREQ0=>DNMREQ_DUMMY, DNMREQ1=>DNMREQ1,
                 DNMREQ2=>DNMREQ2, DNMREQ3=>DNMREQ3,
                 DDIN(31 downto 0)=>DDIN_INTERNAL(31 downto 0) );
   I_4 : INV1
      Port Map ( IN1=>NRESET, OUT1=>RESET );
   I_2 : TOYARM
      Port Map ( BIGEND=>BIGEND, CLK=>CLK, DABORT=>DABORT,
                 DDIN(31 downto 0)=>DDIN_INTERNAL(31 downto 0),
                 DNWAIT=>DNWAIT, HIVECS=>HIVECS, IABORT=>IABORT,
                 ID(31 downto 0)=>ID(31 downto 0), INWAIT=>INWAIT,
                 NFIQ=>NFIQ_INTERNAL, NIRQ=>NIRQ_INTERNAL,
                 NRESET=>NRESET, DA(31 downto 0)=>DA_DUMMY(31 downto 0),
                 DDOUT(31 downto 0)=>DDOUT_DUMMY(31 downto 0),
                 DMAS(1 downto 0)=>DMAS(1 downto 0), DMORE=>DMORE,
                 DNMREQ=>DNMREQ_INTERNAL, DNRW=>DNRW_DUMMY, DSEQ=>DSEQ,
                 IA(31 downto 0)=>IA(31 downto 0), INMREQ=>INMREQ,
                 ISEQ=>ISEQ );

end SCHEMATIC;

configuration CFG_TOYARM_TA01 of TOYARM_TA01 is

   for SCHEMATIC
      for I_5: ADDR_DEC_TA01
         use configuration WORK.CFG_ADDR_DEC_TA01;
      end for;
      for I_8: STDIO_TA01
         use configuration WORK.CFG_STDIO_TA01;
      end for;
      for I_7: PIO_TA01
         use configuration WORK.CFG_PIO_TA01;
      end for;
      for I_6: DDIN_SEL_TA01
         use configuration WORK.CFG_DDIN_SEL_TA01;
      end for;
      for I_4: INV1
         use configuration WORK.CFG_INV1;
      end for;
      for I_2: TOYARM
         use configuration WORK.CFG_TOYARM;
      end for;
   end for;

end CFG_TOYARM_TA01;
