function [R_dist,Rpdf,x] = res_dist(d, distribution)
% res_dist defines the cdf and pdf of the resource distribution used
%
% Author: Lukas Eigentler (lukas.eigentler@uni-bielefeld.de)
% License: GNU GPL
% Last updated: 28/02/2023

x = linspace(d,1,1000);
switch distribution
    case "A"
        Rcdf = -x/(d - 1) + d/(d - 1); % resource dist cdf
        Rpdf = 1/(1 - d)*ones(1,length(x)); % resource dist pdf
    case "B"
        Rcdf = -x.*(-2 + x)/(d - 1)^2 + d*(-2 + d)/(d - 1)^2; % resource dist cdf
        Rpdf = 2*(1 - x)/(d - 1)^2; % resource dist pdf
    case "C"
        Rcdf = (-2*d*x + x.^2)/(d - 1)^2 + d^2/(d - 1)^2; % resource dist cdf
        Rpdf = 2*(x - d)/(d - 1)^2; % resource dist pdf
    case "D"
        x1 = x(x<(d+1)/2); x2 = x(x>(d+1)/2);
        Rcdf = 1/(d-1)^2*(2*d^2 + [2*x1.*(x1 - 2*d),-d^2 - 2*x2.^2 - 2*d + 4*x2 - 1]); % resource dist cdf
        Rpdf = [(4*(x1-d))/(d^2-2*d+1), (4*(1-x2))/(d^2-2*d+1)]; % resource dist pdf
    case "E"
        sd = (1-d)/3;
        x = linspace(d,10,1000);
        Rcdf = erf((x-d)/(sqrt(2)*sd));
        Rpdf = sqrt(2/(2*sd^2))*exp(-(x - d).^2/(2*sd^2)); % resource dist pdf
    case "F"
        Rcdf = d./((d - 1)*x) - 1/(d - 1); % resource dist cdf
        Rpdf = d./((1 - d)*x.^2); % resource dist pdf
end
Rcdf(end) = 1; Rcdf(1) = 0;

R_dist = makedist('PiecewiseLinear', 'x', x, 'Fx', Rcdf);