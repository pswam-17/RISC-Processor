module InstDecode (
    input [8:0] Instruction,
    output logic RItype,
    output logic [2:0] Rop,
    output logic [1:0] Iop, //use opcodes to decode rest of the bits
    output logic [7:0] immLI, //8-bit datapath for ALU

    output logic [2:0] immB, //should be good with limited bits for B and J
    output logic [4:0] PCJAdd,

    output logic [7:0] MemAdd, //make this 8 bits, and zero extend for output NEED
    output logic [7:0] ShiftLH, //8-bit for ALU
    output logic ShiftDirection,

    output logic [2:0] Rs, //ALWAYS MODIFYING TO THIS REG
    output logic [2:0] Rt

);

assign RItype = Instruction[8];

always_comb begin
     Rop = 0;
     Iop = 0;
     immLI = 0;

     immB = 0;
     PCJAdd = 0;

     MemAdd = 0;
     ShiftLH = 0;
     ShiftDirection = 0;

     Rs = 0;
     Rt = 0;

    case(RItype)
    1'b0: begin
        Rop = Instruction[7:5];
        case(Rop)

        3'b000: begin
             Rs = Instruction[4:2];
             Rt = {1'b0, Instruction[1:0]};
        end
        3'b001: begin
             Rs = Instruction[4:2];
             Rt = {1'b0, Instruction[1:0]};
        end
        3'b010: begin
             Rs = Instruction[4:2];
             Rt = {1'b0, Instruction[1:0]};
        end
        3'b011: begin
             Rs = Instruction[4:2];
             Rt = {1'b0, Instruction[1:0]};
        end
        3'b100: begin //MOV
             Rs = {1'b0, Instruction[4:3]};
             Rt = Instruction[2:0];
        end
        3'b101: begin //SHL and SHR
             Rs = Instruction[4:2];
             ShiftLH = Instruction[0];
             ShiftDirection = Instruction[1];
        end
        3'b110: begin //GT
             Rs = Instruction[4:2];
             Rt = {1'b0, Instruction[1:0]};

        end
        3'b111: begin
             PCJAdd = Instruction[4:0];
        end
        endcase

    end

    1'b1: begin
        Iop = Instruction[7:6];
        case(Iop)

        2'b00: begin //BEQZ
             Rs = Instruction[5:3];
             immB = Instruction[2:0];
        end
        2'b01: begin
             Rs = Instruction[5:3];
             immLI = Instruction[2:0];
        end
        2'b10: begin //LD
             Rs = {2'b0, Instruction[5]};
            MemAdd = Instruction[4:0];
        end 
        2'b11: begin//STR
            Rs = {2'b0, Instruction[5]};
            MemAdd = Instruction[4:0];
        end

        endcase

    end

/*
    default: begin
        assign Rop = 0;
        assign Iop = 0;
        assign immLI = 0;

        assign immB = 0;
        assign PCJAdd = 0;

        assign MemAdd = 0;
        assign ShiftLH = 0;

        assign Rs = 0;
        assign Rt = 0;
    end
*/

    endcase


end


endmodule