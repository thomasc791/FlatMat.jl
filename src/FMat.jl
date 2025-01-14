struct FMat{N,T} <: AbstractArray{Int,1}
  data::Vector{T}
  @inline function FMat(vals::Vector{Vector{T}}) where {T}
    N = size(vals, 1)
    flattened = reduce(vcat, vals)
    A = Array{T,1}(undef, N + 1 + size(flattened, 1))
    A[1] = 1
    A[N+2:end] = flattened
    A[2:N+1] = accumulate(+, size(i, 1) for i in vals) .+ 1
    new{N,T}(A)
  end

  @inline function FMat{N,T}(vals::Vector{<:Int}) where {N,T}
    new{N,T}(vals)
  end
end

Base.length(::FMat{N,T}) where {N,T} = N

Base.size(::FMat{N,T}) where {N,T} = (N,)

@inline function Base.getindex(A::FMat{N,T}, i::Int) where {N,T}
  return A.data[A.data[i]+N+1:A.data[i+1]+N]
end

@inline function Base.getindex(A::FMat{N,T}, u::UnitRange) where {N,T}
  i_start = u.start
  i_stop = u.stop
  @views indices = A.data[i_start:i_stop+1] .- A.data[i_start] .+ 1
  a = vcat(indices, A.data[N+A.data[i_start]+1:N+A.data[i_stop+1]])
  return FMat{length(u),T}(a)
end

Base.setindex!(A::FMat{N,T}, ::Int, ::Int) where {N,T} = A

IndexStyle(::Type{<:FMat}) = IndexLinear()
