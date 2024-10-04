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

![Print da simulacao com o ModelSim](https://drive.google.com/file/d/1AYhFOqVPcpxg3cZnUO3Wlb3olO98-GNB/view?usp=drive_link)

Simulamos o circuito com todos os possíveis valores de entrada (números em BCD que representam de 0 a 9) e comparamos o resultado com o valor de saída esperado (encontrado na tabela abaixo).

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
"
### Valor Absoluto

Aqui, desenvolvemos um circuito que, a partir de um número em complemento de dois com 8 bits, retornava o módulo desse número com 7 bits. Um problema que encontramos é quando é passado o valor negativo máximo - no caso de 8 bits seria -128 - o qual contém módulo impossível de representar com apenas 7 bits. Tendo isso em mente, consideramos esse caso como impossível e portanto nosso circuito não o suporta.

#### Circuito desenvolvido

A lógica se resume em negar a entrada bit a bit e somar '1', e desconsidera-se o bit mais significativo (o negativo ou 0 no caso dos positivos).

#### Simulação

Em se tratando da simulação, assim como os outros circuitos, usamos um arquivo .do para realiza-la, e lá definimos a troca de entrada de 30 em 30 ns, considerando que o maior atraso na datasheet era de aproximadamente 11 ns. Essas entradas foram definidas aleatoriamente, com atenção ao caso proibido, aos números negativos gerando saídas positivas e números positivos gerando saídas iguais, apenas com um bit a menos.


### Árvore de somas

O circuito desenvolvido trata-se da soma de uma quantidade de genérica de entradas, como sugerido pelo desafio.

#### Circuito desenvolvido

Definimos como generic N (numero de bits das entradas) P (numero de entradas) e ExtraBits (numero de bits a serem adicionados à saída para evitar overflow). Depois, definimos uma variável temporária para armazenar a soma. Em seguida, implementamos um loop para somar as entradas, onde i serve como index que vai de 0 a P-1.

#### Simulação


