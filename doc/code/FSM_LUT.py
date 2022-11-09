@posedge(clock 0):
    #input
    msg[56:8] <- IN[63:8]
    crc[7:0] <- IN[7:0]
    md <- MD
    
    ControlUnit.in_en = 0;
    ControlUnit.mid_sel = 0;
    ControlUnit.out_en = 0;

@posedge(clock 1):
    # shift register
    PIPOShiftRegister[55:8] <- msg[47:0]
    PIPOShiftRegister[7:0] <- md == 0 ? '00000000' : crc[7:0]

    # accumulator
    accumulator[7:0] <- msg[55:48]

    ControlUnit.mid_sel = 1;
 
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

    ControlUnit.mid_sel = 0;
    ControlUnit.out_en = 1

@posedge(clock 9):
    # output
    out[7:0] <- accum[7:0]
    out[63:8] <- msg[55:0]
    
    ControlUnit.out_en = 0;
    ControlUnit.in_en = 1;
    