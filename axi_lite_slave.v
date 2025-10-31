`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2025 11:21:05
// Design Name: 
// Module Name: axi_lite_slave
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


module axi_lite_slave #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter BASE_ADDR  = 32'h00000000  // Slave base address
)(
    input wire clk,
    input wire reset,

    // Write Address Channel
    input  wire [ADDR_WIDTH-1:0] awaddr,
    input  wire                  awvalid,
    output reg                   awready,

    // Write Data Channel
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire [3:0]            wstrb,
    input  wire                  wvalid,
    output reg                   wready,

    // Write Response Channel
    output reg [1:0]             bresp,
    output reg                   bvalid,
    input  wire                  bready,

    // Read Address Channel
    input  wire [ADDR_WIDTH-1:0] araddr,
    input  wire                  arvalid,
    output reg                   arready,

    // Read Data Channel
    output reg [DATA_WIDTH-1:0]  rdata,
    output reg [1:0]             rresp,
    output reg                   rvalid,
    input  wire                  rready
);

    // Memory (simple register bank)
    reg [DATA_WIDTH-1:0] mem [0:15];  // 16 registers

    // Internal registers
    reg [ADDR_WIDTH-1:0] wr_addr_reg;
    reg [ADDR_WIDTH-1:0] rd_addr_reg;

    // Write FSM states
    localparam WR_IDLE  = 2'd0;
    localparam WR_DATA  = 2'd1;
    localparam WR_RESP  = 2'd2;

    // Read FSM states
    localparam RD_IDLE  = 2'd0;
    localparam RD_DATA  = 2'd1;

    reg [1:0] wr_state, wr_next;
    reg [1:0] rd_state, rd_next;

    // ========================
    // Write FSM
    // ========================
    always @(posedge clk or posedge reset) begin
        if (reset)
            wr_state <= WR_IDLE;
        else
            wr_state <= wr_next;
    end

    always @(*) begin
        wr_next = wr_state;
        case (wr_state)
            WR_IDLE:
                if (awvalid)
                    wr_next = WR_DATA;
            WR_DATA:
                if (wvalid)
                    wr_next = WR_RESP;
            WR_RESP:
                if (bready)
                    wr_next = WR_IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            awready <= 0;
            wready  <= 0;
            bvalid  <= 0;
            bresp   <= 2'b00;
        end else begin
            awready <= (wr_state == WR_IDLE);
            wready  <= (wr_state == WR_DATA);
            bvalid  <= (wr_state == WR_RESP);
            bresp   <= 2'b00;  // OKAY response
        end
    end

    // Capture write address
    always @(posedge clk) begin
        if (wr_state == WR_IDLE && awvalid)
            wr_addr_reg <= awaddr;
    end

    // Write to memory
    always @(posedge clk) begin
        if (wr_state == WR_DATA && wvalid) begin
            if ((wr_addr_reg - BASE_ADDR) >> 2 < 16) begin
                if (wstrb[0]) mem[(wr_addr_reg - BASE_ADDR) >> 2][7:0]   <= wdata[7:0];
                if (wstrb[1]) mem[(wr_addr_reg - BASE_ADDR) >> 2][15:8]  <= wdata[15:8];
                if (wstrb[2]) mem[(wr_addr_reg - BASE_ADDR) >> 2][23:16] <= wdata[23:16];
                if (wstrb[3]) mem[(wr_addr_reg - BASE_ADDR) >> 2][31:24] <= wdata[31:24];
            end
        end
    end

    // ========================
    // Read FSM
    // ========================
    always @(posedge clk or posedge reset) begin
        if (reset)
            rd_state <= RD_IDLE;
        else
            rd_state <= rd_next;
    end

    always @(*) begin
        rd_next = rd_state;
        case (rd_state)
            RD_IDLE:
                if (arvalid)
                    rd_next = RD_DATA;
            RD_DATA:
                if (rready)
                    rd_next = RD_IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            arready <= 0;
            rvalid  <= 0;
            rresp   <= 2'b00;
        end else begin
            arready <= (rd_state == RD_IDLE);
            rvalid  <= (rd_state == RD_DATA);
            rresp   <= 2'b00; // OKAY
        end
    end

    // Capture read address
    always @(posedge clk) begin
        if (rd_state == RD_IDLE && arvalid)
            rd_addr_reg <= araddr;
    end

    // Read from memory
    always @(posedge clk) begin
        if (rd_state == RD_DATA) begin
            if ((rd_addr_reg - BASE_ADDR) >> 2 < 16)
                rdata <= mem[(rd_addr_reg - BASE_ADDR) >> 2];
            else
                rdata <= 32'hBADADD;
        end
    end

endmodule
