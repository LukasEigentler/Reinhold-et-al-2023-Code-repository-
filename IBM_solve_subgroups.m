function c_gen_all = IBM_solve_subgroups(tend,c_gen_all,N,Nsub,R_dist)
% IMB_solve solves the IBM once
%
% Author: Lukas Eigentler (lukas.eigentler@uni-bielefeld.de)
% License: GNU GPL
% Last updated: 28/02/2023
for tt = 1:tend
    c_exp_all = c_gen_all(tt,:) + normrnd(0,0.01,1,N); % expressed trait varies randomly from genetic trait 
    c_exp_all(c_exp_all<0) = 0; % apply lower BC
    % c_exp(c_exp>1) = 1; % apply upper BC - not needed due to "natural"
    % upper bound c = 1-d?

    nogroups = N/Nsub;
    c_gen_all_thistime = c_gen_all(tt,:);
    for nn = 1:nogroups
        tempind = randperm(length(c_exp_all),Nsub); % select indices of subgroup members
        c_exp = c_exp_all(tempind); % assign selected indices to vector = 
        c_gen = c_gen_all_thistime(tempind); % same for cgen vector
        c_exp_all(tempind) = []; % delete selected values
        c_gen_all_thistime(tempind) = [];

        R_sort = [];
        while length(R_sort) < Nsub % loop until enough resource values are picked
            R_sort = [R_sort, random(R_dist, 1, Nsub-length(R_sort))]; % pick resources
            R_sort(R_sort>1) = []; % exclude resources above value 1 (only applicable to right half of normal dist) 
        end

        R_sort = sort(R_sort); % sorting of resources
        [c_exp_sort, sort_ind] = sort(c_exp); % sort expressed traits
        c_gen_sort = c_gen(sort_ind); % reorder genetic trait value vector
        fit = (1-c_exp_sort).*R_sort; % define fitness of individuals
        fit(fit<0) = 0; % negative fitness is same as fitness = 0 --> no reproduction
        c_new = randsample(c_gen_sort,Nsub,true,fit); % new trait values without mutation
        mut = rand(1,Nsub) < 0.01; % define mutation events
        c_gen_new_no_bc = c_new + mut.*normrnd(0,0.1,1,Nsub); % apply mutations
        c_gen_new_no_bc(c_gen_new_no_bc<0) = 0; c_gen_new_no_bc(c_gen_new_no_bc>1) = 1; % apply bc
        c_gen_all(tt+1,(nn-1)*Nsub+1:nn*Nsub) = c_gen_new_no_bc; % update cgen
    end
end
