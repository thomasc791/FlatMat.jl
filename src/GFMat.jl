"""
    GFMat{T} <: AbstractVector{Int}

A contiguously stored array, that behaves like a `A::Vector{Vector{T}}`, takes up less than half the size. The field `data` stores all elements and has size `sum(length, A)`. The field `indices` stores the index of `last(elements[i])`. GFMat is a generalized version of FMat which can take any `Type{<:Number}`.
"""
struct GFMat{T} <: AbstractGFMat{T}
  indices::Vector{Int}
  data::Vector{T}
  GFMat{T}(vals::Vector{T}, indices::Vector{Int}, n=1) where {T<:Number} = new{T}(indices, vals)
end

"""
    GFMat(vvals::Vector{Vector{T}}) where {T<:Number}

Construct a `GFMat` using a vector of vectors of type `T`. Uses the method of [DNF](https://discourse.julialang.org/t/help-with-reducing-allocations-when-indexing-into-custom-array/124732/3?u=thomasc791)
"""
function GFMat(vvals::Vector{Vector{T}}) where {T<:Number}
  N = length(vvals)
  M = sum(length, vvals)
  data = Vector{T}(undef, M)
  indices = Vector{T}(undef, N + 1)
  indices[1] = 1
  len = 0
  i, j = 1, 0
  for vals in vvals
    indices[i+=1] = (len += length(vals)) + 1
  end
  for vals in vvals
    for val in vals
      data[j+=1] = val
    end
  end
  GFMat{T}(data, indices)
end

Base.length(fm::GFMat{T}) where {T} = length(fm.indices) - 1

Base.size(fm::GFMat{T}) where {T} = (length(fm),)

function Base.getindex(fm::GFMat{T}, i::Int) where {T}
  return fm.data[fm.indices[i]:fm.indices[i+1]-1]
end

function Base.getindex(fm::GFMat{T}, u::UnitRange) where {T}
  i_start = first(u)
  i_stop = last(u)
  N = length(fm)
  indices = @views fm.indices[i_start:i_stop+1] .- fm.indices[i_start] .+ 1
  data = fm.data[fm.indices[i_start]:fm.indices[i_stop+1]-1]
  return GFMat{T}(data, indices, length(u))
end

function Base.getindex(fm::GFMat{T}, I) where {T}
  return GFMat([fm[i] for i in I])
end

Base.setindex!(A::GFMat{T}, ::Int, ::Int) where {T} = A

IndexStyle(::Type{<:GFMat}) = IndexLinear()
