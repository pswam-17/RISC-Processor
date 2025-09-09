module ALU_mux ( 
	input logic [1:0] control_in,
	input logic [7:0] val2, //output from D2
	input logic [7:0] LHWordBit, //Low or high word, for shifts
	input logic [7:0] li_immediate,
	output logic [7:0] out
   );
	
always_comb begin
	 if (control_in == 0) begin
		out = val2;
		//$display("Out is val2. control_in is %d", control_in);
	 end else if (control_in == 1) begin
		out = LHWordBit;
		//$display("Out is LHWordBit. control_in is %d", control_in);
	 end else if (control_in == 2) begin		
	 
		////$display("Li_imm %d!", li_immediate);
		out = li_immediate;  //for LI instruction, putting into ALU as 8 bit number
		
	 end else if (control_in == 3) begin //For weird values
		out = 0;
		//$display("Out is 0. control_in is %d", control_in);
	 end else begin
		out = 0;
		//$display("Weird control_in value of %d", control_in);
	 end
  end
endmodule
