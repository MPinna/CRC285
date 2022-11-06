from math import floor, ceil
from random import random

INPUT_BITS_SENDER = 56
INPUT_BITS_RECEIVER = 64

# Generator = x^8 + x^4 + x^3 + x^2 + 1
GENERATOR = "100011101"

SENDER_INPUTS = [
    "0526abfa59289d",
    "1ad743298a5b0c",
    "49dbf2d3fca778",
    "58de7943c3b4e1",
    "7a32768bdb8fb4",
    "8d73243271fdf2",
    "c387f7b71ddd50",
    "d8c66625791098",
    "e34a300fa4c345",
    "f9e70f4d2b6ed3"
    ]

RECEIVER_INPUTS = [
    "0526abfa59289d75",
    "1ad743298a5b0c13",
    "49dbf2d3fca7787a",
    "58de7943c3b4e1f7",
    "7a32768bdb8fb458",
    "8d73243271fdf286",
    "c387f7b71ddd502e",
    "d8c66625791098b7",
    "e34a300fa4c3451d",
    "f9e70f4d2b6ed389",
]

def hex_string_to_bit_string(hex_string: str) -> str:
    if(hex_string[:2] == "0x"):
        hex_string = bit_string[2:]
    bit_string_len = len(hex_string)*4
    i = int(hex_string, 16)
    bit_string = format(i, f"0{bit_string_len}b")
    return bit_string


def bit_string_to_hex_string(bit_string: str) -> str:
    if(bit_string[:2] == "0b"):
        bit_string = bit_string[2:]
    hex_string_len = ceil(len(bit_string)/4)
    i = int(bit_string, 2)
    hex_string = format(i, f"0{hex_string_len}x")
    return hex_string


def generate_random_sender_input():
    input = ""
    for i in range(int((INPUT_BITS_SENDER/8)*2)):
        input += str(hex(floor(random()*16)))[2:]
    return input


def compute_CRC(M, G = GENERATOR) -> str:
    
    M_len = len(M)

    # add padding to the right
    padding = (len(G) - 1) * '0'
    padded_M = list(M + padding)

    # the outer while loop scans the whole message to be processed
    while '1' in padded_M[:M_len]:
        MSB_index = padded_M.index('1')
        # the inner for loop computes each step of the division
        for i in range(len(G)):
            # the != between single bits basically corresponds to a XOR
            padded_M[MSB_index + i] = str(int(G[i] != padded_M[MSB_index + i]))
    return ''.join(padded_M)[M_len:]


def check_CRC(IN, G=GENERATOR) -> str:
    IN_len = len(IN) - 8
    M = IN[0:len(IN) - 8]

    IN_list = list(IN)

    # the outer while loop scans the whole message to be processed
    while '1' in IN_list[:IN_len]:
        MSB_index = IN_list.index('1')
        # the inner for loop computes each step of the division
        for i in range(len(G)):
            # the != between single bits basically corresponds to a XOR
            IN_list[MSB_index + i] = str(int(G[i] != IN_list[MSB_index + i]))
    return M + (''.join(IN_list)[IN_len:])


def CRC(IN: str, md: str) -> str:
    IN = hex_string_to_bit_string(IN)
    SENDER_MODE = True if md == '0' else False
    ret = ""
    if(SENDER_MODE):
        ret = IN + compute_CRC(IN)
    else:
        ret = check_CRC(IN)
    return bit_string_to_hex_string(ret)

if __name__ == "__main__":
    print("Sender mode")
    for index, input in enumerate(SENDER_INPUTS):
        output = CRC(input, '0')
        print(f"{input} -> {output}")
        check = CRC(output, '1')
        # check = check_CRC(hex_string_to_bit_string(output))
        print(f"Check: {check}")