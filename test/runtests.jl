using FlatMat
using Random.Random
using Test
using Aqua
using JET

@testset "FlatMat.jl" begin
  # @testset "Code quality (Aqua.jl)" begin
  #   Aqua.test_all(FlatMat)
  # end
  # @testset "Code linting (JET.jl)" begin
  #   JET.test_package(FlatMat; target_defined_modules=true)
  # end

  elements = Vector{Vector{Int}}()
  for i in 1:7
    nrows = rand(UInt8) + 1
    for _ in 1:nrows
      push!(elements, abs.(rand(Int16, i)))
    end
  end
  fm = FMat(elements)

  function array_is_same()
    is_same::Bool = true
    for (i, val) in enumerate(elements)
      is_same = is_same && fm[i] == val
    end
    return is_same
  end

  @test array_is_same()
  @test fm[1:end] == FMat(elements[1:end])
  @test fm[2:5] == FMat(elements[2:5])
  @test fm[end:end] == FMat(elements[end:end])

  # @test FMat([])
  # @test FMat([[], []])
end
