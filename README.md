# CDC2024 - ParametricDAQP 

Compares the software packages
* [MPT3](https://www.mpt3.org/)  
* [POP](https://parametric.tamu.edu/POP/)
* [ParametricDAQP.jl](https://github.com/darnstrom/ParametricDAQP.jl)


MPT and POP also requires an external solver such as GLPK, CPLEX, or GUROBI to work sufficiently.

## Generating results for ParametricDAQP.jl 
In a terminal, run
```shell
julia --project=@. ParametricDAQP_benchmark.jl
```
This requires that [Julia](https://julialang.org/) is installed.

## Generating results for MPT 
After starting MATLAB, run 
```shell
>> MPT_benchmark 
```
This requires that [MPT](https://www.mpt3.org/) is installed.

## Generating results for POP 
After starting MATLAB, run 
```shell
>> POP_benchmark 
```
This requires that [POP](https://parametric.tamu.edu/POP/) is installed.
