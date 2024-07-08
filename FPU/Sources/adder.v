`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 09:45:54 AM
// Design Name: 
// Module Name: adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module adder#(parameter WIDTH=32,
    parameter EXP_WIDTH=8,
    parameter MAN_WIDTH=23,
    parameter BIAS=127
    )
    (
    a,b,mode,sum,clk
    );
    
    input [WIDTH-1:0]a;
    input [WIDTH-1:0]b;
    input mode;
    input clk;
    output [WIDTH-1:0]sum;
    
    wire [EXP_WIDTH-1:0]exp_a,exp_b,exp;
    wire [MAN_WIDTH-1:0]ma,mb,m_sum;
    wire sign,infinite;
    reg zero;
    
    assign exp_a=a[WIDTH-2:WIDTH-EXP_WIDTH-1];
    assign exp_b=b[WIDTH-2:WIDTH-EXP_WIDTH-1];
    assign ma=a[MAN_WIDTH-1:0];
    assign mb=b[MAN_WIDTH-1:0];
    always@(*)begin
        if(a[WIDTH-1]^b[WIDTH-1]^mode)
            zero=~(|((exp_a^exp_b)&(ma^mb)));
        else
            zero=0;
    end
    
    mant_sign #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS))num
    (
        a,b,mode,clk,sign,m_sum,exp
    );
    
    assign infinite=(&exp)|(&exp_a)|(&exp_b);
    
    assign sum=infinite?({sign,{EXP_WIDTH{1'b1}},{MAN_WIDTH{1'b0}}}):(zero?{32'd0}:{sign,exp,m_sum});
    
endmodule



module mant_sign#(parameter WIDTH=32,
    parameter EXP_WIDTH=8,
    parameter MAN_WIDTH=23,
    parameter BIAS=127
    )
    (
    a,b,mode,clk,sign,m_sum,exp
    );

    input [WIDTH-1:0]a;
    input [WIDTH-1:0]b;
    input mode;
    input clk;
    output reg sign;
    output reg [MAN_WIDTH-1:0]m_sum;
    output reg [EXP_WIDTH-1:0]exp;
        
    wire sign_a,sign_b,compare,sub;
    wire [EXP_WIDTH-1:0]exp_dif;
    wire [MAN_WIDTH:0]m_dif;
    wire [MAN_WIDTH+1:0]sum;
    reg [MAN_WIDTH-1:0]bigm,smallm,m_sum1;
    reg [EXP_WIDTH-1:0]exp_dif1,exp1,exp_add,exp_sub;
    reg [MAN_WIDTH+1:0]shifted;
    
    assign sign_a=a[WIDTH-1];
    assign sign_b=b[WIDTH-1];
    assign sub=(sign_a^sign_b)^mode;
    assign {compare,exp_dif}=a[WIDTH-2:WIDTH-EXP_WIDTH-1]+(~b[WIDTH-2:WIDTH-EXP_WIDTH-1])+1;
    assign m_dif=a[MAN_WIDTH-1:0]+(~b[MAN_WIDTH-1:0])+1;
    
    always@(*)begin
        if(compare) begin
            if(~(|exp_dif))begin
                sign=(m_dif[MAN_WIDTH])?sign_a:sign_b;
                bigm=(m_dif[MAN_WIDTH])?a[MAN_WIDTH-1:0]:b[MAN_WIDTH-1:0];
                smallm=(m_dif[MAN_WIDTH])?b[MAN_WIDTH-1:0]:a[MAN_WIDTH-1:0];
                exp1=(m_dif[MAN_WIDTH])?a[WIDTH-2:WIDTH-EXP_WIDTH-1]:b[WIDTH-2:WIDTH-EXP_WIDTH-1];
            end
            else begin
                sign=sign_a;
                bigm=a[MAN_WIDTH-1:0];
                smallm=b[MAN_WIDTH-1:0];
                exp1=a[WIDTH-2:WIDTH-EXP_WIDTH-1];
            end
            exp_dif1=exp_dif;
        end
        else begin
                sign=sign_b;
                bigm=b[MAN_WIDTH-1:0];
                smallm=a[MAN_WIDTH-1:0];
                exp_dif1=(~exp_dif)+1;
        end
    end
    always@(*)begin
        shifted={1'b1,smallm}>>exp_dif1;
    end
    
    assign sum=sub?({1'b1,bigm}-shifted):({1'b1,bigm}+shifted);
    
    always@(*)begin
        casez(sum)
            25'b1????????????????????????:begin
                exp_add=1;
                exp_sub=0;
            end
            25'b01???????????????????????:begin
                exp_add=0;
                exp_sub=0;
            end
            25'b001??????????????????????:begin
                exp_add=0;
                exp_sub=1;
            end
            25'b0001?????????????????????:begin
                exp_add=0;
                exp_sub=2;
            end
            25'b00001?????????????????????:begin
                exp_add=0;
                exp_sub=3;
            end
            25'b000001???????????????????:begin
                exp_add=0;
                exp_sub=4;
            end
            25'b0000001??????????????????:begin
                exp_add=0;
                exp_sub=5;
            end
            25'b00000001?????????????????:begin
                exp_add=0;
                exp_sub=6;
            end
            25'b000000001????????????????:begin
                exp_add=0;
                exp_sub=7;
            end
            25'b0000000001???????????????:begin
                exp_add=0;
                exp_sub=8;
            end
            25'b00000000001??????????????:begin
                exp_add=0;
                exp_sub=9;
            end
            25'b000000000001?????????????:begin
                exp_add=0;
                exp_sub=10;
            end
            25'b0000000000001????????????:begin
                exp_add=0;
                exp_sub=11;
            end
            25'b00000000000001????????????:begin
                exp_add=0;
                exp_sub=12;
            end
            25'b000000000000001???????????:begin
                exp_add=0;
                exp_sub=13;
            end
            25'b0000000000000001?????????:begin
                exp_add=0;
                exp_sub=14;
            end
            25'b00000000000000001????????:begin
                exp_add=0;
                exp_sub=15;
            end
            25'b000000000000000001???????:begin
                exp_add=0;
                exp_sub=16;
            end
            25'b0000000000000000001??????:begin
                exp_add=0;
                exp_sub=17;
            end
            25'b00000000000000000001?????:begin
                exp_add=0;
                exp_sub=18;
            end
            25'b000000000000000000001????:begin
                exp_add=0;
                exp_sub=19;
            end
            25'b0000000000000000000001???:begin
                exp_add=0;
                exp_sub=20;
            end
            25'b00000000000000000000001??:begin
                exp_add=0;
                exp_sub=21;
            end
            25'b000000000000000000000001?:begin
                exp_add=0;
                exp_sub=22;
            end
            25'b0000000000000000000000001:begin
                exp_add=0;
                exp_sub=23;
            end
            
        endcase
    end
    
    always@(posedge clk)begin
        m_sum<=m_sum1;
        exp<=exp1+exp_add-exp_sub;
    end

endmodule