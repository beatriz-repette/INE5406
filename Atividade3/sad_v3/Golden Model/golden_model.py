import numpy as np

def sad(matriz_a, matriz_b):
    # Calcula o SAD (a transformação dos números para 16 bits evita erros relacionados aos valores negativos)
    sad = np.sum(np.abs(matriz_a.astype(np.int16) - matriz_b.astype(np.int16)))
    return sad

for _ in range(50):
    # Gera 50 matrizes 8x8 aleatórias, com números de 8 bits
    matriz_a = np.random.randint(0, 255, size=(8, 8), dtype=np.uint8)
    matriz_b = np.random.randint(0, 255, size=(8, 8), dtype=np.uint8)

    sad_value = sad(matriz_a, matriz_b)

    # Formata as matrizes em binário e aplaina os arrays
    matriz_a_bin = ''.join(f"{value:08b}" for value in matriz_a.flatten())
    matriz_b_bin = ''.join(f"{value:08b}" for value in matriz_b.flatten())

    # Divide os bits em blocos de 32
    matriz_a_blocks = [matriz_a_bin[i:i + 32] for i in range(0, len(matriz_a_bin), 32)]
    matriz_b_blocks = [matriz_b_bin[i:i + 32] for i in range(0, len(matriz_b_bin), 32)]

    # Alterna os blocos da matriz A e B
    combined_blocks = []
    for a_block, b_block in zip(matriz_a_blocks, matriz_b_blocks):
        combined_blocks.append(a_block)
        combined_blocks.append(b_block)

    # Adiciona o valor de SAD ao final
    sad_bin = f"{sad_value:014b}"
    combined_blocks.append(sad_bin)

    # Junta os blocos com espaços entre eles
    output = ' '.join(combined_blocks)

    # Imprime o resultado
    print(output)