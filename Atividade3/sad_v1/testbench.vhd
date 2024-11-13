
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;
 
entity testbench is
end testbench; 

architecture tb of testbench is

signal input: std_logic_vector(7 DOWNTO 0);
signal output: std_logic_vector(31 downto 0);

CONSTANT passo : TIME := 20 ns;	 

begin

  -- Connect DUV
  DUV: entity work.sad 
    port map(input, output);

  stim: process is
    file arquivo_de_estimulos : text open read_mode is "../../estimulos.dat";
    variable linha_de_estimulos: line;
    variable espaco: character;
    variable valor_de_entrada: bit_vector(7 downto 0);
    variable valor_de_saida: bit_vector(31 downto 0);
	 begin
	 
    while not endfile(arquivo_de_estimulos) loop
      -- read inputs
      readline(arquivo_de_estimulos, linha_de_estimulos);
      read(linha_de_estimulos, valor_de_entrada);
      input  <= to_stdlogicvector (valor_de_entrada);
      read(linha_de_estimulos, espaco);
      read(linha_de_estimulos, valor_de_saida);
      wait for passo;
        assert (output = to_stdlogicvector(valor_de_saida)) 
          report  
            "Falha na simulacao. "
          severity error;
    end loop;

    wait for passo;
    assert false report "Test done." severity note;
    wait;
  end process;
end tb;
