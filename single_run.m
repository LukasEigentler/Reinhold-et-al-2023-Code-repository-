%% Modelling individual variation in competitiveness for different resource distributions
% This script performs one single realisation of the model and plots its
% output.
% 
% Author: Lukas Eigentler (lukas.eigentler@uni-bielefeld.de)
% License: GNU GPL
% Last updated: 28/02/2023

clear; 
close all;

%% Parameters

N = 10000; % no of individuals
tend = 2000; % no of generations
distribution = "E"; % resource dist
d = 0.15; % ratio worst to best resource
    
    
        %% Resource dist 
R_dist = res_dist(d, distribution);


%% Initial condition
c_gen = NaN*ones(tend+1,N);
c_gen(1,:) = rand(1,N); % initial c's randomly chosen

%% solver
tic
c_gen = IBM_solve(tend,c_gen,N,R_dist);
toc
            
%% Outputs
cmean = mean(c_gen,2); % mean trait
cstd = std(c_gen,0,2); % std of trait distribution
p25 = prctile(c_gen,25,2); % 25 percentile
p75 = prctile(c_gen,75,2); % 75 percentile


%% plotting
 
figure
subplot(3,1,1)
plot(1:tend+1, cmean)
hold on
grid on
fill([1:tend+1, fliplr(1:tend+1)], [cmean-cstd; flipud(cmean+cstd)],'magenta','FaceAlpha',0.3)
xlabel("Time")
ylabel("Competitive trait")
title("Distribution "+ distribution +", d=" + num2str(d)+", std")
ylim([0,1])

subplot(3,1,2)
plot(1:tend+1, cmean)
hold on
grid on
fill([1:tend+1, fliplr(1:tend+1)], [p25; flipud(p75)],'magenta','FaceAlpha',0.3)
xlabel("Time")
ylabel("Competitive trait")
title("Distribution "+ distribution +", d=" + num2str(d)+", interquartile range")
ylim([0,1])

% distribution at fixed time
subplot(3,1,3)
histogram(c_gen(1001,:), 0:0.02:1, 'Normalization','probability')
ylabel("Probability density")
xlabel("Competitive trait")
title("Trait distribution at t=1000")

% distribution across one "period"
locmax = find(islocalmax(cmean)==1); % find local max of mean trait
tvec = 0:1:tend; % time vector of simulations
t_one_period = tvec(locmax(end-2)):tvec(locmax(end-1)); % select last full period of oscillation
figure; pmax = 16; % no of plots
ppp = 1:pmax - 2;
pind = [t_one_period(1), t_one_period(1) + floor(ppp*length(t_one_period)/(pmax-2)),t_one_period(end)]; % plot indices
for pppp = 1:pmax
    pp = pind(pppp);
    subplot(sqrt(pmax),sqrt(pmax),pppp)
    histogram(c_gen(pp,:), 0:0.02:1, 'Normalization','probability')
    ylabel("Probability density")
    xlabel("Competitive trait")
    title("Trait distribution at $t= " + num2str(tvec(pp)) + "$", 'Interpreter','latex')
end

f2 = figure(10);
plot(1:tend+1, cmean)
hold on
grid on
fill([1:tend+1, fliplr(1:tend+1)], [cmean-cstd; flipud(cmean+cstd)],'magenta','FaceAlpha',0.3)
xlabel("Generation")
ylabel("c (investment in competition)")
title("Distribution "+ distribution +", d=" + num2str(d))
ylim([0,1])
xlim([1000,tend])

f3 = figure(20);
plot(1:tend+1, cmean)
hold on
grid on
fill([1:tend+1, fliplr(1:tend+1)], [p25; flipud(p75)],'magenta','FaceAlpha',0.3)
xlabel("Generation")
ylabel("c (investment in competition)")
title("Distribution "+ distribution +", d=" + num2str(d))
ylim([0,1])
xlim([1000,tend])

set(f2,'Windowstyle','normal')
set(findall(f2,'-property','FontSize'),'FontSize',11)
set(f2,'Units','centimeters')
set(f2,'Position',[18 1 17 13])

set(f3,'Windowstyle','normal')
set(findall(f3,'-property','FontSize'),'FontSize',11)
set(f3,'Units','centimeters')
set(f3,'Position',[18 1 17 13])
