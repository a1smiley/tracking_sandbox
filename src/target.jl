using Random

"""
    Target

An object with motion across the 2D plane.  Time between successive route points specified in seconds
"""
struct Target
    route::Matrix
    timestep
end

"""
    maketarget_ncv(initialstate::Vector, duration, timestepsize, variance)

Near-constant velocity motion model.  Initial state defined as [x_pos, y_pos, x_vel, y_vel].
"""
function maketarget_ncv(initialstate::Vector, duration, timestep, variance)
    T = timestep
    statetransition = [ 1 0 T 0
                        0 1 0 T
                        0 0 1 0
                        0 0 0 1]

    tsquare = 0.5*(T^2)
    inputgain = [tsquare  0
                 0        tsquare
                 T        0
                 0        T]

    ncvmodel = StateSpaceModel(statetransition, inputgain, zeros(2,2))
    time = range(start = 0, step = T, stop = duration)
    velocity_noise = sqrt(variance).*randn((2,length(time)))
    return maketarget_statespace(ncvmodel, initialstate, velocity_noise, timestep)
end

"Generates a target with motion defined by the provided StateSpaceModel"
function maketarget_statespace(model::StateSpaceModel, initialstate::Vector, inputs::Array, timestep)
    # Check state and matrices are compatible
    transition_dims = size(model.F)
    input_dims = size(model.G)
    state_len = length(initialstate)
    if transition_dims[1] != state_len error("Initial state and transition matrix dimensions incompatible") end
    if input_dims[1] != state_len error("Initial state and input gain matrix dimensions incompatible") end

    # Compute points 
    route = initialstate[1:2]
    state = initialstate
    for i = 1:size(inputs, 2)
        state = propagate(model, state, inputs[:,i])
        route = hcat(route, state[1:2])
    end
    return Target(route, timestep)
end