% TODO Terminate mpQP solver after certain time has exceeded 
% TODO Find reason for "Unexpected failure in QP solver when determining a feasible parameter" 
%% Load problems
load('test_set.mat')
%% Expose private function by cd
dir = strcat(toolboxdir('mpc'),'/mpc/@explicitMPC/private');
cd(dir)
%% Solve problems
mpc_opts = generateExplicitOptions(mpc)
ts = zeros(100,1);
nCRs = zeros(100,1);
for i = 1:100
    fprintf('============= Solving %d/100  =============\n',i);
    sol = computeMPQP(problem(i).Q,...
        problem(i).Ht,...
        problem(i).c,...
        problem(i).A,...
        problem(i).b,...
        problem(i).F,...
        problem(i).Tmin,...,
        problem(i).Tmax,...
        true,...
        mpc_opts)
end
%% Write to file
if ~exist('result', 'dir')
    mkdir('result')
end
fmt = sprintf('%s\n',repmat( ' %u',1,3));
fid = fopen('result/MPCTBX_result.dat','wt');
fprintf(fid,'problem time nCR \n');
fprintf(fid,fmt,[(1:100)' ts nCRs]');
fclose(fid);
