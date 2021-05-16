function figln()
hold on;
grid on;
for fc = [1e9,2e9,3e9,4e9,5e9]
%     fc=1500000000;
    d0=1;
    n=0.8;
    d=0:0.1:20;
    sigma=0.3;
    
    PL=PL_logdist_or_norm(fc,d,1,n,sigma);
    plot(d,PL,'linewidth',1.5);
end
xlabel('Distance (m)','fontsize',15);
ylabel('Path Loss (dBm)','fontsize',15);
legend('1GHz','2GHz','3GHz','4GHz','5GHz','Location','southeast','fontsize',15);
end

function PL=PL_logdist_or_norm(fc,d,d0,n,sigma)
% Log-distance or Log-normal shadowing path loss model
% Inputs: fc : Carrier frequency[Hz]
% d : Distance between base station and mobile station[m]
% d0 : Reference distance[m]
% n : Path loss exponent
% sigma : Variance[dB]

lamda=3e8/fc; PL= -20*log10(lamda/(4*pi*d0))+10*n*log10(d/d0); % Eq.(1.4)
PL = PL + sigma*randn(size(d));
end % Eq.(1.5)

function PL=PL_free(fc,d,Gt,Gr)
% Free Space Path Loss Model
% Inputs: fc : Carrier frequency[Hz]
% d : Distance between base station and mobile station[m]
% Gt/Gr : Transmitter/Receiver gain
% Output: PL : Path loss[dB]
lamda = 3e8/fc; tmp = lamda./(4*pi*d);
if nargin&gt;2, tmp = tmp*sqrt(Gt); end
if nargin&gt;3, tmp = tmp*sqrt(Gr); end
PL = -20*log10(tmp); % Eq.(1.2)/(1.3)
end