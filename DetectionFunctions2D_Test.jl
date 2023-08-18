using Test
using Statistics

# Distance calculation tests
@test distance((3,4), (0,0)) == 5

# Detections Tests
target = Target([(-2,1) (-1,1) (0,1) (1,1) (2,1)])
sensor = Sensor((0,0))
detections = makedetections(target, sensor)

expectedsize = 5
@test length(detections) == expectedsize
@test detections[3][1] == 90
@test detections[3][2] == 1

# Make route tests
start = (-50.0,0.0)
stop = (50.0,100.0)
npoints = 500
target = maketarget_linear(start, stop, npoints)
@test length(target.route) == npoints
@test target.route[1] == start
@test isapprox(target.route[end][1] - stop[1], 0.0)
@test isapprox(target.route[end][2] - stop[2], 0.0)

# Noised detections test
start = (-50.0, 10.0)
stop = (50.0, 10.0)
npoints = 1000
target = maketarget_linear(start, stop, npoints)
sensor = Sensor((0.0,0.0))
detections = makedetections(target, sensor)
variance = 0.01
noiseddets = addnoise(detections, variance)
@test length(noiseddets) == npoints
@test mean([noiseddets[i][1] - detections[i][1] for i=eachindex(detections)]) ≈ 0.0 atol=0.01
@test mean([noiseddets[i][2] - detections[i][2] for i=eachindex(detections)]) ≈ 0.0 atol=0.01
@test var([noiseddets[i][1] - detections[i][1] for i=eachindex(detections)]) ≈ variance atol=0.01
@test var([noiseddets[i][2] - detections[i][2] for i=eachindex(detections)]) ≈ variance atol=0.01