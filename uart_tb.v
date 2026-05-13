`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2026 12:09:06
// Design Name: 
// Module Name: uart_tb
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


module tb_uart_rx;
    reg clk, reset, rx;
    wire [7:0] data;
    wire valid;

    // Instantiate DUT
    uart_rx uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data(data),
        .valid(valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units per cycle
    end

    // Task to send UART frame (start + 8 data bits + stop)
    task send_uart_byte(input [7:0] byte);
        integer i;
        begin
            rx = 0; #10; // start bit
            for (i = 0; i < 8; i = i + 1) begin
                rx = byte[i]; #10; // data bits LSB first
            end
            rx = 1; #10; // stop bit
        end
    endtask

    // Stimulus
    initial begin
        reset = 1; rx = 1; #20;
        reset = 0;

        // Send byte 0xA5 (10100101)
        send_uart_byte(8'hA5);

        // Wait and check
        #50;
        if (valid && data == 8'hA5)
            $display("PASS: Received 0x%h correctly", data);
        else
            $display("FAIL: Incorrect reception");

        $stop;
    end
endmodule
