module Master_Mux_W (
    //----- Global -----//
    input         aclk          ,
    input         aresetn       ,
    //----- Master 0 -----//
    // Write adress
    input  [3:0]  m0_axi_awid   ,
    input  [31:0] m0_axi_awaddr ,
    input  [7:0]  m0_axi_awlen  ,
    input  [2:0]  m0_axi_awsize ,
    input  [1:0]  m0_axi_awburst,
    input         m0_axi_awvalid,
    output        m0_axi_awready,
    // Write data
    input  [31:0] m0_axi_wdata  ,
    input  [3:0]  m0_axi_wstrb  ,
    input         m0_axi_wlast  ,
    input         m0_axi_wvalid ,
    output        m0_axi_wready ,
    // Write response
    output [3:0]  m0_axi_bid    ,
    output [1:0]  m0_axi_bresp  ,
    output        m0_axi_bvalid ,
    input         m0_axi_bready ,
    //----- Master 1 -----//
    // Write adress
    input  [3:0]  m1_axi_awid   ,
    input  [31:0] m1_axi_awaddr ,
    input  [7:0]  m1_axi_awlen  ,
    input  [2:0]  m1_axi_awsize ,
    input  [1:0]  m1_axi_awburst,
    input         m1_axi_awvalid,
    output        m1_axi_awready,
    // Write data
    input  [31:0] m1_axi_wdata  ,
    input  [3:0]  m1_axi_wstrb  ,
    input         m1_axi_wlast  ,
    input         m1_axi_wvalid ,
    output        m1_axi_wready ,
    // Write response
    output [3:0]  m1_axi_bid    ,
    output [1:0]  m1_axi_bresp  ,
    output        m1_axi_bvalid ,
    input         m1_axi_bready ,
    //----- Master 2 -----//
    // Write adress
    input  [3:0]  m2_axi_awid   ,
    input  [31:0] m2_axi_awaddr ,
    input  [7:0]  m2_axi_awlen  ,
    input  [2:0]  m2_axi_awsize ,
    input  [1:0]  m2_axi_awburst,
    input         m2_axi_awvalid,
    output        m2_axi_awready,
    // Write data
    input  [31:0] m2_axi_wdata  ,
    input  [3:0]  m2_axi_wstrb  ,
    input         m2_axi_wlast  ,
    input         m2_axi_wvalid ,
    output        m2_axi_wready ,
    // Write response
    output [3:0]  m2_axi_bid    ,
    output [1:0]  m2_axi_bresp  ,
    output        m2_axi_bvalid ,
    input         m2_axi_bready ,
    //----- Master 3 -----//
    // Write adress
    input  [3:0]  m3_axi_awid   ,
    input  [31:0] m3_axi_awaddr ,
    input  [7:0]  m3_axi_awlen  ,
    input  [2:0]  m3_axi_awsize ,
    input  [1:0]  m3_axi_awburst,
    input         m3_axi_awvalid,
    output        m3_axi_awready,
    // Write data
    input  [31:0] m3_axi_wdata  ,
    input  [3:0]  m3_axi_wstrb  ,
    input         m3_axi_wlast  ,
    input         m3_axi_wvalid ,
    output        m3_axi_wready ,
    // Write response
    output [3:0]  m3_axi_bid    ,
    output [1:0]  m3_axi_bresp  ,
    output        m3_axi_bvalid ,
    input         m3_axi_bready ,
    //----- Slave general -----//
    // Write address
    output [3:0]  s_awid        ,
    output [31:0] s_awaddr      ,
    output [7:0]  s_awlen       ,
    output [2:0]  s_awsize      ,
    output [1:0]  s_awburst     ,
    output        s_awvalid     ,
    // Write data
    output [31:0] s_wdata       ,
    output [3:0]  s_wstrb       ,
    output        s_wlast       ,
    output        s_wvalid      ,
    // Write response
    output        s_bready      ,
    //----- Master general -----//
    // Write address
    input         m_awready     ,
    // Write data
    input         m_wready      ,
    // Write response
    input  [3:0]  m_bid         ,
    input  [1:0]  m_bresp       ,
    input         m_bvalid      ,
    //----- Control signals -----//
    input         m0_write_accept,
    input         m1_write_accept,
    input         m2_write_accept,
    input         m3_write_accept
);
//----- Other signals -----//
reg [3:0]  s_awid_r   ; 
reg [31:0] s_awaddr_r ; 
reg [7:0]  s_awlen_r  ; 
reg [2:0]  s_awsize_r ; 
reg [1:0]  s_awburst_r; 
reg        s_awvalid_r; 
reg [31:0] s_wdata_r  ; 
reg [3:0]  s_wstrb_r  ; 
reg        s_wlast_r  ; 
reg        s_wvalid_r ; 
reg        s_bready_r ; 
always @(*) begin
    case ({m0_write_accept, m1_write_accept, m2_write_accept, m3_write_accept})
        4'b1000 : begin
            s_awid_r    = m0_axi_awid   ;
            s_awaddr_r  = m0_axi_awaddr ;
            s_awlen_r   = m0_axi_awlen  ;
            s_awsize_r  = m0_axi_awsize ;
            s_awburst_r = m0_axi_awburst;
            s_awvalid_r = m0_axi_wvalid ;
            s_wdata_r   = m0_axi_wdata  ;
            s_wstrb_r   = m0_axi_wstrb  ;
            s_wlast_r   = m0_axi_wlast  ;
            s_wvalid_r  = m0_axi_wvalid ;
            s_bready_r  = m0_axi_bready ;
        end
        4'b0100 : begin
            s_awid_r    = m1_axi_awid   ;
            s_awaddr_r  = m1_axi_awaddr ;
            s_awlen_r   = m1_axi_awlen  ;
            s_awsize_r  = m1_axi_awsize ;
            s_awburst_r = m1_axi_awburst;
            s_awvalid_r = m1_axi_wvalid ;
            s_wdata_r   = m1_axi_wdata  ;
            s_wstrb_r   = m1_axi_wstrb  ;
            s_wlast_r   = m1_axi_wlast  ;
            s_wvalid_r  = m1_axi_wvalid ;
            s_bready_r  = m1_axi_bready ;
        end
        4'b0010 : begin
            s_awid_r    = m2_axi_awid   ;
            s_awaddr_r  = m2_axi_awaddr ;
            s_awlen_r   = m2_axi_awlen  ;
            s_awsize_r  = m2_axi_awsize ;
            s_awburst_r = m2_axi_awburst;
            s_awvalid_r = m2_axi_wvalid ;
            s_wdata_r   = m2_axi_wdata  ;
            s_wstrb_r   = m2_axi_wstrb  ;
            s_wlast_r   = m2_axi_wlast  ;
            s_wvalid_r  = m2_axi_wvalid ;
            s_bready_r  = m2_axi_bready ;
        end
        4'b0001 : begin
            s_awid_r    = m3_axi_awid   ;
            s_awaddr_r  = m3_axi_awaddr ;
            s_awlen_r   = m3_axi_awlen  ;
            s_awsize_r  = m3_axi_awsize ;
            s_awburst_r = m3_axi_awburst;
            s_awvalid_r = m3_axi_wvalid ;
            s_wdata_r   = m3_axi_wdata  ;
            s_wstrb_r   = m3_axi_wstrb  ;
            s_wlast_r   = m3_axi_wlast  ;
            s_wvalid_r  = m3_axi_wvalid ;
            s_bready_r  = m3_axi_bready ;
        end
        default : begin
            s_awid_r    = 4'd0 ;
            s_awaddr_r  = 32'd0;
            s_awlen_r   = 8'd0 ;
            s_awsize_r  = 3'd0 ;
            s_awburst_r = 2'd0 ;
            s_awvalid_r = 1'b0 ;
            s_wdata_r   = 32'd0;
            s_wstrb_r   = 4'd0 ;
            s_wlast_r   = 1'b0 ;
            s_wvalid_r  = 1'b0 ;
            s_bready_r  = 1'b0 ;
        end
    endcase
end
assign s_awid    = s_awid_r   ;
assign s_awaddr  = s_awaddr_r ;
assign s_awlen   = s_awlen_r  ;
assign s_awsize  = s_awsize_r ;
assign s_awburst = s_awburst_r;
assign s_awvalid = s_awvalid_r;
assign s_wdata   = s_wdata_r  ;
assign s_wstrb   = s_wstrb_r  ;
assign s_wlast   = s_wlast_r  ; 
assign s_wvalid  = s_wvalid_r ;
assign s_bready  = s_bready_r ;
//----- AWREADY -----//
reg m0_awready_r;
reg m1_awready_r;
reg m2_awready_r;
reg m3_awready_r;
always @(*) begin
    case ({m0_write_accept, m1_write_accept, m2_write_accept, m3_write_accept})
        4'b1000 : begin
            m0_awready_r = m_awready;
            m1_awready_r = 1'b0;
            m2_awready_r = 1'b0;
            m3_awready_r = 1'b0;
        end
        4'b0100 : begin
            m0_awready_r = 1'b0;
            m1_awready_r = m_awready;
            m2_awready_r = 1'b0;
            m3_awready_r = 1'b0;
        end
        4'b0010 : begin
            m0_awready_r = 1'b0;
            m1_awready_r = 1'b0;
            m2_awready_r = m_awready;
            m3_awready_r = 1'b0;
        end
        4'b0001 : begin
            m0_awready_r = 1'b0;
            m1_awready_r = 1'b0;
            m2_awready_r = 1'b0;
            m3_awready_r = m_awready;
        end
        default : begin
            m0_awready_r = 1'b0;
            m1_awready_r = 1'b0;
            m2_awready_r = 1'b0;
            m3_awready_r = 1'b0;
        end
    endcase
end
assign m0_axi_awready = m0_awready_r;
assign m1_axi_awready = m1_awready_r;
assign m2_axi_awready = m2_awready_r;
assign m3_axi_awready = m3_awready_r;
//----- WREADY-----//
reg m0_axi_wready_r;
reg m1_axi_wready_r;
reg m2_axi_wready_r;
reg m3_axi_wready_r;
always @(*) begin
    case ({m0_write_accept, m1_write_accept, m2_write_accept, m3_write_accept})
        4'b1000 : begin
            m0_axi_wready_r = m_wready;
            m1_axi_wready_r = 1'b0;
            m2_axi_wready_r = 1'b0;
            m3_axi_wready_r = 1'b0;
        end
        4'b0100 : begin
            m0_axi_wready_r = 1'b0;
            m1_axi_wready_r = m_wready;
            m2_axi_wready_r = 1'b0;
            m3_axi_wready_r = 1'b0;
        end
        4'b0010 : begin
            m0_axi_wready_r = 1'b0;
            m1_axi_wready_r = 1'b0;
            m2_axi_wready_r = m_wready;
            m3_axi_wready_r = 1'b0;
        end
        4'b0001 : begin
            m0_axi_wready_r = 1'b0;
            m1_axi_wready_r = 1'b0;
            m2_axi_wready_r = 1'b0;
            m3_axi_wready_r = m_wready;
        end
        default : begin
            m0_axi_wready_r = 1'b0;
            m1_axi_wready_r = 1'b0;
            m2_axi_wready_r = 1'b0;
            m3_axi_wready_r = 1'b0;
        end 
    endcase
end
assign m0_axi_wready = m0_axi_wready_r;
assign m1_axi_wready = m1_axi_wready_r;
assign m2_axi_wready = m2_axi_wready_r;
assign m3_axi_wready = m3_axi_wready_r;
//----- BID -----//
reg [3:0] m0_axi_bid_r;
reg [3:0] m1_axi_bid_r;
reg [3:0] m2_axi_bid_r;
reg [3:0] m3_axi_bid_r;
always @(*) begin
    case ({m0_write_accept, m1_write_accept, m2_write_accept, m3_write_accept})
        4'b1000 : begin
            m0_axi_bid_r = m_bid;
            m1_axi_bid_r = 4'd0;
            m2_axi_bid_r = 4'd0;
            m3_axi_bid_r = 4'd0;
        end
        4'b0100 : begin
            m0_axi_bid_r = 4'd0;
            m1_axi_bid_r = m_bid;
            m2_axi_bid_r = 4'd0;
            m3_axi_bid_r = 4'd0;
        end
        4'b0010 : begin
            m0_axi_bid_r = 4'd0;
            m1_axi_bid_r = 4'd0;
            m2_axi_bid_r = m_bid;
            m3_axi_bid_r = 4'd0;
        end
        4'b0001 : begin
            m0_axi_bid_r = 4'd0;
            m1_axi_bid_r = 4'd0;
            m2_axi_bid_r = 4'd0;
            m3_axi_bid_r = m_bid;
        end
        default : begin
            m0_axi_bid_r = 4'd0;
            m1_axi_bid_r = 4'd0;
            m2_axi_bid_r = 4'd0;
            m3_axi_bid_r = 4'd0;
        end
    endcase
end
assign m0_axi_bid = m0_axi_bid_r;
assign m1_axi_bid = m1_axi_bid_r;
assign m2_axi_bid = m2_axi_bid_r;
assign m3_axi_bid = m3_axi_bid_r;
//----- BRESP -----//
reg [1:0] m0_axi_bresp_r;
reg [1:0] m1_axi_bresp_r;
reg [1:0] m2_axi_bresp_r;
reg [1:0] m3_axi_bresp_r;
always @(*) begin
    case ({m0_write_accept, m1_write_accept, m2_write_accept, m3_write_accept})
        4'b1000 : begin
            m0_axi_bresp_r = m_bresp;
            m1_axi_bresp_r = 2'd0;
            m2_axi_bresp_r = 2'd0;
            m3_axi_bresp_r = 2'd0;
        end
        4'b0100 : begin
            m0_axi_bresp_r = 2'd0;
            m1_axi_bresp_r = m_bresp;
            m2_axi_bresp_r = 2'd0;
            m3_axi_bresp_r = 2'd0;
        end
        4'b0010 : begin
            m0_axi_bresp_r = 2'd0;
            m1_axi_bresp_r = 2'd0;
            m2_axi_bresp_r = m_bresp;
            m3_axi_bresp_r = 2'd0;
        end
        4'b0001 : begin
            m0_axi_bresp_r = 2'd0;
            m1_axi_bresp_r = 2'd0;
            m2_axi_bresp_r = 2'd0;
            m3_axi_bresp_r = m_bresp;
        end
        default : begin
            m0_axi_bresp_r = 2'd0;
            m1_axi_bresp_r = 2'd0;
            m2_axi_bresp_r = 2'd0;
            m3_axi_bresp_r = 2'd0;
        end
    endcase
end
assign m0_axi_bresp = m0_axi_bresp_r;
assign m1_axi_bresp = m1_axi_bresp_r;
assign m2_axi_bresp = m2_axi_bresp_r;
assign m3_axi_bresp = m3_axi_bresp_r;
//----- BVALID -----//
reg m0_axi_bvalid_r;
reg m1_axi_bvalid_r;
reg m2_axi_bvalid_r;
reg m3_axi_bvalid_r;
always @(*) begin
    case ({m0_write_accept, m1_write_accept, m2_write_accept, m3_write_accept})
        4'b1000 : begin
            m0_axi_bvalid_r = m_bvalid;
            m1_axi_bvalid_r = 1'b0;
            m2_axi_bvalid_r = 1'b0;
            m3_axi_bvalid_r = 1'b0;
        end
        4'b0100 : begin
            m0_axi_bvalid_r = 1'b0;
            m1_axi_bvalid_r = m_bvalid;
            m2_axi_bvalid_r = 1'b0;
            m3_axi_bvalid_r = 1'b0;
        end
        4'b0010 : begin
            m0_axi_bvalid_r = 1'b0;
            m1_axi_bvalid_r = 1'b0;
            m2_axi_bvalid_r = m_bvalid;
            m3_axi_bvalid_r = 1'b0;
        end
        4'b0001 : begin
            m0_axi_bvalid_r = 1'b0;
            m1_axi_bvalid_r = 1'b0;
            m2_axi_bvalid_r = 1'b0;
            m3_axi_bvalid_r = m_bvalid;
        end
        default : begin
            m0_axi_bvalid_r = 1'b0;
            m1_axi_bvalid_r = 1'b0;
            m2_axi_bvalid_r = 1'b0;
            m3_axi_bvalid_r = 1'b0;
        end
    endcase
end
assign m0_axi_bvalid = m0_axi_bvalid_r;
assign m1_axi_bvalid = m1_axi_bvalid_r;
assign m2_axi_bvalid = m2_axi_bvalid_r;
assign m3_axi_bvalid = m3_axi_bvalid_r;
endmodule