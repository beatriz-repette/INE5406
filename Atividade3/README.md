# Atividade Prática III

Relatório da Atividade Prática III (AP2) de INE5406 em 2024.2. 

## Grupo 4

- Ana Luiza Ramos Guimaraes (Matrícula 24100607)
- Beatriz Reis Repette (Matrícula 24103620)

## Objetivo

Seguindo com os projetos desenvolvidos para o Relatório 3, nesta etapa tivemos como objetivo criar testbenches automatizados para as duas versões da SAD desenvolvidas e corrigir erros encontrados.

## SAD_v1

Nesta parte, corrigimos os problemas que já estavam presentes na entrega do último relatório e atualizamos os arquivos VHDL e relatório.json. Com a ajuda do professor Ismael, identificamos e corrigimos problemas relacionados à descrição de componentes de um dos nossos registradores, ao número de bits de determinados sinais, à não declaração do sinal "reset" em alguns dos arquivos e, também, alteramos a declaração do número de bits para que ficasse em função de 'B'.

#### Testbench: elaboração e testagem

A elaboração do testbench foi relativamente simples, especialmente se comparada ao da SAD_v3, já que não houve necessidade de leitura de um arquivo de texto para assumir os valores de entrada e saída. Para a testagem, utilizamos os mesmos valores da nossa simulação do relatório anterior com o arquivo estímulos.do. Ou seja, colocamos os valores 0 e 1 para as matrizes, a fim de obter como saída o valor 64. Como no último relatório sequer esse caso de teste funcionou, acabamos não elaborando outro.

Quando rodamos a testagem pela primeira vez, mesmo o valor de saída da SAD sendo o esperado, o testbench retornou erros. Corrigimos isso ajustando os tempos de espera no testbench para que a checagem ocorresse apenas após o cálculo da SAD ter sido finalizado. Depois, rodamos o testbench mais uma vez e nenhum erro ocorreu.

## SAD_v3

Também tínhamos problemas com o SAD_v3 desde o relatório anterior, então começamos corrigindo-os. Entre os erros, identificamos e resolvemos problemas relacionados à declaração do registrador (reset e enable), ao número de bits de alguns sinais e alteramos a declaração de bits para que ficasse em função de 'B', como feito para a SAD_v1.

#### Elaboração do Golden Model

Criamos o nosso golden model em Python, utilizando a biblioteca "numpy", que ajuda bastante na realização de operações em matrizes. O nosso programa gera matrizes A e B (8x8) com elementos de 8 bits e calcula a soma das diferenças absolutas dos elementos correspondentes (|A[1,1] - B[1,1]| + |A[1,2] - B[1,2]| + ...). Isso é feito 50 vezes para os 50 testes. Ao final da execução do programa, são exibidos o conteúdo das matrizes A e B e o resultado esperado para o valor de saída da SAD, todos em binário.

Na saída, dividimos as matrizes A e B em blocos de 32 bits e as imprimimos de forma intercalada (ex.: 32bitsA + ' ' + 32bitsB + ' ' + 32bitsA + ...), deixando o valor da SAD ao final. Fizemos isso para facilitar a leitura dos estímulos no testbench. Dividindo as matrizes em blocos de 32 bits, temos o necessário para um ciclo do cálculo da SAD e podemos implementar um loop para o cálculo com mais facilidade.

#### Testbench: elaboração e testagem

A parte mais difícil da elaboração desse testbench foi decidir como extrair os valores do arquivo .dat de maneira eficiente e, depois, fazer com que o loop escolhido funcionasse corretamente.

Durante a testagem, ocorreram erros em todos os casos de teste. Primeiramente, testamos mais algumas vezes o nosso golden model para assegurar que seus valores de saída estavam realmente corretos e confirmamos que sim. Restaram, então, duas possibilidades: erros na descrição do testbench ou erros na descrição da nossa arquitetura da SAD. Infelizmente, não conseguimos identificar o problema nem corrigi-lo a tempo, mas acreditamos que os seguintes fatores possam ter causado os erros:

1. Número de bits insuficiente nos subtratores: A primeira hipótese é que podemos ter utilizado um número insuficiente no portmap dos nossos subtratores, o que poderia ocasionar overflow quando esses valores são convertidos para signed dentro da entidade do subtrator. Caso ocorra overflow, perderíamos a precisão do cálculo, o que explicaria o valor incorreto de saída.

2. Leitura errada dos valores de estímulos.dat: Outra razão para o testbench ter falhado pode ser uma leitura incorreta dos estímulos (como interpretar um valor com um espaço adicional ou ausência dele), o que afetaria os cálculos e resultaria em valores de sad_value errados.

3. Tempo de espera inadequado no testbench: Tivemos esse problema no testbench da SAD_v1 e ele também pode estar presente aqui. Caso o tempo de espera seja insuficiente para validar o assert com o valor esperado da SAD, o testbench pode estar comparando o resultado com outro ponto da testagem. Embora este seja um problema que não corrigimos, verificamos os valores manualmente e confirmamos que, mesmo que o testbench utilizasse os valores nos momentos certos (quando done=1), os valores de saída ainda estariam diferentes dos esperados segundo o golden model.
