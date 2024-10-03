LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY absolute IS
	GENERIC (N : POSITIVE := 8);
	PORT (
		a: IN std_logic_vector (N-1 DOWNTO 0);
		s: OUT std_logic_vector (N-2 DOWNTO 0)
	);
END absolute;

ARCHITECTURE arch OF absolute IS
	signal temp : std_logic_vector(N-1 downto 0);
BEGIN
	process(a)
	BEGIN
		if a(N-1) = '1' then
			temp <= std_logic_vector(unsigned(not(a)) + 1);
		else
			temp <= a;
		end if;
	end process;
	
	s <= temp(N-2 downto 0);
END arch;
