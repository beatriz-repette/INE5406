LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;

ENTITY sad IS
	GENERIC (
		-- obrigatório ---
		-- defina as operações considerando o número B de bits por amostra
		B : POSITIVE := 8 -- número de bits por amostra
	);
    ---------------------------------------------------------
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
		sample_ori : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- Mem_A[end]
		sample_can : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- Mem_B[end]
		read_mem : OUT STD_LOGIC; -- read, nao sera usado
		address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- end
		sad_value : OUT STD_LOGIC_VECTOR (13 DOWNTO 0); -- SAD
		done: OUT STD_LOGIC -- pronto
	);
END ENTITY; -- sad

ARCHITECTURE arch OF sad IS
	-- descrever
	-- usar sad_bo e sad_bc (sad_operativo e sad_controle)
	-- não codifiquem toda a arquitetura apenas neste arquivo
	-- modularizem a descrição de vocês...
	component sad_operativo is
	port(
	clk, zi, ci, cpa, cpb, zsoma, csoma, csad_reg : in std_logic; --tem que carregar cpa e cpb em regs? se sim, adicionar isso
      
		  menor : out std_logic;
		  sample_ori : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- sample_ori[end]
		  sample_can : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- sample_can[end]
		  address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- end
		  sad_value : OUT STD_LOGIC_VECTOR (13 DOWNTO 0) -- SAD
	);
	end component;
	
	component sad_controle is
	port(
	enable, reset, clk, menor : in std_logic;
    pronto, read_mem , zi, ci, cpa, cpb, zsoma, csoma, csad_reg : out std_logic
	);
	end component;
	
	signal zi, ci, cpA, cpB, zsoma, csoma, csad_reg, menor: std_LOGIC;
	
	
BEGIN
	controle: sad_controle
	port map(enable, reset, clk, menor, done, read_mem, zi, ci, cpA, cpB, zsoma, csoma, csad_reg);

	datapath: sad_operativo
	port map(clk, zi, ci, cpa, cpb, zsoma, csoma, csad_reg, menor, sample_ori, sample_can, address, sad_value);
	
	
	end arch;
