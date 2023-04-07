function [param_in] = plot_magic(fig_han, ax_han, param_in)
%plot_magic Magic function to get figure to the right
% proportions, and all the axis to visible sizes.
arguments
    fig_han = gcf;
    ax_han = gca;
    param_in.aspect_ratio = [4 3];
    param_in.size_flag = ['none'];
    param_in.pixelDensity = 200; % Pixels pre 1 unit of aspect ratio
    param_in.lineWidth = 3;
    param_in.fontSize = 18;
    param_in.gridFlag = 'on';
    param_in.minorGridFlag = 'on';
end

if(~isempty(fig_han))
    fig_han.Position = [fig_han.Position(1:2) param_in.aspect_ratio*param_in.pixelDensity];
end

switch(param_in.size_flag)
    case 'big'
        param_in.lineWidth = 3;
        param_in.fontSize = 18;
    case 'med'
        param_in.lineWidth = 2;
        param_in.fontSize = 12;
    otherwise
end

set(findall(ax_han, 'Type', 'Line'),'LineWidth',param_in.lineWidth);
set(ax_han,'fontsize', param_in.fontSize);

grid(ax_han, param_in.gridFlag);
if(param_in.minorGridFlag == "on")
    grid(ax_han, 'minor');
end


end

