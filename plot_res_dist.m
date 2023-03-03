function plot_res_dist(rand_nums,d,x,Rpdf,distribution)
histogram(rand_nums, d:0.01:1, 'Normalization', 'pdf')
hold on
plot(x, Rpdf, 'r', 'LineWidth', 2)
xlabel("x")
ylabel("Prob. density")
pbaspect([1 1 1])
title(distribution)