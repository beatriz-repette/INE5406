
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

    stim: process is
        file arquivo_de_estimulos : text open read_mode is "../../estimulos.dat";
        variable linha_de_estimulos: line;
        variable espaco: character;
        variable valor_de_entrada_A: bit_vector(31 downto 0);
        variable valor_de_entrada_B: bit_vector(31 downto 0);
        variable valor_de_saida: bit_vector(13 downto 0);
        begin
        
        while not endfile(arquivo_de_estimulos) loop
        -- read inputs
        readline(arquivo_de_estimulos, linha_de_estimulos);
        read(linha_de_estimulos, valor_de_entrada_A);
        read(linha_de_estimulos, espaco);
        read(linha_de_estimulos, valor_de_entrada_B);

        sample_ori  <= to_stdlogicvector (valor_de_entrada_A);
        sample_can  <= to_stdlogicvector (valor_de_entrada_B);

        read(linha_de_estimulos, espaco);
        read(linha_de_estimulos, valor_de_saida);

        wait for passo;
            assert (sad_value = to_stdlogicvector(valor_de_saida)) 
            report  
                "Falha na simulacao. "
            severity error;
        end loop;

        wait for passo;
        assert false report "Test done." severity note;
        wait;
    end process;
    end tb;
