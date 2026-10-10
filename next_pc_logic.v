
module next_pc_logic (
    input  wire [31:0] pc,
    input  wire [31:0] immediate,
    input  wire [31:0] rs1_data,
    input  wire        branch_taken,
    input  wire        jump,
    input  wire        jalr,
    output wire [31:0] next_pc
);

    wire [31:0] pc_plus4;
    wire [31:0] pc_relative_target;
    wire [31:0] jalr_target;

    assign pc_plus4 = pc + 32'd4;

    assign pc_relative_target = pc + immediate;

    // JALR target must have bit 0 cleared.
    assign jalr_target = (rs1_data + immediate) & 32'hFFFFFFFE;

    assign next_pc =
        jalr ? jalr_target :
        (jump || branch_taken) ? pc_relative_target :
        pc_plus4;

endmodule
