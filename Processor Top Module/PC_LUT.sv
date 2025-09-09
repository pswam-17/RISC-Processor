module PC_LUT #(parameter D=12)(
  input       [4:0] addr,	   // target up to 32 values
  output logic[D-1:0] target);

  always_comb case(addr)
    0: target = 20;   //PROGRAM 1
	1: target = 71;   
	2: target = 26;   
	3: target = 35;
	4: target = 36;
	5: target = 56;
	default: target = 71;  // make default the done program counter value, to stop if something goes wrong 
  endcase

  /*
   always_comb case(addr) //PROGRAM 2
    0: target = 33;   //beginCond
	1: target = 46;   //skip
	2: target = 41;   //sign1
	3: target = 90;   //END
	4: target = 52;   //beginElse
	5: target = 68;   //shift
	6: target = 78;   //bitInv
	7: target = 86;   //storingMem
	default: target = 90;  // make default the done program counter value, to stop if something goes wrong 
  endcase
  */

/*
  always_comb case(addr) //PROGRAM 3
    0: target = 56;   //mantissaAdjust
	1: target = 90;   //skip
	2: target = 61;   //shiftm2
	3: target = 76;   //shiftm1
	4: target = 66;   //loop
	5: target = 81;   //loop2
	6: target = 104;   //bitAdj
	7: target = 120;   //preEnd
	8: target = 127;   //ENDSTORE
	default: target = 139;  // make default the done program counter value, to stop if something goes wrong 
  endcase
*/
endmodule


