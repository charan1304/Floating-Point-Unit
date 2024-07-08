`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2024 01:58:44 PM
// Design Name: 
// Module Name: mult
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


module mult#(parameter WIDTH=32,
    parameter EXP_WIDTH=8,
    parameter MAN_WIDTH=23,
    parameter BIAS=127
    )
    (
    a,b,product,clk
    );
    
    input [WIDTH-1:0]a;
    input [WIDTH-1:0]b;
    input clk;
    output reg [WIDTH-1:0]product;
    
    wire [EXP_WIDTH-1:0]exp_a,exp_b,exp_prod;
    wire sign_a,sign_b,sign,over;
    wire [2*MAN_WIDTH+1:0]man_prod;
    wire exp_add;
    wire [EXP_WIDTH-1:0]dif;
    wire [MAN_WIDTH-1:0]man,under;
    
    assign sign_a=a[31];
    assign sign_b=b[31];
    assign exp_a=a[30:23];
    assign exp_b=b[30:23];
    assign sign=sign_a^sign_b;
    assign man_prod={(1'b1 & (|exp_a)),a[MAN_WIDTH-1:0]}*{(1'b1 & (|exp_b)),b[MAN_WIDTH-1:0]};
    assign exp_add=man_prod[2*MAN_WIDTH+1];
    assign {over,exp_prod}=exp_a+exp_b+exp_add-BIAS;
    assign man=man_prod[2*MAN_WIDTH+1]?man_prod[2*MAN_WIDTH:MAN_WIDTH+1]:man_prod[2*MAN_WIDTH-1:MAN_WIDTH];
    assign dif=BIAS-exp_a-exp_b+1;
    assign under={{1'b1,man}>>(dif)};
    
    always@(posedge clk)
    begin:assigning
        if(over)begin
            if(exp_a+exp_b<BIAS)
                product<={sign,{EXP_WIDTH{1'b0}},under};
            else
            product<={sign,{EXP_WIDTH{1'b1}},{MAN_WIDTH{1'b0}}};
        end
        else
        begin
            if((a[WIDTH-2:0]==0)||(b[WIDTH-2:0]==0))begin
                product<={sign,{(WIDTH-1){1'b0}}};
            end
            product<={sign,exp_prod,man};
        end
    end
    
endmodule
