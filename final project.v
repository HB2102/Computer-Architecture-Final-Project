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

 

//======================================================================================

module twobitcounter(rst,clk,count);
    input rst,clk;
    output [0:1] count;

    TFF tff1(1,rst,clk,count[1],qbar1);
    TFF tff2(1,rst,qbar1,count[0],qbar2);


endmodule

// =============================================================================================

module DFF(d,reset,clk,q);
input clk,d,reset;
output reg q;
    always @(posedge clk)
    begin
    if (reset==1) 
    begin
        q = 0;
    end

    if (reset==0 && d==0)
    begin
        q= 0;
    end

    else if (reset==0 && d == 1)
    begin
        q = 1;
    end
    end 
    
endmodule

// =====================================================================================================

module fourbitregister(data,read,clk,out);
    input [0:3] data;
    input read, clk;
    output reg [0:3] out;

    wire q0,q1,q2,q3;
    

    DFF dff0(data[0],0,clk,q0);
    DFF dff1(data[1],0,clk,q1);
    DFF dff2(data[2],0,clk,q2);
    DFF dff3(data[3],0,clk,q3);

    always @(posedge clk or negedge clk)
    begin
        if (read == 1)
        begin
             out[0] = q0;
             out[1] = q1;
             out[2] = q2;
             out[3] = q3;
        end
    end
endmodule

module fourbitregisterjustposedgr(data,read,clk,out);
    input [0:3] data;
    input read, clk;
    output reg [0:3] out;

    wire q0,q1,q2,q3;
    

    DFF dff0(data[0],0,clk,q0);
    DFF dff1(data[1],0,clk,q1);
    DFF dff2(data[2],0,clk,q2);
    DFF dff3(data[3],0,clk,q3);

    always @(posedge clk)
    begin
        if (read == 1)
        begin
             out[0] = q0;
             out[1] = q1;
             out[2] = q2;
             out[3] = q3;
        end
    end
endmodule
//======================================================================================================
module Bus(R1,R2,R3,AC,r1,r2,r3,dr1,dr2,OUTR,s);
    input [0:3] R3,R1,R2,AC,s;
    output reg [0:3] r1,r2,r3,dr1,dr2,OUTR;

    always @(*)
    begin
        if(s == 4'b0000)
        begin
            assign OUTR = R3;
        end
        if(s == 4'b0001)
        begin
            assign dr1 = R1;
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

// =====================================================================================================
//ALU:
module fulladder (a, b, cin, cout, sum);
    input a , b , cin;
    output cout, sum;

    xor(w0, a , b);
    xor(sum, w0, cin);

    and(w1, a, b);
    and(w2, w0, cin);
    or(cout, w1 ,w2); 
endmodule

module mux (i1,i2,i3,i4 , s , y);
    input i1,i2, i3, i4;
    input [1:0] s;
    output y;
    not(ns0 , s[0]);
    not(ns1 , s[1]);
    and(w0, i1, ns1, ns0);
    and(w1, i2, ns1, s[0]);
    and(w2, i3, s[1], ns0);
    and(w3, i4, s[1], s[0]);

    or(y,w0,w1,w2,w3);
endmodule

module arithmatic(x, y , cin , s, a, b, d , cout);
    input [3:0] x;
    input [3:0] y;
    input cin , a, b;
    input [1:0] s;
    output [3:0] d;
    output cout;

    mux mux1(y[0], ~y[0], a, b, s , w1);
    fulladder fa1(x[0], w1, cin, c1, d[0]);

    mux mux2(y[1], ~y[1], a, b, s , w2);
    fulladder fa2(x[1], w2, c1, c2, d[1]);

    mux mux3(y[2], ~y[2], a, b, s , w3);
    fulladder fa3(x[2], w3, c2, c3, d[2]);

    mux mux4(y[3], ~y[3], a, b, s , w4);
    fulladder fa4(x[3], w4, c3, cout, d[3]);
endmodule

// ========================================================================================================

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
// s => t 
//============================================================================================================

module set_selector(E,t0,t1,t2,t3,R1_read,R2_read,R3_read,DR1_read,DR2_read,AC_read,OUTR_read,Bus_selector);
    input E,t0,t1,t2,t3;
    output reg R1_read,R2_read,R3_read,DR1_read,DR2_read,AC_read,OUTR_read;
    output reg [0:3] Bus_selector;

    always @(*) begin
    if (E == 1)
    begin
        assign R1_read = 0;
        assign R2_read = 0;
        assign R3_read = 1;
        assign DR1_read = 0;
        assign DR2_read = 0;
        assign AC_read = 0;
        assign OUTR_read = 1;
        assign Bus_selector = 4'b0000;
    end
    else if (E == 0)
    begin
        if(t0 == 1)
        begin
            assign R1_read = 1;
            assign R2_read = 0;
            assign R3_read = 0;
            assign DR1_read = 0;
            assign DR2_read = 0;
            assign AC_read = 0;
            assign OUTR_read = 0;
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
            assign OUTR_read = 0;
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
            assign OUTR_read = 0;
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
            assign OUTR_read = 0;
            assign Bus_selector = 4'b0100;
        end
    end
    end

endmodule
//====================================================================================================

module main(E,clk,module_out);
    input E,clk;
    output [0:3] module_out;

    wire [0:1]count;
    wire [0:3]r1,r2,r3,dr1,dr2,R1,R2,R3,DR1,DR2,AC,alu_out,Bus_selector,OUTR;
    wire t0,t1,t2,t3,R1_read,R2_read,R3_read,DR1_read,DR2_read,AC_read,OUTR_read;
    twobitcounter my_counter(E,clk,count);
    decoder my_decoder(count,t0,t1,t2,t3);
    set_selector my_set_selector(E,t0,t1,t2,t3,R1_read,R2_read,R3_read,DR1_read,DR2_read,AC_read,OUTR_read,Bus_selector);

    fourbitregister my_R1(r1,R1_read,clk,R1);
    fourbitregister my_R2(r2,R2_read,clk,R2);
    fourbitregister my_R3(r3,R3_read,clk,R3);
    fourbitregister my_DR1(dr1,DR1_read,clk,DR1);
    fourbitregister my_DR2(dr2,DR2_read,clk,DR2);
    arithmatic my_alu(DR1,DR2,0,2'b00,0,0,alu_out,out);
    fourbitregister my_AC(alu_out,AC_read,clk,AC);
    Bus my_bus(R1,R2,R3,AC,r1,r2,r3,dr1,dr2,OUTR,Bus_selector);
    fourbitregisterjustposedgr my_OUTR(OUTR,OUTR_read,clk,module_out);

endmodule
//============================================

module tb_my_module();
    reg E,clk;
    wire [0:3] module_out;


    main this_module(E,clk,module_out);

    initial begin
        clk=0;
        forever #50 clk = ~clk;  
    end 

    initial begin
        E = 1;
        
        #160;
        E = 0;
        
    end
endmodule
