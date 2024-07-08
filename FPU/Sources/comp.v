`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2024 14:50:28
// Design Name: 
// Module Name: comp
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


module comp #(parameter WIDTH=32,
    parameter EXP_WIDTH=8,
    parameter MAN_WIDTH=23,
    parameter BIAS=127
    )
    (
    a,b,clk,mode,comp
    );
    //1 if a is greater, 0 if equal, -1 if a is lesser
    input [WIDTH-1:0]a;
    input [WIDTH-1:0]b;
    input clk;
    input mode;
    output reg [1:0] comp;//comp==2'b01 means a>b,comp==2'b00 means a=b,comp==2'b11 means a<b
    always@(posedge clk)begin
        if(mode==0)begin
            if(a[WIDTH-1:MAN_WIDTH]>b[WIDTH-1:MAN_WIDTH])
                comp<=2'b01;
            else if(a[WIDTH-1:MAN_WIDTH]==b[WIDTH-1:MAN_WIDTH]) begin
                if (a[MAN_WIDTH-1:0]>b[MAN_WIDTH-1:0])
                    comp<=2'b01;
                else if (a[MAN_WIDTH-1:0]<b[MAN_WIDTH-1:0])
                    comp<=2'b11;
                else
                    comp<=2'b00;
            end
            else
                comp<=2'b11;
        end
        if(mode==1)begin
            if(a[WIDTH-1]^b[WIDTH-1])begin
                if(a[WIDTH-1])
                    comp<=2'b11;
                else
                    comp<=2'b01;
            end
            else begin
                if(a[WIDTH-1:MAN_WIDTH]>b[WIDTH-1:MAN_WIDTH])
                    comp<={a[WIDTH-1],1'b1};
                else if(a[WIDTH-1:MAN_WIDTH]==b[WIDTH-1:MAN_WIDTH]) begin
                    if (a[MAN_WIDTH-1:0]>b[MAN_WIDTH-1:0])
                        comp<={a[WIDTH-1],1'b1};
                    else if (a[MAN_WIDTH-1:0]<b[MAN_WIDTH-1:0])
                        comp<={~a[WIDTH-1],1'b1};
                    else
                        comp<=2'b00;
                end
                else
                    comp<={~a[WIDTH-1],1'b1};
            end
        end
    end
endmodule
