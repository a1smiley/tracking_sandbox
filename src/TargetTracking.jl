module TargetTracking
export
    # Types
    Target,
    Sensor,
    Track,
    StateSpaceModel,
    inearEstimatorConfig,

    # Functions
    maketarget_ncv,
    maketarget_statespace,
    makedetections,
    makenoiseddets,
    propagate,
    output,
    tracker_batch,
    tracker_iterative,
    plot_target,
    plot_track,
    plot_scenario

include("utility.jl")
include("statespacemodel.jl")
include("target.jl")
include("sensor.jl")
include("track.jl")
include("linear_estimator.jl")
include("plotting.jl")
end