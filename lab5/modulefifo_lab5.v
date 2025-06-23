module fifo(clk, rst, din, we, re, full, empty, dout);

input clk, rst, we, re;
input [7:0] din;
reg [4:0] wr_pntr, rd_pntr;
output full, empty;
output reg [7:0] dout;

reg [7:0] mem[0:15];

integer i;

// write operation
always @(posedge clk)
begin
    if (rst)
    begin
        for (i = 0; i < 16; i = i + 1)
            mem[i] <= 0;
        wr_pntr <= 0;
    end
    else if (we && !full)
    begin
        mem[wr_pntr] <= din;
        wr_pntr <= wr_pntr + 1'b1;
    end
    else
        wr_pntr <= wr_pntr;
end

// read operation
always @(posedge clk)
begin
    if (rst)
    begin
        dout <= 0;
        rd_pntr <= 0;
    end
    else if (re && !empty)
    begin
        dout <= mem[rd_pntr];
        rd_pntr <= rd_pntr + 1'b1;
    end
    else
    begin
        dout <= dout;
        rd_pntr <= rd_pntr;
    end
end

assign full = ((wr_pntr[4] != rd_pntr[4]) && (wr_pntr[3:0] == rd_pntr[3:0])) ? 1'b1 : 1'b0;
assign empty = (wr_pntr == rd_pntr) ? 1'b1 : 1'b0;

endmodule