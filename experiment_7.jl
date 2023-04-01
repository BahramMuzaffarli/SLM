using Statistics
using DataFrames

function test(μ)
    result = [m + 3 * randn() for m in μ]
    est1 = result
    μ₀ = fill(20, length(μ))
    est2 = μ₀ + max((1 - 1 / sum(x -> x^2, result - μ₀)), 0.0) * (result - μ₀)
    return (MSE1 = mean(x -> x^2, est1 - μ),
            MSE2 = mean(x -> x^2, est2 - μ))
end

experiment = DataFrame()
for i in 1:1_000_000
    push!(experiment, test([16, 18, 26]))
end
describe(experiment, :detailed)
