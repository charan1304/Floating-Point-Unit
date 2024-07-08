`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2024 14:50:28
// Design Name: 
// Module Name: div
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


module div #(parameter WIDTH=32,
    parameter EXP_WIDTH=8,
    parameter MAN_WIDTH=23,
    parameter BIAS=127
    )
    (
        a,b,clk,quot
    );
    input [WIDTH-1:0]a;
    input [WIDTH-1:0]b;
    input clk;
    output [WIDTH-1:0]quot;
    
    wire [WIDTH-1:0] div;
    
    recip #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS))divisor
    (
        .a(b),
        .r(div),
        .clk(clk)
    );
    
    mult #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS)) quotient
    (
        .a(a),
        .b(div),
        .clk(clk),
        .product(quot)
    );
endmodule
