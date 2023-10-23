module Slave_Mux_W (
    //----- Global -----//
    input         aclk          ,
    input         aresetn       ,
    //----- Slave 0 -----//
    // Write adress
    output [3:0]  s0_axi_awid   ,
    output [31:0] s0_axi_awaddr ,
    output [7:0]  s0_axi_awlen  ,
    output [2:0]  s0_axi_awsize ,
    output [1:0]  s0_axi_awburst,
    output        s0_axi_awvalid,
    input         s0_axi_awready,
    // Write data
    output [31:0] s0_axi_wdata  ,
    output [3:0]  s0_axi_wstrb  ,
    output        s0_axi_wlast  ,
    output        s0_axi_wvalid ,
    input         s0_axi_wready ,
    // Write response
    input  [3:0]  s0_axi_bid    ,
    input  [1:0]  s0_axi_bresp  ,
    input         s0_axi_bvalid ,
    output        s0_axi_bready ,
    //----- Slave 1 -----//
    // Write adress
    output [3:0]  s1_axi_awid   ,
    output [31:0] s1_axi_awaddr ,
    output [7:0]  s1_axi_awlen  ,
    output [2:0]  s1_axi_awsize ,
    output [1:0]  s1_axi_awburst,
    output        s1_axi_awvalid,
    input         s1_axi_awready,
    // Write data
    output [31:0] s1_axi_wdata  ,
    output [3:0]  s1_axi_wstrb  ,
    output        s1_axi_wlast  ,
    output        s1_axi_wvalid ,
    input         s1_axi_wready ,
    // Write response
    input  [3:0]  s1_axi_bid    ,
    input  [1:0]  s1_axi_bresp  ,
    input         s1_axi_bvalid ,
    output        s1_axi_bready ,
    //----- Slave 2 -----//
    // Write adress
    output [3:0]  s2_axi_awid   ,
    output [31:0] s2_axi_awaddr ,
    output [7:0]  s2_axi_awlen  ,
    output [2:0]  s2_axi_awsize ,
    output [1:0]  s2_axi_awburst,
    output        s2_axi_awvalid,
    input         s2_axi_awready,
    // Write data
    output [31:0] s2_axi_wdata  ,
    output [3:0]  s2_axi_wstrb  ,
    output        s2_axi_wlast  ,
    output        s2_axi_wvalid ,
    input         s2_axi_wready ,
    // Write response
    input  [3:0]  s2_axi_bid    ,
    input  [1:0]  s2_axi_bresp  ,
    input         s2_axi_bvalid ,
    output        s2_axi_bready ,
    //----- Slave 3 -----//
    // Write adress
    output [3:0]  s3_axi_awid   ,
    output [31:0] s3_axi_awaddr ,
    output [7:0]  s3_axi_awlen  ,
    output [2:0]  s3_axi_awsize ,
    output [1:0]  s3_axi_awburst,
    output        s3_axi_awvalid,
    input         s3_axi_awready,
    // Write data
    output [31:0] s3_axi_wdata  ,
    output [3:0]  s3_axi_wstrb  ,
    output        s3_axi_wlast  ,
    output        s3_axi_wvalid ,
    input         s3_axi_wready ,
    // Write response
    input  [3:0]  s3_axi_bid    ,
    input  [1:0]  s3_axi_bresp  ,
    input         s3_axi_bvalid ,
    output        s3_axi_bready ,
    //----- Master general -----//
    // Write adress
    output        m_awready     ,
    // Write data
    output        m_wready      ,
    // Write response
    output [3:0]  m_bid         ,
    output [1:0]  m_bresp       ,
    output        m_bvalid      ,
    //----- Slave general -----//
    // Write adress
    input  [3:0]  s_awid        ,
    input  [31:0] s_awaddr      ,
    input  [7:0]  s_awlen       ,
    input  [2:0]  s_awsize      ,
    input  [1:0]  s_awburst     ,
    input         s_awvalid     ,
    // Write data
    input  [31:0] s_wdata       ,
    input  [3:0]  s_wstrb       ,
    input         s_wlast       ,
    input         s_wvalid      ,
    // Write response
    input         s_bready      
);
//----- ID register -----//
reg [3:0] s_awid_r;
always @(posedge aclk or negedge aresetn) begin
    if (!aresetn)
        s_awid_r = 4'b0000;
    else
        s_awid_r = s_awid;
end
//----- Other signals -----//
reg       m_awready_r;
reg       m_wready_r ;
reg [3:0] m_bid_r    ;
reg [1:0] m_bresp_r  ;
reg       m_bvalid_r ;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            m_awready_r = s0_axi_awready;
            m_wready_r  = s0_axi_wready ;
            m_bid_r     = s0_axi_bid    ;
            m_bresp_r   = s0_axi_bresp  ;
            m_bvalid_r  = s0_axi_bvalid ;
        end
        4'b0100 : begin
            m_awready_r = s1_axi_awready;
            m_wready_r  = s1_axi_wready ;
            m_bid_r     = s1_axi_bid    ;
            m_bresp_r   = s1_axi_bresp  ;
            m_bvalid_r  = s1_axi_bvalid ;
        end
        4'b0010 : begin
            m_awready_r = s2_axi_awready;
            m_wready_r  = s2_axi_wready ;
            m_bid_r     = s2_axi_bid    ;
            m_bresp_r   = s2_axi_bresp  ;
            m_bvalid_r  = s2_axi_bvalid ;
        end
        4'b0001 : begin
            m_awready_r = s3_axi_awready;
            m_wready_r  = s3_axi_wready ;
            m_bid_r     = s3_axi_bid    ;
            m_bresp_r   = s3_axi_bresp  ;
            m_bvalid_r  = s3_axi_bvalid ;
        end
        default : begin
            m_awready_r = 1'b0;
            m_wready_r  = 1'b0;
            m_bid_r     = 4'd0;
            m_bresp_r   = 2'd0;
            m_bvalid_r  = 1'b0;
        end
    endcase
end
assign m_awready = m_awready_r;
assign m_wready  = m_wready_r ;
assign m_bid     = m_bid_r    ;
assign m_bresp   = m_bresp_r  ;
assign m_bvalid  = m_bvalid_r ;
//----- AWID -----//
reg [3:0] s0_axi_awid_r;
reg [3:0] s1_axi_awid_r;
reg [3:0] s2_axi_awid_r;
reg [3:0] s3_axi_awid_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_awid_r = s_awid;
            s1_axi_awid_r = 4'd0;
            s2_axi_awid_r = 4'd0;
            s3_axi_awid_r = 4'd0;
        end
        4'b0100 : begin
            s0_axi_awid_r = 4'd0;
            s1_axi_awid_r = s_awid;
            s2_axi_awid_r = 4'd0;
            s3_axi_awid_r = 4'd0;
        end
        4'b0010 : begin
            s0_axi_awid_r = 4'd0;
            s1_axi_awid_r = 4'd0;
            s2_axi_awid_r = s_awid;
            s3_axi_awid_r = 4'd0;
        end
        4'b0001 : begin
            s0_axi_awid_r = 4'd0;
            s1_axi_awid_r = 4'd0;
            s2_axi_awid_r = 4'd0;
            s3_axi_awid_r = s_awid;
        end
        default : begin
            s0_axi_awid_r = 4'd0;
            s1_axi_awid_r = 4'd0;
            s2_axi_awid_r = 4'd0;
            s3_axi_awid_r = 4'd0;
        end
    endcase
end
assign s0_axi_awid = s0_axi_awid_r;
assign s1_axi_awid = s1_axi_awid_r;
assign s2_axi_awid = s2_axi_awid_r;
assign s3_axi_awid = s3_axi_awid_r;
//----- AWADDR -----//
reg [31:0] s0_axi_awaddr_r;
reg [31:0] s1_axi_awaddr_r;
reg [31:0] s2_axi_awaddr_r;
reg [31:0] s3_axi_awaddr_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_awaddr_r = s_awaddr;
            s1_axi_awaddr_r = 32'd0;
            s2_axi_awaddr_r = 32'd0;
            s3_axi_awaddr_r = 32'd0;
        end
        4'b0100 : begin
            s0_axi_awaddr_r = 32'd0;
            s1_axi_awaddr_r = s_awaddr;
            s2_axi_awaddr_r = 32'd0;
            s3_axi_awaddr_r = 32'd0;
        end
        4'b0010 : begin
            s0_axi_awaddr_r = 32'd0;
            s1_axi_awaddr_r = 32'd0;
            s2_axi_awaddr_r = s_awaddr;
            s3_axi_awaddr_r = 32'd0;
        end
        4'b0001 : begin
            s0_axi_awaddr_r = 32'd0;
            s1_axi_awaddr_r = 32'd0;
            s2_axi_awaddr_r = 32'd0;
            s3_axi_awaddr_r = s_awaddr;
        end
        default : begin
            s0_axi_awaddr_r = 32'd0;
            s1_axi_awaddr_r = 32'd0;
            s2_axi_awaddr_r = 32'd0;
            s3_axi_awaddr_r = 32'd0;
        end
    endcase
end
assign s0_axi_awaddr = s0_axi_awaddr_r;
assign s1_axi_awaddr = s1_axi_awaddr_r;
assign s2_axi_awaddr = s2_axi_awaddr_r;
assign s3_axi_awaddr = s3_axi_awaddr_r;
//----- AWLEN -----//
reg [7:0] s0_axi_awlen_r;
reg [7:0] s1_axi_awlen_r;
reg [7:0] s2_axi_awlen_r;
reg [7:0] s3_axi_awlen_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_awlen_r = s_awlen;
            s1_axi_awlen_r = 8'd0;
            s2_axi_awlen_r = 8'd0;
            s3_axi_awlen_r = 8'd0;
        end
        4'b0100 : begin
            s0_axi_awlen_r = 8'd0;
            s1_axi_awlen_r = s_awlen;
            s2_axi_awlen_r = 8'd0;
            s3_axi_awlen_r = 8'd0;
        end
        4'b0010 : begin
            s0_axi_awlen_r = 8'd0;
            s1_axi_awlen_r = 8'd0;
            s2_axi_awlen_r = s_awlen;
            s3_axi_awlen_r = 8'd0;
        end
        4'b0001 : begin
            s0_axi_awlen_r = 8'd0;
            s1_axi_awlen_r = 8'd0;
            s2_axi_awlen_r = 8'd0;
            s3_axi_awlen_r = s_awlen;
        end
        default : begin
            s0_axi_awlen_r = 8'd0;
            s1_axi_awlen_r = 8'd0;
            s2_axi_awlen_r = 8'd0;
            s3_axi_awlen_r = 8'd0;
        end
    endcase
end
assign s0_axi_awlen = s0_axi_awlen_r;
assign s1_axi_awlen = s1_axi_awlen_r;
assign s2_axi_awlen = s2_axi_awlen_r;
assign s3_axi_awlen = s3_axi_awlen_r;
//----- AWSIZE -----//
reg [2:0] s0_axi_awsize_r;
reg [2:0] s1_axi_awsize_r;
reg [2:0] s2_axi_awsize_r;
reg [2:0] s3_axi_awsize_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_awsize_r = s_awsize;
            s1_axi_awsize_r = 3'd0;
            s2_axi_awsize_r = 3'd0;
            s3_axi_awsize_r = 3'd0;
        end
        4'b0100 : begin
            s0_axi_awsize_r = 3'd0;
            s1_axi_awsize_r = s_awsize;
            s2_axi_awsize_r = 3'd0;
            s3_axi_awsize_r = 3'd0;
        end
        4'b0010 : begin
            s0_axi_awsize_r = 3'd0;
            s1_axi_awsize_r = 3'd0;
            s2_axi_awsize_r = s_awsize;
            s3_axi_awsize_r = 3'd0;
        end
        4'b0001 : begin
            s0_axi_awsize_r = 3'd0;
            s1_axi_awsize_r = 3'd0;
            s2_axi_awsize_r = 3'd0;
            s3_axi_awsize_r = s_awsize;
        end
        default : begin
            s0_axi_awsize_r = 3'd0;
            s1_axi_awsize_r = 3'd0;
            s2_axi_awsize_r = 3'd0;
            s3_axi_awsize_r = 3'd0;
        end
    endcase
end
assign s0_axi_awsize = s0_axi_awsize_r;
assign s1_axi_awsize = s1_axi_awsize_r;
assign s2_axi_awsize = s2_axi_awsize_r;
assign s3_axi_awsize = s3_axi_awsize_r;
//----- AWBURST -----//
reg [1:0] s0_axi_awburst_r;
reg [1:0] s1_axi_awburst_r;
reg [1:0] s2_axi_awburst_r;
reg [1:0] s3_axi_awburst_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_awburst_r = s_awburst;
            s1_axi_awburst_r = 2'd0;
            s2_axi_awburst_r = 2'd0;
            s3_axi_awburst_r = 2'd0;
        end
        4'b0100 : begin
            s0_axi_awburst_r = 2'd0;
            s1_axi_awburst_r = s_awburst;
            s2_axi_awburst_r = 2'd0;
            s3_axi_awburst_r = 2'd0;
        end
        4'b0010 : begin
            s0_axi_awburst_r = 2'd0;
            s1_axi_awburst_r = 2'd0;
            s2_axi_awburst_r = s_awburst;
            s3_axi_awburst_r = 2'd0;
        end
        4'b0001 : begin
            s0_axi_awburst_r = 2'd0;
            s1_axi_awburst_r = 2'd0;
            s2_axi_awburst_r = 2'd0;
            s3_axi_awburst_r = s_awburst;
        end
        default : begin
            s0_axi_awburst_r = 2'd0;
            s1_axi_awburst_r = 2'd0;
            s2_axi_awburst_r = 2'd0;
            s3_axi_awburst_r = 2'd0;
        end
    endcase
end
assign s0_axi_awburst = s0_axi_awburst_r;
assign s1_axi_awburst = s1_axi_awburst_r;
assign s2_axi_awburst = s2_axi_awburst_r;
assign s3_axi_awburst = s3_axi_awburst_r;
//----- AWVALID -----//
reg s0_axi_awvalid_r;
reg s1_axi_awvalid_r;
reg s2_axi_awvalid_r;
reg s3_axi_awvalid_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_awvalid_r = s_awvalid;
            s1_axi_awvalid_r = 1'b0;
            s2_axi_awvalid_r = 1'b0;
            s3_axi_awvalid_r = 1'b0;
        end
        4'b0100 : begin
            s0_axi_awvalid_r = 1'b0;
            s1_axi_awvalid_r = s_awvalid;
            s2_axi_awvalid_r = 1'b0;
            s3_axi_awvalid_r = 1'b0;
        end
        4'b0010 : begin
            s0_axi_awvalid_r = 1'b0;
            s1_axi_awvalid_r = 1'b0;
            s2_axi_awvalid_r = s_awvalid;
            s3_axi_awvalid_r = 1'b0;
        end
        4'b0001 : begin
            s0_axi_awvalid_r = 1'b0;
            s1_axi_awvalid_r = 1'b0;
            s2_axi_awvalid_r = 1'b0;
            s3_axi_awvalid_r = s_awvalid;
        end
        default : begin
            s0_axi_awvalid_r = 1'b0;
            s1_axi_awvalid_r = 1'b0;
            s2_axi_awvalid_r = 1'b0;
            s3_axi_awvalid_r = 1'b0;
        end
    endcase
end
assign s0_axi_awvalid = s0_axi_awvalid_r;
assign s1_axi_awvalid = s1_axi_awvalid_r;
assign s2_axi_awvalid = s2_axi_awvalid_r;
assign s3_axi_awvalid = s3_axi_awvalid_r;
//----- WDATA -----//
reg [31:0] s0_axi_wdata_r;
reg [31:0] s1_axi_wdata_r;
reg [31:0] s2_axi_wdata_r;
reg [31:0] s3_axi_wdata_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_wdata_r = s_wdata;
            s1_axi_wdata_r = 32'd0;
            s2_axi_wdata_r = 32'd0;
            s3_axi_wdata_r = 32'd0;
        end
        4'b0100 : begin
            s0_axi_wdata_r = 32'd0;
            s1_axi_wdata_r = s_wdata;
            s2_axi_wdata_r = 32'd0;
            s3_axi_wdata_r = 32'd0;
        end
        4'b0010 : begin
            s0_axi_wdata_r = 32'd0;
            s1_axi_wdata_r = 32'd0;
            s2_axi_wdata_r = s_wdata;
            s3_axi_wdata_r = 32'd0;
        end
        4'b0001 : begin
            s0_axi_wdata_r = 32'd0;
            s1_axi_wdata_r = 32'd0;
            s2_axi_wdata_r = 32'd0;
            s3_axi_wdata_r = s_wdata;
        end
        default : begin
            s0_axi_wdata_r = 32'd0;
            s1_axi_wdata_r = 32'd0;
            s2_axi_wdata_r = 32'd0;
            s3_axi_wdata_r = 32'd0;
        end
    endcase
end
assign s0_axi_wdata = s0_axi_wdata_r;
assign s1_axi_wdata = s1_axi_wdata_r;
assign s2_axi_wdata = s2_axi_wdata_r;
assign s3_axi_wdata = s3_axi_wdata_r;
//----- WSTRB -----//
reg [3:0] s0_axi_wstrb_r;
reg [3:0] s1_axi_wstrb_r;
reg [3:0] s2_axi_wstrb_r;
reg [3:0] s3_axi_wstrb_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_wstrb_r = s_wstrb;
            s1_axi_wstrb_r = 4'd0;
            s2_axi_wstrb_r = 4'd0;
            s3_axi_wstrb_r = 4'd0;
        end
        4'b0100 : begin
            s0_axi_wstrb_r = 4'd0;
            s1_axi_wstrb_r = s_wstrb;
            s2_axi_wstrb_r = 4'd0;
            s3_axi_wstrb_r = 4'd0;
        end
        4'b0010 : begin
            s0_axi_wstrb_r = 4'd0;
            s1_axi_wstrb_r = 4'd0;
            s2_axi_wstrb_r = s_wstrb;
            s3_axi_wstrb_r = 4'd0;
        end
        4'b0001 : begin
            s0_axi_wstrb_r = 4'd0;
            s1_axi_wstrb_r = 4'd0;
            s2_axi_wstrb_r = 4'd0;
            s3_axi_wstrb_r = s_wstrb;
        end
        default : begin
            s0_axi_wstrb_r = 4'd0;
            s1_axi_wstrb_r = 4'd0;
            s2_axi_wstrb_r = 4'd0;
            s3_axi_wstrb_r = 4'd0;
        end
    endcase
end
assign s0_axi_wstrb = s0_axi_wstrb_r;
assign s1_axi_wstrb = s1_axi_wstrb_r;
assign s2_axi_wstrb = s2_axi_wstrb_r;
assign s3_axi_wstrb = s3_axi_wstrb_r;
//----- WLAST -----//
reg s0_axi_wlast_r;
reg s1_axi_wlast_r;
reg s2_axi_wlast_r;
reg s3_axi_wlast_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_wlast_r = s_wlast;
            s1_axi_wlast_r = 1'b0;
            s2_axi_wlast_r = 1'b0;
            s3_axi_wlast_r = 1'b0;
        end
        4'b0100 : begin
            s0_axi_wlast_r = 1'b0;
            s1_axi_wlast_r = s_wlast;
            s2_axi_wlast_r = 1'b0;
            s3_axi_wlast_r = 1'b0;
        end
        4'b0010 : begin
            s0_axi_wlast_r = 1'b0;
            s1_axi_wlast_r = 1'b0;
            s2_axi_wlast_r = s_wlast;
            s3_axi_wlast_r = 1'b0;
        end
        4'b0001 : begin
            s0_axi_wlast_r = 1'b0;
            s1_axi_wlast_r = 1'b0;
            s2_axi_wlast_r = 1'b0;
            s3_axi_wlast_r = s_wlast;
        end
        default : begin
            s0_axi_wlast_r = 1'b0;
            s1_axi_wlast_r = 1'b0;
            s2_axi_wlast_r = 1'b0;
            s3_axi_wlast_r = 1'b0;
        end
    endcase
end
assign s0_axi_wlast = s0_axi_wlast_r;
assign s1_axi_wlast = s1_axi_wlast_r;
assign s2_axi_wlast = s2_axi_wlast_r;
assign s3_axi_wlast = s3_axi_wlast_r;
//----- WVALID -----//
reg s0_axi_wvalid_r;
reg s1_axi_wvalid_r;
reg s2_axi_wvalid_r;
reg s3_axi_wvalid_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_wvalid_r = s_wvalid;
            s1_axi_wvalid_r = 1'b0;
            s2_axi_wvalid_r = 1'b0;
            s3_axi_wvalid_r = 1'b0;
        end
        4'b0100 : begin
            s0_axi_wvalid_r = 1'b0;
            s1_axi_wvalid_r = s_wvalid;
            s2_axi_wvalid_r = 1'b0;
            s3_axi_wvalid_r = 1'b0;
        end
        4'b0010 : begin
            s0_axi_wvalid_r = 1'b0;
            s1_axi_wvalid_r = 1'b0;
            s2_axi_wvalid_r = s_wvalid;
            s3_axi_wvalid_r = 1'b0;
        end
        4'b0001 : begin
            s0_axi_wvalid_r = 1'b0;
            s1_axi_wvalid_r = 1'b0;
            s2_axi_wvalid_r = 1'b0;
            s3_axi_wvalid_r = s_wvalid;
        end
        default : begin
            s0_axi_wvalid_r = 1'b0;
            s1_axi_wvalid_r = 1'b0;
            s2_axi_wvalid_r = 1'b0;
            s3_axi_wvalid_r = 1'b0;
        end
    endcase
end
assign s0_axi_wvalid = s0_axi_wvalid_r;
assign s1_axi_wvalid = s1_axi_wvalid_r;
assign s2_axi_wvalid = s2_axi_wvalid_r;
assign s3_axi_wvalid = s3_axi_wvalid_r;
//----- BREADY -----//
reg s0_axi_bready_r;
reg s1_axi_bready_r;
reg s2_axi_bready_r;
reg s3_axi_bready_r;
always @(*) begin
    case (s_awid_r)
        4'b1000 : begin
            s0_axi_bready_r = s_bready;
            s1_axi_bready_r = 1'b0;
            s2_axi_bready_r = 1'b0;
            s3_axi_bready_r = 1'b0;
        end
        4'b0100 : begin
            s0_axi_bready_r = 1'b0;
            s1_axi_bready_r = s_bready;
            s2_axi_bready_r = 1'b0;
            s3_axi_bready_r = 1'b0;
        end
        4'b0010 : begin
            s0_axi_bready_r = 1'b0;
            s1_axi_bready_r = 1'b0;
            s2_axi_bready_r = s_bready;
            s3_axi_bready_r = 1'b0;
        end
        4'b0001 : begin
            s0_axi_bready_r = 1'b0;
            s1_axi_bready_r = 1'b0;
            s2_axi_bready_r = 1'b0;
            s3_axi_bready_r = s_bready;
        end
        default : begin
            s0_axi_bready_r = 1'b0;
            s1_axi_bready_r = 1'b0;
            s2_axi_bready_r = 1'b0;
            s3_axi_bready_r = 1'b0;
        end
    endcase
end
assign s0_axi_bready = s0_axi_bready_r;
assign s1_axi_bready = s1_axi_bready_r;
assign s2_axi_bready = s2_axi_bready_r;
assign s3_axi_bready = s3_axi_bready_r;
endmodule