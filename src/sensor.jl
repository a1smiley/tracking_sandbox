using Random
using Logging
"""
    Sensor

A detection generator (no phenomenology currently defined), located on the 2D plane.
"""
struct Sensor
    location::Tuple
end

function makenoiseddets(target::Target, sensor::Sensor, variance)
    detections = makedetections(target, sensor)
    return addnoise(detections, variance)
end

function makedetections(target::Target, sensor::Sensor)
    detections = []
    time = 0.0
    for i in 1:size(target.route, 2)
        range = distance(target.route[:,i], sensor.location)
        angle = atand(target.route[2,i], target.route[1,i])
        time = time + target.timestep
        detection = (angle, range, time)
        detections = vcat(detections, detection)
    end
    return detections
end

function addnoise(detections, variance)
    angle_noise = sqrt(variance).*randn(size(detections))
    range_noise = sqrt(variance).*randn(size(detections))
    
    # Assemble noised detections
    noiseddets = []
    for i in eachindex(detections)
        noiseddets = vcat(noiseddets, (detections[i][1]+angle_noise[i], detections[i][2]+range_noise[i], detections[i][3]))
    end
    return noiseddets
end