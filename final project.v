module TFF(
    input t,rst,clk,
    output reg q,qbar
);

    always @(posedge clk)
    begin
    
    if (rst == 1 && t == 1) 
    begin
        q = 0;
        qbar = 1;
    end

    else if (rst == 1 && t == 0)
    begin
        q = 0;
        qbar = 1;
    end

    else if (rst == 0 && t == 0)
    begin
        q = q;
        qbar = ~q;
    end

    else if (rst == 0 && t == 1)
    begin 
        q = ~q;
        qbar = ~q;
    end
    
    end
endmodule


module twobitcounter(rst,clk,count);
    input rst,clk;
    output [0:1] count;

    TFF tff1(1,rst,clk,count[1],qbar1);
    TFF tff2(1,rst,qbar1,count[0],qbar2);


endmodule

// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================


module DFF(
    input d,rst,clk,
    output reg q,qbar
);

    always @(posedge clk)
    begin
    if (rst == 1 && d == 1) 
    begin
        q = 0;
        qbar = 1;
    end

    else if (rst == 1 && d == 0)
    begin
        q = 0;
        qbar = 1;
    end

    else if (rst == 0 && d == 0)
    begin
        q = 0;
        qbar = 1;
    end

    else if (rst == 0 && d == 1)
    begin 
        q = 1;
        qbar = 0;
    end
    
    end

endmodule

// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================


module fourbitregister(data,read,clk,out);
    input [0:3] data;
    input read, clk;
    output reg [0:3] out;

    wire q0,q1,q2,q3,qbar0,qbar1,qbar2,qbar3;
    // wire [0:3] puff;

    DFF dff0(data[0],0,clk,q0,qbar0);
    DFF dff1(data[1],0,clk,q1,qbar1);
    DFF dff2(data[2],0,clk,q2,qbar2);
    DFF dff3(data[3],0,clk,q3,qbar3);

    always @(posedge clk or negedge clk)
    begin
        if (read == 1)
        begin
             out[0] = q0;
             out[1] = q1;
             out[2] = q2;
             out[3] = q3;
            //  out = puff;
        end
    end
endmodule

// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================


module Bus(R1,R2,R3,DR1,DR2,AC,r1,r2,r3,dr1,dr2,OUTR,s);
    input [0:3] R1,R2,R3,DR1,DR2,AC,s;
    output reg [0:3] r1,r2,r3,dr1,dr2,OUTR;

    always @(*)
    begin
        if(s == 4'b0001)
        begin
            assign dr1 = R1;
            assign OUTR = R3;
        end
        if(s == 4'b0010)
        begin
            assign dr2 = R2;
        end
        if(s == 4'b0011)
        begin
            assign r1 = R3;
        end
        if(s == 4'b0100)
        begin
            assign r3 = AC;
        end
    end
 
endmodule


// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================


module ALU(DR1,DR2,out);
    input [0:3] DR1,DR2;
    output reg [0:3] out;

    
    assign out = DR1 + DR2;

endmodule

// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================


module decoder(I,s1,s2,s3,s4);
    input [0:1] I;
    output reg s1,s2,s3,s4;

    always @(*)
    begin
        if (I == 2'b00)
        begin
            assign s1 = 1;
            assign s2 = 0;
            assign s3 = 0;
            assign s4 = 0;
        end
        if (I == 2'b01)
        begin
            assign s1 = 0;
            assign s2 = 1;
            assign s3 = 0;
            assign s4 = 0;
        end
        if (I == 2'b10)
        begin
            assign s1 = 0;
            assign s2 = 0;
            assign s3 = 1;
            assign s4 = 0;
        end
        if (I == 2'b11)
        begin
            assign s1 = 0;
            assign s2 = 0;
            assign s3 = 0;
            assign s4 = 1;
        end
    end
endmodule

// ===================================================================================
// ===================================================================================
// ===================================================================================


module set_selector(t0,t1,t2,t3,R1_read,R2_read,R3_read,DR1_read,DR2_read,AC_read,Bus_selector);
    input t0,t1,t2,t3;
    output reg R1_read,R2_read,R3_read,DR1_read,DR2_read,AC_read;
    output reg [0:3] Bus_selector;

    always @(*)
    begin
        if(t0 == 1)
        begin
            assign R1_read = 1;
            assign R2_read = 0;
            assign R3_read = 1;
            assign DR1_read = 0;
            assign DR2_read = 0;
            assign AC_read = 0;
            assign Bus_selector = 4'b0001;
        end
        if(t1 == 1)
        begin
            assign R1_read = 0;
            assign R2_read = 1;
            assign R3_read = 0;
            assign DR1_read = 0;
            assign DR2_read = 0;
            assign AC_read = 0;
            assign Bus_selector = 4'b0010;
        end
        if(t2 == 1)
        begin
            assign R1_read = 0;
            assign R2_read = 0;
            assign R3_read = 0;
            assign DR1_read = 1;
            assign DR2_read = 1;
            assign AC_read = 0;
            assign Bus_selector = 4'b0011;
        end
        if(t3 == 1)
        begin
            assign R1_read = 0;
            assign R2_read = 0;
            assign R3_read = 1;
            assign DR1_read = 0;
            assign DR2_read = 0;
            assign AC_read = 1;
            assign Bus_selector = 4'b0100;
        end
    end

endmodule


// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================


module my_module(rst,clk,module_out);
    input rst,clk;
    output [0:3] module_out;

    wire [0:1]count;
    wire [0:3]r1,r2,r3,dr1,dr2,R1,R2,R3,DR1,DR2,AC,alu_out,Bus_selector;
    wire t0,t1,t2,t3,R1_read,R2_read,R3_read,DR1_read,DR2_read,AC_read;
    twobitcounter my_counter(rst,clk,count);
    decoder my_decoder(count,t0,t1,t2,t3);
    set_selector my_set_selector(t0,t1,t2,t3,R1_read,R2_read,R3_read,DR1_read,DR2_read,AC_read,Bus_selector);

    fourbitregister my_R1(r1,R1_read,clk,R1);
    fourbitregister my_R2(r2,R2_read,clk,R2);
    fourbitregister my_R3(r3,R3_read,clk,R3);
    fourbitregister my_DR1(dr1,DR1_read,clk,DR1);
    fourbitregister my_DR2(dr2,DR2_read,clk,DR2);
    ALU my_alu(DR1,DR2,alu_out);
    fourbitregister my_AC(alu_out,AC_read,clk,AC);
    Bus my_bus(R1,R2,R3,DR1,DR2,AC,r1,r2,r3,dr1,dr2,module_out,Bus_selector);
    // fourbitregister my_OUTR(OUTR,1,clk,module_out);
    

endmodule

// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================
// ===================================================================================

module tb_my_module();
    reg rst,clk;
    wire [0:3] module_out;


    my_module this_module(rst,clk,module_out);

    initial begin
        clk=0;
        forever #50 clk = ~clk;  
    end 

    initial begin
        rst = 1;
        
        #160;
        rst = 0;
        
    end
endmodule