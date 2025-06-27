require 'gosu'
require_relative 'animation'

#############      Slime       ##############
#############   Enemy Object   ##############

class Slime < Character # Inherit functions from Character class
    # These attributes need to be readable for collison detection.
    attr_reader :type, :x, :y, :hitbox_dim_x, :hitbox_dim_y, :hitbox_x, :hitbox_y

    # Specify size of sprite tiles
    CHARACTER_SPRITE_DIM = 96

    def initialize(x, y, base_tiles, prop_tiles)
        @type = "slime"
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
        @attack_cooldown = rand(400..800) # Timer between attacks

        @alive = true

        # The spritesheet tiles don't centre the sprites, so some 
        # manual adjusting of hitboxes is required.
        # Setup initial hitbox location, then update every frame:
        @hitbox_dim_x = 55
        @hitbox_dim_y = 41
        @hitbox_offset_x = 20
        @hitbox_offset_y = 55
        @hitbox_x = @x + @hitbox_offset_x
        @hitbox_y = @y + @hitbox_offset_y

        # Load spritesheet and cut into tiles
        spritesheet_file = "slime96.png"
        @sprites = Gosu::Image.load_tiles('sprites/' + spritesheet_file, 
                    CHARACTER_SPRITE_DIM, CHARACTER_SPRITE_DIM, :tileable => true)

        # Define Animations
        @ani_idle = @sprites[0]

        @ani_move_horizontal = Animation.new(@sprites[4..7], 0.2)
        @ani_move_vertical = Animation.new(@sprites[8..11], 0.2)

        @ani_attack_horizontal = Animation.new(@sprites[12..15], 0.2)
        @ani_attack_down = Animation.new(@sprites[16..19], 0.2)
        @ani_attack_up = Animation.new(@sprites[20..23], 0.2)

        @ani_death = Animation.new(@sprites[28..31], 0.3)
    end

    def move_randomly
        if @select_direction_timer <= 0
            @direction = [:left, :right, :up, :down, :none].sample
            @select_direction_timer = rand(30..50)
        else
            @select_direction_timer -= 1
        end

        # Validate that movement doesn't collide with wall before updating position
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
        @attack_cooldown = rand(500..800)
        @attack_state_timer = 60
        # puts "Slime Attacking!"
    end

    # Pass in object to determine if collision has occurred.
    # If yes, return true.
    def collides_with?(object)
        if (@hitbox_x < object.hitbox_x + object.hitbox_dim_x && 
            @hitbox_x + @hitbox_dim_x > object.hitbox_x && 
            @hitbox_y < object.hitbox_y + object.hitbox_dim_y && 
            @hitbox_y + @hitbox_dim_y > object.hitbox_y)
            return true
        else 
            return false
        end
    end

    # Run every frame in game loop update function.
    # Handles enemy status and changes.
    def update(player)
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
                    if collides_with?(player)
                        player.die
                    end
                    @attack_state_timer -= 1
                else
                    @attacking = false
                end
            # If not attacking, move and resfresh attack animations            
            else
                move_randomly
                @ani_attack_horizontal.reset
                @ani_attack_down.reset
                @ani_attack_up.reset
                @ani_death.reset # Prepare the death animation
            end
        end
    end

    # Run every frame in game loop draw function
    # If alive, draw enemy given direction.
    def draw
        # Draw hitbox for troubleshooting
        # Gosu.draw_rect(@hitbox_x, @hitbox_y, @hitbox_dim_x, @hitbox_dim_y, 
                        #Gosu::Color::rgba(255, 100, 100, 100), ZOrder::MIDDLE)

        if !@alive
            @ani_death.play_once.draw(@x, @y, ZOrder::TOP)
        elsif @attacking
            case @facing
            when :left
                # Flip the sprite and modify x location when facing left
                @ani_attack_horizontal.play_once.draw(@x + CHARACTER_SPRITE_DIM, 
                                                        @y, ZOrder::TOP, -1)
            when :right
                @ani_attack_horizontal.play_once.draw(@x, @y, ZOrder::TOP)
            when :up
                @ani_attack_up.play_once.draw(@x, @y, ZOrder::TOP)
            when :down
                @ani_attack_down.play_once.draw(@x, @y, ZOrder::TOP)
            end
        elsif @moving
            case @direction
            when :none
                @ani_idle.draw(@x, @y, ZOrder::TOP)
            when :left
                @ani_move_horizontal.play_loop.draw(@x + CHARACTER_SPRITE_DIM, 
                                                    @y, ZOrder::TOP, -1)
            when :right
                @ani_move_horizontal.play_loop.draw(@x, @y, ZOrder::TOP)
            when :up
                @ani_move_vertical.play_loop.draw(@x, @y, ZOrder::TOP)
            when :down
                @ani_move_vertical.play_loop.draw(@x, @y, ZOrder::TOP)
            end
        else
            @ani_idle.draw(@x, @y, ZOrder::TOP)
        end
    end
end