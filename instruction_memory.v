
module instruction_memory #(
    parameter DEPTH = 256,
    parameter INIT_FILE = "program.hex"
) (
    input wire [31:0] address,
    output wire [31:0] instruction
);
    reg [31:0] memory [0:DEPTH-1];
    wire [31:0] word_index;

    assign word_index = address >> 2;

    initial begin
        $readmemh(INIT_FILE, memory);
    end

    assign instruction = (word_index < DEPTH)
                       ? memory[word_index]
                       : 32'h00000013; // RISC-V NOP

endmodule
