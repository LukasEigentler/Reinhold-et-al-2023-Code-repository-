function c_gen = IBM_solve(tend,c_gen,N,R_dist)
% IMB_solve solves the IBM once
%
% Author: Lukas Eigentler (lukas.eigentler@uni-bielefeld.de)
% License: GNU GPL
% Last updated: 28/02/2023

for tt = 1:tend
    c_exp = c_gen(tt,:) + normrnd(0,0.01,1,N); % expressed trait varies randomly from genetic trait 
    c_exp(c_exp<0) = 0; % apply lower BC
    % c_exp(c_exp>1) = 1; % apply upper BC - not needed due to "natural"
    % upper bound c = 1-d?

    R_sort = [];
    while length(R_sort) < N % loop until enough resource values are picked
        R_sort = [R_sort, random(R_dist, 1, N-length(R_sort))]; % pick resources
        R_sort(R_sort>1) = []; % exclude resources above value 1 (only applicable to distribution E) 
    end

    R_sort = sort(R_sort); % random drawing of resources
    [c_exp_sort, sort_ind] = sort(c_exp); % sort expressed traits
    c_gen_sort = c_gen(tt,sort_ind); % reorder genetic trait value vector
    fit = (1-c_exp_sort).*R_sort; % define fitness of individuals
    fit(fit<0) = 0; % negative fitness is same as fitness = 0 --> no reproduction
    c_new = randsample(c_gen_sort,N,true,fit); % new trait values without mutation
    mut = rand(1,N) < 0.01; % define mutation events
    c_gen_new_no_bc = c_new + mut.*normrnd(0,0.1,1,N); % apply mutations
    c_gen_new_no_bc(c_gen_new_no_bc<0) = 0; c_gen_new_no_bc(c_gen_new_no_bc>1) = 1; % apply bc
    c_gen(tt+1,:) = c_gen_new_no_bc; % update c_gen
end
