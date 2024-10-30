LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity sad_operativo is
    port (
        clk, zi, ci, cpa, cpb, zsoma, csoma, csad_reg : in std_logic;
		  menor : out std_logic
		  sample_ori : IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- Mem_A[end]
		  sample_can : IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- Mem_B[end]
		  address : OUT STD_LOGIC_VECTOR (5 DOWNTO 0); -- end
		  sad_value : OUT STD_LOGIC_VECTOR (13 DOWNTO 0) -- SAD
    );
end sad_operativo;

architecture arch of sad_operativo is
	
	-- COMPONENTES -- 
	component mux is
		GENERIC (N : POSITIVE := 7);
		PORT (
			sel: IN std_logic;
			w0, w1: IN std_logic_vector (N-1 downto 0);
			f: OUT std_logic_vector (N-1 DOWNTO 0)
		);
	END component;
	
	component registrador is
		GENERIC (N : POSITIVE := 8);
		PORT (
			clk: IN std_logic;
			rst: IN std_logic;
			a: IN std_logic_vector (N-1 downto 0);
			b: OUT std_logic_vector (N-1 downto 0)
		);
	END component;
	
	component somador is
		GENERIC (N : POSITIVE := 7);
		PORT (
			a: IN std_logic_vector (N-1 downto 0);
			b: IN std_logic_vector (N-1 downto 0);
			s: OUT std_logic_vector (N-1 DOWNTO 0)
		);
	END component;
	
	component subtrator is
		GENERIC (N : POSITIVE := 7);
		PORT (
			a: IN std_logic_vector (N-1 downto 0);
			b: IN std_logic_vector (N-1 downto 0);
			s: OUT std_logic_vector (N-1 DOWNTO 0)
		);
	END component;
	
	-- SINAIS -- 
	
	signal SpA, SpB, Ssubtrator1 : std_logic_vector(7 downto 0);
	signal Smux_cont, Sreg_i, Ssomador_cont : std_logic_vector(6 downto 0);
	signal Saddress : std_logic_vector(5 downto 0);
	signal Ssubtrator2, Ssomador_AB, Sreg_soma, Smux_soma : std_logic_vector(13 downto 0);

	-- MAPEAMENTO --
	
	begin
		
		mux_i : mux
		generic map(N => 7)
		port map(zi, Ssomador_cont, "0000000", Smux_cont);
		
		reg_i : registrador
		generic map(N => 7);
		port map(clk, ci, Smux_cont, Sreg_i);
		
		menor <= not(Sreg_i(6)); -- chegar bit mais significativo
		Saddress <= Sreg_i(5 downto 0);
		
		somador_i : somador
		generic map (N => 6)
		port map(Saddress, "000001", Ssomador_cont);
		
		reg_pA : registrador
		generic map(N => 8)
		port map(clk, cpA, sample_ori, SpA);
		
		reg_pB : registrador
		generic map(N => 8)
		port map(clk, cpB, sample_can, SpB);
		
		subtratorABS : subtrator
		generic map(N => 8)
		port map(SpA, SpB, Ssubtrator1);
		
		Ssubtrator2 <= "00000" & Ssubtrator1;
		
		somador_AB : somador
		generic map (N => 14)
		port map (Sreg_soma, Ssubtrator2, Ssomador_AB);
		
		muxSoma : mux
		generic map (N => 14)
		port map (zsoma, Ssomador_AB, "00000000000000", Smux_soma);
		
		reg_soma : registrador
		generic map (N => 14)
		port map (clk, csoma, Smux_soma, Sreg_soma);
		
		reg_sad : registrador
		generic map (N => 14)
		port map (clk, csad_reg, Sreg_soma, sad_value);
		
		address <= Saddress;
		
	end arch;
