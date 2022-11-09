
# Generator polynomial is 100011101
GENERATOR = int("00011101", 2)

def compute_crc(dividend):
    b = dividend
    for i in range(8):
        if (b & 0x80):
            b <<= 1
            b ^= GENERATOR
        else:
            b <<= 1
    return b % 256

LUT = []

if __name__ == "__main__":
    print("Generating look-up table")
    for i in range (256):
        crc = compute_crc(i)
        LUT.append(crc)

    for index, entry in enumerate(LUT):
        print(f"\"{entry:02X}\",", end="")
        if(index % 16 == 15):
            print()
        else:
            print(" ", end="")
