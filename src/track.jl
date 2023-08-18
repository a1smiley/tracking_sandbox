
"""
    Track

The current estimate of a target's position, as well as the history of the estimate position.
"""
struct Track
    state::Vector
    state_history::Matrix
end

function update_state!(track::Track, newstate::Vector)
    hcat(track.history, newstate)
    track.state = newstate
    return nothing
end