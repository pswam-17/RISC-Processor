// Latest rev:     2024.10.06
// Created by:     J Eldon
// Design Name:    CSE141L
// Module Name:    Data Mem

// Generic data memory design for CSE141L projects
// width = 8 bits (per assignment spec.)
// depth = 2**W (default value of W = 8, may be changed)
module data_mem1 #(parameter AW=8)(
  input              clk,                // clock
  input    [AW-1:0]  DataAddress,		 // pointer
  input              ReadMem,			 // read enable	(may be tied high)
  input              WriteMem,			 // write enable
  input       [7:0]  DataIn,			 // data to store (write into memory)
  output logic[7:0] DataOut);			 //	data to load (read from memory)

  logic [7:0] mem_core [2**AW]; 		 // create array of 2**AW elements (default = 256)

// optional initialization of memory, e.g. seeding with constants
//  initial 
//    $readmemh("dataram_init.list", my_memory);

 //Program 1 all good
initial begin
  $readmemb("C:/Users/Praveen Swaminathan/Downloads/CSE 141L TestbenchesDUT/MemoryInitProg1.txt", mem_core, 17, 22);
  //$readmemb("C:/Users/Praveen Swaminathan/Downloads/CSE 141L TestbenchesDUT/MemoryInitProg2.txt", mem_core, 17, 24);
  //$readmemb("C:/Users/Praveen Swaminathan/Downloads/CSE 141L TestbenchesDUT/MemoryInitProg3.txt", mem_core, 17, 24);
end

  /*
  //Program 1
  mem_core[17] = 8'h80;
  mem_core[18] = 8'hFF;
  mem_core[19] = 8'b00010110;
  mem_core[20] = 8'b01111111;
  mem_core[21] = 8'b11100000;
  mem_core[22] = 8'b00000001;

*/
/*
//Program 2
  mem_core[17] = 8'h80;
  mem_core[18] = 8'b01111100;
  mem_core[19] = 8'b00000011;
  mem_core[20] = 8'b11111111;
  mem_core[21] = 8'b00010110;
  mem_core[22] = 8'b01111111;
  mem_core[23] = 8'b00000100;
  mem_core[24] = 8'b00001111;


//Program 3
  mem_core[17] = 8'b10000000;
  mem_core[18] = 8'b01111100;
  mem_core[19] = 8'b00000011;
  mem_core[20] = 8'b00000100;
  mem_core[21] = 8'b11111111;
  mem_core[22] = 8'b00001000;
  mem_core[23] = 8'b00000111;
  mem_core[24] = 8'b11111110;

*/

//NEED TO INITIALIZE MEM WITH ALL MASKS ^^^

// read from memory, e.g. on load instruction
  always_comb	begin						 // reads are immediate/combinational
    if(ReadMem) begin
      DataOut = mem_core[DataAddress];
      //$display("Memory read M[%d] = %d",DataAddress,DataOut);
    end
	 else begin
		DataOut = 0;
	 end
   end


// write to memory, e.g. on store instruction
  always_ff @ (posedge clk) begin	             // writes are clocked / sequential
    if(WriteMem) begin
      mem_core[DataAddress] <= DataIn;
  	  //$display("Memory write M[%d] = %d",DataAddress,DataIn);
    end
  end

endmodule
