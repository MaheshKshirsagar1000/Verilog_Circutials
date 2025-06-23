module jk_ff_tb();
    reg clk, reset;
    reg [1:0] state1;
    wire q, qn;

    parameter
        HOLD   = 2'b00,
        RESET  = 2'b01,
        SET    = 2'b10,
        TOGGLE = 2'b11,
        CYCLE  = 10;

    // Instantiate the JK flip-flop
    jk_ff jk1 (
        .clk(clk),
        .rst(reset),
        .q(q),
        .qn(qn),
        .state(state1)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CYCLE/2) clk = ~clk;
    end

    // Reset task
    task rst_dut();
    begin
        @(negedge clk);
        reset = 1'b1;
        @(negedge clk);
        reset = 1'b0;
    end
    endtask

    // Set input state task
    task set_ip(input [1:0] l);
    begin
        @(negedge clk);
        state1 = l;
    end
    endtask

    // Initial stimulus
    initial begin
        // Initialize signals
        reset = 0;
        state1 = HOLD;

        // Apply reset
        rst_dut();

        // Apply stimulus
        set_ip(HOLD);   // Hold
        set_ip(RESET);  // Reset
        set_ip(SET);    // Set
        set_ip(TOGGLE); // Toggle
        set_ip(TOGGLE); // Toggle again
        set_ip(HOLD);   // Hold again

        #50;
        $finish;
    end

endmodule
