using FlatMat
using Random.Random

elements = Vector{Vector{Int}}()
for i in 1:7
  nrows = rand(UInt16) + 1
  for _ in 1:nrows
    push!(elements, abs.(rand(Int16, i)))
  end
end
fm = FMat(elements)
