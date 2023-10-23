module Master (
    //----- Global -----//
    input         m_aclk       ,
    input         m_aresetn    ,
    //----- Write adress -----//
    output [3:0]  m_axi_awid   ,
    output [31:0] m_axi_awaddr ,
    output [7:0]  m_axi_awlen  ,
    output [2:0]  m_axi_awsize ,
    output [1:0]  m_axi_awburst,
    output        m_axi_awvalid,
    input         m_axi_awready,
    //----- Write data -----//
    output [31:0] m_axi_wdata  ,
    output [3:0]  m_axi_wstrb  ,
    output        m_axi_wlast  ,
    output        m_axi_wvalid ,
    input         m_axi_wready ,
    //----- Write response -----//
    input  [3:0]  m_axi_bid    ,
    input  [1:0]  m_axi_bresp  ,
    input         m_axi_bvalid ,
    output        m_axi_bready ,
    //----- Read address -----//
    output [3:0]  m_axi_arid   ,
    output [31:0] m_axi_araddr ,
    output [7:0]  m_axi_arlen  ,
    output [2:0]  m_axi_arsize ,
    output [1:0]  m_axi_arburst,
    output        m_axi_arvalid,
    input         m_axi_arready,
    //----- Read data -----//
    input  [3:0]  m_axi_rid    ,
    input  [31:0] m_axi_rdata  ,
    input  [1:0]  m_axi_rresp  ,
    input         m_axi_rlast  ,
    input         m_axi_rvalid ,
    output        m_axi_rready ,
    //----- Control signals -----//
    input         write_en     ,
    input         read_en      ,
    input  [31:0] awaddr_ctrl  ,
    input  [7:0]  awlen_ctrl   ,
    input  [2:0]  awsize_ctrl  ,
    input  [1:0]  awburst_ctrl ,
    input  [31:0] araddr_ctrl  ,
    input  [7:0]  arlen_ctrl   ,
    input  [2:0]  arsize_ctrl  ,
    input  [1:0]  arburst_ctrl ,
    //----- Data output -----//
    output [31:0] data_o        
);
//----- FSM -----//
// FSM
localparam IDLE         = 4'b0000;
localparam W_ADDR       = 4'b0001;
localparam W_ADDR_VALID = 4'b0010;
localparam W_DATA       = 4'b0011;
localparam W_VALID      = 4'b0100;
localparam R_START      = 4'b0101;
localparam R_VALID      = 4'b0110;
localparam R_DATA       = 4'b0111;
localparam STOP         = 4'b1000;
reg [3:0] CURRENT_STATE;
reg [3:0] NEXT_STATE   ;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        CURRENT_STATE <= IDLE;
    else
        CURRENT_STATE <= NEXT_STATE;
end
always @(*) begin
    case (CURRENT_STATE)
        IDLE : begin
            if (write_en)
                NEXT_STATE = W_ADDR;
            else if (read_en)
                NEXT_STATE = R_START;
            else
                NEXT_STATE = IDLE;
        end
        W_ADDR : begin
            NEXT_STATE = W_ADDR_VALID;
        end
        W_ADDR_VALID : begin
            if (m_axi_awvalid && m_axi_awready)
                NEXT_STATE = W_DATA;
            else
                NEXT_STATE = W_ADDR_VALID;
        end
        W_DATA : begin
            if (m_axi_wlast && m_axi_wvalid && m_axi_wready)
                NEXT_STATE = STOP;
            else
                NEXT_STATE = W_DATA;
        end
        R_START : begin
            NEXT_STATE = R_VALID;
        end
        R_VALID : begin
            if (m_axi_arvalid && m_axi_arready)
                NEXT_STATE = R_DATA;
            else
                NEXT_STATE = R_VALID; 
        end
        R_DATA : begin
            if (m_axi_rvalid && m_axi_rready)
                NEXT_STATE = STOP;
            else
                NEXT_STATE = R_DATA; 
        end
        STOP : begin
            NEXT_STATE = IDLE;
        end
        default : begin
            NEXT_STATE = IDLE;
        end 
    endcase
end
//----- function -----//
function [31:0] CALCULATE_NEXT_ADDR;
input [31:0] axaddr   ;
input [7:0]  axlen    ;
input [2:0]  axsize   ;
input [1:0]  axburst  ;
reg   [31:0] mask     ;
reg   [7:0]  cnt_bytes;
begin
    mask = 32'd0;
    case (axsize)
        3'b000  : cnt_bytes = 8'd1  ;
        3'b001  : cnt_bytes = 8'd2  ;
        3'b010  : cnt_bytes = 8'd4  ;
        3'b011  : cnt_bytes = 8'd8  ;
        3'b100  : cnt_bytes = 8'd16 ;
        3'b101  : cnt_bytes = 8'd32 ;
        3'b110  : cnt_bytes = 8'd64 ;
        3'b111  : cnt_bytes = 8'd128;
        default : cnt_bytes = 8'd32 ;
    endcase
    case (axburst)
        // FIXED
        2'b00 : begin
            CALCULATE_NEXT_ADDR = axaddr;
        end
        // INCR
        2'b01 : begin
            CALCULATE_NEXT_ADDR = axaddr + cnt_bytes;
        end
        // WRAP
        2'b10 : begin
            case (axlen)
                8'd0    : mask = 32'h03;
                8'd1    : mask = 32'h07;
                8'd3    : mask = 32'h0f;
                8'd7    : mask = 32'h1f;
                8'd15   : mask = 32'h3f;
                default : mask = 32'h3f;
            endcase
            CALCULATE_NEXT_ADDR = (axaddr & ~mask) | ((axaddr + cnt_bytes) & mask);
        end
        // Default is INCR
        default : begin
            CALCULATE_NEXT_ADDR = axaddr + cnt_bytes;
        end
    endcase
end
endfunction
//----- Write address -----//
// AWID
reg [3:0] awid_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        awid_r <= 4'b0000;
    else
        awid_r <= 4'b1000;
end
assign m_axi_awid = awid_r;
// AWADDR
reg [31:0] awaddr_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        awaddr_r <= 32'd0;
    else if ((CURRENT_STATE == W_ADDR) || (CURRENT_STATE == W_ADDR_VALID))
        awaddr_r <= CALCULATE_NEXT_ADDR(awaddr_ctrl, awlen_ctrl, awsize_ctrl, awburst_ctrl);
    else
        awaddr_r <= awaddr_r;
end
assign m_axi_awaddr = awaddr_r;
// AWLEN
reg [7:0] awlen_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        awlen_r <= 8'd0;
    else if ((CURRENT_STATE == W_ADDR) || (CURRENT_STATE == W_ADDR_VALID))
        awlen_r <= awlen_ctrl;
    else
        awlen_r <= awlen_r;
end
assign m_axi_awlen = awlen_r;
// AWSIZE
reg [2:0] awsize_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        awsize_r <= 3'd0;
    else if ((CURRENT_STATE == W_ADDR) || (CURRENT_STATE == W_ADDR_VALID))
        awsize_r <= awsize_ctrl;
    else
        awsize_r <= awsize_r;
end
assign m_axi_awsize = awsize_r;
// AWBURST
reg [1:0] awburst_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        awburst_r <= 2'd0;
    else if ((CURRENT_STATE == W_ADDR) || (CURRENT_STATE == W_ADDR_VALID))
        awburst_r <= awburst_ctrl;
    else
        awburst_r <= awburst_r;
end
assign m_axi_awburst = awburst_r;
// AWVALID
reg awvalid_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        awvalid_r <= 1'b0;
    else if (CURRENT_STATE == W_ADDR_VALID)
        awvalid_r <= 1'b1;
    else if (m_axi_awready && m_axi_awvalid)
        awvalid_r <= 1'b0;
    else
        awvalid_r <= 1'b0;
end
assign m_axi_awvalid = awvalid_r;
//----- Write data -----//
// WDATA
reg [31:0] wdata_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        wdata_r <= 32'd0;
    else if (CURRENT_STATE == W_DATA)
        if (m_axi_wvalid && m_axi_wready)
            if (m_axi_wlast)
                wdata_r <= 32'd0;
            else
                wdata_r <= wdata_r + 1'b1;
        else
            wdata_r <= wdata_r;
    else
        wdata_r <= 32'd0;
end
assign m_axi_wdata = wdata_r;
// WSTRB
reg [3:0] wstrb_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        wstrb_r <= 4'b0000;
    else if (CURRENT_STATE == W_DATA)
        wstrb_r <= 4'b1111;
    else
        wstrb_r <= 4'b0000;
end
assign m_axi_wstrb = wstrb_r;
// WLAST
reg       wlast_r  ;
reg [7:0] cnt_axlen;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        cnt_axlen <= 8'd0;
    else if (CURRENT_STATE == W_DATA)
        if (m_axi_wvalid && m_axi_wready)
            cnt_axlen <= cnt_axlen + 8'd1;
        else
            cnt_axlen <= cnt_axlen;
    else
        cnt_axlen <= 8'd0;
end
always @(*) begin
    if (CURRENT_STATE == W_DATA && (cnt_axlen == awlen_r))
        wlast_r <= 1'b1;
    else
        wlast_r <= 1'b0;
end
assign m_axi_wlast = wlast_r;
// WVALID
reg wvalid_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        wvalid_r <= 1'b0;
    else if (CURRENT_STATE == W_DATA)
        wvalid_r <= 1'b1;
    else
        wvalid_r <= wvalid_r;
end
assign m_axi_wvalid = wvalid_r;
//----- Write response -----//
reg bready_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        bready_r <= 1'b0;
    else if (CURRENT_STATE == W_DATA)
        bready_r <= 1'b1;
    else
        bready_r <= bready_r;
end
assign m_axi_bready = bready_r;
//----- Read address -----//
// ARID
reg [3:0] arid_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        arid_r <= 4'b0000;
    else
        arid_r <= 4'b1000;
end
assign m_axi_arid = arid_r;
// ARADDR
reg [31:0] araddr_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        araddr_r <= 32'd0;
    else if (CURRENT_STATE == R_DATA || CURRENT_STATE == R_VALID)
        araddr_r <= CALCULATE_NEXT_ADDR(araddr_ctrl, arlen_ctrl, arsize_ctrl, arburst_ctrl);
    else
        araddr_r <= araddr_r;
end
assign m_axi_araddr = araddr_r;
// ARLEN
reg [7:0] arlen_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        arlen_r <= 8'd0;
    else if (CURRENT_STATE == R_DATA || CURRENT_STATE == R_VALID)
        arlen_r <= arlen_ctrl;
    else
        arlen_r <= arlen_r;
end
assign m_axi_arlen = arlen_r;
// ARSIZE
reg [2:0] arsize_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        arsize_r <= 3'd0;
    else if (CURRENT_STATE == R_DATA || CURRENT_STATE == R_VALID)
        arsize_r <= arsize_ctrl;
    else
        arsize_r <= arsize_r;
end
assign m_axi_arsize = arsize_r;
// ARBURST
reg [1:0] arburst_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        arburst_r <= 2'd0;
    else if (CURRENT_STATE == R_DATA || CURRENT_STATE == R_VALID)
        arburst_r <= arburst_ctrl;
    else
        arburst_r <= arburst_r;
end
assign m_axi_arburst = arburst_r;
// ARVALID
reg arvalid_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        arvalid_r <= 1'b0;
    else if (CURRENT_STATE == R_VALID)
        arvalid_r <= 1'b1;
    else
        arvalid_r <= arvalid_r;
end
assign m_axi_arvalid = arvalid_r;
//----- Read data -----//
// RREADY
reg rready_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        rready_r <= 1'b0;
    else if (read_en)
        rready_r <= 1'b1;
    else if (m_axi_rlast)
        rready_r <= 1'b0;
    else
        rready_r <= rready_r;
end
assign m_axi_rready = rready_r;
//----- Data output -----//
reg [31:0] data_o_r;
always @(posedge m_aclk or negedge m_aresetn) begin
    if (!m_aresetn)
        data_o_r <= 32'd0;
    else if (rready_r && m_axi_arvalid)
        data_o_r <= m_axi_rdata;
    else
        data_o_r <= 32'd0;
end
assign data_o = data_o_r;
endmodule