module async_dual_port(
    clr, clk_wr, clk_rd, din, wr_addr, rd_addr, we, re, dout
);
    input [15:0] din;
    input clr, clk_wr, clk_rd, we, re;
    input [2:0] wr_addr, rd_addr;
    output reg [15:0] dout;

    reg [15:0] mem[7:0];
    integer i;
    parameter depth = 8;

    // Write logic
    always @(posedge clk_wr or posedge clr)
    begin
        if (clr)
        begin
            for (i = 0; i < depth; i = i + 1)
                mem[i] <= 0;
        end
        else if (we)
            mem[wr_addr] <= din;
    end

    // Read logic
    always @(posedge clk_rd or posedge clr)
    begin
        if (clr)
        begin
            dout <= 0;
        end
        else if (re)
            dout <= mem[rd_addr];
    end

endmodule
