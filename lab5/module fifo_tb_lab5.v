module fifo_tb();
reg [7:0] din_tb;
reg clk, rst, we_tb, re_tb;
wire full_tb, empty_tb;
wire [7:0] dout_tb;

integer l, m;

fifo ff1(.clk(clk), .rst(rst), .din(din_tb), .we(we_tb), .re(re_tb),
         .full(full_tb), .empty(empty_tb), .dout(dout_tb));

initial
    clk = 1'b0;

always
    #10 clk = ~clk;

// Task to apply reset
task value_rst();
    begin
        @(negedge clk)
            rst = 1'b1;
        @(negedge clk)
            rst = 1'b0;
    end
endtask

// Task to initialize signals
task initialize();
    begin
        {din_tb, we_tb, re_tb} = 0;
    end
endtask

// Task to write value
task value_write(input [7:0] j);
    begin
        @(negedge clk)
            we_tb = 1'b1;
            din_tb = j;
    end
endtask

// Task to read value
task value_read();
    begin
        @(negedge clk)
            re_tb = 1'b1;
    end
endtask

initial
    begin
        initialize();
        value_rst();
        for (l = 0; l < 16; l = l + 1)
        begin
            value_write(l);
        end
        we_tb = 1'b0;
        value_read();
    end

initial
    #1000 $finish;

endmodule