module ALU(
  input RItype,
  input [ 2:0] OP, //Op code for R instructions
  input [ 1:0] OP2, //Opcode for I instructions
  input [7:0] R1,
  input [7:0] R2,
  input logic ShiftDirection,
  input logic CarryIn,
  input logic OverflowIn,
  output logic [7:0] OUT,
  output logic CarryOut,   //C Flag for shift
  output logic OVERFLOW,   //V flag for add (not necessary for SUB for programs)
  output logic zero);
  
	
  always_comb begin
  
	  OUT = 0;
	  OVERFLOW = 0;
	  CarryOut = 0;
	  zero = 0;
	  
	case(RItype)
	1'b0: begin
		case(OP)
		
		3'b000: begin //AND
			OUT = R1 & R2;
		end
		3'b001: begin //ADD
			{OVERFLOW, OUT} = R1+R2+OverflowIn; //Make sure to understand what numbers I might be adding, and plan assembly accordingly 
		end
		3'b010: begin //SUB 1
			OUT = R1 - R2;
		end
		3'b011: begin //XOR
			OUT = R1 ^ R2;
		end
		3'b100: begin//MOV
			OUT = R2;

		end
		3'b101: begin//SHL & SHR -> 0 is left, 1 is right

			if(ShiftDirection == 0 ) begin //SHL
				if(R2 == 0) begin //loading high or low word bit into ALU R2. 0 is low word
					{CarryOut, OUT} = {R1, 1'b0};
				end
				else if(R2==1) begin
					OUT = {R1[6:0], CarryIn};
				end
			end
			else if(ShiftDirection == 1) begin //SHR
				if(R2 == 0) begin
					OUT = {CarryIn, R1[7:1]};
				end
				else if(R2 == 1) begin
					{OUT, CarryOut} = {R1[7], R1};
				end
			end
		
		end
		3'b110: begin //GT
			OUT = R1 > R2; 

		end
		default: begin
			OUT = 0;
			zero = 0; //dont care
			CarryOut = 0; //dont care
			OVERFLOW = 0; //dc
	  	end

		endcase
	end


	1'b1: begin
		case(OP2)
		2'b00: begin //BEQZ
			if (R1 == 0) begin
				OUT = 0;
				zero = 1;
			end
			else begin
				OUT = 0;
				zero = 0; 
			end
		end
		2'b01: begin //LI
			//R2 has imm value so R1 getting that value
			OUT = R2; //output has value now
		end
		default: begin
			OUT = 0;
			zero = 0;
			CarryOut = 0;
			OVERFLOW = 0;
		end
		endcase
	end


	endcase

  end


endmodule