"Initializer for 2D linear motion model, assuming measurements in the form (angle, range, time)"
function initial_kinematic_determination(sensor::Sensor, ob_1::Tuple, ob_2::Tuple)::Vector
    pos_1 = az_range_to_cartesian(ob_1, sensor)
    pos_2 = az_range_to_cartesian(ob_2, sensor)
    elapsed_time = ob_2[3] - ob_1[3]

    # Convert positions to initial state
    x_pos = pos_2[1]
    y_pos = pos_2[2]
    x_vel = (pos_2[1] - pos_1[1])/elapsed_time
    y_vel = (pos_2[2] - pos_1[1])/elapsed_time
    return [x_pos, y_pos, x_vel, y_vel]
end