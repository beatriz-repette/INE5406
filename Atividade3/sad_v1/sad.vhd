LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;

ENTITY sad IS
	GENERIC (
		-- obrigatório ---
		-- defina as operações considerando o número B de bits por amostra
		B : POSITIVE := 8 -- número de bits por amostra
		-----------------------------------------------------------------------
		-- desejado (i.e., não obrigatório) ---
		-- se você desejar, pode usar os valores abaixo para descrever uma
		-- entidade que funcione tanto para a SAD v1 quanto para a SAD v3.
		--N : POSITIVE := 64; -- número de amostras por bloco
		--P : POSITIVE := 1 -- número de amostras de cada bloco lidas em paralelo
		-----------------------------------------------------------------------
	);
	PORT (
		-- ATENÇÃO: modifiquem a largura de bits das entradas e saídas que
		-- estão marcadas com DEFINIR de acordo com o número de bits B e
		-- de acordo com o necessário para cada versão da SAD (tentem utilizar
		-- os valores N e P descritos acima para criar apenas uma descrição
		-- configurável que funcione tanto para a SAD v1 quanto para a SAD v3).
		-- Não modifiquem os nomes das portas, apenas a largura de bits quando
		-- for necessário.
		clk : IN STD_LOGIC; -- ck
		enable : IN STD_LOGIC; -- iniciar
		reset : IN STD_LOGIC; -- reset
		sample_ori : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- Mem_A[end]
		sample_can : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- Mem_B[end]
		read_mem : OUT STD_LOGIC; -- read
		address : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); -- end / Para 64 amostras por bloco
		sad_value : OUT STD_LOGIC_VECTOR (B+5 DOWNTO 0); -- SAD / ceil(log2( (2^B - 1) * 64)) - 1 = B + 6 - 1 = B + 5
		done: OUT STD_LOGIC -- pronto
	);
END ENTITY; -- sad

ARCHITECTURE arch OF sad IS

	component sad_operativo is
	port(
        sample_ori : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- Mem_A[end]
		sample_can : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- Mem_B[end]
		clk, zi, ci, cpa, cpb, zsoma, csoma, csad_reg, reset : in std_logic;
		menor : out std_logic;
		sad_value : OUT STD_LOGIC_VECTOR (B+5 DOWNTO 0); -- SAD
		address : OUT STD_LOGIC_VECTOR (5 DOWNTO 0) -- end
	);
	end component;
	
	component sad_controle is
	port(
	    enable, reset, clk, menor : in std_logic;
        done, read_mem, zi, ci, cpa, cpb, zsoma, csoma, csad_reg: out std_logic
    );
	end component;
	
	signal zi, ci, cpA, cpB, zsoma, csoma, csad_reg, menor: std_LOGIC;
	
	
BEGIN
	controle: sad_controle 
	port map(enable, reset, clk, menor, done, read_mem, zi, ci, cpa, cpb, zsoma, csoma, csad_reg);

	datapath: sad_operativo 
	port map(sample_ori, sample_can, clk, zi, ci, cpa, cpb, zsoma, csoma, csad_reg, reset, menor, sad_value, address);
	
	
	end arch;