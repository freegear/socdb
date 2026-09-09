--
--       CarrySaveAdder.VHD
--       for ?
--
--       Version 1.0 (?/?/?)
--       Designed by ?, ?, ? and ImJH.
--
--       Copyright (c) ? by ? in ?
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity CSA is
    port (a,
          b,
          c : in std_logic_vector (63 downto 0);
          d,
          e : out std_logic_vector (63 downto 0));
end CSA;

architecture BEHAVIORAL of CSA is

    component fadd
        port (a,
              b,
              c : in std_logic;
              sum,
              carry : out std_logic);
    end component;

    signal dummy : std_logic;

begin

    e(0) <= '0';
    csa00blk : fadd port map (a( 0), b( 0), c( 0), d( 0), e( 1));
    csa01blk : fadd port map (a( 1), b( 1), c( 1), d( 1), e( 2));
    csa02blk : fadd port map (a( 2), b( 2), c( 2), d( 2), e( 3));
    csa03blk : fadd port map (a( 3), b( 3), c( 3), d( 3), e( 4));
    csa04blk : fadd port map (a( 4), b( 4), c( 4), d( 4), e( 5));
    csa05blk : fadd port map (a( 5), b( 5), c( 5), d( 5), e( 6));
    csa06blk : fadd port map (a( 6), b( 6), c( 6), d( 6), e( 7));
    csa07blk : fadd port map (a( 7), b( 7), c( 7), d( 7), e( 8));
    csa08blk : fadd port map (a( 8), b( 8), c( 8), d( 8), e( 9));
    csa09blk : fadd port map (a( 9), b( 9), c( 9), d( 9), e(10));
    csa10blk : fadd port map (a(10), b(10), c(10), d(10), e(11));
    csa11blk : fadd port map (a(11), b(11), c(11), d(11), e(12));
    csa12blk : fadd port map (a(12), b(12), c(12), d(12), e(13));
    csa13blk : fadd port map (a(13), b(13), c(13), d(13), e(14));
    csa14blk : fadd port map (a(14), b(14), c(14), d(14), e(15));
    csa15blk : fadd port map (a(15), b(15), c(15), d(15), e(16));
    csa16blk : fadd port map (a(16), b(16), c(16), d(16), e(17));
    csa17blk : fadd port map (a(17), b(17), c(17), d(17), e(18));
    csa18blk : fadd port map (a(18), b(18), c(18), d(18), e(19));
    csa19blk : fadd port map (a(19), b(19), c(19), d(19), e(20));
    csa20blk : fadd port map (a(20), b(20), c(20), d(20), e(21));
    csa21blk : fadd port map (a(21), b(21), c(21), d(21), e(22));
    csa22blk : fadd port map (a(22), b(22), c(22), d(22), e(23));
    csa23blk : fadd port map (a(23), b(23), c(23), d(23), e(24));
    csa24blk : fadd port map (a(24), b(24), c(24), d(24), e(25));
    csa25blk : fadd port map (a(25), b(25), c(25), d(25), e(26));
    csa26blk : fadd port map (a(26), b(26), c(26), d(26), e(27));
    csa27blk : fadd port map (a(27), b(27), c(27), d(27), e(28));
    csa28blk : fadd port map (a(28), b(28), c(28), d(28), e(29));
    csa29blk : fadd port map (a(29), b(29), c(29), d(29), e(30));
    csa30blk : fadd port map (a(30), b(30), c(30), d(30), e(31));
    csa31blk : fadd port map (a(31), b(31), c(31), d(31), e(32));
    csa32blk : fadd port map (a(32), b(32), c(32), d(32), e(33));
    csa33blk : fadd port map (a(33), b(33), c(33), d(33), e(34));
    csa34blk : fadd port map (a(34), b(34), c(34), d(34), e(35));
    csa35blk : fadd port map (a(35), b(35), c(35), d(35), e(36));
    csa36blk : fadd port map (a(36), b(36), c(36), d(36), e(37));
    csa37blk : fadd port map (a(37), b(37), c(37), d(37), e(38));
    csa38blk : fadd port map (a(38), b(38), c(38), d(38), e(39));
    csa39blk : fadd port map (a(39), b(39), c(39), d(39), e(40));
    csa40blk : fadd port map (a(40), b(40), c(40), d(40), e(41));
    csa41blk : fadd port map (a(41), b(41), c(41), d(41), e(42));
    csa42blk : fadd port map (a(42), b(42), c(42), d(42), e(43));
    csa43blk : fadd port map (a(43), b(43), c(43), d(43), e(44));
    csa44blk : fadd port map (a(44), b(44), c(44), d(44), e(45));
    csa45blk : fadd port map (a(45), b(45), c(45), d(45), e(46));
    csa46blk : fadd port map (a(46), b(46), c(46), d(46), e(47));
    csa47blk : fadd port map (a(47), b(47), c(47), d(47), e(48));
    csa48blk : fadd port map (a(48), b(48), c(48), d(48), e(49));
    csa49blk : fadd port map (a(49), b(49), c(49), d(49), e(50));
    csa50blk : fadd port map (a(50), b(50), c(50), d(50), e(51));
    csa51blk : fadd port map (a(51), b(51), c(51), d(51), e(52));
    csa52blk : fadd port map (a(52), b(52), c(52), d(52), e(53));
    csa53blk : fadd port map (a(53), b(53), c(53), d(53), e(54));
    csa54blk : fadd port map (a(54), b(54), c(54), d(54), e(55));
    csa55blk : fadd port map (a(55), b(55), c(55), d(55), e(56));
    csa56blk : fadd port map (a(56), b(56), c(56), d(56), e(57));
    csa57blk : fadd port map (a(57), b(57), c(57), d(57), e(58));
    csa58blk : fadd port map (a(58), b(58), c(58), d(58), e(59));
    csa59blk : fadd port map (a(59), b(59), c(59), d(59), e(60));
    csa60blk : fadd port map (a(60), b(60), c(60), d(60), e(61));
    csa61blk : fadd port map (a(61), b(61), c(61), d(61), e(62));
    csa62blk : fadd port map (a(62), b(62), c(62), d(62), e(63));
    csa63blk : fadd port map (a(63), b(63), c(63), d(63), dummy);

end BEHAVIORAL;

configuration CFG_CSA of CSA is
   for BEHAVIORAL
      for csa00blk : fadd use configuration work.cfg_fadd; end for;
      for csa01blk : fadd use configuration work.cfg_fadd; end for;
      for csa02blk : fadd use configuration work.cfg_fadd; end for;
      for csa03blk : fadd use configuration work.cfg_fadd; end for;
      for csa04blk : fadd use configuration work.cfg_fadd; end for;
      for csa05blk : fadd use configuration work.cfg_fadd; end for;
      for csa06blk : fadd use configuration work.cfg_fadd; end for;
      for csa07blk : fadd use configuration work.cfg_fadd; end for;
      for csa08blk : fadd use configuration work.cfg_fadd; end for;
      for csa09blk : fadd use configuration work.cfg_fadd; end for;
      for csa10blk : fadd use configuration work.cfg_fadd; end for;
      for csa11blk : fadd use configuration work.cfg_fadd; end for;
      for csa12blk : fadd use configuration work.cfg_fadd; end for;
      for csa13blk : fadd use configuration work.cfg_fadd; end for;
      for csa14blk : fadd use configuration work.cfg_fadd; end for;
      for csa15blk : fadd use configuration work.cfg_fadd; end for;
      for csa16blk : fadd use configuration work.cfg_fadd; end for;
      for csa17blk : fadd use configuration work.cfg_fadd; end for;
      for csa18blk : fadd use configuration work.cfg_fadd; end for;
      for csa19blk : fadd use configuration work.cfg_fadd; end for;
      for csa20blk : fadd use configuration work.cfg_fadd; end for;
      for csa21blk : fadd use configuration work.cfg_fadd; end for;
      for csa22blk : fadd use configuration work.cfg_fadd; end for;
      for csa23blk : fadd use configuration work.cfg_fadd; end for;
      for csa24blk : fadd use configuration work.cfg_fadd; end for;
      for csa25blk : fadd use configuration work.cfg_fadd; end for;
      for csa26blk : fadd use configuration work.cfg_fadd; end for;
      for csa27blk : fadd use configuration work.cfg_fadd; end for;
      for csa28blk : fadd use configuration work.cfg_fadd; end for;
      for csa29blk : fadd use configuration work.cfg_fadd; end for;
      for csa30blk : fadd use configuration work.cfg_fadd; end for;
      for csa31blk : fadd use configuration work.cfg_fadd; end for;
      for csa32blk : fadd use configuration work.cfg_fadd; end for;
      for csa33blk : fadd use configuration work.cfg_fadd; end for;
      for csa34blk : fadd use configuration work.cfg_fadd; end for;
      for csa35blk : fadd use configuration work.cfg_fadd; end for;
      for csa36blk : fadd use configuration work.cfg_fadd; end for;
      for csa37blk : fadd use configuration work.cfg_fadd; end for;
      for csa38blk : fadd use configuration work.cfg_fadd; end for;
      for csa39blk : fadd use configuration work.cfg_fadd; end for;
      for csa40blk : fadd use configuration work.cfg_fadd; end for;
      for csa41blk : fadd use configuration work.cfg_fadd; end for;
      for csa42blk : fadd use configuration work.cfg_fadd; end for;
      for csa43blk : fadd use configuration work.cfg_fadd; end for;
      for csa44blk : fadd use configuration work.cfg_fadd; end for;
      for csa45blk : fadd use configuration work.cfg_fadd; end for;
      for csa46blk : fadd use configuration work.cfg_fadd; end for;
      for csa47blk : fadd use configuration work.cfg_fadd; end for;
      for csa48blk : fadd use configuration work.cfg_fadd; end for;
      for csa49blk : fadd use configuration work.cfg_fadd; end for;
      for csa50blk : fadd use configuration work.cfg_fadd; end for;
      for csa51blk : fadd use configuration work.cfg_fadd; end for;
      for csa52blk : fadd use configuration work.cfg_fadd; end for;
      for csa53blk : fadd use configuration work.cfg_fadd; end for;
      for csa54blk : fadd use configuration work.cfg_fadd; end for;
      for csa55blk : fadd use configuration work.cfg_fadd; end for;
      for csa56blk : fadd use configuration work.cfg_fadd; end for;
      for csa57blk : fadd use configuration work.cfg_fadd; end for;
      for csa58blk : fadd use configuration work.cfg_fadd; end for;
      for csa59blk : fadd use configuration work.cfg_fadd; end for;
      for csa60blk : fadd use configuration work.cfg_fadd; end for;
      for csa61blk : fadd use configuration work.cfg_fadd; end for;
      for csa62blk : fadd use configuration work.cfg_fadd; end for;
      for csa63blk : fadd use configuration work.cfg_fadd; end for;
   end for;
end CFG_CSA;
