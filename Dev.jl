module Dev
    include("src/TargetTracking.jl")
    using .TargetTracking

    # Script start
    target = maketarget_ncv([0;0;1;1], 10, 1, 0.0001)
    @info "($target)"

    sensor = Sensor((-3,5))
    @info "($sensor)"

    variance = 0.001
    detections = makenoiseddets(target, sensor, variance)
    @info "($detections)"

    gain = [1 0
            0 0
            0 1
            0 0]
    @info "($gain)"
    
    track = track_cv_target(sensor, detections, gain, 1)
    @info "Tracking data created"

    

    export track, target, plot_scenario
end