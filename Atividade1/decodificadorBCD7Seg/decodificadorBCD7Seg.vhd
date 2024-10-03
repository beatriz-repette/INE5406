LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY decodificadorBCD7Seg IS
	PORT (
		bcd     : IN  std_logic_vector(3 DOWNTO 0);
		abcdefg : OUT std_logic_vector(6 DOWNTO 0)
	);
END decodificadorBCD7Seg;

ARCHITECTURE arch OF decodificadorBCD7Seg IS
	-- implementar
BEGIN
		abcdefg <= "0000000" when bcd = "0000" else --0
				    "1001111" when bcd = "0001" else --1
					  "0010010" when bcd = "0010" else --2
					  "0000110" when bcd = "0011" else --3
					  "1001100" when bcd = "0100" else --4
					  "0100100" when bcd = "0101" else --5
					  "0100000" when bcd = "0110" else --6
					  "0001111" when bcd = "0111" else --7
					  "0000000" when bcd = "1000" else --8
					  "0000100"; --9

END ARCHITECTURE; -- arch
