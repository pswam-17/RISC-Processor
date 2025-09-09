# Outputs: 
# 1. Machine code (no comments) 
# 2. LUT Reference (Jump locations and associated PC counter) 
# 3. Machine + comments (has machine code, associated assembly code, and assembly comments)

def convert_fixed(inFile, outFileMachine, outFileLUT, outFileComments):
    with open(inFile, 'r') as f:
        assembly = f.readlines()

    opcodes = {
        'AND': '000', 'ADD': '001', 'SUB': '010', 'XOR': '011',
        'MOV': '100', 'SH': '101', 'GT': '110',
        'BEQZ': '00', 'LI': '01', 'LD': '10', 'STR': '11', 'J': '111'
    }

    registers = {
        'R0': '000', 'R1': '001', 'R2': '010', 'R3': '011',
        'R4': '100', 'R5': '101', 'R6': '110', 'R7': '111'
    }

    # First pass: collect labels with actual PC values
    lut = {}
    jump_label_ids = {}
    next_jump_id = 0
    pc = 0
    for line in assembly:
        line = line.strip()
        if not line or line.startswith('//'):
            continue
        if line.endswith(':'):
            label = line[:-1]
            lut[label] = pc
        elif line.startswith('J '):  # it's a jump instruction
            parts = line.split()
            label = parts[1]
            if label not in jump_label_ids:
                jump_label_ids[label] = next_jump_id
                next_jump_id += 1
            pc+=1
        else:
            pc += 1

    pc = 0
    with open(outFileMachine, 'w') as mf, open(outFileLUT, 'w') as lf, open(outFileComments, 'w') as cf:
        for label, addr in lut.items():
            lf.write(f"{label} {addr}\n")

        for line in assembly:
            orig_line = line.rstrip('\n')
            line = line.strip()
            if not line or line.startswith('//') or line.endswith(':'):
                continue

            code_part = line.split('//')[0].strip()
            parts = code_part.replace(',', '').split()

            instr = parts[0].upper()
            binary = ""

            if instr == 'MOV':
                src = registers[parts[1].upper()]
                tgt = registers[parts[2].upper()]
                binary = '0' + opcodes[instr] + src[-2:] + tgt
            elif instr in ['AND', 'ADD', 'SUB', 'XOR', 'GT']:
                src = registers[parts[1].upper()]
                tgt = registers[parts[2].upper()]
                binary = '0' + opcodes[instr] + src + tgt[-2:]
            elif instr == 'SH':
                src = registers[parts[1].upper()]
                direction = parts[2]
                highlow = parts[3]
                binary = '0' + opcodes[instr] + src + direction + highlow
            elif instr == 'BEQZ':
                src = registers[parts[1].upper()]
                imm = int(parts[2])
                imm_bin = format(imm, '03b')
                binary = '1' + opcodes[instr] + src + imm_bin
            elif instr == 'LI':
                src = registers[parts[1].upper()]
                imm = int(parts[2])
                imm_bin = format(imm, '03b')
                binary = '1' + opcodes[instr] + src + imm_bin
            elif instr in ['LD', 'STR']:
                reg_bin = registers[parts[1].upper()]
                reg_bit = reg_bin[-1]
                imm = int(parts[2])
                imm_bin = format(imm, '05b')
                binary = '1' + opcodes[instr] + reg_bit + imm_bin
            elif instr == 'J':
                label = parts[1]
                imm = jump_label_ids.get(label, 0)
                imm_bin = format(imm, '05b')
                binary = '0' + opcodes[instr] + imm_bin
            else:
                continue

            mf.write(binary + '\n')
            cf.write(f"PC {pc}: {binary}\t// {orig_line}\n")
            pc += 1


#convert_fixed('Prog1_Assembly.txt', 'Prog1_machine.txt', 'Prog1_lut.txt', 'Prog1_comments.txt')
#convert_fixed('Prog2_Assembly.txt', 'Prog2_machine.txt', 'Prog2_lut.txt', 'Prog2_comments.txt')
convert_fixed('Prog3_Assembly.txt', 'Prog3_machine.txt', 'Prog3_lut.txt', 'Prog3_comments.txt')


