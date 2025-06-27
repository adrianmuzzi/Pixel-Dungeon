require 'gosu'
require_relative 'tiles'

###### Class housing utility functions/procedures ######
###### used by the player and enemies             ######

class Character
    # Function used to detect collisions with wall tiles.
    # If attempted movement is valid, return true.
    def valid_movement?(x, y)
        # Find the coordinates of each corner of the hitbox
        corners = [
        topleft_corner = [x + @hitbox_offset_x, y + @hitbox_offset_y],
        topright_corner = [x + @hitbox_offset_x + hitbox_dim_x, y + @hitbox_offset_y],
        bottomleft_corner = [x + @hitbox_offset_x, y + hitbox_dim_y + @hitbox_offset_y],
        bottomright_corner = [x + @hitbox_offset_x + hitbox_dim_x, y + 
                            hitbox_dim_y + @hitbox_offset_y]
        ] 

        # Container for the outcome of each check
        checks = Array.new

        # Check for collisions with wall tiles on each corner.
        corners.each do |corner|
            tile_x = (corner[0] / TILE_DIMENSION)
            tile_y = (corner[1] / TILE_DIMENSION)
            base_tile = @base_tiles[tile_x][tile_y]
            prop_tile = @prop_tiles[tile_x][tile_y]
            
            # On player collision with a score tile, increment score
            if (@type == "player" && prop_tile != nil && prop_tile.score)
                puts "You scored!"
                @prop_tiles[tile_x][tile_y] = nil
                @score += 1
            end

            if prop_tile != nil
                if base_tile.wall || prop_tile.wall
                    check = true
                    checks << check
                else
                    check = false
                    checks << check
                end
            else
                if base_tile.wall
                    check = true
                    checks << check
                else
                    check = false
                    checks << check
                end
            end
        end

        # If any check returned true, block movement.
        if checks[0] || checks[1] || checks[2] || checks[3]
            return false
        else
            return true
        end
    end

    # Flip alive controlling variable
    def die
        @alive = false
    end

end