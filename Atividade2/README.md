# Atividade Prática II

Relatório da Atividade Prática II (AP2) de INE5406 em 2024.2. 

## Grupo 4

- Ana Luiza Ramos Guimaraes (Matrícula 24100607)
- Beatriz Reis Repette (Matrícula 24103620)

## Descrição dos circuitos

Na implementação de ambas as versões da SAD, utilizamos os componentes: Somador, subtrator absoluto - juntamos o subtrator comum com o ABS -, registradores e multiplexadores. A partir desses componentes genéricos, os instanciamos no bloco operativo definindo quantidade de bits.

#### Circuito desenvolvido

Além dos componentes genéricos, temos o bloco de controle que administra os sinais de acordo com a máquina de estados, e o operativo, que usa-os de fato nos componentes combinacionais.
Destacando o componente "subtrator absoluto": foi uma maneira que encontramos de simplificar os processos, utilizando apenas um componente em vez de dois separados. A implementação é bem básica, simplesmente definindo a partir da subtração de, primeiro, A por B e depois, B por A, qual das duas é positiva, sendo esse o sinal de saída.

```vhdl
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
```

#### Simulação SAD v1

Em relação a simulação, tivemos alguns problemas. A principio, forçando os valores de MemA[end] para 00000011 e MemB[end] para 00000100, o clock com frequência de 10ns, e variações de reset e enable, obtivemos o valor da SAD variando apenas entre 0 e 1, ela não estava somando a cada iteração. Além disso, o endereço também se mantinha variando entre esses dois valores, não sendo incrementado a cada processo como era o esperado. 

#### Simulação SAD v3

