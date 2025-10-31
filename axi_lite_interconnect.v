`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2025 11:24:00
// Design Name: 
// Module Name: axi_lite_interconnect
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


module axi_lite_interconnect #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter NUM_SLAVES = 2,
    parameter [ADDR_WIDTH-1:0] SLAVE0_BASE = 32'h0000_0000,
    parameter [ADDR_WIDTH-1:0] SLAVE0_HIGH = 32'h0000_0FFF,
    parameter [ADDR_WIDTH-1:0] SLAVE1_BASE = 32'h0000_1000,
    parameter [ADDR_WIDTH-1:0] SLAVE1_HIGH = 32'h0000_1FFF
)(
    input wire clk,
    input wire reset,

    // Master side AXI-Lite
    input  wire [ADDR_WIDTH-1:0] M_awaddr,
    input  wire                  M_awvalid,
    output wire                  M_awready,

    input  wire [DATA_WIDTH-1:0] M_wdata,
    input  wire [3:0]            M_wstrb,
    input  wire                  M_wvalid,
    output wire                  M_wready,

    output wire [1:0]            M_bresp,
    output wire                  M_bvalid,
    input  wire                  M_bready,

    input  wire [ADDR_WIDTH-1:0] M_araddr,
    input  wire                  M_arvalid,
    output wire                  M_arready,

    output wire [DATA_WIDTH-1:0] M_rdata,
    output wire [1:0]            M_rresp,
    output wire                  M_rvalid,
    input  wire                  M_rready,

    // Slave 0 AXI-Lite
    output wire [ADDR_WIDTH-1:0] S0_awaddr,
    output wire                  S0_awvalid,
    input  wire                  S0_awready,

    output wire [DATA_WIDTH-1:0] S0_wdata,
    output wire [3:0]            S0_wstrb,
    output wire                  S0_wvalid,
    input  wire                  S0_wready,

    input  wire [1:0]            S0_bresp,
    input  wire                  S0_bvalid,
    output wire                  S0_bready,

    output wire [ADDR_WIDTH-1:0] S0_araddr,
    output wire                  S0_arvalid,
    input  wire                  S0_arready,

    input  wire [DATA_WIDTH-1:0] S0_rdata,
    input  wire [1:0]            S0_rresp,
    input  wire                  S0_rvalid,
    output wire                  S0_rready,

    // Slave 1 AXI-Lite
    output wire [ADDR_WIDTH-1:0] S1_awaddr,
    output wire                  S1_awvalid,
    input  wire                  S1_awready,

    output wire [DATA_WIDTH-1:0] S1_wdata,
    output wire [3:0]            S1_wstrb,
    output wire                  S1_wvalid,
    input  wire                  S1_wready,

    input  wire [1:0]            S1_bresp,
    input  wire                  S1_bvalid,
    output wire                  S1_bready,

    output wire [ADDR_WIDTH-1:0] S1_araddr,
    output wire                  S1_arvalid,
    input  wire                  S1_arready,

    input  wire [DATA_WIDTH-1:0] S1_rdata,
    input  wire [1:0]            S1_rresp,
    input  wire                  S1_rvalid,
    output wire                  S1_rready
);

    // Address decoding
    wire sel_slave0_w = (M_awaddr >= SLAVE0_BASE) && (M_awaddr <= SLAVE0_HIGH);
    wire sel_slave1_w = (M_awaddr >= SLAVE1_BASE) && (M_awaddr <= SLAVE1_HIGH);

    wire sel_slave0_r = (M_araddr >= SLAVE0_BASE) && (M_araddr <= SLAVE0_HIGH);
    wire sel_slave1_r = (M_araddr >= SLAVE1_BASE) && (M_araddr <= SLAVE1_HIGH);

    // Write Address Channel Routing
    assign S0_awaddr  = M_awaddr;
    assign S0_awvalid = M_awvalid & sel_slave0_w;
    assign S1_awaddr  = M_awaddr;
    assign S1_awvalid = M_awvalid & sel_slave1_w;
    assign M_awready  = (sel_slave0_w ? S0_awready :
                        (sel_slave1_w ? S1_awready : 1'b0));

    // Write Data Channel Routing
    assign S0_wdata  = M_wdata;
    assign S0_wstrb  = M_wstrb;
    assign S0_wvalid = M_wvalid & sel_slave0_w;

    assign S1_wdata  = M_wdata;
    assign S1_wstrb  = M_wstrb;
    assign S1_wvalid = M_wvalid & sel_slave1_w;

    assign M_wready  = (sel_slave0_w ? S0_wready :
                       (sel_slave1_w ? S1_wready : 1'b0));

    // Write Response Routing
    assign S0_bready = M_bready & sel_slave0_w;
    assign S1_bready = M_bready & sel_slave1_w;

    assign M_bvalid = (sel_slave0_w ? S0_bvalid :
                      (sel_slave1_w ? S1_bvalid : 1'b0));
    assign M_bresp  = (sel_slave0_w ? S0_bresp :
                      (sel_slave1_w ? S1_bresp : 2'b11)); // DECERR for invalid

    // Read Address Channel Routing
    assign S0_araddr  = M_araddr;
    assign S0_arvalid = M_arvalid & sel_slave0_r;
    assign S1_araddr  = M_araddr;
    assign S1_arvalid = M_arvalid & sel_slave1_r;

    assign M_arready  = (sel_slave0_r ? S0_arready :
                        (sel_slave1_r ? S1_arready : 1'b0));

    // Read Data Channel Routing
    assign S0_rready = M_rready & sel_slave0_r;
    assign S1_rready = M_rready & sel_slave1_r;

    assign M_rvalid = (sel_slave0_r ? S0_rvalid :
                      (sel_slave1_r ? S1_rvalid : 1'b0));

    assign M_rresp  = (sel_slave0_r ? S0_rresp :
                      (sel_slave1_r ? S1_rresp : 2'b11)); // DECERR

    assign M_rdata  = (sel_slave0_r ? S0_rdata :
                      (sel_slave1_r ? S1_rdata : 32'hDEAD_DEAD));

endmodule
