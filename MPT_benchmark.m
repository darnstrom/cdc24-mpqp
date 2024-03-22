%% Load problems
load('test_set.mat')
%% Solve problems
ts = zeros(100,1);
nCRs = zeros(100,1);
%mptopt('time_limit',100); % Custom modification. Comment out if error
mptopt('report_period',5);
mptopt('lpsolver','GLPK');
profile on
for i = 1:100 
    fprintf('============= Solving %d/100  =============\n',i);
    S = Opt('H', problem(i).Q,...
        'f' , problem(i).c ,...
        'pf' , problem(i).Ht,...
        'A' , problem(i).A,...
        'b' , problem(i).b,...
        'pB' , problem(i).F,...
        'Ath' , problem(i).CRA,...
        'bth' , problem(i).CRb)
    sol = mpt_solvemp(S)
    if(strcmp(sol.how,'ok'))
        ts(i) = sol.stats.solveTime;
    else
        ts(i) = 1e12;
    end
    nCRs(i) = sol.xopt.Num;
end
%% Write to file
if ~exist('result', 'dir')
    mkdir('result')
end
fmt = sprintf('%s\n',repmat( ' %u',1,3));
fid = fopen('result/MPT_result.dat','wt');
fprintf(fid,'problem time nCR \n');
fprintf(fid,fmt,[(1:100)' ts nCRs]');
fclose(fid);
