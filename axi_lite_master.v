`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2025 11:12:53
// Design Name: 
// Module Name: axi_lite_master
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


module axi_lite_master #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input wire clk,
    input wire reset,

    // Write Address Channel
    output reg [ADDR_WIDTH-1:0] awaddr,
    output reg                  awvalid,
    input  wire                 awready,

    // Write Data Channel
    output reg [DATA_WIDTH-1:0] wdata,
    output reg [3:0]            wstrb,
    output reg                  wvalid,
    input  wire                 wready,

    // Write Response Channel
    input  wire [1:0]           bresp,
    input  wire                 bvalid,
    output reg                  bready,

    // Read Address Channel
    output reg [ADDR_WIDTH-1:0] araddr,
    output reg                  arvalid,
    input  wire                 arready,

    // Read Data Channel
    input  wire [DATA_WIDTH-1:0] rdata,
    input  wire [1:0]            rresp,
    input  wire                 rvalid,
    output reg                  rready,

    // Done indicator
    output reg done
);

    // State encoding
    localparam STATE_IDLE       = 3'd0;
    localparam STATE_WRITE_ADDR = 3'd1;
    localparam STATE_WRITE_DATA = 3'd2;
    localparam STATE_WRITE_RESP = 3'd3;
    localparam STATE_READ_ADDR  = 3'd4;
    localparam STATE_READ_DATA  = 3'd5;
    localparam STATE_FINISH     = 3'd6;

    reg [2:0] state, next_state;

    // FSM sequential
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= STATE_IDLE;
        else
            state <= next_state;
    end

    // FSM combinational
    always @(*) begin
        next_state = state;
        case (state)
            STATE_IDLE:       next_state = STATE_WRITE_ADDR;
            STATE_WRITE_ADDR: if (awready) next_state = STATE_WRITE_DATA;
            STATE_WRITE_DATA: if (wready)  next_state = STATE_WRITE_RESP;
            STATE_WRITE_RESP: if (bvalid)  next_state = STATE_READ_ADDR;
            STATE_READ_ADDR:  if (arready) next_state = STATE_READ_DATA;
            STATE_READ_DATA:  if (rvalid)  next_state = STATE_FINISH;
            STATE_FINISH:     next_state = STATE_FINISH;
            default:          next_state = STATE_IDLE;
        endcase
    end

    // Signal control logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            awaddr   <= 0;
            awvalid  <= 0;
            wdata    <= 0;
            wstrb    <= 4'b1111;
            wvalid   <= 0;
            bready   <= 0;
            araddr   <= 0;
            arvalid  <= 0;
            rready   <= 0;
            done     <= 0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    awaddr   <= 32'h00000004;        // Write to Slave 0
                    awvalid  <= 1;
                    wdata    <= 32'hDEADBEEF;
                    wstrb    <= 4'b1111;
                    wvalid   <= 1;
                    bready   <= 1;
                    araddr   <= 0;
                    arvalid  <= 0;
                    rready   <= 0;
                    done     <= 0;
                end

                STATE_WRITE_ADDR: begin
                    if (awready) awvalid <= 0;
                end

                STATE_WRITE_DATA: begin
                    if (wready) wvalid <= 0;
                end

                STATE_WRITE_RESP: begin
                    if (bvalid) bready <= 0;
                end

                STATE_READ_ADDR: begin
                    araddr  <= 32'h00001004;         // Read from Slave 1
                    arvalid <= 1;
                    rready  <= 1;
                end

                STATE_READ_DATA: begin
                    if (rvalid) begin
                        arvalid <= 0;
                        rready  <= 0;
                    end
                end

                STATE_FINISH: begin
                    done <= 1;
                end
            endcase
        end
    end

endmodule
