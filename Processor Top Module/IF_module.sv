module IF_module #(parameter D=12) (
  input RItype,
  input Branch,  //link to control output
  input [2:0] CondTarget, //unsigned target value to add to PC
  input [D-1:0] Target,
  input Init, //same as start
  input reset,
  input PCSrc,
  input Halt,
  //input Halt, maybe add done logic here? Might change
  input CLK,
  output logic[D-1:0] PC
  );
	
  always_ff @(posedge CLK) begin
	if(reset || Init) begin 
	  PC <= 0;
	  //$display("Reset detected at time %0t, PC reset to 0", $time);
	end
	else if(Halt) begin //This is done signal inject pc counter number USE IF CODE BREAKING 
	  PC <= PC; end
	else if(Branch && (PCSrc == 1)) begin
	  //$display("Target = %b", Target);
	  if(RItype == 1) begin
			//$display("Branching %d forward!", CondTarget);
			PC <= PC + CondTarget;  //unsigned 
	  end
	  else if (RItype == 0) begin
			//$display("Branching to PC %d !", Target);
			PC <= Target;
	  end
	end
	else begin
	  PC <= PC+1;
	  //$display("[%t] PC incremented. PC <= %0d", $time, PC);
	end

  end

endmodule
