module Control (
	input  [2:0] opcode,				//R instruction OPCODE
	input  [1:0] opcode2,				// I instruction OPCODE
	input  logic RItype,				//R or I type
	input logic zero,
	input init,
	input reset,
	output logic RegWrite,			// Allowing to write to register
	output logic [1:0] ALUSrc,		// mux to decide what goes to ALU (check paper) RENAME TO ALUSRC

	output logic memRead,				// loading from memory
	output logic memWrite,				// storing into memory
	output logic memToReg,

	output logic branch,					// 0 is not branching, 1 is branch
	output logic PCSrc,						//use branch value or use normal PC+1
	output logic updateFlags,
	output logic clearFlags

	);
		

	always_comb begin
	   if(init || reset) begin //init is the same signal as start
			RegWrite = 0;
			ALUSrc = 0; //maybe change to 3? Trash val anyways
			memRead = 0;
			memWrite = 0;
			memToReg = 0;
			branch = 0;
			PCSrc = 0;
			updateFlags = 0;
			clearFlags = 1;
		end
		else begin
			case(RItype)
			1'b0: begin //R type
				case(opcode)
				
				3'b000: begin //AND
					RegWrite = 1;
					ALUSrc = 0;
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  
					branch = 0; //dc
					PCSrc = 0; //(might just hardcode this to 0)
					updateFlags = 0;
					clearFlags = 0;
				end

				3'b001: begin //ADD
					RegWrite = 1;
					ALUSrc = 0;
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  
					branch = 0; //dc
					PCSrc = 0; //(might just hardcode this to 0)
					updateFlags = 1; //for "overflow" on add
					clearFlags = 0;
				end

				3'b010: begin //SUB
					RegWrite = 1;
					ALUSrc = 0;
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  
					branch = 0; //dc
					PCSrc = 0; 
					updateFlags = 0; 
					clearFlags = 0;
				end

				3'b011: begin //XOR
					RegWrite = 1;
					ALUSrc = 0;
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  
					branch = 0; //dc
					PCSrc = 0; //(might just hardcode this to 0)
					updateFlags = 0;
					clearFlags = 0; //might use as nop
				end

				3'b100: begin //MOV
					RegWrite = 1;
					ALUSrc = 0;
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  
					branch = 0; //dc
					PCSrc = 0; 
					updateFlags = 0;
					clearFlags = 0; 
				end

				3'b101: begin //SHL and SHR
					RegWrite = 1;
					ALUSrc = 1; //ALU mux selects low/high word bit
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  
					branch = 0; //dc
					PCSrc = 0; 
					updateFlags = 1; //for carry flag
					clearFlags = 0;
				end

				3'b110: begin //GT
					RegWrite = 1;
					ALUSrc = 0;
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  
					branch = 0; //dc
					PCSrc = 0; 
					updateFlags = 0; 
					clearFlags = 0;
				end

				3'b111: begin //J
					RegWrite = 0; //dc
					ALUSrc = 3; //dc, setting to 0
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  //dc
					branch = 1; //branch flag to 1
					PCSrc = 1; //will jump to PC target value designated by PC LUT
					updateFlags = 0;
					clearFlags = 0;
				end
				endcase

			end



			1'b1: begin //I type
				case(opcode2)

				2'b00: begin //BEQZ
					RegWrite = 0;
					ALUSrc = 3; //scrap value (0)
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  //dc
					branch = 1; 
					PCSrc = branch && zero; //if zero flag set, then branch (since branch already = 1)
					updateFlags = 0;
					clearFlags = 0;
				end

				2'b01: begin //LI
					RegWrite = 1;
					ALUSrc = 2; //last 3 bits is imm
					memRead = 0; //dc
					memWrite = 0; //dc
					memToReg = 0;  
					branch = 0; 
					PCSrc = 0; 
					updateFlags = 0;
					clearFlags = 1; //Doubles as a NOP for clearing Flags
				end

				2'b10: begin //LD
					RegWrite = 1;
					ALUSrc = 0; //dc CHECK LATER TO MAKE SURE NOTHING IS GOING WRONG
					memRead = 1; 
					memWrite = 0; //dc
					memToReg = 1;  
					branch = 0; 
					PCSrc = 0; 
					updateFlags = 0;
					clearFlags = 0;
				end

				2'b11: begin //STR
					RegWrite = 0; //dc
					ALUSrc = 0; //dc CHECK LATER TO MAKE SURE NOTHING IS GOING WRONG
					memRead = 0; 
					memWrite = 1; //to write to mem 
					memToReg = 0;  
					branch = 0; 
					PCSrc = 0; 
					updateFlags = 0;
					clearFlags = 0;
				end

				endcase

			end
				
				
			endcase
		end
	end
endmodule