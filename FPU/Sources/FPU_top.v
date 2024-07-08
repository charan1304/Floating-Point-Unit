`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2024 14:34:02
// Design Name: 
// Module Name: FPU_top
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


module FPU_top #(parameter WIDTH=32,
    parameter EXP_WIDTH=8,
    parameter MAN_WIDTH=23,
    parameter BIAS=127,
    parameter MODE=0
    )
    (
    a,b,clk,result,mode
    );
    
    input [WIDTH-1:0]a;
    input [WIDTH-1:0]b;
    input clk;
    input [2:0]mode;
    output reg [WIDTH-1:0]result;
    
    wire [WIDTH-1:0] sum,dif,comp_mag,compare,product,reciprocal,quotient;
    
    
    adder #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS)) adding
    (
    .a(a),
    .b(b),
    .mode(0),
    .sum(sum),
    .clk(clk)
    );
    
    
    adder #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS)) subtracting
    (
    .a(a),
    .b(b),
    .mode(1),
    .sum(dif),
    .clk(clk)
    );
    
    comp #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS)) comparing_magnitudes
    (
    .a(a),
    .b(b),
    .mode(0),
    .comp(comp_mag[1:0]),
    .clk(clk)
    );
    
    comp #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS)) comparing
    (
    .a(a),
    .b(b),
    .mode(1),
    .comp(compare[1:0]),
    .clk(clk)
    );
    
    mult #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS)) multiplying
    (
        .a(a),
        .b(b),
        .clk(clk),
        .product(product)
    );
    
    recip #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS)) recip
    (
        .a(a),
        .r(reciprocal),
        .clk(clk)
    );
    
    div #(.WIDTH(WIDTH),.EXP_WIDTH(EXP_WIDTH),.MAN_WIDTH(MAN_WIDTH),.BIAS(BIAS)) division
    (
        .a(a),
        .b(b),
        .clk(clk),
        .quot(quotient)
    );
    
    //MUX for choosing operation
    always@(*)begin
    case(mode)
        3'd0:result=sum;
        3'd1:result=dif;
        //fixed point representation of the comparision result
        3'd2:result={{WIDTH-2{1'b0}},comp_mag[1:0]};
        //floating point representation of the comparision result
        //3'd2:result={ comp_mag[1],{ 1'b0,{(EXP_WIDTH-1){1'b1}} }&{ EXP_WIDTH{comp_mag[0]} },{ MAN_WIDTH{1'b0} }};
        //fixed point representation of the comparision result
        3'd3:result={{WIDTH-2{1'b0}},compare[1:0]};
        //floating point representation of the comparision result
        //3'd3:result={ compare[1],{ 1'b0,{(EXP_WIDTH-1){1'b1}} }&{ EXP_WIDTH{compare[0]} },{ MAN_WIDTH{1'b0} }};
        3'd4:result=product;
        3'd5:result=reciprocal;
        3'd6:result=quotient;
        default:result=result;
    endcase
    end
            
endmodule
