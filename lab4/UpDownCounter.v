module up_counter1 (
    input clk,
    input load,
    input reset,
    input mode,           // 1 = up, 0 = down
    input [3:0] data_in,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (~reset) begin
        count <= 4'b0000;
    end else if (load && data_in < 4'd15) begin
        count <= data_in;
    end else begin
        case (mode)
            1'b1: count <= count + 1'b1; // Count up
            1'b0: count <= count - 1'b1; // Count down
        endcase
    end
end

endmodule
