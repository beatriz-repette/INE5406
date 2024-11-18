# Atividade Prática III

Relatório da Atividade Prática III (AP2) de INE5406 em 2024.2. 

## Grupo 4

- Ana Luiza Ramos Guimaraes (Matrícula 24100607)
- Beatriz Reis Repette (Matrícula 24103620)

## Objetivo

Seguindo com os projetos desenvolvidos para o relatorio 3, nessa etapa tivemos como objetivo criar testbenches automatizados para as duas versoes da SAD desenvolvidas e corrigir erros encontrados.

## SAD_v1

Nessa parte, corrigimos os problemas que ja estavam presentes na entrega do ultimo relatorio e atualizamos os arquivos vhdl, e relatorio.json. Com ajuda do professor Ismael, identificamos e corrigimos problemas com a descricao de component de um dos nossos registradores, com o numero de bits de determinados sinais, com a nao declaracao do sinal "reset" em alguns dos arquivos e, tambem, mudamos a declaracao do numero de bits para deixa-la e funcao de 'B'.

#### Elaboracao do testbench

A elaboração do testbench foi relativamente simples principalmente se comparada ao da SAD v3, já que não houve necessidade de leitura de um arquivo de texto para assumir os valores de entrada e saída. Sobre esse aspecto, o testbench assumia os valores de 1 e 0 iniciais para as entradas A e B e deve retornar o valor 64 como saida do sad_value. Além disso, testamos a entrada enable, forçando seu valor para 1 apenas após um passo.

#### Testagem com o testbench

...

## SAD_v3

Tambem tinhamos problemas com o SAD_v3 ja do relatorio anterior, entao comecamos corrigindo-os. Dentre os erros, identificamos e corrigimos problemas com a declaracao do registrador (reset e enable), numero de bits de alguns sinais e (adicionar caso a gente encontre outros problemas).

#### Elaboracao do Golden Model

Criamos o nosso golden model em python, utilizando a biblioteca "numpy" que ajuda bastante na realizacao de operacoes em matrizes. O nosso programa gera matrizes A e B (8x8) de elementos de 8 bits e calcula a soma da diferenca absoluta dos elementos correspondentes (|A[1,1] - B[1,1]| + |A[1,2] - B[1,2] + ....), isso eh gerado 50 vezes, para os 50 testes. Ao final da execucao do programa sao printados o contedo das matrizes A e B e o resultado esperado para o valor de saida da SAD, todos em binario.
