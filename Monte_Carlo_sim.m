%% Modelling individual variation in competitiveness for different resource distributions
% This script performs Monte Carlo simulations and generates the data used
% in the paper [CITATION TO BE ADDED AFTER PUBLICATION]
%
% Author: Lukas Eigentler (lukas.eigentler@uni-bielefeld.de)
% License: GNU GPL
% Last updated: 28/02/2023

clear; close all;
newcalc = 0; % 0 for plotting only, 1 for new calculation, 0.5 for adding to existing data


%% Parameters

N = 10000; % no of individuals
tend = 2000; % no of generations
d_vec_new = [0.01,0.05:0.05:0.95, 0.99]; % vector that contains all ratios worst to best resource used in the simulations
norep = 100; % number of independent replicates
distribution_vec = ["A", "B", "C", "D", "E", "F"]; % resource distributions to be used
f3 = figure(3); % initialise figures
f2 = figure(2);
f1 = figure(1);
f4 = figure(4);
timestart = tic;
steptot = length(distribution_vec)*length(d_vec_new)*norep;
step = 0;
for res = 1:length(distribution_vec) % loop through all distributions
    distribution = distribution_vec(res);
    if newcalc < 1 % load existing data if not the first run and create plot of one example resource distribution
        load("Data/dist"+distribution+"_N"+num2str(N))
        if newcalc == 0
            d = 0.2;
            [R_dist, Rpdf, x] = res_dist(d, distribution);
            rand_nums = random(R_dist, 1, N);
            figure(f1)
            subplot(3,2,res)
            plot_res_dist(rand_nums,d,x,Rpdf,distribution)
        end
    end
    if newcalc > 0 % initialise counting of how many entries are present
        if newcalc ==0.5
            exist = length(c_mean_1000_sum);
        else
            exist = 0;
        end
        for dd = 1:length(d_vec_new) % loop through all d values
            d = d_vec_new(dd); % ratio worst to best resource
        
        
            %% Resource dist and check of random number generator
            [R_dist, Rpdf, x] = res_dist(d, distribution); % define resource distribution
             if dd == 4 % Example plot of resource distribution for one d value
                rand_nums = random(R_dist, 1, N);
                figure(f1)
                subplot(3,2,res)
                plot_res_dist(rand_nums,d,x,Rpdf,distribution)
            end
            for rep = 1:norep % perform all independent replicates
                
                %% IC
                c_gen = NaN*ones(tend+1,N);
                c_gen(1,:) = rand(1,N); % initial c's randomly chosen
                
                
                %% solver
                c_gen = IBM_solve(tend,c_gen,N,R_dist);
                %% Outputs
                cmean = mean(c_gen,2); % find mean
                cstd = std(c_gen,0,2); % find std
                c_mean(:,dd) = cmean; % store mean
                c_mean_1000(rep,dd) = cmean(1001,:); % mean trait at gen 1000
                c_std_1000(rep,dd) = cstd(1001,:); % std of trait at gen 1000
                c_mean_max(rep,dd) = max(cmean(1001:end)); % max mean trait between gen 1000 - 2000
                c_mean_min(rep,dd) = min(cmean(1001:end)); % min mean trait between gen 1000 - 2000
    
                step = step+1;
                timeend = toc(timestart); 
                disp("Step " + num2str(step) + " of "+ num2str(steptot) + ". Avg. step length = " + num2str(timeend/step) + ". Remaining time = " + string(duration(0,0,timeend/step * (steptot-step))) )
                
            end
            %% Assign outputs to larger vectors
            d_vec(exist + dd) = d_vec_new(dd); 
            c_mean_1000_sum(exist + dd) = mean(c_mean_1000(:,dd));
            c_std_1000_sum(exist + dd) = mean(c_std_1000(:,dd));
            c_mean_max_sum(exist + dd) = mean(c_mean_max(:,dd));
            c_mean_min_sum(exist + dd) = mean(c_mean_min(:,dd));
        end
        %% save data
        save("Data/dist"+distribution+"_N"+num2str(N), "distribution", "d_vec", "c_mean_1000_sum", "c_mean_max_sum", "c_mean_min_sum", "c_std_1000_sum", "N")
    
           
    end
    %% plotting
    figure(f2)
    subplot(3,2,res)
    scatter(d_vec,c_mean_1000_sum)
%     pbaspect([1 1 1])
    hold on
    grid on
    scatter(d_vec,c_mean_max_sum)
    scatter(d_vec,c_mean_min_sum)
%     plot(d_vec,(1-d_vec)/2, '--k', 'LineWidth',1)
    if res == 5
        xlabel("d (ratio of worst to best resource used)")
    end
    if res == 3
        ylabel("Mean c (investment in competition)")
    end
    title(distribution)
    ylim([0,1])

    figure(f3)
    subplot(3,2,res)
    scatter(d_vec,c_std_1000_sum)
%     pbaspect([1 1 1])
    hold on
    grid on
    plot(d_vec,(1-d_vec)/sqrt(12), '--')
    if res == 5
        xlabel("d (ratio of worst to best resource used)")
    end
    if res == 3
        ylabel("SD c (investment in competition)")
    end
    ylim([0,0.3])
    title(distribution) 

    %% SD relative to expected max; for information only

    figure(f4)
    subplot(3,2,res)
    maxstd = (1-d_vec)/sqrt(12);
    scatter(d_vec,c_std_1000_sum./maxstd)
%     pbaspect([1 1 1])
    hold on
    grid on
    if res == 5
        xlabel("d (ratio of worst to best resource used)")
    end
    if res == 3
        ylabel("SD c / SD max")
    end
    ylim([0,2])
    title(distribution) 

end

%% finalise figures
set(f2,'Windowstyle','normal')
set(findall(f2,'-property','FontSize'),'FontSize',11)
set(f2,'Units','centimeters')
set(f2,'Position',[18 1 17 20])

set(f3,'Windowstyle','normal')
set(findall(f3,'-property','FontSize'),'FontSize',11)
set(f3,'Units','centimeters')
set(f3,'Position',[18 1 17 20])

set(f4,'Windowstyle','normal')
set(findall(f4,'-property','FontSize'),'FontSize',11)
set(f4,'Units','centimeters')
set(f4,'Position',[18 1 17 20])


%% save figures
% exportgraphics(f3,'plots/SD_vs_d.jpg','Resolution',1000)
% exportgraphics(f2,'plots/mean_c_vs_d.jpg','Resolution',1000)
% exportgraphics(f4,'plots/rel_SD_vs_d.jpg','Resolution',1000)


