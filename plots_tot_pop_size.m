%% Plots for different total population sizes
% This script plots the outputs of our Monte Carlo simulations for
% different values of the total population size and for constant total
% population size but different sizes of local interaction groups

clear;
close all;

%% different total population sizes
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


%% different local population sizes
N = 1e4;
Nsubplot = [2,10,100,1000]; % N values to be used
distribution = "F"; % distribution to be used
f1 = figure;
for nn = 1:length(Nsubplot)
    Nsub = Nsubplot(nn);
    load("Data/dist"+distribution+"_N"+num2str(N)+"_Nsub"+num2str(Nsub))
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
    title("$N=" +num2str(N)+", N_{sub} = "+num2str(Nsub)+"$", 'Interpreter','latex')
    ylim([0,1])
end

set(f1,'Windowstyle','normal')
set(findall(f1,'-property','FontSize'),'FontSize',11)
set(f1,'Units','centimeters')
set(f1,'Position',[18 1 17 2/3*20])
exportgraphics(f1,"plots/meanc_vs_d_different_Nsub_distribution"+num2str(distribution)+".jpg",'Resolution',1000)

