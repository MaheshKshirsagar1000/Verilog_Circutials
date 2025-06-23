module sr_latch_tb();
    reg s, r;
    wire q, qn;

    // Instantiate the SR latch
    sr_latch s1 (
        .s(s),
        .r(r),
        .q(q),
        .qn(qn)
    );

    // Task to initialize inputs
    task initialize();
    begin
        s = 0;
        r = 0;
    end
    endtask

    // Task to set S and R inputs
    task set_in(input reg s_in, input reg r_in);
    begin
        s = s_in;
        r = r_in;
    end
    endtask

    // Test sequence
    initial begin
        initialize;
        #5;

        $display("Time\tS R | Q Qn");
        $monitor("%0t\t%b %b | %b %b", $time, s, r, q, qn);

        set_in(1'b0, 1'b0);  // Hold
