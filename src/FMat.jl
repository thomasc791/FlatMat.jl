"""
    FMat{T} <: AbstractVector{Int}

A contiguously stored array, that behaves like a `A::Vector{Vector{T}}`, takes up less than half the size. The field `data` stores all the pointers and elements and has size `length(A) + 1 + sum(length, A)`. `FMat` can only take `Integer` as values, since the pointer and elements are stored in the same vector.
"""
struct FMat{T} <: AbstractVector{Int}
  data::Vector{T}
  len::Int

  FMat{T}(vals::Vector{T}, n=1) where {T<:Integer} = new{T}(vals, n)
end

"""
    FMat(elements::Vector{Vector{T}}) where {T<:Integer}

Construct an `FMat` using a vector of vectors of type `T`. Uses the method of [DNF](https://discourse.julialang.org/t/help-with-reducing-allocations-when-indexing-into-custom-array/124732/3?u=thomasc791)
"""
function FMat(elements::Vector{Vector{T}}) where {T<:Integer}
  N = length(elements)
  M = sum(length, elements)
  A = Vector{T}(undef, N + 1 + M)
  A[1] = 1
  len = 0
  i, j = 1, N + 1
  for v in elements
    A[i+=1] = (len += length(v)) + 1
  end
  for v in elements
    for val in v
      A[j+=1] = val
    end
  end
  FMat{T}(A, N)
end

Base.length(fm::FMat{T}) where {T} = fm.len

Base.size(fm::FMat{T}) where {T} = (length(fm),)

function Base.getindex(A::FMat{T}, i::Int) where {T}
  len = A.len
  return A.data[A.data[i]+len+1:A.data[i+1]+len]
end

function Base.getindex(A::FMat{T}, u::UnitRange) where {T}
  i_start = first(u)
  i_stop = last(u)
  N = length(A)
  indices = @views A.data[i_start:i_stop+1] .- A.data[i_start] .+ 1
  a = vcat(indices, A.data[N+A.data[i_start]+1:N+A.data[i_stop+1]])
  return FMat{T}(a, length(u))
end

function Base.getindex(fm::FMat{T}, I) where {T}
  return FMat([fm[i] for i in I])
end

Base.setindex!(A::FMat{T}, ::Int, ::Int) where {T} = A

IndexStyle(::Type{<:FMat}) = IndexLinear()
