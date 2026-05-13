`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2026 12:08:03
// Design Name: 
// Module Name: UART
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


module uart_rx (
    input wire clk,          // system clock
    input wire reset,        // reset
    input wire rx,           // serial input line
    output reg [7:0] data,   // received byte
    output reg valid         // high when a byte is received
);

    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;

    reg [1:0] state = IDLE;
    reg [3:0] bit_index;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_index <= 0;
            shift_reg <= 0;
            data <= 0;
            valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    valid <= 0;
                    if (rx == 0) // detect start bit
                        state <= START;
                end
                START: begin
                    state <= DATA;
                    bit_index <= 0;
                end
                DATA: begin
                    shift_reg[bit_index] <= rx; // sample data bits
                    if (bit_index == 7)
                        state <= STOP;
                    else
                        bit_index <= bit_index + 1;
                end
                STOP: begin
                    if (rx == 1) begin // stop bit check
                        data <= shift_reg;
                        valid <= 1;
                    end
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
