%% Load problems
load('test_set.mat')
%% Solve problems
ts = zeros(100,1)
nCRs = zeros(100,1)

opts.TimeMax = 100
opts.Progress = 'None'
for i = 1:100 
    fprintf('============= Solving %d/100  =============\n',i);
    [sol, time, outer] = mpQP(problem(i),opts);
    ts(i) = time.Total;
    nCRs(i) = size(sol,1);
end
%% Write to file
if ~exist('result', 'dir')
    mkdir('result')
end
fmt = sprintf('%s\n',repmat( ' %u',1,3));
fid = fopen('result/POP_result.dat','wt');
fprintf(fid,'problem time nCR \n');
fprintf(fid,fmt,[(1:100)' ts nCRs]');
fclose(fid);
