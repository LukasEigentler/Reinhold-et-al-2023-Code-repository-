%% Plots for different total population sizes
% This script plots the outputs of our Monte Carlo simulations for
% different values of the total population size

clear;
close all;

Nplot = [10,100,1000,10000]; % N values to be used
distribution = "F"; % distribution to be used
f = figure;
for nn = 1:length(Nplot)
    N = Nplot(nn);
    load("Data/dist"+distribution+"_N"+num2str(N))
    subplot(2,2,nn)
    scatter(d_vec,c_mean_1000_sum)
    hold on
    grid on
    scatter(d_vec,c_mean_max_sum)
    scatter(d_vec,c_mean_min_sum)
    if nn == 3
        xlabel("d (ratio of worst to best resource used)", "Position",[1.2 -0.15])
        ylabel("Mean c (investment in competition)", "Position",[-0.2 1.2])
    end
    title("$N = "+num2str(N)+"$", 'Interpreter','latex')
    ylim([0,1])
end

set(f,'Windowstyle','normal')
set(findall(f,'-property','FontSize'),'FontSize',11)
set(f,'Units','centimeters')
set(f,'Position',[18 1 17 2/3*20])
exportgraphics(f,"plots/meanc_vs_d_different_N_distribution"+num2str(distribution)+".jpg",'Resolution',1000)

