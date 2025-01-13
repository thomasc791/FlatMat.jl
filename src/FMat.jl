struct FMat{N} <: AbstractArray{Int,1}
  data::Vector{<:Integer}
  @inline function FMat(vals::Vector{Vector{T}}) where {T}
    N = size(vals, 1)
    flattened = reduce(vcat, vals)
    A = Array{T,1}(undef, N + 1 + size(flattened, 1))
    A[1] = 1
    A[N+2:end] = flattened
    A[2:N+1] = accumulate(+, size(i, 1) for i in vals) .+ 1
    new{N}(A)
  end

  @inline function FMat{N}(vals::Vector{<:Int}) where {N}
    new{N}(vals)
  end
end

Base.length(::FMat{N}) where {N} = N

Base.size(::FMat{N}) where {N} = (N,)

@inline function Base.getindex(A::FMat{N}, i::Int) where {N}
  return A.data[A.data[i]+N+1:A.data[i+1]+N]
end

@inline function Base.getindex(A::FMat{N}, u::UnitRange) where {N}
  i_start = u.start
  i_stop = u.stop
  @views indices = A.data[i_start:i_stop+1] .- A.data[i_start] .+ 1
  a = vcat(indices, A.data[N+A.data[i_start]+1:N+A.data[i_stop+1]])
  return FMat{length(u)}(a)
end

Base.setindex!(A::FMat{N}, ::Int, ::Int) where {N} = A

IndexStyle(::Type{<:FMat}) = IndexLinear()
