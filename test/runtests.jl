using FlatMat
using Test
using Aqua
using JET

@testset "FlatMat.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(FlatMat)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(FlatMat; target_defined_modules = true)
    end
    # Write your tests here.
end
