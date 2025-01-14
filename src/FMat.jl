struct FMat{T} <: AbstractArray{Int,1}
  data::Vector{T}
  len::Int
  FMat{T}(vals::Vector{T}, n=1) where {T<:Integer} = new{T}(vals, n)
end

function FMat(vals::Vector{Vector{T}}) where {T<:Integer}
  N = length(vals)
  M = sum(length, vals)
  flattened = reduce(vcat, vals)
  A = Vector{T}(undef, N + 1 + M)
  A[1] = 1
  A[N+2:end] = flattened
  A[2:N+1] = accumulate(+, size(i, 1) for i in vals) .+ 1
  FMat{T}(A, N)
end

function FMat2(elements::Vector{Vector{T}}) where {T<:Integer}
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

@views function Base.getindex(A::FMat{T}, i::Int) where {T}
  len = A.len
  return A.data[A.data[i]+len+1:A.data[i+1]+len]
end

@views function Base.getindex(A::FMat{T}, u::UnitRange) where {T}
  i_start = first(u)
  i_stop = last(u)
  N = length(A)
  indices = @views A.data[i_start:i_stop+1] .- A.data[i_start] .+ 1
  a = vcat(indices, A.data[N+A.data[i_start]+1:N+A.data[i_stop+1]])
  return FMat{T}(a, length(u))
end

Base.setindex!(A::FMat{T}, ::Int, ::Int) where {T} = A

IndexStyle(::Type{<:FMat}) = IndexLinear()
