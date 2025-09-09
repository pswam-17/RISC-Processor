module reg_file #(parameter W=8, D=3)( // W = size of register, 2^d is number of registers
    input CLK,
	input RegWrite,
    input  [2:0] R1,
    input  [2:0] R2,
    input  [W-1:0] writeValue,
    output logic [W-1:0] D1,
    output logic [W-1:0] D2
    );

// 8 bits wide, 8 reg deep 
logic [7:0] registers_arr[2**D];
// combinational reads

assign D1 = registers_arr[R1];
assign D2 = registers_arr[R2];



// sequential (clocked) writes
always_ff @ (posedge CLK) begin
	if(RegWrite) begin
		registers_arr[R1] <= writeValue;
        //$display("Reg write reg_arr[%d] = %d",R1,writeValue);
	end
end

endmodule
