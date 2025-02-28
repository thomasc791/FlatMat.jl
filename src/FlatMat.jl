module FlatMat

using StaticArrays

abstract type AbstractFMat{T} <: AbstractVector{T} end
abstract type AbstractGFMat{T} <: AbstractVector{T} end

include("FMat.jl")
export FMat

include("GFMat.jl")
export GFMat

end
