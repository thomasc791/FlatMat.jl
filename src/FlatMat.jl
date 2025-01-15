module FlatMat

abstract type AbstractFMat{T} <: AbstractVector{T} end
abstract type AbstractGFMat{T} <: AbstractVector{T} end

include("FMat.jl")
export FMat
export FMat2

include("GFMat.jl")
export GFMat
export GFMat2

end
