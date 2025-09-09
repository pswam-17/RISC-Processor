module TopLevel(
	input clk,
	input start,
	input reset,
	output done
);
	
	logic [8:0] Instruction;
	logic carry, overflow, alu_carry, alu_overflow; 
	logic [11:0] target, pc;
	logic [7:0] immLI, MemAdd, ShiftLH, D1, D2, ALUMuxO, ALUout, dataMemOut, RFMux;
	logic [4:0] PCJAdd;
	logic [2:0] Rs;
	logic [2:0] Rop, immB, Rt;
	logic [1:0] Iop, ALUSrc; 
	logic RItype, RegWrite, memRead, memWrite, memToReg, branch, PCSrc, updateFlags, zero, clearFlags, ShiftDirection;

	
	
// instruction ROM
InstROM inst_module(
	.InstAddress   (pc), 
	.InstOut       (Instruction)
);

InstDecode ID(
	.Instruction(Instruction),
	.RItype(RItype),
	.Rop(Rop),
	.Iop(Iop),
	.immLI(immLI),
	.immB(immB),
	.PCJAdd(PCJAdd),
	.MemAdd(MemAdd),
	.ShiftLH(ShiftLH),
	.ShiftDirection(ShiftDirection),
	.Rs(Rs),
	.Rt(Rt)
);


Control control(
	.opcode(Rop),
	.opcode2(Iop),
	.RItype(RItype),
	.zero(zero), //FILL IN AFTER ALU
	.init(start),
	.reset(reset),

	.RegWrite(RegWrite),
	.ALUSrc(ALUSrc),
	.memRead(memRead),
	.memWrite(memWrite),
	.memToReg(memToReg),
	.branch(branch),
	.PCSrc(PCSrc),
	.updateFlags(updateFlags),
	.clearFlags(clearFlags)
);

PC_LUT LUT(
	.addr(PCJAdd),
	.target(target)
);


IF_module fetch(
	.RItype(RItype),
	.Branch(branch),
	.CondTarget(immB),
	.Target(target),
	.Init(start),
	.reset(reset),
	.Halt(done),
	.PCSrc(PCSrc),
	.CLK(clk),
	.PC(pc) //ties to InstRom

);

reg_file reg_file(
	.CLK(clk),
	.RegWrite(RegWrite),
	.R1(Rs),
	.R2(Rt),
	.writeValue(RFMux), //VALUE FROM MEMTOREG MUX, TIE LATER
	.D1(D1),
	.D2(D2)
);

ALU_mux ALUmux(
	.control_in(ALUSrc),
	.val2(D2),
	.LHWordBit(ShiftLH),
	.li_immediate(immLI),
	.out(ALUMuxO)
);

ALU ALU(
	.RItype(RItype),
	.OP(Rop),
	.OP2(Iop),
	.R1(D1),
	.R2(ALUMuxO),
	.ShiftDirection(ShiftDirection),
	.CarryIn(carry),
	.OverflowIn(overflow),
	.OUT(ALUout),
	.CarryOut(alu_carry),
	.OVERFLOW(alu_overflow),
	.zero(zero)
);

FlagRegister FlagReg(
	.clk(clk),
	.start(start),
	.reset(reset), 
	.update(updateFlags),
	.clear(clearFlags),
	.CarryIn(alu_carry),
	.OverflowIn(alu_overflow),
	.C(carry),
	.V(overflow)
);


data_mem1 data_mem1(
	.clk(clk),
	.ReadMem(memRead),
	.WriteMem(memWrite),
	.DataAddress(MemAdd),
	.DataIn(D1),
	.DataOut(dataMemOut)
);

assign RFMux = memToReg ? dataMemOut : ALUout; //MUX for data on write back to reg file

assign done = pc == 71; //Program 1
//assign done = pc == 90;  //Program 2
//assign done = pc == 139;  //Program 3



endmodule