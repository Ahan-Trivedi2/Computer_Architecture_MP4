//-----------------------------------------------------------------------------
// Top-Level Module
//
// Coordinates the multicycle processor datapath. Each instruction is executed
// over multiple clock cycles: Fetch, Decode, Execute, Memory Access, and
// Writeback. This module instantiates and wires together all major components,
// including the control unit, ALU, register file, memory, and PC.
//
// Used In: All stages
//
// File Contributor(s): Ishan Porwal
//-----------------------------------------------------------------------------

`include "alu_control.sv"
`include "alu.sv"
`include "branch_logic.sv"
`include "control_unit.sv"
`include "immediate_generator.sv"
`include "instruction_decode.sv"
`include "instruction_register.sv"
`include "memory.sv"
`include "program_counter.sv"
`include "register_file.sv"

// Fade top level module

module top (
    input logic clk
);
    // Program Counter Output
    logic [31:0] pc_out;

    // Register File Output
    logic [31:0] rs1_value, rs2_value;

    // Memory File Output
    logic [31:0] memory_read_value;

    // Instruction Register Ouput
    logic [31:0] instruction;

    // Instruction Decoder Output
    logic [6:0] opcode;
    logic [4:0] rd_address, rs1_address, rs2_address;
    logic [2:0] funct3;
    logic [6:0] funct7;

    // Immediate Generator Output
    logic [31:0] immediate;

    // Branch Logic Output
    logic branch_taken;

    // ALU Logic Output
    logic [31:0] alu_result;

    // Control Unit Logic Output
    logic [31:0] op2, memory_write, memory_read_address, register_file_write, memory_write_address;
    logic register_write_en, memory_write_en;
    logic [3:0] pc_control;
    logic [3:0] alu_control;
    logic [1:0] ir_control;
    

    control_unit CONTROL_UNIT (
        .instruction(instruction),
        .branch_taken(branch_taken),
        .register_write_en(register_write_en),
        .pc_control(pc_control),
        .ir_control(ir_control),
        .alu_control(alu_control),
        .op2(op2),
        .memory_write(memory_write),
        .memory_write_en(memory_write_en),
        .memory_write_address(memory_write_address),
        .memory_read_address(memory_read_address),
        .register_file_write(register_file_write)
    );

    // ALU
    alu ALU (
        .operand_a(rs1_value),
        .operand_b(op2),
        .alu_control(alu_control),
        .result(alu_result)
    );

    // Branch Logic
    branch_logic BRANCH_LOGIC (
        .rs1(rs1_value),
        .rs2(rs2_value),
        .funct3(funct3),
        .branch_taken(branch_taken)
    );

    // Immediate Generator
    immediate_generator IMM_GEN (
        .instruction(instruction),
        .immediate(immediate)
    );

    // Instruction Decode
    instruction_decode INSTR_DECODE (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd_address),
        .funct3(funct3),
        .rs1(rs1_address),
        .rs2(rs2_address),
        .funct7(funct7)
    );

    // Instruction Register
    instruction_register INSTR_REG (
        .clk(clk),
        .ir_control(ir_control),
        .instr_in(memory_read_value),
        .instr_out(instruction)
    );

    // Memory
    memory MEM (
        .clk(clk),
        .write_mem(memory_write),
        .funct3(funct3),
        .write_address(memory_write_address),
        .write_data(rs2_value),
        .read_address(memory_read_address),
        .read_data(memory_read_value),
        .led(),
        .red(),
        .green(),
        .blue()
    );

    // Program Counter
    program_counter PC (
        .clk(clk),
        .pc_control(pc_control),
        .immediate(immediate),
        .rs1(rs1_value),
        .PC(pc_out)
    );

    // Register File
    RegisterFile REGFILE (
        .clk(clk),
        .WEn(register_write_en),
        .rs1(rs1_address),
        .rs2(rs2_address),
        .rd(rd_address),
        .write_data(register_file_write),
        .rs1_data(rs1_value),
        .rs2_data(rs2_value)
    );

endmodule
