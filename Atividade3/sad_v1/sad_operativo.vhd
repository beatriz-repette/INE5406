LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity sad_operativo is
    generic (B: positive);
    port (
		  sample_ori : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- Mem_A[end]
		  sample_can : IN STD_LOGIC_VECTOR (B-1 DOWNTO 0); -- Mem_B[end]
		  clk, zi, ci, cpa, cpb, zsoma, csoma, csad_reg, reset : in std_logic;
		  menor : out std_logic;
		  sad_value : OUT STD_LOGIC_VECTOR (B+5 DOWNTO 0); -- SAD
		  address : OUT STD_LOGIC_VECTOR (5 DOWNTO 0) -- end

    );
end sad_operativo;

architecture arch of sad_operativo is
	
	-- COMPONENTES -- 
	component mux is
		GENERIC (N : POSITIVE := B-1);
		PORT (
			sel: IN std_logic;
			w0, w1: IN std_logic_vector (N-1 downto 0);
			f: OUT std_logic_vector (N-1 DOWNTO 0)
		);
	END component;
	
	component registrador is
		GENERIC (N : POSITIVE := B);
		PORT (
			clk: IN std_logic;
			rst: IN std_logic;
			carga: IN std_logic;
			a: IN std_logic_vector (N-1 downto 0);
			b: OUT std_logic_vector (N-1 downto 0)
		);
	END component;
	
	component somador is
		GENERIC (N : POSITIVE := B-1);
		PORT (
			a: IN std_logic_vector (N-1 downto 0);
			b: IN std_logic_vector (N-1 downto 0);
			s: OUT std_logic_vector (N-1 DOWNTO 0)
		);
	END component;
	
	component subtrator is
		GENERIC (N : POSITIVE := B-1);
		PORT (
			a: IN std_logic_vector (N-1 downto 0);
			b: IN std_logic_vector (N-1 downto 0);
			s: OUT std_logic_vector (N-1 downto 0)
		);
	END component;
	
----- Sinais Internos -----

-- Sinais circuitinho
    signal s1, s2, sfinal: std_logic_vector (B-2 downto 0);

-- Sinais circuitao
    signal pa, pb, sub: std_logic_vector (B-1 downto 0);
    signal sum, smux, sreg, finall: std_logic_vector (B+5 downto 0);


----- PortMap -----

-- PortMap Circuitinho

	BEGIN
    mux_i : mux
    generic map (N => B-1)
    port map(zi, sfinal, std_LOGIC_VECTOR(resize(unsigned('0'), B-1)), s1);
    
    reg_i : registrador
    generic map (N => B-1)
    port map(clk, reset, ci, s1, s2);
    
    menor <= not(s2(B-2));
    address <= s2(B-3 downto 0);
    
    somador_i : somador
    generic map (N => B-1)
    port map(s2, std_LOGIC_VECTOR(resize(unsigned('1'), B-1)), sfinal);
    
--PortMap Circuitao
    reg_pa : registrador
    generic map (N => B)
    port map (clk, reset, cpa, sample_ori, pa);
    
    reg_pb : registrador
    generic map (N => B)
    port map(clk, reset, cpb, sample_can, pb);
    
    abs_subtrator : subtrator
    generic map (N => B+1)
    port map(std_LOGIC_VECTOR(resize(unsigned(pa), B+1)), std_LOGIC_VECTOR(resize(unsigned(pb), B+1)), sub);
    
    soma : somador
    generic map (N => B+6)
    port map(sreg, (std_LOGIC_VECTOR(resize(unsigned(sub), B+6))), sum);
    
    muxx: mux
    generic map (N => B+6)
    port map(zsoma, sum, std_LOGIC_VECTOR(resize(unsigned('0'), B+6)), smux);
    
    antepenultimo_reg : registrador
    generic map(N => B+6)
    port map(clk, reset, csoma, smux, sreg);
    
    ultimp_reg : registrador
    generic map (N => B+6)
    port map(clk, reset, csad_reg, sreg, finall);
    
    sad_value <= finall;
    
end arch;
