using GLM, Plots, DataFrames, Statistics, Random

function sim_r²_k(n, k, reps)
    x, y, result = ones(n, k+1), zeros(n), Float64[]
    for _ in 1:reps
        randn!(view(x, :, 1:k)); sum!(y, x)
        for i in 1:n
            y[i] += randn()
        end
        model = lm(x, y)
        push!(result, r²(model))
    end
    return result
end

function run(k, reps=10000, maxn=200)
    sizes = 10:10:maxn
    r²_q95, r²_q5, r²_mean = Float64[], Float64[], Float64[]

    @time for s in sizes
        @show s
        result = sim_r²_k(s, k, reps)
        push!(r²_mean, mean(result))
        push!(r²_q5, quantile(result, 0.05))
        push!(r²_q95, quantile(result, 0.95))
    end

    scatter(sizes, r²_mean, xlabel="sample size", ylabel="R²", legend=false)
    plot!(sizes, r²_q5, color="black")
    plot!(sizes, r²_q95, color="black")
end
