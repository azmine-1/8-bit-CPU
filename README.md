# 8-bit-CPU
## Overview

This project is an implementation of an 8-bit CPU based on the Ahmes architecture, as outlined in the [guide by Embedded Systems](https://embeddedsystems.io/ahmes-a-simple-8-bit-cpu-in-vhdl/). It supports 24 instructions, uses an 8-bit data bus, and can address 256 bytes of memory. The CPU was developed using VHDL.

The core components of the CPU are:
- **Accumulator (AC)**: 8-bit register for arithmetic and logical operations.
- **Status Register**: 5-bit register holding flags (N-negative, Z-zero, C-carry, B-borrow, V-overflow).
- **Program Counter (PC)**: 8-bit register to hold the address of the current instruction.
  
## Instruction Set

The CPU supports the following instructions:

| Opcode       | Mnemonic   | Description                                  | Comments                                  |
|--------------|------------|----------------------------------------------|-------------------------------------------|
| 0000 0000    | NOP        | No operation                                 | No operation performed                    |
| 0001 0000    | STA addr   | `MEM(addr) ← AC`                             | Store the accumulator at memory address   |
| 0010 0000    | LDA addr   | `AC ← MEM(addr)`                             | Load accumulator from memory address      |
| 0011 0000    | ADD addr   | `AC ← MEM(addr) + AC`                        | Add memory content to accumulator         |
| 0100 0000    | OR addr    | `AC ← MEM(addr) OR AC`                       | Logical OR between memory and accumulator |
| 0101 0000    | AND addr   | `AC ← MEM(addr) AND AC`                      | Logical AND between memory and accumulator|
| 0110 0000    | NOT        | `AC ← NOT AC`                                | Logical complement of accumulator         |
| 0111 0000    | SUB addr   | `AC ← MEM(addr) - AC`                        | Subtract accumulator from memory content  |
| 1000 0000    | JMP addr   | `PC ← addr`                                  | Unconditional jump                        |
| 1001 0000    | JN addr    | `If N=1, PC ← addr`                          | Jump if negative                          |
| 1001 0100    | JP addr    | `If N=0, PC ← addr`                          | Jump if positive                          |
| 1001 1000    | JV addr    | `If V=1, PC ← addr`                          | Jump if overflow                          |
| 1001 1100    | JNV addr   | `If V=0, PC ← addr`                          | Jump if not overflow                      |
| 1010 0000    | JZ addr    | `If Z=1, PC ← addr`                          | Jump if zero                              |
| 1010 0100    | JNZ addr   | `If Z=0, PC ← addr`                          | Jump if not zero                          |
| 1011 0000    | JC addr    | `If C=1, PC ← addr`                          | Jump if carry                             |
| 1011 0100    | JNC addr   | `If C=0, PC ← addr`                          | Jump if not carry                         |
| 1011 1000    | JB addr    | `If B=1, PC ← addr`                          | Jump if borrow                            |
| 1011 1100    | JNB addr   | `If B=0, PC ← addr`                          | Jump if not borrow                        |
| 1110 0000    | SHR        | `C ← AC(0); AC(i-1) ← AC(i); AC(7) ← 0`      | Logical shift right                       |
| 1110 0001    | SHL        | `C ← AC(7); AC(i) ← AC(i-1); AC(0) ← 0`      | Logical shift left                        |
| 1110 0010    | ROR        | `C ← AC(0); AC(i-1) ← AC(i); AC(7) ← C`      | Rotate right through carry                |
| 1110 0011    | ROL        | `C ← AC(7); AC(i) ← AC(i-1); AC(0) ← C`      | Rotate left through carry                 |
| 1111 0000    | HLT        | Halt                                         | Halt the CPU (not implemented)            |

### Special Instructions:
- **NOP**: No operation; the CPU performs no action during this cycle.
- **HLT**: Stops the CPU (not implemented in this version).

### Jump Instructions:
Conditional jump instructions alter the flow of execution based on flag values. They depend on the status register flags (N, Z, C, B, V) to determine whether to branch.

## Registers and Flags

- **Accumulator (AC)**: Main register for ALU operations (8 bits).
- **Program Counter (PC)**: Holds the address of the current instruction (8 bits).
- **Status Register**: Contains five flags:
  - **N** (Negative): Set if the result of an operation is negative.
  - **Z** (Zero): Set if the result of an operation is zero.
  - **C** (Carry): Set if there is a carry out of the most significant bit.
  - **B** (Borrow): Set during subtraction operations when a borrow occurs.
  - **V** (Overflow): Set if there is an overflow during signed arithmetic operations.

## Memory

- The CPU can address 256 bytes of memory, meaning the memory address bus is 8 bits wide.

## Usage

1. **Load Program**: Load a program into memory using the assembler that translates instructions to machine code (opcode).
2. **Run Program**: The program counter fetches and executes instructions from memory sequentially or conditionally, based on the opcode.

### Example Program

```asm
LDA 0x10      ; Load accumulator with value from address 0x10
ADD 0x11      ; Add value from address 0x11 to accumulator
STA 0x12      ; Store result from accumulator into address 0x12
HLT           ; Halt the CPU
