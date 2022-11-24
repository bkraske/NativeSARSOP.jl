# NativeSARSOP

## Installation

It is recommended that you have [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) installed. To install SARSOP run the following command:

```julia
] add https://github.com/JuliaPOMDP/NativeSARSOP.jl
```

## Example Usage
```julia
using POMDPs
using NativeSARSOP
using POMDPModels

pomdp = TigerPOMDP()
solver = SARSOPSolver()
policy = solve(solver, pomdp)
```