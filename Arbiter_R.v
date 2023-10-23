module Arbiter_R (
    //----- Global -----//
    input  aclk          ,
    input  aresetn       ,
    //----- Master 0 -----//
    input  m0_arvalid    ,
    input  m0_rready     ,
    //----- Master 1 -----//
    input  m1_arvalid    ,
    input  m1_rready     ,
    //----- Master 2 -----//
    input  m2_arvalid    ,
    input  m2_rready     ,
    //----- Master 3 -----//
    input  m3_arvalid    ,
    input  m3_rready     ,
    //----- General signals -----//
    input  m_rvalid      ,
    input  m_rlast       ,
    output m0_read_accept,
    output m1_read_accept,
    output m2_read_accept,
    output m3_read_accept 
);
//----- Local parameter -----//
localparam MASTER_0 = 2'b00;
localparam MASTER_1 = 2'b01;
localparam MASTER_2 = 2'b10;
localparam MASTER_3 = 2'b11;
//----- FSM -----//
reg [1:0] CURRENT_STATE;
reg [1:0] NEXT_STATE;
// State change
always @(*) begin
    case (CURRENT_STATE)
        MASTER_0 : begin
            if (m0_arvalid)
                NEXT_STATE = MASTER_0;
            else if (m_rvalid || m0_rready)
                NEXT_STATE = MASTER_0;
            else if (m_rlast && m_rvalid)
                NEXT_STATE = MASTER_1;
            else if (m1_arvalid)
                NEXT_STATE = MASTER_1;
            else if (m2_arvalid)
                NEXT_STATE = MASTER_2;
            else if (m3_arvalid)
                NEXT_STATE = MASTER_3;
            else
                NEXT_STATE = MASTER_0;
        end
        MASTER_1 : begin
            if (m1_arvalid)
                NEXT_STATE = MASTER_1;
            else if (m_rvalid || m1_rready)
                NEXT_STATE = MASTER_1;
            else if (m_rlast && m_rvalid)
                NEXT_STATE = MASTER_2;
            else if (m2_arvalid)
                NEXT_STATE = MASTER_2;
            else if (m3_arvalid)
                NEXT_STATE = MASTER_3;
            else if (m0_arvalid)
                NEXT_STATE = MASTER_0;
            else
                NEXT_STATE = MASTER_1;
        end
        MASTER_2 : begin
            if (m2_arvalid)
                NEXT_STATE = MASTER_2;
            else if (m_rvalid || m2_rready)
                NEXT_STATE = MASTER_2;
            else if (m_rlast && m_rvalid)
                NEXT_STATE = MASTER_3;
            else if (m3_arvalid)
                NEXT_STATE = MASTER_3;
            else if (m0_arvalid)
                NEXT_STATE = MASTER_0;
            else if (m1_arvalid)
                NEXT_STATE = MASTER_1;
            else
                NEXT_STATE = MASTER_2;
        end
        MASTER_3 : begin
            if (m3_arvalid)
                NEXT_STATE = MASTER_3;
            else if (m_rvalid || m3_rready)
                NEXT_STATE = MASTER_3;
            else if (m_rlast && m_rvalid)
                NEXT_STATE = MASTER_0;
            else if (m0_arvalid)
                NEXT_STATE = MASTER_0;
            else if (m1_arvalid)
                NEXT_STATE = MASTER_1;
            else if (m2_arvalid)
                NEXT_STATE = MASTER_2;
            else
                NEXT_STATE = MASTER_3;
        end
        default : begin
            NEXT_STATE = MASTER_0;
        end 
    endcase
end
// State register
always @(posedge aclk or negedge aresetn) begin
    if (!aresetn)
        CURRENT_STATE <= MASTER_0;
    else
        CURRENT_STATE <= NEXT_STATE;
end
// State control
reg m0_read_accept_r;
reg m1_read_accept_r;
reg m2_read_accept_r;
reg m3_read_accept_r;
always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
        m0_read_accept_r <= 1'b0;
        m1_read_accept_r <= 1'b0;
        m2_read_accept_r <= 1'b0;
        m3_read_accept_r <= 1'b0;
    end
    else begin
        m0_read_accept_r <= m0_read_accept;
        m1_read_accept_r <= m1_read_accept;
        m2_read_accept_r <= m2_read_accept;
        m3_read_accept_r <= m3_read_accept;
    end
end
always @(*) begin
    case (CURRENT_STATE)
        MASTER_0 : {m0_read_accept_r, m1_read_accept_r, m2_read_accept_r, m3_read_accept_r} = 4'b1000;
        MASTER_1 : {m0_read_accept_r, m1_read_accept_r, m2_read_accept_r, m3_read_accept_r} = 4'b0100;
        MASTER_2 : {m0_read_accept_r, m1_read_accept_r, m2_read_accept_r, m3_read_accept_r} = 4'b0010;
        MASTER_3 : {m0_read_accept_r, m1_read_accept_r, m2_read_accept_r, m3_read_accept_r} = 4'b0001;
        default  : {m0_read_accept_r, m1_read_accept_r, m2_read_accept_r, m3_read_accept_r} = 4'b0000;
    endcase
end
endmodule