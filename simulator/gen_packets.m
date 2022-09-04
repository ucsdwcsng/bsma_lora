function queue = gen_packets(arrival_rate,num_packets)
    queue = exprnd(arrival_rate,1,num_packets);
    if num_packets > 1            
        for i = 2:num_packets
            queue(i) = queue(i-1)+queue(i);
        end
    end
end

    