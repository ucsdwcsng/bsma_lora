function [] = print_fig (fig, filename, flag)


switch(flag)

    case '-dfig'
        savefig(fig, filename);
    
    otherwise
        fig_pos = fig.PaperPosition;
        fig.PaperSize = [fig_pos(3) fig_pos(4)];
        print(fig, filename, flag)

end

end