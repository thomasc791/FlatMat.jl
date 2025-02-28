using Revise
using FlatMat
using StaticArrays
using Random.Random

elements = Vector{Vector{Int}}()
for i in 1:7
  nrows = rand(UInt16) + 1
  for _ in 1:nrows
    push!(elements, abs.(rand(Int16, i)))
  end
end
sfm = Vector{SVector}(undef, length(elements))
for i in axes(elements, 1)
  sfm[i] = SVector{length(elements[i]),Int}(elements[i])
end
@time gfm = GFMat(elements)

elementsfm = Vector{Vector{Int}}()
nrows = rand(UInt16) + 1
for _ in 1:nrows
  push!(elementsfm, abs.(rand(Int16, 4)))
end
@time fm = FMat(elements)
