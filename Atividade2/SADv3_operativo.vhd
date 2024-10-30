LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity sad_operativo is
    port (
      clk, zi, ci, cpa, cpb, zsoma, csoma, csad_reg : in std_logic;
      
		  menor : out std_logic
		  sample_ori : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- sample_ori[end]
		  sample_can : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- sample_can[end]
		  address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- end
		  sad_value : OUT STD_LOGIC_VECTOR (13 DOWNTO 0) -- SAD
    );
end sad_operativo

  architecture arc of sad_operativo is

	--------- SIGNALS----------
	signal S_pA0, S_pA1, S_pA2, S_pA3, S_pB0, S_pB1, S_pB2, S_pB3, S_subtrator0, S_subtrator1, S_subtrator2, S_subtrator3 : std_logic_vector(7 downto 0);
	signal S_Somador0, S_Somador1 : std_logic_vector(8 downto 0);
	signal S_Somador2 : std_logic_vector(9 downto 0);
	signal eS_Somador2, S_reg_soma, S_mux_14bits, S_SomadorTotal : std_logic_vector(13 downto 0);
	signal S_mux_cont, S_reg_i, S_somador_cont : std_logic_vector(4 downto 0);
	signal end_memoria : std_logic_vector(3 downto 0);

	--------- COMPONENTES----------
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
	
	---- contador e endereçamento

	mux_i : mux
	generic map(N => 5)
	port map(zi, S_somador_cont, "00000", S_mux_cont);

	reg_i : registrador
	generic map(N => 5)
	port map(clk, ci, S_mux_cont, S_reg_i);

	menor <= not(S_reg_i(4));
	address <= S_reg_i(3 downto 0);

	somador_i : somador
	generic map(N => 4)
	port map(address, "0001", S_somador_cont);

  reg_pA0 : registrador
	generic map(N => 8)
	port map(clk, cpA, sample_ori(7 downto 0), S_pA0);

	reg_pA1 : registrador
	generic map(N => 8)
	port map(clk, cpA, sample_ori(15 downto 8), S_pA1);

	reg_pA2 : registrador
	generic map(N => 8)
	port map(clk, cpA, sample_ori(23 downto 16), S_pA2);

	reg_pA3 : registrador
	generic map(N => 8)
	port map(clk, cpA, sample_ori(31 downto 24), S_pA3);

	reg_pB0 : registrador
	generic map(N => 8)
	port map(clk, cpB, sample_can(7 downto 0), S_pB0);

	reg_pB1 : registrador
	generic map(N => 8)
	port map(clk, cpB, sample_can(15 downto 8), S_pB1);

	reg_pB2 : registrador
	generic map(N => 8)
	port map(clk, cpB, sample_can(23 downto 16), S_pB2);

	reg_pB3 : registrador
	generic map(N => 8)
	port map(clk, cpB, sample_can(31 downto 24), S_pB3);
    
  sub0 : subtrator
	generic map(N => 8)
	port map(S_pA0, S_pB0, S_subtrator0);

	sub1 : subtrator
	generic map(N => 8)
	port map(S_pA1, S_pB1, S_subtrator1);

	sub2 : subtrator
	generic map(N => 8)
	port map(S_pA2, S_pB2, S_subtrator2);

	sub3 : subtrator
	generic map(N => 8)
	port map(S_pA3, S_pB3, S_subtrator3);

  somador_0 : somador
	generic map(N => 8)
	port map(S_Subtrator0, S_Subtrator1, S_Somador0);

	somador_1 : somador
	generic map(N => 8)
	port map(S_Subtrator2, S_Subtrator3, S_Somador1);

	somador_2 : somador
	generic map(N => 9)
	port map(S_Somador0, S_Somador1, S_Somador2);

  eS_Somador2 <= "0000" & S_Somador2;

	somador_total : somador
	generic map(N => 14)
	port map(S_reg_soma, eS_Somador2, S_SomadorTotal);

	mux_14bits : mux
	generic map(N => 14)
	port map(zsoma, S_SomadorTotal, "00000000000000", S_mux_14bits);

	reg_soma : registrador
	generic map(N => 14)
	port map(clk, csoma, S_mux_14bits, S_reg_soma);

	reg_SAD : registrador
	generic map(N => 14)
	port map(clk, csad_reg, S_reg_soma, sad_value);

	address <= end_memoria;

end arc;
