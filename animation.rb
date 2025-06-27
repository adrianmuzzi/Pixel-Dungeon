require 'gosu'

class Animation
    def initialize(frames, time_in_secs)
        @frames = frames
        @time = time_in_secs * 1000
        # Variables tracking single play animations
        @start_time = Gosu::milliseconds
        @finished = false
    end

    # If being drawn, loop the animation
    def play_loop
        @frames[Gosu::milliseconds / @time % @frames.size]
    end

    # If being drawn, play animation once,
    # the continuously return the last frame
    def play_once
        if @finished
            return @frames.last
        end

        # Find current frame from animation run time
        current_time = Gosu::milliseconds
        elapsed_time = current_time - @start_time
        current_frame_index = elapsed_time / @time

        # Return frame to draw to calling function
        if current_frame_index < @frames.size
            @frames[current_frame_index]
        else
            @finished = true
            @frames.last
        end
    end

    # Called to reset animation to first frame
    # and the start time of the animation to now
    def reset
        @start_time = Gosu::milliseconds
        @finished = false
    end
end