//-----------------------------------------------------------------------------
// Program Counter
//
// The Program Counter (PC) stores the address of the current instruction.
// In the Fetch stage, the top-level module uses this address to retrieve the
// instruction from memory. After the instruction is decoded and executed,
// the PC is updated — usually to PC + 4, or to a new address if the instruction
// is a branch or jump — so that it points to the next instruction to execute.
//
// Used In: Fetch, Execute, Writeback
//
// File Contributor(s): Ishan Porwal
//-----------------------------------------------------------------------------

module program_counter (
    input logic clk,
    input logic reset,
    input logic select,
    input logic [31:0] immediate,       // to store the immediate for jumps/branches
    output logic [31:0] pc              // 32-bit program counter
);
    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 0;
        end
        else if (select) begin
            pc <= pc + immediate;
        end
        else begin
            pc <= pc + 4;
        end
    end
endmodule
