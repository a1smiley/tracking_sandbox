"""
    distance(point1::Tuple, point2::Tuple)

Compute the straight line distance between point1 and point2 in 2D space.
"""
function distance(point1, point2) 
    hypot(point1[1] - point2[1], point1[2] - point2[2])
end

"""
    define_line(start, stop)

Return the slope and y-intercept of a line intercepting the start and stop points in 2D space.
"""
function define_line(start, stop)
    slope = (stop[2] - start[2])/(stop[1]-start[1])
    offset = -slope*start[1] + start[2] # Derived from point-slope formula
    return slope, offset
end

function calc_error(actual, predicted) 
    a = actual[1] - predicted[1]
    b = actual[2] - predicted[2]
    return [a;b]
end