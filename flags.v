
module flags (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] result,
    input wire [3:0] alu_control,
    output wire zero,
    output wire negative,
    output reg carry,
    output reg overflow
);
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;

    wire [32:0] add_ext;
    wire [32:0] sub_ext;

    assign add_ext = {1'b0, a} + {1'b0, b};
    assign sub_ext = {1'b0, a} + {1'b0, ~b} + 33'd1;

    assign zero = (result == 32'd0);
    assign negative = result[31];

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;

        case (alu_control)
            ALU_ADD: begin
                carry = add_ext[32];
                overflow = (~(a[31] ^ b[31])) & (result[31] ^ a[31]);
            end
            ALU_SUB: begin
                carry = sub_ext[32];
                overflow = (a[31] ^ b[31]) & (result[31] ^ a[31]);
            end
            default: begin
                carry = 1'b0;
                overflow = 1'b0;
            end
        endcase
    end
endmodule
