require 'gosu'
require_relative 'animation'

#############      Ghast       ##############
#############   Enemy Object   ##############

class Ghast < Character # Inherit functions from Character class
    # These attributes need to be readable for collison detection.
    attr_reader :type, :x, :y, :hitbox_dim_x, :hitbox_dim_y, :hitbox_x, :hitbox_y, 
                :bullets

    # Specify size of sprite tiles
    CHARACTER_SPRITE_DIM = 96

    def initialize(x, y, base_tiles, prop_tiles)
        @type = "ghast"
        # Initialise position and status variables
        @x = x
        @y = y

        @base_tiles = base_tiles
        @prop_tiles = prop_tiles

        @direction = :none
        @select_direction_timer = 0
        @facing = :right

        @attacking = false # In attack state
        @attack_state_timer = 0 # Manages duration of attack state
        @attack_cooldown = rand(200..400) # Timer between attacks

        @alive = true

        # Holders for child objects
        @shooters = Array.new()
        @bullets = Array.new()

        # The spritesheet tiles don't centre the sprites, so some 
        # manual adjusting of hitboxes is required.
        # Setup initial hitbox location, then update every frame:
        @hitbox_dim_x = 45
        @hitbox_dim_y = 60
        @hitbox_offset_x = 25
        @hitbox_offset_y = 35
        @hitbox_x = @x + @hitbox_offset_x
        @hitbox_y = @y + @hitbox_offset_y

        # Load spritesheet and cut into tiles
        spritesheet_file = "ghast96.png"
        @sprites = Gosu::Image.load_tiles('sprites/' + spritesheet_file, 
                    CHARACTER_SPRITE_DIM, CHARACTER_SPRITE_DIM, :tileable => true)

        # Define Animations
        @ami_facing_horizontal = Animation.new(@sprites[0..3], 0.2)
        @ani_facing_up = Animation.new(@sprites[4..7], 0.2)
        @ani_facing_down = Animation.new(@sprites[8..11], 0.2)

        @ani_shoot = Animation.new(@sprites[12..15], 0.3)
        @ani_bullet = Animation.new(@sprites[16..19], 0.2)

        @ani_death = Animation.new(@sprites[24..27], 0.3)
    end

    def move_randomly
        if @select_direction_timer <= 0
            @direction = [:left, :right, :up, :down, :none].sample
            @select_direction_timer = rand(30..40)
        else
            @select_direction_timer -= 1
        end
      
        # Calculate new potential position given direction
        new_x, new_y = @x, @y
        case @direction
        when :none
            @moving = false
            return # Break out of function if no attempted movement
        when :left
            new_x -= 1
        when :right
            new_x += 1
        when :up
            new_y -= 1
        when :down
            new_y += 1
        end
        
        # Check if the movement is valid and update position if it is
        if valid_movement?(new_x, new_y)
            @x, @y = new_x, new_y
            @moving = true
            @facing = @direction
        else
            @moving = false
        end
    end

   # Attack. Reset cooldown and state timer.
    def attack
        @attacking = true

        shooter = GhastShooter.new(@x, @y, @ani_shoot, @ani_bullet, @facing,
                                     @bullets, @base_tiles)
        @shooters << shooter

        @attack_cooldown = rand(300..600)
        @attack_state_timer = 60
        # puts "Ghast Attacking!"
    end

    # Run every frame in game loop update function.
    # Handles enemy status and changes.
    def update        
        # Cleanup dead shooter objects
        @shooters.select!{|shooter| shooter.alive?}
        # Update live shooters
        @shooters.each do |shooter|
            shooter.update
        end

        # Cleanup dead bullet objects
        @bullets.select!{|bullet| bullet.alive}
        # Update live bullets
        @bullets.each do |bullet|
            bullet.update
        end

        if @alive
            # Update hitbox to current position
            @hitbox_x = @x + @hitbox_offset_x
            @hitbox_y = @y + @hitbox_offset_y

            # Trigger attack or decrement attack cooldown.
            if @attack_cooldown <= 0
                attack
            else 
                @attack_cooldown -= 1
            end

            # If attacking, decrement attacking state timer.
            if @attacking
                if @attack_state_timer > 0
                    @attack_state_timer -= 1
                else
                    @attacking = false
                end
            # If not attacking, move        
            else
                move_randomly
                @ani_death.reset # Prepare the death animation
            end
        end
    end

    # Run every frame in game loop draw function
    # If alive, draw enemy given direction.
    def draw
        # Draw hitbox for troubleshooting
=begin
        Gosu.draw_rect(@hitbox_x, @hitbox_y, @hitbox_dim_x, @hitbox_dim_y, 
                        Gosu::Color::rgba(255, 100, 100, 100), ZOrder::MIDDLE)
=end
        if !@alive
            @ani_death.play_once.draw(@x, @y, ZOrder::TOP)
        else
            case @facing
            when :left
                @ami_facing_horizontal.play_loop.draw(@x + CHARACTER_SPRITE_DIM, @y, 
                                                    ZOrder::TOP, -1)
            when :right
                @ami_facing_horizontal.play_loop.draw(@x, @y, ZOrder::TOP)
            when :up
                @ani_facing_up.play_loop.draw(@x, @y, ZOrder::TOP)
            when :down
                @ani_facing_down.play_loop.draw(@x, @y, ZOrder::TOP)
            end
        end

        # Draw bullets and shooters that currently exist
        @shooters.each do |shooter|
            shooter.draw
        end

        @bullets.each do |bullet|
            bullet.draw
        end
    end
end

# Created when the Ghast object attacks.
# Draw and Update are methods are called by the parent, which is in turn
# Called by the main update and draw methods.
class GhastShooter
    def initialize(x, y, ani_shoot, ani_bullet, facing, bullets, base_tiles)
        @x = x
        @y = y

        @base_tiles = base_tiles

        @lifespan = 65

        @ani_shoot = ani_shoot
        @ani_shoot.reset

        @bullets = bullets
        @ani_bullet = ani_bullet
        
        @ghast_facing = facing
        # Adjust the position of the shoot animation based on facing direction
        case @ghast_facing
        when :left
            @x -= 30
        when :right
            @x += 30
        when :up
            @y -= 30
        when :down
            @y += 30
        end
    end

    # Returns true if the attack is dead.
    def alive?
        @lifespan > 0
    end

   # Decrement lifespan once per frame
    def update
        @lifespan -= 1

        # Fire bullet at lifespan trigger
        if @lifespan == 30
            bullet = GhastBullet.new(@x, @y, @ani_bullet, @ghast_facing, @base_tiles)
            @bullets << bullet
        end
    end

    def draw
        @ani_shoot.play_once.draw(@x, @y, ZOrder::TOP)
    end
end

# Bullets instantiated by the shooter class. Reference held by array in Ghast
# parent. 
class GhastBullet
    # These attributes need to be readable for collison detection.
    attr_reader :x, :y, :hitbox_dim_x, :hitbox_dim_y, :hitbox_x, :hitbox_y, :alive

    def initialize(x, y, ani_bullet, ghast_facing, base_tiles)
        @x = x
        @y = y

        @base_tiles = base_tiles
        @alive = true

        @ani_bullet = ani_bullet

        @direction = ghast_facing

        # The spritesheet tiles don't centre the sprites, so some 
        # manual adjusting of hitboxes is required.
        # Set hitbox location
        @hitbox_dim_x = 15
        @hitbox_dim_y = 15
        @hitbox_offset_x = 38
        @hitbox_offset_y = 43
        @hitbox_x = @x + @hitbox_offset_x
        @hitbox_y = @y + @hitbox_offset_y
    end

    # If the bullet attempts an invalid movement, set alive to false
    # Will then be cleaned up in Ghast update loop
    def move
        # Move bullet in travel direction each frame    
        case @direction
        when :left
            new_x = @x - 5
            new_y = @y
        when :right
            new_x = @x + 5
            new_y = @y
        when :up
            new_x = @x
            new_y = @y - 5
        when :down
            new_x = @x
            new_y = @y + 5
        end
         
        # If movement is invalid, kill bullet
        if valid_movement?(new_x, new_y)
            @x = new_x
            @y = new_y
        else
            die
        end
    end

    # If attempted movement is valid, return true
    # Invalid movements are those which collide with wall tiles
    def valid_movement?(x, y)
        # Find the coordinates of each corner of the hitbox
        corners = [
        topleft_corner = [x + @hitbox_offset_x, y + @hitbox_offset_y],
        topright_corner = [x + @hitbox_offset_x + hitbox_dim_x, y + @hitbox_offset_y],
        bottomleft_corner = [x + @hitbox_offset_x, y + hitbox_dim_y + @hitbox_offset_y],
        bottomright_corner = [x + @hitbox_offset_x + hitbox_dim_x, y + hitbox_dim_y + 
                            @hitbox_offset_y]
        ] 

        # Container for the outcome of each check
        checks = Array.new

        # Check collision with wall tile on each corner.
        corners.each do |corner|
            tile_x = (corner[0] / TILE_DIMENSION)
            tile_y = (corner[1] / TILE_DIMENSION)
            tile = @base_tiles[tile_x][tile_y]
            if tile.wall
                check = true
                checks << check
            else
                check = false
                checks << check
            end
        end

        # If any check returned true, block movement.
        if checks[0] || checks[1] || checks[2] || checks[3]
            return false
        else
            return true
        end
    end

    def die
        @alive = false
    end

    def update
        # Update hitbox location
        @hitbox_x = @x + @hitbox_offset_x
        @hitbox_y = @y + @hitbox_offset_y

        move
    end

    # Draw bullet to window
    def draw
=begin
        Draw hitbox for troubleshooting
        Gosu.draw_rect(@hitbox_x, @hitbox_y, @hitbox_dim_x, @hitbox_dim_y, 
                        Gosu::Color::rgba(255, 100, 100, 100), ZOrder::MIDDLE)
=end
        @ani_bullet.play_loop.draw(@x, @y, ZOrder::TOP)
    end
end