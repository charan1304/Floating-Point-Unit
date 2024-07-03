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

module adder(
    a,b,mode,sum
    );
    parameter WIDTH=32;
    parameter EXP_WIDTH=8;
    parameter MAN_WIDTH=23;
    
    input [WIDTH-1:0]a;
    input [WIDTH-1:0]b;
    input mode;
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
    
    mant_sign num(a,b,mode,sign,m_sum,exp);
    
    assign infinite=(&exp)|(&exp_a)|(&exp_b);
    
    assign sum=infinite?({sign,{EXP_WIDTH{1'b1}},{MAN_WIDTH{1'b0}}}):(zero?{32'd0}:{sign,exp,m_sum});
    
endmodule



module mant_sign(
    a,b,mode,sign,m_sum,exp
    );
    parameter WIDTH=32;
    parameter EXP_WIDTH=8;
    parameter MAN_WIDTH=23;

    input [WIDTH-1:0]a;
    input [WIDTH-1:0]b;
    input mode;
    output reg sign;
    output reg [MAN_WIDTH-1:0]m_sum;
    output reg [EXP_WIDTH-1:0]exp;
        
    wire sign_a,sign_b,compare,sub;
    wire [EXP_WIDTH-1:0]exp_dif;
    wire [MAN_WIDTH:0]m_dif;
    wire [MAN_WIDTH+1:0]sum;
    reg [MAN_WIDTH-1:0]bigm,smallm;
    reg [EXP_WIDTH-1:0]exp_dif1;
    reg [MAN_WIDTH+1:0]shifted;
    
    assign sign_a=a[WIDTH-1];
    assign sign_b=b[WIDTH-1];
    assign sub=(sign_a^sign_b)^mode;
    assign {compare,exp_dif}=a[WIDTH-2:WIDTH-EXP_WIDTH-1]+(~b[WIDTH-2:WIDTH-EXP_WIDTH-1])+1;
    assign m_dif=a[MAN_WIDTH-1:0]+(~b[MAN_WIDTH-1:0])+1;
    
    always@(*)begin
        if(compare) begin
            sign=sign_a;
            bigm=a[MAN_WIDTH-1:0];
            smallm=b[MAN_WIDTH-1:0];
            exp=a[WIDTH-2:WIDTH-EXP_WIDTH-1];
            if(~(|exp_dif))begin
                sign=(m_dif[MAN_WIDTH])?sign_a:sign_b;
                bigm=(m_dif[MAN_WIDTH])?a[MAN_WIDTH-1:0]:b[MAN_WIDTH-1:0];
                smallm=(m_dif[MAN_WIDTH])?b[MAN_WIDTH-1:0]:a[MAN_WIDTH-1:0];
                exp=(m_dif[MAN_WIDTH])?a[WIDTH-2:WIDTH-EXP_WIDTH-1]:b[WIDTH-2:WIDTH-EXP_WIDTH-1];
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
        if(sum[MAN_WIDTH+1])begin
            exp=exp+1;
            m_sum=sum[MAN_WIDTH:1];
        end
        else begin
            m_sum=sum;
            while(~m_sum[MAN_WIDTH-1])begin
                m_sum=m_sum<<1;
                exp=exp-1;
            end
        end
    end

endmodule