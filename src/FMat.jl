"""
    FMat{T} <: AbstractVector{Int}

A contiguously stored array, that behaves like a `A::Vector{Vector{T}}`, takes up less than half the size.
"""
struct FMat{T} <: AbstractVector{T}
  data::Vector{<:NTuple}

  FMat{T}(A::Vector{NT}) where {T,NT} = new{T}(A)
end

"""
    FMat(elements::Vector{Vector{T}}) where {T<:Integer}

Construct a FMat with elements stored contiguously in memory.
"""
function FMat(elements::Vector{Vector{T}}) where {T}
  A = Vector{NTuple}(undef, length(elements))
  @views for i in axes(elements, 1)
    element::Vector{T} = elements[i]
    A[i] = Tuple(e for e in element)
  end
  FMat{T}(A)
end

Base.length(fm::FMat{T}) where {T} = length(fm.data)

Base.size(fm::FMat{T}) where {T} = (length(fm),)

function Base.getindex(A::FMat{T}, i::Int) where {T}
  return A.data[i]
end

function Base.getindex(A::FMat{T}, u::UnitRange) where {T}
  start = first(u)
  stop = last(u)
  return FMat{T}(A.data[start:stop])
end

function Base.getindex(fm::FMat{T}, I) where {T}
  return FMat{T}([fm[i] for i in I])
end

Base.setindex!(A::FMat{T}, ::Int, ::Int) where {T} = A

IndexStyle(::Type{<:FMat}) = IndexLinear()
