## Init
using Pkg, MAT, DelimitedFiles
Pkg.add(url="https://github.com/darnstrom/ParametricDAQP.jl", rev="main")
using ParametricDAQP
## Read mpQPs from .mat 
mat = matread("test_set.mat")
problem = mat["problem"]
problems = Any[]

for i = 1:100
    m,n = size(problem["A"][i]);
    mth,nth = size(problem["CRA"][i])
    A,b,W = zeros(m,n),zeros(m),zeros(m,nth) 
    A[:] = problem["A"][i]
    b[:] = problem["b"][i]
    W[:] = problem["F"][i]

    H,f,f_theta = zeros(n,n),zeros(n),zeros(n,nth) 
    if(n==1)
        H[:] .= problem["Q"][i]
        f[:] .= problem["c"][i]
    else
        H[:] = problem["Q"][i]
        f[:] = problem["c"][i]
    end
    if(nth == 1 & n == 1)
        f_theta[:].=problem["Ht"][i]
    else
        f_theta[:]=problem["Ht"][i]
    end

    bounds_table = collect(1:m);
    mpQP = (A = A, b = b, W = W,
            H = H, f = f, f_theta=f_theta,
            bounds_table = bounds_table,
            senses = zeros(Int32,m)
           )
    mth = 0
    Ath,bth = zeros(nth,mth), zeros(mth)
    lb,ub = zeros(nth),zeros(nth)
    if(nth==1)
        ub[:] .= problem["Tmax"][i]
        lb[:] .= problem["Tmin"][i]
    else
        ub[:] = problem["Tmax"][i]
        lb[:] = problem["Tmin"][i]
    end
    P_theta = (A=Ath, b = bth, ub = ub, lb = lb)
    push!(problems,(mpQP=mpQP,P_theta=P_theta))
end

## Run the benchmarks 
opts = ParametricDAQP.EMPCSettings();
opts.verbose= 0;
opts.time_limit =100;

excluded_problems = []; # Problems to remove from the test set

ts, nCRs = zeros(100), zeros(100)

# Warm up (for compilation)
ParametricDAQP.mpsolve(problems[1].mpQP,problems[1].P_theta;opts);

# Start solving the problems 
for (i,p) in enumerate(problems)
    println("$i/$(length(problems))")
    if i in excluded_problems
        ts[i],nCRs[i] = Inf, 0
        continue
    end
    F,info = ParametricDAQP.mpsolve(p.mpQP,p.P_theta;opts);
    ts[i],nCRs[i] = info.solve_time, info.nCR
end

## Write reuslt to file 
isdir("result") || mkdir("result");

open("result/ParametricDAQP_result.dat"; write=true) do f
  write(f, "problem time nCR \n")
  writedlm(f, [collect(1:100) ts nCRs])
end

