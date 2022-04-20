from math import floor
from random import random

INPUT_BITS_SENDER = 56
INPUT_BITS_RECEIVER = 64

# Generator = x^8 + x^4 + x^3 + x^2 + 1
GENERATOR = "100011101"

SENDER_INPUTS = [
    'f9e70f4d2b6ed3',
    '49dbf2d3fca778',
    'e34a300fa4c345',
    'd8c66625791098',
    'c387f7b71ddd50',
    '58de7943c3b4e1',
    '7a32768bdb8fb4',
    '8d73243271fdf2',
    '1ad743298a5b0c',
    '0526abfa59289d'
    ]

RECEIVER_INPUTS = [
    "f9e70f4d2b6ed389",
    "49dbf2d3fca7787a",
    "e34a300fa4c3451d",
    "d8c66625791098b7",
    "c387f7b71ddd502e",
    "58de7943c3b4e1f7",
    "7a32768bdb8fb458",
    "8d73243271fdf286",
    "1ad743298a5b0c13",
    "0526abfa59289d75"
]

def hex_string_to_bit_string(hex_string: str) -> str:
    hex_string = hex_string.lstrip("0x")
    i = int(hex_string, 16)
    bit_string = format(i, 'b')
    return bit_string


def bit_string_to_hex_string(bit_string: str) -> str:
    i = int(bit_string, 2)
    return str(hex(i)).lstrip("0x")


def generate_random_sender_input():
    input = ""
    for i in range(int((INPUT_BITS_SENDER/8)*2)):
        input += str(hex(floor(random()*16)))[2:]
    return input


def compute_CRC(M, G = GENERATOR) -> str:

    # check if M is effectively a bit string
    if not all(b in "01" for b in M):
        print(f"[crc_remainder()] {M} is not a valid input")
    
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


# TODO clean and add comments
def check_CRC(IN, G=GENERATOR):

    # split input into message and CRC
    CRC = IN[INPUT_BITS_SENDER:INPUT_BITS_RECEIVER]
    M = IN[:INPUT_BITS_SENDER]
    msg_len = len(M)
    initial_padding = CRC
    input_padded_array = list(M + initial_padding)
    while '1' in input_padded_array[:msg_len]:
        cur_shift = input_padded_array.index('1')
        for i in range(len(G)):
            input_padded_array[cur_shift + i] = str(int(G[i] != input_padded_array[cur_shift + i]))
    return ('1' not in ''.join(input_padded_array)[msg_len:])

def CRC(IN: str, md: str) -> str:
    SENDER_MODE = True if md == '0' else False
    ret = ""
    if(SENDER_MODE):
        # print("Sender mode")
        ret = IN + compute_CRC(IN)
    
    # if receiver mode
    else:
        # print("Receiver mode")
        ret = IN
        if(check_CRC(IN)):
            ret = ret[:INPUT_BITS_SENDER] + '0'*8
    if len(ret) < 64:
        ret = '0'*(64 - len(ret)) + ret
    return ret


for input in SENDER_INPUTS:
    print(CRC(hex_string_to_bit_string(input), '0'))

print()
for input in RECEIVER_INPUTS:
    print(CRC(hex_string_to_bit_string(input), '1'))