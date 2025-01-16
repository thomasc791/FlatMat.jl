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

  re1 = Vector{Vector{Int}}()
  for i in 1:7
    nrows = rand(UInt16) + 1
    for _ in 1:nrows
      push!(re1, abs.(rand(Int16, i)))
    end
  end
  fm1 = FMat(re1)

  re2 = Vector{Vector{Int}}()
  for _ in 1:7
    nrows = rand(UInt16) + 1
    for _ in 1:nrows
      push!(re2, abs.(rand(Int16, rand(UInt8))))
    end
  end
  fm2 = FMat(re2)

  gfm1 = GFMat(re1)
  gfm2 = GFMat(re2)

  function array_is_same(fm, re)
    is_same::Bool = true
    for i in eachindex(re)
      is_same &= fm[i] == re[i]
    end
    return is_same
  end

  @testset "FMat" begin
    @test array_is_same(fm1, re1)
    @test array_is_same(fm2, re2)
    @test re1 == fm1
    @test fm1[2:5] == FMat(re1[2:5])
    @test fm1[end:end] == FMat(re1[end:end])
    @test fm1[[end - 1, end]] == FMat(re1[end-1:end])
    @test re2 == fm2
    @test fm2[2:5] == FMat(re2[2:5])
    @test fm2[end:end] == FMat(re2[end:end])
    @test fm2[[end - 1, end]] == FMat(re2[end-1:end])
  end

  @testset "GFMat" begin
    @test array_is_same(fm1, gfm1)
    @test array_is_same(fm2, gfm2)
    @test gfm1 == fm1
    @test gfm1[2:5] == GFMat(re1[2:5])
    @test gfm1[end:end] == GFMat(re1[end:end])
    @test gfm1[[end - 1, end]] == GFMat(re1[end-1:end])
    @test gfm2 == fm2
    @test gfm2[2:5] == GFMat(re2[2:5])
    @test gfm2[end:end] == GFMat(re2[end:end])
    @test gfm2[[end - 1, end]] == GFMat(re2[end-1:end])
  end
end


