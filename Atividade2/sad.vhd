LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sad IS
	GENERIC (
		-- obrigatório ---
		-- defina as operações considerando o número B de bits por amostra
		B : POSITIVE := 8; -- número de bits por amostra
		-----------------------------------------------------------------------
		-- desejado (i.e., não obrigatório) ---
		-- se você desejar, pode usar os valores abaixo para descrever uma
		-- entidade que funcione tanto para a SAD v1 quanto para a SAD v3.
		N : POSITIVE := 64; -- número de amostras por bloco
		P : POSITIVE := 1 -- número de amostras de cada bloco lidas em paralelo
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
		sample_ori : IN STD_LOGIC_VECTOR (DEFINIR DOWNTO 0); -- Mem_A[end]
		sample_can : IN STD_LOGIC_VECTOR (DEFINIR DOWNTO 0); -- Mem_B[end]
		read_mem : OUT STD_LOGIC; -- read
		address : OUT STD_LOGIC_VECTOR (DEFINIR DOWNTO 0); -- end
		sad_value : OUT STD_LOGIC_VECTOR (DEFINIR DOWNTO 0); -- SAD
		done: OUT STD_LOGIC -- pronto
	);
END ENTITY; -- sad

ARCHITECTURE arch OF sad IS
	TYPE Tipo_estado IS (S0, S1, S2, S3, S4, S5);
	SIGNAL EstadoAtual, ProximoEstado : TipoEstado; 
	SIGNAL i : integer;
	
	component absolute
		port( 
			a : in std_logic_vector(DEFINIR downto 0);
			s : out std_logic_vector(DEFINIR downto 0)
		);
	end component;
	
BEGIN
	i <= N;
	PROCESS (EstadoAtual, N, enable)
	BEGIN
		CASE EstadoAtual IS
			WHEN S0 =>
				IF enable = '0' THEN
					ProximoEstado <= S0;
				ELSE 
					ProximoEstado <= S1;
				END IF;
			WHEN S1 =>
				ProximoEstado <= S2;
			WHEN S2 =>
				IF i < N THEN
					ProximoEstado <= S3;
				ELSE
					ProximoEstado <= S5;
				END IF;
			WHEN S3 =>
				ProximoEstado <= S4;
			WHEN S4 =>
				ProximoEstado <= S2;
			WHEN S5 =>
				ProximoEstado <= S0;
		END CASE;
	END PROCESS;
	
	PROCESS (clk, reset)
	VARIABLE soma : integer := 0;
	VARIABLE pA : std_logic_vector(DEFINIR downto 0);
	VARIABLE pB: std_logic_vector(DEFINIR downto 0);
	BEGIN
		IF reset = '1' THEN
			EstadoAtual <= S0;
		ELSIF (rising_edge(clk)) THEN
			EstadoAtual <= ProximoEstado;
		END IF;
	END PROCESS;
	
	PROCESS (EstadoAtual)
	BEGIN
		CASE EstadoAtual IS
			WHEN S0 =>
				done <= '1';
				read_mem <= '0';
			WHEN S1 =>
				done <= '0';
				address <= '0';
				i <= '0';
				soma := '0';
			WHEN S3 =>
				read_mem <= '1';
				pA := to_integer(unsigned(sample_ori));
				pB := to_integer(unsigned(sample_can));
			WHEN S4 =>
				read_mem <= '0';
				address <= address + 1;
				i := i + 1;
				soma := soma + 
				
				
				
	-- descrever
	-- usar sad_bo e sad_bc (sad_operativo e sad_controle)
	-- não codifiquem toda a arquitetura apenas neste arquivo
	-- modularizem a descrição de vocês...
END ARCHITECTURE; -- arch	
