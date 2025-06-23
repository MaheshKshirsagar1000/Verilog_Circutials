module async_dual_port_tb();

  reg [15:0] din_tb;
  reg [2:0] wr_addr_tb, rd_addr_tb;
  reg clr, clk_wr, clk_rd, we_tb, re_tb;
  wire [15:0] dout_tb;

  integer l, m;
  parameter DEPTH = 8;
  parameter T = 10;

  async_dual_port adp (
    .clr(clr),
    .clk_wr(clk_wr),
    .clk_rd(clk_rd),
    .din(din_tb),
    .wr_addr(wr_addr_tb),
    .rd_addr(rd_addr_tb),
    .we(we_tb),
    .re(re_tb),
    .dout(dout_tb)
  );

  initial begin
    clk_wr = 1'b0;
    clk_rd = 1'b0;
  end

  always #5 clk_wr = ~clk_wr;
  always #8 clk_rd = ~clk_rd;

  task value_clr();
  begin
    clr = 1'b1;
    #10 clr = 1'b0;
  end
  endtask

  task initialize();
  begin
    {din_tb, we_tb, re_tb} = 0;
  end
  endtask

  task value_write(input [2:0] i, input [15:0] j);
  begin
    @(negedge clk_wr)
    we_tb = 1'b1;
    re_tb = 1'b0;
    wr_addr_tb = i;
    din_tb = j;
  end
  endtask

  task value_read(input [2:0] i);
  begin
    @(negedge clk_rd)
    we_tb = 1'b0;
    re_tb = 1'b1;
    rd_addr_tb = i;
  end
  endtask

  initial begin
    initialize();
    value_clr();
    for (l = 0; l < DEPTH; l = l + 1)
      value_write(l, l + 1);
    for (m = 0; m < DEPTH; m = m + 1)
      value_read(m);
  end

  initial #1000 $finish;

endmodule
