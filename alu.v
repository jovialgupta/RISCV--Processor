
module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] alu_control,
    output reg [31:0] result
);
    localparam ADD=4'b0000, SUB=4'b0001,
               AND_OP=4'b0010, OR_OP=4'b0011,
               XOR_OP=4'b0100, SLL=4'b0101,
               SRL=4'b0110, SLT=4'b0111,
               SLTU=4'b1000, SRA=4'b1001;

    always @(*) begin
        case (alu_control)
            ADD:    result = a + b;
            SUB:    result = a - b;
            AND_OP: result = a & b;
            OR_OP:  result = a | b;
            XOR_OP: result = a ^ b;
            SLL:    result = a << b[4:0];
            SRL:    result = a >> b[4:0];
            SLT:    result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            SLTU:   result = (a < b) ? 32'd1 : 32'd0;
            SRA:    result = $signed(a) >>> b[4:0];
            default: result = 32'd0;
        endcase
    end
endmodule
