struct LinearEstimatorConfig
    prop_model::StateSpaceModel
    initializer::Function
    gainfunc::Function
end

"2D cartesian coordinate to (az, rng) measurement conversion"
function cartesian_to_az_range(position::Vector, sensor::Sensor)
    range = distance(position, sensor.location)
    azimuth = atand(position[2], position[1])
    return (azimuth, range)
end

"(az, rng) measurement to 2D cartesian coordinate conversion"
function az_range_to_cartesian(measurement::Tuple, sensor::Sensor)
    az_range_to_cartesian(measurement[1], measurement[2], sensor)
end

function az_range_to_cartesian(azimuth, range, sensor::Sensor)::Vector
    # Calculate x, y assuming centered at origin
    x = range*cosd(azimuth)
    y = range*sind(azimuth)
    # Offset based on actual sensor location
    x = x + sensor.location[1]
    y = y + sensor.location[2]
    return [x, y]
end

"Track a target assuming that it is moving with constant velocity"
function tracker_iterative(config::LinearEstimatorConfig, detections)::Track
    state = zeros(4,1)
    prediction = zeros(4,1)
    state_history = zeros(4, length(detections))
    @info "Entering tracking loop"
    for i in eachindex(detections)
        state, initial_state_not_ready = config.initializer(detections[i])
        if initial_state_not_ready
            continue
        end
        @info "Initial state estimate as ($state)"

        prediction = propagate(config.model, state)
        @info "predicted state is ($prediction)"

        expected_measurement = output(config.model, state)
        @info "predicted measurement is ($expected_measurement)"

        det = detections[i][1:2]
        @info "actual measurement is ($det)"

        error = calc_error(det, expected_measurement)
        @info "calculated error is ($error)"

        gain = config.gainfunc()
        @info "gain is ($gain)"

        state = prediction + gain*error
        @info "corrected state is ($state)"

        state_history[:, i] = state
    end
    @info "Exited tracking loop"
    return Track(state, state_history)
end

function tracker_batch()