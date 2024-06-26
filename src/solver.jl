Base.@kwdef struct SARSOPSolver{LOW,UP} <: Solver
    epsilon::Float64    = 0.5
    precision::Float64  = 1e-3
    kappa::Float64      = 0.5
    delta::Float64      = Inf
    max_time::Float64   = 1.0
    max_steps::Int      = typemax(Int)
    verbose::Bool       = true
    init_lower::LOW     = BlindLowerBound(bel_res = 1e-2)
    init_upper::UP      = FastInformedBound(bel_res=1e-2)
    prunethresh::Float64= 0.10
    consistency_fix_thresh=1e-14
end

function POMDPTools.solve_info(solver::SARSOPSolver, pomdp::POMDP; max_iter=Inf, prune_flag=true, prune_tree_flag=true)
    tree = SARSOPTree(solver, pomdp)

    t0 = time()
    iter = 0
    while time()-t0 < solver.max_time && root_diff(tree) > solver.precision && iter <= max_iter
        sample!(solver, tree)
        backup!(tree)
        prune!(solver, tree, prune_flag, prune_tree_flag, iter)
        iter += 1
    end

    pol = AlphaVectorPolicy(
        pomdp,
        getproperty.(tree.Γ, :alpha),
        ordered_actions(pomdp)[getproperty.(tree.Γ, :action)]
    )
    return pol, (;
        time = time()-t0, 
        tree,
        iter
    )
end

POMDPs.solve(solver::SARSOPSolver, pomdp::POMDP) = first(solve_info(solver, pomdp))
