struct GFMat{T} <: AbstractArray{Int,1}
  indices::Vector{Int}
  data::Vector{T}
  len::Int
  GFMat{T}(vals::Vector{T}, indices::Vector{Int}, n=1) where {T<:Number} = new{T}(indices, vals, n)
end

function GFMat(vvals::Vector{Vector{T}}) where {T<:Number}
  N = length(vvals)
  data = reduce(vcat, vvals)
  indices = Vector{Int}(undef, N + 1)
  indices[1] = 1
  indices[2:N+1] = accumulate(+, size(i, 1) for i in vvals) .+ 1
  GFMat{T}(data, indices, N)
end

function GFMat2(vvals::Vector{Vector{T}}) where {T<:Number}
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
  GFMat{T}(data, indices, N)
end

Base.length(fm::GFMat{T}) where {T} = fm.len

Base.size(fm::GFMat{T}) where {T} = (length(fm),)

@views function Base.getindex(fm::GFMat{T}, i::Int) where {T}
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

Base.setindex!(A::GFMat{T}, ::Int, ::Int) where {T} = A

IndexStyle(::Type{<:GFMat}) = IndexLinear()
