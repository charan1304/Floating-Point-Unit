`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2024 11:57:22 AM
// Design Name: 
// Module Name: recip
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


module recip #(parameter WIDTH=32,
    parameter EXP_WIDTH=8,
    parameter MAN_WIDTH=23,
    parameter BIAS=127
    )
    (
    a,r,clk
    );
    
    input [WIDTH-1:0]a;
    input clk;
    output [WIDTH-1:0]r;
    
    wire sign,sign_a,check,infinte,fract;
    wire [EXP_WIDTH-1:0]exp,exp_a;
    wire [MAN_WIDTH-1:0]man,man_a;
    wire [MAN_WIDTH:0] x_1,x_2,x_3;
    wire [2*MAN_WIDTH+1:0]man2,prod1,prod2,prod3;
    reg [2*MAN_WIDTH+1:0]x1,x2,x3;
    reg [MAN_WIDTH:0]x0;
    
    assign sign_a=a[WIDTH-1];
    assign man_a=a[MAN_WIDTH-1:0];
    assign exp_a=a[WIDTH-2:MAN_WIDTH];
    
    assign sign=sign_a;
    assign exp=2*BIAS-exp_a-1;
    assign check=|exp_a;
    assign infinite=&exp_a;
    assign fract=&man_a;
    
    assign man2={1'b0,man_a}*{1'b0,man_a};
    assign prod1=x0*{1'b1,man_a};
    assign prod2=x_1*{1'b1,man_a};
    assign prod3=x_2*{1'b1,man_a};
    assign x_1=x1[2*MAN_WIDTH:MAN_WIDTH];
    assign x_2=x2[2*MAN_WIDTH:MAN_WIDTH];
    
    always@(posedge clk)begin
        x0<=(~man_a+1)+{(man2[2*MAN_WIDTH:MAN_WIDTH])>>1};
        x1<=x0*({2'b10,{MAN_WIDTH{1'b0}}}-prod1[2*MAN_WIDTH+1:MAN_WIDTH]);
        x2<=x1*({2'b10,{MAN_WIDTH{1'b0}}}-prod2[2*MAN_WIDTH+1:MAN_WIDTH]);
        x3<=x2*({2'b10,{MAN_WIDTH{1'b0}}}-prod3[2*MAN_WIDTH+1:MAN_WIDTH]);
    end
    
    assign man=fract?x3[2*MAN_WIDTH-2:MAN_WIDTH-1]:{MAN_WIDTH{1'b0}};
    
    assign r=infinite?({sign,{WIDTH-1{1'b0}}}):(check?{sign,exp,man}:{sign,{EXP_WIDTH{1'b1}},{MAN_WIDTH{1'b0}}});

endmodule
