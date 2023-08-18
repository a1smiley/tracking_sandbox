using Gadfly

function plot_target(target::Target)
    plot(x = target.route[1,:], y = target.route[2,:], 
    Geom.line, Geom.point,
    Guide.xlabel("X Position"), Guide.ylabel("Y Position"))
end

function plot_track(track::Track)
    plot(x = track.state_history[1,:], y = track.state_history[2,:],
    Geom.line, Geom.point,
    Guide.xlabel("X̂ Position"), Guide.ylabel("Ŷ Position"))
end

function plot_scenario(target::Target, track::Track)
    p1 = plot()
    push!(p1, layer(x = target.route[1,:], y = target.route[2,:], 
    Geom.line, Geom.point, color=[colorant"blue"]))
    push!(p1, layer(x = track.state_history[1,:], y = track.state_history[2,:],
    Geom.line, Geom.point, color=[colorant"red"]))
    push!(p1, Guide.xlabel("X Position"), Guide.ylabel("Y Position"))

    p2=plot(x = target.route[3,:], y = target.route[1, :] .- track.state_history[1,:],
    Geom.line, Geom.point, color=[colorant"red"],
    Guide.xlabel("Time [s]"), Guide.ylabel("X error"))
    p3=plot(x = target.route[3,:], y = target.route[2, :] .- track.state_history[2,:],
    Geom.line, Geom.point, color=[colorant"red"],
    Guide.xlabel("Time [s]"), Guide.ylabel("Y error"))

    vstack(p1, hstack(p2, p3))
end

