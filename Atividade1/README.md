# Atividade Prática I

Relatório da Atividade Prática I (AP1) de INE5406 em 2024.2. 

## Grupo 4

- Ana Luiza Ramos Guimarães (Matrícula 24100607)
- Beatriz Reis Repette (Matrícula 24103620)

## Descrição dos Circuitos

### Decodificador BCD 7-Segmentos

O circuito basicamente define qual número será representada (quais "leds" do display irão acender) a partir de seu valor em BCD. Por exemplo, para o número 1000 em BCD, equivalente a 8 em decimal, o display se acenderia por completo, exibindo um oito.

#### Circuito desenvolvido

Para realizar o circuito do decodificador de 7 bits, usamos códigos muito parecidos aos que usávamos na matéria de circuitos e técnicas, que são bastante diretos e intuitivos. Por meio do "when" definimos um valor de saída para "abcdefg" para cada um dos valores de input de "bcd", de 0 a 9.

#### Simulação

![decod7seg](https://github.com/user-attachments/assets/82009577-4d4a-4ea2-b9cf-0814def867bf)

Simulamos o circuito com todos os possíveis valores de entrada (números em BCD que representam de 0 a 9) e comparamos o resultado com o valor de saída esperado (encontrado na tabela abaixo). Como o atraso crítico do nosso circuito foi de 9.164 ns, na hora de simular mantivemos cada input por 20 ns.

| Número (decimal) | Codificação para display7seg |
|:-:|:-:|
| 0 | 0000001 |
| 1 | 1001111 |
| 2 | 0010010 |
| 3 | 0000110 |
| 4 | 1001100 |
| 5 | 0100100 |
| 6 | 0100000 |
| 7 | 0001111 |
| 8 | 0000000 |
| 9 | 0000100 |

Nota: Quando o print do teste foi feito, o valor de saída para a entrada "0000" estava descrito como "0000000" no código, que na verdade representa o número 8 no display. Isso foi posteriormente corrigido, de acordo com a tabela acima.

### Valor Absoluto

Aqui, desenvolvemos um circuito que, a partir de um número em complemento de dois com N bits (8 bits, para os casos de teste), retornava o módulo desse número com um bit a menos (ignorando o sinal). Um possível problema relacionado à nossa implementação surge quando, na entrada, tem-se o valor mais negativo de determinado intervalo de representação. Nesse caso, quando o módulo do número é calculado e o bit mais significativo é descartado, ocorre overflow, devido ao fato de o valor mais negativo em complemento de dois para N bits não poder ser representado de forma positiva em N-1 bits. Para fins de simplificação e objetividade, nesta implementação, consideramos que isso não ocorreria como entrada.

#### Circuito desenvolvido

A lógica se resume em negar a entrada bit a bit e somar '1', desconsiderando o bit mais significativo (que, de antemão, estava presente para identificar o sinal).

#### Simulação

![absolute jpg](https://github.com/user-attachments/assets/cdfccd1b-86e0-46af-bb59-9abf48182cd6)

Assim como para os outros circuitos, montamos arquivos de teste .do e os usamos para a simulação no ModelSim. Para este circuito, definimos a troca de entrada de 30 em 30 ns, considerando o atraso crítico do circuito, de 11,394 ns. Para as entradas de teste, utilizamos tanto números negativos quanto positivos gerados aleatoriamente (em complemento de 2), tomando cuidado para não usar o valor mais negativo de um intervalo de representação. Convertíamos esses números para decimal, calculávamos seus módulos e comparávamos essas respostas às saídas do circuito, verificando se estavam corretas para todos os casos de teste.


### Árvore de somas

Na proposta padrão, a árvore de somas deveria somar 4 números de N bits e retornar um resultado de N+2 bits, visando prevenir overflow. Para esse circuito, decidimos desenvolver sua versão desafio, que adiciona uma camada de dificuldade por ser um circuito genérico que, em vez de somar apenas 4 números, soma P valores de entrada, cada um com N bits. Nesta questão, todos os números de entrada são positivos e sem sinal.

#### Circuito desenvolvido

Na resolução deste circuito, nos deparamos com inúmeros desafios, sendo o fato de o número de entradas ser genérico um complicador para a implementação.

Nosso primeiro impasse foi como realizar o input de todos esses valores a serem somados, já que não poderíamos mais armazená-los em variáveis separadas e pré-determinadas. A solução foi receber todos os valores como uma string de N*P bits e, posteriormente, separar essa string em P entradas de N bits, recuperando assim os valores que queríamos! Imagine: seja "i" o índice dos elementos P em uma lista de entrada, haveria índices de 0 a P-1. Para a nossa implementação, usamos esse raciocínio, considerando "i" como uma espécie de índice e procedendo da seguinte maneira,  onde "input" é o nosso vetor de entrada:

```vhdl
input((i*N + N - 1) DOWNTO (i*N))
```

O segundo desafio que tivemos foi determinar quantos bits deveriam ser adicionados ao vetor de saída para prevenir casos de overflow. Para isso, pesquisamos e descobrimos que, se o nosso vetor de saída tivesse N + ceil(log2(P)) bits, o overflow nunca ocorreria. Implementar isso em VHDL é um verdadeiro desafio, já que nem ceil() nem log2() são funções descritas em bibliotecas da linguagem. Para contornar esse problema, decidimos adicionar um terceiro elemento genérico: "ExtraBits". O propósito da variável ExtraBits é facilitar a execução do código VHDL, determinando a quantidade de bits extras que o output deverá ter antes da execução. Para isso, pode-se seguir a seguinte tabela:

| Número de Entradas (P) | Bits Extras (ExtraBit) |
|:-:|:-:|
| 2 | 1 |
| 4 | 2 |
| 8 | 3 |
| 16 | 4 |
| 32 | 8 |

Para efetuar a soma de todos os valores P, decidimos usar um processo com a variável "temp_sum" para a soma temporária. Além disso, também utilizamos um sinal, "sum_result", que receberia o resultado da soma temporária, ainda dentro do processo, e passaria esse valor para a saída "output" após o fim do processo. Usando o processo e um loop, conseguimos facilitar a implementação do somador, aproximando-o ao funcionamento de um somador em uma possível linguagem de alto nível (usando um for loop).

```vhdl
PROCESS(input)
		VARIABLE temp_sum : unsigned((N + ExtraBits - 1) DOWNTO 0) := (OTHERS => '0'); -- Variavel temporarea para armazenar a soma
	BEGIN
		temp_sum := (OTHERS => '0');
		
		FOR i IN 0 TO P-1 LOOP -- Loop para somar as entradas
			temp_sum := temp_sum + unsigned(input((i*N + N - 1) DOWNTO (i*N))); -- i serve como um index que vai de 0 a P-1
		END LOOP;
	
		sum_result <= temp_sum;	
	END PROCESS;
```


#### Simulação

![addertree](https://github.com/user-attachments/assets/b3dcb0c4-1d50-4f25-8752-dad6900cd48a)

Assim como para os outros circuitos, montamos um arquivo com casos de teste em intervalos de 30 ns, respeitando o atraso crítico do circuito de 13.490 ns. Para a simulação usamos N=8, P=4 e ExtraBit=2, a fim de atender os requisitos da proposição original do circuito. Determinamos, então, várias sequências de números para serem somados, os somamos manualmente e comparamos os resultados com o output obtido, verificando todos os casos.
