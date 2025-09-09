# ATLAS Processor README

## Design Philosophy
The overall philosophy of this architecture is to be highly optimized to accomplish the heavy bit manipulation, carries, and basic arithmetic required to execute the three programs.  

- Uses an instruction set geared toward prioritizing bit manipulation, arithmetic operations, and related conditionals.  
- Shifts computational workload to the hardware and instructions, making software easy to understand and efficient in clock cycles.  
- Employs a **register-register / load-store classification**.  

---

## ATLAS Instruction Set Overview

| Type     | Format                                                                 | Corresponding Instructions |
|----------|------------------------------------------------------------------------|-----------------------------|
| **R**    | 1 bit type, 3 bits opcode, 3 bits source reg, 2 bits target reg         | AND, ADD, OR, SUB, XOR      |
| **R\***  | 1 bit type, 3 bits opcode, 2 bits source reg, 3 bits target reg         | MOV                         |
| **R-SH** | 1 bit type, 3 bits opcode, 3 bits source reg, 1 bit shift dir, 1 bit H/L | SH                          |
| **J**    | 1 bit type, 3 bits opcode, 5-bit immediate                              | J                           |
| **I**    | 1 bit type, 2 bits opcode, 3 bits source reg, 3 bits immediate          | BEQZ, LI (load immediate)   |
| **I-MEM**| 1 bit type, 2 bits opcode, 1 bit source reg, 5 bits immediate           | LD, STR                     |

---

## Program Scores (All Passed)
- **Program 1:** 101/101  
- **Program 2:** 31/31  
- **Program 3:** 12/12  

---

## Hardware / Software Files

### Top Module
- `TopLevel.sv`  
- `InstROM.sv`  
- `InstructionDecode.sv`  
- `Control.sv`  
- `PC_LUT.sv`  
- `IF_module.sv`  
- `reg_file.sv`  
- `ALU_mux.sv`  
- `ALU.sv`  
- `FlagReg.sv`  
- `data_mem.sv`  

### Testbenches & Dummy DUTs
- `data_mem_DUT1.sv`  
- `data_mem_DUT2.sv`  
- `data_mem_DUT3.sv`  
- `flt2fix_tb.sv` — Program 2 TB  
- `flt2fix0.sv` — Program 2 Dummy DUT  
- `fltflt_no_rnd_tb.sv` — Program 3 TB  
- `fltflt0_no_rnd.sv` — Program 3 Dummy DUT  
- `new_fix2flt_tb.sv` — Program 1 TB  
- `Top_level0.sv` — Program 1 Dummy DUT  

### Memory Initialization (per program)
- `MemoryInitProg1.txt`  
- `MemoryInitProg2.txt`  
- `MemoryInitProg3.txt`  

### Program Initialization (machine code)
- `Prog1_machine.txt`  
- `Prog2_machine.txt`  
- `Prog3_machine.txt`  

### Assembler
- `assembler2.py` — main assembler program  
- `Prog1_Assembly.txt`  
- `Prog1_comments.txt`  
- `Prog1_lut.txt`  
- `Prog1_machine.txt`  
- `Prog2_Assembly.txt`  
- `Prog2_comments.txt`  
- `Prog2_lut.txt`  
- `Prog2_machine.txt`  
- `Prog3_Assembly.txt`  
- `Prog3_comments.txt`  
- `Prog3_lut.txt`  
- `Prog3_machine.txt`  

---

## How to Use

### Synthesis
- `data_mem.sv`: comment out initial `begin` block with `readmemb`.  
- `InstROM.sv`: comment out from `logic[8:0]` to `always_comb InstOut`; uncomment bottom block (contains sample instructions for synthesis).  
- No changes required for other files.  

### Simulation
- `data_mem.sv`: update memory masks and filepaths for program-specific `MemoryInit` files.  
- `InstROM.sv`: update machine code filepath for each program.  
- `PC_LUT.sv`: set `PC_Lut` for program number, keep others commented out.  
- `TopLevel.sv`: update `assign done` statement for program number (last lines).  
- Load testbenches, Dummy DUTs, and memory files for each program.  
- No changes required for other files.  

### Assembler
- Place `assembler2.py` and target Assembly file in the same folder.  
- Uncomment the bottom of `assembler2.py` for the desired program’s Assembly file.  
- Generates 3 files:  
  - `*_comments.txt`: Assembly converted to machine text with PC numbers and annotations.  
  - `*_lut.txt`: Label-to-PC mappings for jumps (PC_LUT already updated automatically).  
  - `*_machine.txt`: Raw machine code ready for simulation.  

---

