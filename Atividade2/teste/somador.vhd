LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY somador IS
	GENERIC (N : POSITIVE := 7);
	PORT (
		a: IN std_logic_vector (N-1 downto 0);
		b: IN std_logic_vector (N-1 downto 0);
		s: OUT std_logic_vector (N-1 DOWNTO 0)
	);
END somador;

ARCHITECTURE behavior OF somador IS
BEGIN

	s <= std_logic_vector(unsigned(a) + unsigned(b));

end behavior;
