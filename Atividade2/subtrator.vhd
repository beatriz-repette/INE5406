LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY subtrator IS
	GENERIC (N : POSITIVE := 7);
	PORT (
		a: IN std_logic_vector (N-1 downto 0);
		b: IN std_logic_vector (N-1 downto 0);
		s: OUT std_logic_vector (N-1 DOWNTO 0)
	);
END subtrator;

ARCHITECTURE behavior OF subtrator IS
	SIGNAL s1, s2 : integer;
BEGIN
	s1 <= to_integer(signed(a)) - to_integer(signed(b));
	s2 <= to_integer(signed(b)) - to_integer(signed(a));
	
	PROCESS (s1, s2)
	BEGIN
		IF s1 > 0 THEN
			s <= std_logic_vector(to_signed(s1, N));
		ELSE s <= std_logic_vector(to_signed(s2, N));
	end if;
	end process;

end behavior;
