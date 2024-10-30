LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity sad_controle is
    port (
        iniciar, rst, clk, menor : in std_logic;
        pronto, read, zi, ci, cpa, cpb, zsoma, csoma, csad_reg : out std_logic
    );
end sad_controle;


ARCHITECTURE arch OF sad IS
	TYPE Tipo_estado IS (S0, S1, S2, S3, S4, S5);
	SIGNAL EstadoAtual, ProximoEstado : TipoEstado; 
	
PROCESS (EstadoAtual)
BEGIN
	CASE EstadoAtual IS
		WHEN S0 =>
			IF enable = '0' THEN
				ProximoEstado <= S0;
				pronto <= '1';
			ELSE 
				ProximoEstado <= S1;
			END IF;
			 pronto <= '1';
			 read_mem <= '0'; 
			 zi <= '0' ;
			 ci <= '0' ;
			 cpa <= '0' ;
			 cpb <= '0' ;
			 zsoma <= '0';
			 csoma <= '0';
			 csad_reg <= '0';
			
		WHEN S1 =>
			ProximoEstado <= S2;
			 pronto <= '0';
			 read_mem <= '0'; 
			 zi <= '1' ;
			 ci <= '1' ;
			 cpa <= '0' ;
			 cpb <= '0' ;
			 zsoma <= '1';
			 csoma <= '1';
			 csad_reg <= '0';
			
		WHEN S2 =>
			if menor = '1' then
				EstadoAtual <= S3;
			 else
				EstadoAtual <= S5;
			 end if;
			 pronto <= '0';
			 read_mem <= '0'; 
			 zi <= '0' ;
			 ci <= '0' ;
			 cpa <= '0' ;
			 cpb <= '0' ;
			 zsoma <= '0';
			 csoma <= '0';
			 csad_reg <= '0';
			 
		WHEN S3 =>
			ProximoEstado <= S4;
			 pronto <= '0';
			 read_mem <= '1'; 
			 zi <= '0' ;
			 ci <= '0' ;
			 cpa <= '1' ;
			 cpb <= '1' ;
			 zsoma <= '0';
			 csoma <= '0';
			 csad_reg <= '0';
			
		WHEN S4 =>
			ProximoEstado <= S2;
			pronto <= '0';
			 read_mem <= '0'; 
			 zi <= '0' ;
			 ci <= '1' ;
			 cpa <= '0' ;
			 cpb <= '0' ;
			 zsoma <= '0';
			 csoma <= '1';
			 csad_reg <= '0';
			
		WHEN S5 =>
			ProximoEstado <= S0;
			pronto <= '0';
			 read_mem <= '0'; 
			 zi <= '0' ;
			 ci <= '0' ;
			 cpa <= '0' ;
			 cpb <= '0' ;
			 zsoma <= '0';
			 csoma <= '0';
			 csad_reg <= '1';
	END CASE;
END PROCESS;

PROCESS (clk, reset)
BEGIN
		IF reset = '1' THEN
			EstadoAtual <= S0;
		ELSIF (rising_edge(clk)) THEN
			EstadoAtual <= ProximoEstado;
		END IF;
	END PROCESS;
	
end arch;
