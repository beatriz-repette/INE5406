LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY registrador IS
	GENERIC (N : POSITIVE := 8);
	PORT (
		clk: IN std_logic;
		rst: IN std_logic;
		carga IN std_logic;
		a: IN std_logic_vector (N-1 downto 0);
		b: OUT std_logic_vector (N-1 downto 0)
	);
END registrador;

ARCHITECTURE behavior OF registrador IS
	signal reg_value : std_logic_vector(N-1 downto 0);
BEGIN
	process(clk, rst)
	BEGIN
	if rst = '1' then
		reg_value <= (others => '0');
	elsif rising_edge(clk) then
	    if (carga = '1') then
		    reg_value <= a;
		end if;
	end if;
	end process;
	
	b <= reg_value;

end behavior;
