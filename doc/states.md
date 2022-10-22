# Bitwise architecture
```python
@posedge(clock 0):
    # input
    msg[55:0] <- IN[63:8]
    crc[7:0] <- IN[7:0]
    md <- MD

    ControlUnit.md_en = 0;
    ControlUnit.msg_en = 0;
    ControlUnit.crc_en = 0;
    ControlUnit.acc_sel = 0;
    ControlUnit.shift_sel = 0;

@posedge(clock 1):
    # shift register
    PIPOShiftRegister[54:8] <- msg[46:0]
    PIPOShiftRegister[7:0] <- md == 0 ? '00000000' : crc[7:0]
    # accumulator
    accumulator[8:0] <- msg[55:47]

    ControlUnit.acc_sel = 1;
    ControlUnit.shift_sel = 1;
    
@posedge(clock 2..55):
    # shift register
    PIPOShiftRegister[0] <- '0'
    for i in 1..54:
        PIPOShiftRegister[i] <- [i-1]

    # accumulator
    accumulator[0] <- PIPOShiftRegister[55]
    accumulator[8:1] <- accumulator[7:0] XOR (GENERATOR AND accumulator[8])

@posedge(clock 56):
    # shift register
    for i in range(1, 55):
        PIPOShiftRegister[i] <- [i-1]
    PIPOShiftRegister[0] <- '0'
    # accumulator
    accumulator[0] <- PIPOShiftRegister[55]
    accumulator[8:1] <- accumulator[7:0] XOR (GENERATOR AND accumulator[8])

    ControlUnit.out_en = 1;


@posedge(clock 57):
    # output
    out[7:0] <- accum[7:0]
    out[63:8] <- msg[55:0]
    
    ControlUnit.out_en = 0;
    ControlUnit.msg_en = 1;
    ControlUnit.crc_en = 1;
    ControlUnit.md_en = 1;
```
----------------------------------------------------------
----------------------------------------------------------

# LUT architecture

```python
@posedge(clock 0):
    #input
    msg[56:8] <- IN[63:8]
    crc[7:0] <- IN[7:0]
    md <- MD
    
    ControlUnit.md_en = 0;
    ControlUnit.msg_en = 0;
    ControlUnit.crc_en = 0;
    ControlUnit.acc_sel = 0;
    ControlUnit.shift_sel = 0;

@posedge(clock 1):
    # shift register
    PIPOShiftRegister[55:8] <- msg[47:0]
    PIPOShiftRegister[7:0] <- md == 0 ? '00000000' : crc[7:0]

    # accumulator
    accumulator[7:0] <- msg[55:48]

    ControlUnit.acc_sel = 1;
    ControlUnit.shift_sel = 1;
 
 @posedge(clock 2..7):
    # shift register
    for i in range(8, 55):
        PIPOShiftRegister[i] <- [i-8]

    PIPOShiftRegister[7:0] <- '00000000'

    # accumulator
    accumulator[7:0] <- crc_LUT(accumulator[7:0]) XOR PIPOShiftRegister[55:48]

 @posedge(clock 8):
    # shift register
    for i in range(8, 55):
        PIPOShiftRegister[i] <- [i-8]
    PIPOShiftRegister[7:0] <- '00000000'
    # accumulator
    accumulator[7:0] <- crc_LUT(accumulator[7:0]) XOR PIPOShiftRegister[55:48]

    ControlUnit.out_en = 1

@posedge(clock 9):
    # output
    out[7:0] <- accum[7:0]
    out[63:8] <- msg[55:0]
    ControlUnit.out_en = 0;
    
    ControlUnit.msg_en = 1;
    ControlUnit.crc_en = 1;
    ControlUnit.md_en = 1;
 ```