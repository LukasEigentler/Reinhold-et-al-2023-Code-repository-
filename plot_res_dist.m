function plot_res_dist(rand_nums,d,x,Rpdf,distribution)
% histogram(rand_nums, d:0.01:1, 'Normalization', 'pdf')
switch distribution
    case "A"
        eq = distribution + ": $f(x) = \frac{2(x-d)}{(1-d)^2}$";
    case "B"
        eq = {distribution + ": $f(x) = \frac{4(x-d)}{(1-d)^2}$ if $x\le\frac{1+d}{2}$", "$f(x) = \frac{4(1-x)}{(1-d)^2}$ if $x\ge \frac{1+d}{2}$"};
    case "C"
        eq = distribution + ": $f(x) = \frac{1}{1-d}$";
    case "D"
        eq = distribution + ": $f(x) = \frac{2(1-x)}{(1-d)^2}$";
    case "E"
        eq = distribution + ": $f(x) = \sqrt{\frac{2}{\pi\sigma^2}}e^{-\frac{(x-\sigma)^2}{2\sigma^2}}$";
    case "F"
        eq = distribution + ": $f(x) = \frac{d}{(1-d)x^2}$";
end
hold on
plot(x, Rpdf, 'k', 'LineWidth', 2)
fill([x,fliplr(x)],[Rpdf,zeros(1,length(x))], 'k')
% xlabel("x")
% ylabel("Prob. density")
% pbaspect([1 1 1])
title(eq, "Interpreter","latex")
xlim([d,1])
xticks([d,1])
xticklabels(["d", "1"])
ylim([0,3])
