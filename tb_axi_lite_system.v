`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2025 11:32:15
// Design Name: 
// Module Name: tb_axi_lite_system
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


`timescale 1ns / 1ps

module tb_axi_lite_system;

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;

    // Clock & reset
    reg clk;
    reg reset;

    // Master AXI-Lite signals
    wire [ADDR_WIDTH-1:0] M_awaddr;
    wire                  M_awvalid;
    wire                  M_awready;

    wire [DATA_WIDTH-1:0] M_wdata;
    wire [3:0]            M_wstrb;
    wire                  M_wvalid;
    wire                  M_wready;

    wire [1:0]            M_bresp;
    wire                  M_bvalid;
    wire                  M_bready;

    wire [ADDR_WIDTH-1:0] M_araddr;
    wire                  M_arvalid;
    wire                  M_arready;

    wire [DATA_WIDTH-1:0] M_rdata;
    wire [1:0]            M_rresp;
    wire                  M_rvalid;
    wire                  M_rready;

    // Instantiate DUTs
    // Master
    axi_lite_master master_inst (
        .clk(clk),
        .reset(reset),
        .awaddr(M_awaddr),
        .awvalid(M_awvalid),
        .awready(M_awready),
        .wdata(M_wdata),
        .wstrb(M_wstrb),
        .wvalid(M_wvalid),
        .wready(M_wready),
        .bresp(M_bresp),
        .bvalid(M_bvalid),
        .bready(M_bready),
        .araddr(M_araddr),
        .arvalid(M_arvalid),
        .arready(M_arready),
        .rdata(M_rdata),
        .rresp(M_rresp),
        .rvalid(M_rvalid),
        .rready(M_rready)
    );

    // Interconnect
    wire [ADDR_WIDTH-1:0] S0_awaddr, S1_awaddr;
    wire                  S0_awvalid, S1_awvalid;
    wire                  S0_awready, S1_awready;
    wire [DATA_WIDTH-1:0] S0_wdata, S1_wdata;
    wire [3:0]            S0_wstrb, S1_wstrb;
    wire                  S0_wvalid, S1_wvalid;
    wire                  S0_wready, S1_wready;
    wire [1:0]            S0_bresp, S1_bresp;
    wire                  S0_bvalid, S1_bvalid;
    wire                  S0_bready, S1_bready;
    wire [ADDR_WIDTH-1:0] S0_araddr, S1_araddr;
    wire                  S0_arvalid, S1_arvalid;
    wire                  S0_arready, S1_arready;
    wire [DATA_WIDTH-1:0] S0_rdata, S1_rdata;
    wire [1:0]            S0_rresp, S1_rresp;
    wire                  S0_rvalid, S1_rvalid;
    wire                  S0_rready, S1_rready;

    axi_lite_interconnect interconnect_inst (
        .clk(clk),
        .reset(reset),
        .M_awaddr(M_awaddr),
        .M_awvalid(M_awvalid),
        .M_awready(M_awready),
        .M_wdata(M_wdata),
        .M_wstrb(M_wstrb),
        .M_wvalid(M_wvalid),
        .M_wready(M_wready),
        .M_bresp(M_bresp),
        .M_bvalid(M_bvalid),
        .M_bready(M_bready),
        .M_araddr(M_araddr),
        .M_arvalid(M_arvalid),
        .M_arready(M_arready),
        .M_rdata(M_rdata),
        .M_rresp(M_rresp),
        .M_rvalid(M_rvalid),
        .M_rready(M_rready),

        .S0_awaddr(S0_awaddr),
        .S0_awvalid(S0_awvalid),
        .S0_awready(S0_awready),
        .S0_wdata(S0_wdata),
        .S0_wstrb(S0_wstrb),
        .S0_wvalid(S0_wvalid),
        .S0_wready(S0_wready),
        .S0_bresp(S0_bresp),
        .S0_bvalid(S0_bvalid),
        .S0_bready(S0_bready),
        .S0_araddr(S0_araddr),
        .S0_arvalid(S0_arvalid),
        .S0_arready(S0_arready),
        .S0_rdata(S0_rdata),
        .S0_rresp(S0_rresp),
        .S0_rvalid(S0_rvalid),
        .S0_rready(S0_rready),

        .S1_awaddr(S1_awaddr),
        .S1_awvalid(S1_awvalid),
        .S1_awready(S1_awready),
        .S1_wdata(S1_wdata),
        .S1_wstrb(S1_wstrb),
        .S1_wvalid(S1_wvalid),
        .S1_wready(S1_wready),
        .S1_bresp(S1_bresp),
        .S1_bvalid(S1_bvalid),
        .S1_bready(S1_bready),
        .S1_araddr(S1_araddr),
        .S1_arvalid(S1_arvalid),
        .S1_arready(S1_arready),
        .S1_rdata(S1_rdata),
        .S1_rresp(S1_rresp),
        .S1_rvalid(S1_rvalid),
        .S1_rready(S1_rready)
    );

    // Slaves
    axi_lite_slave slave0 (
        .clk(clk),
        .reset(reset),
        .awaddr(S0_awaddr),
        .awvalid(S0_awvalid),
        .awready(S0_awready),
        .wdata(S0_wdata),
        .wstrb(S0_wstrb),
        .wvalid(S0_wvalid),
        .wready(S0_wready),
        .bresp(S0_bresp),
        .bvalid(S0_bvalid),
        .bready(S0_bready),
        .araddr(S0_araddr),
        .arvalid(S0_arvalid),
        .arready(S0_arready),
        .rdata(S0_rdata),
        .rresp(S0_rresp),
        .rvalid(S0_rvalid),
        .rready(S0_rready)
    );

    axi_lite_slave slave1 (
        .clk(clk),
        .reset(reset),
        .awaddr(S1_awaddr),
        .awvalid(S1_awvalid),
        .awready(S1_awready),
        .wdata(S1_wdata),
        .wstrb(S1_wstrb),
        .wvalid(S1_wvalid),
        .wready(S1_wready),
        .bresp(S1_bresp),
        .bvalid(S1_bvalid),
        .bready(S1_bready),
        .araddr(S1_araddr),
        .arvalid(S1_arvalid),
        .arready(S1_arready),
        .rdata(S1_rdata),
        .rresp(S1_rresp),
        .rvalid(S1_rvalid),
        .rready(S1_rready)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset and simulation control
    initial begin
        reset = 1;
        #20;
        reset = 0;

        // Run long enough for master FSM
        #500;

        $finish;
    end

endmodule
