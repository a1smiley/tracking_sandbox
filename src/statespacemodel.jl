"""
    StateSpaceModel

The state space representation for a linear system. Notation per Bar-Shalom's "Estimation with Applications to Navigation and Tracking",
with extension for measurement passthrough term, "D".

# Fields
- `F::Matrix`: State transition matrix
- `G::Matrix`: Input gain matrix
- `Γ::Matrix`: Process noise gain matrix
- `H::Matrix`: State-to-measurement transformation matrix
- `D::Matrix`: Input-to-measurement gain matrix (typcally zero)
"""
struct StateSpaceModel
    additive_noise::Bool
    F::Matrix
    G::Matrix
    Γ::Matrix
    H::Matrix
    D::Matrix
end

StateSpaceModel(F, G, H) = StateSpaceModel(true, F, G, zeros(2,2), H, zeros(2,2))
StateSpaceModel(F, G, Γ, H, D) = StateSpaceModel(false, F, G, Γ, H, D)

"Propagate linear state with no control input"
function propagate(model::StateSpaceModel, state::Vector)
    model.F*state
end

"Propagate linear state with control input"
function propagate(model::StateSpaceModel, state::Vector, input::Vector)
    model.F*state + model.G*input
end

"Propagate linear state with control input and process noise"
function propagate(model::StateSpaceModel, state::Vector, input::Vector, noise::Vector)
    model.F*state + model.G*input + model.Γ*noise
end

function output(model::StateSpaceModel, state::Vector)
    model.H*state
end

function output(model::StateSpaceModel, state::Vector, input::Vector)
    model.H*state + model.D*input

"Discrete-time constant velocity motion model"
function make_cv_model(timestepsize)::StateSpaceModel
    T = timestepsize
    statetransition = [ 1 0 T 0
                        0 1 0 T
                        0 0 1 0
                        0 0 0 1]
    return StateSpaceModel(statetransition, zeros(2,2), zeros(2,2))
end