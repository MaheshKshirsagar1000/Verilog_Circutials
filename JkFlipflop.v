module jk_ff (
    input clk,
    input rst,              // renamed from 'reset' to avoid conflict
    input [1:0] state,
    output reg q,
    output wire qn
);

parameter
    HOLD   = 2'b00,
    RESET  = 2'b01,
    SET    = 2'b10,
    TOGGLE = 2'b11;

always @(posedge clk) begin
    if (rst)
        q <= 1'b0;
    else begin
        case (state)
            HOLD:   q <= q;
            RESET:  q <= 1'b0;
            SET:    q <= 1'b1;
            TOGGLE: q <= ~q;
        endcase
    end
end

assign qn = ~q;

endmodule
