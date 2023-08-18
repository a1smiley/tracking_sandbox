using Test
using TargetTracking

@testset  begin
    F = [2]
    G = [1]
    H = [1]
    model = StateSpaceModel(F, G, H)
    state = [5]
    @test propagate(model, state) ≈ 5
end