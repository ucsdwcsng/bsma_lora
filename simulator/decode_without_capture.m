function capacity = decode_without_capture(nodes,tdiag_ap,packet_duration)
    num_nodes = numel(nodes);
    capacity = zeros(1,num_nodes);
   
    % TODO: Multi-gateway
    for j = 2:size(tdiag_ap,1)-1
        if(tdiag_ap(j,1)==1 &&tdiag_ap(j+1,1)==0&&tdiag_ap(j-1,1)==0)
            capacity(tdiag_ap(j,3)) = capacity(tdiag_ap(j,3))+1;
        end
    end


% function capacity = decode_without_capture(nodes,packets_ap,packet_duration)
%     num_nodes = numel(nodes);
%     capacity = zeros(1,num_nodes);
%     if(packets_ap(2,2)-packets_ap(1,2)>=packet_duration)
%         capacity(packets_ap(1,1)) = capacity(packets_ap(1,1)) +1;
%     end    
%     for i = 2:size(packets_ap,1)-1
%         if((packets_ap(i+1,2)-packets_ap(i,2)>=packet_duration)&&(packets_ap(i,2)-packets_ap(i-1,2)>=packet_duration))
%             capacity(packets_ap(i,1)) = capacity(packets_ap(i,1)) +1;
%         end
%     end 
%     i = i+1;
%     if(packets_ap(i,2)-packets_ap(i-1,2)>=packet_duration)
%         capacity(packets_ap(i,1)) = capacity(packets_ap(i,1)) +1;
%     end
% end