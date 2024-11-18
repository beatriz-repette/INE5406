library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
 
entity testbench is
end testbench; 

architecture tb of testbench is

  clk : STD_LOGIC; 
  enable : STD_LOGIC; 
  reset : STD_LOGIC; 
  sample_ori : STD_LOGIC_VECTOR (7 DOWNTO 0); 
  sample_can : STD_LOGIC_VECTOR (7 DOWNTO 0); 
  read_mem : STD_LOGIC; 
  address : STD_LOGIC_VECTOR (5 DOWNTO 0); 
  sad_value : STD_LOGIC_VECTOR (13 DOWNTO 0); 
  done: STD_LOGIC;

CONSTANT passo : TIME := 20 ns;	 

begin

  DUV: entity work.sad 
    port map(
        clk, enable, reset, sample_ori, sample_can, read_mem, address, sad_value, done
      );

  process
  begin
    enable <= '0', '1' after 20 ns;
    wait for 9*passo;
    sample_ori <= std_logic_vector(to_unsigned(1, sample_ori'length));
    sample_can <= std_logic_vector(to_unsigned(0, sample_can'length));
    wait for 9*passo;
    sample_ori <= std_logic_vector(to_unsigned(0, sample_ori'length));
    sample_can <= std_logic_vector(to_unsigned(1, sample_can'length));
    assert(sad_value='00000001000000')
    report "Falha na simulação" severity error; 

    wait for 20 ns;
    assert false report "Acabou" severity note;
  end process;
end tb;
