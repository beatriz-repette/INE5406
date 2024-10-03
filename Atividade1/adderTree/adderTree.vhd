LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adderTree IS
	GENERIC (N : POSITIVE := 8; -- Numero de bits
				P: POSITIVE := 4; -- Numero de entradas
				ExtraBits : POSITIVE := 2 -- Numero de bits a serem adicionados ao output para evitar overflow. Par 4 numeros a serem somados deve-se adicionar 2 bits
				);
	PORT (
		input: IN std_logic_vector ((P*N)-1 DOWNTO 0);
		output: OUT std_logic_vector ((N + ExtraBits - 1) DOWNTO 0)
		);
END adderTree;

ARCHITECTURE arch OF adderTree IS

	SIGNAL sum_result : unsigned((N + ExtraBits - 1) DOWNTO 0);
	
BEGIN
	PROCESS(input)
		VARIABLE temp_sum : unsigned((N + ExtraBits - 1) DOWNTO 0) := (OTHERS => '0'); -- Variavel temporarea para armazenar a soma
	BEGIN
		temp_sum := (OTHERS => '0');
		
		FOR i IN 0 TO P-1 LOOP -- Loop para somar as entradas
			temp_sum := temp_sum + unsigned(input((i*N + N - 1) DOWNTO (i*N))); -- i serve como um index que vai de 0 a P-1
		END LOOP;
	
		sum_result <= temp_sum;	
	END PROCESS;
	
	output <= STD_logic_vector(sum_result);
	
END arch;
