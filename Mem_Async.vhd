----------------------------------------------------------------------------------
-- Nicolas Primeau
-- 
-- Create Date:    13:24:12 03/15/2014 
-- Design Name:    Asynchronous Generic Memory
-- Module Name:    Mem_Async - Behavioral 
-- Description: 
--
-- Asynchronous generic memory. CAREFUL, Do not write until the address has been
-- stablized or else you might write to an unpredictable place! This component is
-- much better when you only want to read from it with STABLE address bus. STABLE.
-- ADDRESS. BUS.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mem_Async is
generic(memSize: integer:=8;
        numAdr: integer:=32);
port(
	dataIn: in std_logic_vector(memSize -1 downto 0);
	dataOut: out std_logic_vector(memSize-1 downto 0);
	addr: in natural range 0 to numAdr-1;
	rd_wr: in std_logic; -- rd low, wr high
	reset: in std_logic;
	clk: in std_logic
);
end Mem_Async;

architecture Behavioral of Mem_Async is
type RAM is array (0 to numAdr-1) of std_logic_vector(memSize -1 downto 0);
signal memory: RAM;
begin
process(reset,dataIn,addr,rd_wr,memory,clk) begin
  if(reset = '1') then
-- write to master
    memory(0) <= "11100000000000000000";
    memory(1) <= "00000010000000000000";
    memory(2) <= "00000000000000000000"; -- highest volume, unmute

-- write to HP
    memory(3) <= "11100000000000000000";
    memory(4) <= "00000100000000000000"; 
    memory(5) <= "00000000000000000000"; -- highest volume, unmute                               

-- Write to Mono out
    memory(6) <= "11100000000000000000";
    memory(7) <= "00000110000000000000";                  
    memory(8) <= "00000000000000000000"; -- highest volume, unmute
 
-- write to record gain 
    memory(9) <= "11100000000000000000"; 
    memory(10)<= "00011100000000000000";         
    memory(11)<= "00001111000011110000"; --highesty gain
 
-- write to input select
    memory(12) <= "11100000000000000000"; -- select line ine
    memory(13)<= "00011010000000000000";         
    memory(14)<= "00000100000001000000";

-- write to line in
    memory(15)<= "10011000000000000000";
    memory(16)<= "00010000000000000000";	         
    memory(17)<= "00000000000000000000";


    for i in 15 to numAdr-1 loop
        memory(i) <= std_logic_vector(to_unsigned(0,memSize));
    end loop; 
	 
	 dataOut <= (others => '0');
  elsif(falling_edge(clk)) then	 
  if(rd_wr = '0') then
    dataOut <= memory(addr);
	 memory <= memory;
	 
  elsif(rd_wr = '1') then
    dataOut <= (others => '0');
    memory(addr) <= dataIn;
  else
    dataOut <= (others=>'0'); 
  end if;
  end if;
end process;
end Behavioral;

