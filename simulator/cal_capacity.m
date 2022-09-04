function capacity = cal_capacity(nodes,tdiag_ap,tbsig_trig,packet_duration,gateway_position, CE_Thresh)
num_nodes = numel(nodes);
capacity = zeros(8,num_nodes);

% CSMA
capacity(1,:) = decode_without_capture(nodes,tdiag_ap{1},packet_duration);
capacity(2,:) = decode_with_capture(nodes,tdiag_ap{1},packet_duration, gateway_position, CE_Thresh);
capacity(3,:) = 0;

% ALOHA
capacity(4,:) = decode_without_capture(nodes,tdiag_ap{3},packet_duration);
capacity(5,:) = decode_with_capture(nodes,tdiag_ap{3},packet_duration, gateway_position, CE_Thresh);
capacity(6,:) = 0;

% FD-BSMA
if(isempty(tbsig_trig))
    capacity(7,:) = decode_with_capture(nodes,tdiag_ap{2},packet_duration, gateway_position, CE_Thresh);
else
    capacity(7,:) = decode_with_capture_bsma(nodes,tdiag_ap{2},packet_duration, gateway_position, CE_Thresh);
end
capacity(8,:) = decode_without_capture(nodes,tdiag_ap{2},packet_duration);
end