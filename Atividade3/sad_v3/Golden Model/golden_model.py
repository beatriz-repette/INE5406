#Golden model para o projeto SAD_v3

import numpy as np


def sad(matriz_a, matriz_b):
    # Calcula o SAD (a transformacao dos numeros para 16 bits evita erros relcionados aos valores negativos)
    sad = np.sum(np.abs(matriz_a.astype(np.int16) - matriz_b.astype(np.int16)))
    return sad


for _ in range(50):
    # Gera 50 matrizes 8x8 aleatorias, com numeros de 8 bits
    matriz_a = np.random.randint(0, 255, size=(8, 8), dtype=np.uint8)
    matriz_b = np.random.randint(0, 255, size=(8, 8), dtype=np.uint8)

    sad_value = sad(matriz_a, matriz_b)

    # Formata as matrizes e o valor de sad
    matriz_a_bin = ''.join(f"{value:08b}" for value in matriz_a.flatten())
    matriz_b_bin = ''.join(f"{value:08b}" for value in matriz_b.flatten())

    sad_bin = f"{sad_value:014b}"

    #Adiciona um espaco a cada 32 bits do conteudo das matrizes A e B, esses valores serao usados pelo testbench para realizar a simulacao
    matriz_a_bin = ' '.join(matriz_a_bin[i:i + 32] for i in range(0, len(matriz_a_bin), 32))
    matriz_b_bin = ' '.join(matriz_b_bin[i:i + 32] for i in range(0, len(matriz_b_bin), 32))

    # Imprime as matrizes e o SAD, separados por espaco
    print(f"{matriz_a_bin} {matriz_b_bin} {sad_bin}")
  
