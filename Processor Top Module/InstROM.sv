
module InstROM(
  input       [ 11:0] InstAddress, //change to 12 bits
  output logic[ 8:0] InstOut);
	 

  logic[8:0] core[2**12];
  initial							    // load the program
    $readmemb("C:/Users/Praveen Swaminathan/Downloads/CSE 141L TestbenchesDUT/Prog1_machine.txt",core);
    //$readmemb("C:/Users/Praveen Swaminathan/Downloads/CSE 141L TestbenchesDUT/Prog2_machine.txt",core);
    //$readmemb("C:/Users/Praveen Swaminathan/Downloads/CSE 141L TestbenchesDUT/Prog3_machine.txt",core);


  always_comb  InstOut = core[InstAddress];
 
 
 

/*
  always_comb 
	case (InstAddress)
	
   //Sample code, just for synthesizable purposes
	0  :  InstOut = 'b101111111; //LI R7 7
   1  :  InstOut = 'b101010011;  //LI R2 3
   2  :  InstOut = 'b100111101;   //ADD R7 R2

	  default : InstOut = 'b010000010; //keep the default address a NOP or just branch to done to stop program
    endcase
*/

endmodule
