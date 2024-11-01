LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity sad_operativo is
    port (
		  sample_ori : IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- Mem_A[end]
		  sample_can : IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- Mem_B[end]
		  clk, zi, ci, cpa, cpb, zsoma, csoma, csad_reg : in std_logic;
		  menor : out std_logic;
		  sad_value : OUT STD_LOGIC_VECTOR (13 DOWNTO 0); -- SAD
		  address : OUT STD_LOGIC_VECTOR (5 DOWNTO 0) -- end

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
			s: OUT std_logic_vector (N-1 downto 0)
		);
	END component;
	
----- Sinais Internos -----

-- Sinais circuitinho
    signal s1, s2, sfinal: std_logic_vector (6 downto 0);

-- Sinais circuitao
    signal pa, pb, sub: std_logic_vector (7 downto 0);
    signal sum, smux, sreg, finall: std_logic_vector (13 downto 0);


----- PortMap -----

-- PortMap Circuitinho
    mux_i : mux
    generic (N => 7)
    port map(zi, sfinal, "0000000", s1);
    
    reg_i : registrador
    generic (N => 7)
    port map(clk, ci, s1, s2);
    
    menor <= not(s2(6));
    address <= s2(5 downto 0);
    
    somador_i : somador
    generic (N => 7)
    port map(s2, "0000001", sfinal);
    
--PortMap Circuitao
    reg_pa : registrador
    generic (N => 8)
    port map (clk, cpa, sample_ori, pa);
    
    reg_pb : registrador
    generic (N => 8)
    port map(clk, cpb, sample_can, pb);
    
    abs_subtrator : subtrator
    generic (N => 8)
    port map(pa, pb, sub);
    
    soma : somador
    generic (N => 14)
    port map(sreg, ("000000"&sub), sum);
    
    muxx: mux
    generic (N => 14)
    port map(zsoma, sum, "00000000000000", smux);
    
    antepenultimo_reg : registrador
    generic (N => 14)
    port map(clk, csoma, smux, sreg);
    
    ultimp_reg : registrador
    generic (N => 14)
    port map(clk, csad_reg, sreg, finall);
    
    sad_value <= finall
    
end arch;
