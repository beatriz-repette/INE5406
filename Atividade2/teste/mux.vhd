LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux IS
	GENERIC (N : POSITIVE := 7);
	PORT (
		sel: IN std_logic;
		w0: IN std_logic_vector (N-1 downto 0);
		w1: IN std_logic_vector (N-1 downto 0);
		f: OUT std_logic_vector (N-1 DOWNTO 0)
	);
END mux;

ARCHITECTURE behavior OF mux IS
BEGIN
	f <= w0 WHEN sel = '0' ELSE w1;

end behavior;
