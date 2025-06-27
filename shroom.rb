require 'gosu'
require_relative 'animation'

#############      Shroom      ##############
#############   Enemy Object   ##############

class Shroom < Character # Inherit functions from Character class
    # These attributes need to be readable for collison detection.
    attr_reader :type, :x, :y, :hitbox_dim_x, :hitbox_dim_y, :hitbox_x, :hitbox_y, 
                :shroom_plants

    # Specify size of sprite tiles
    CHARACTER_SPRITE_DIM = 96

    def initialize(x, y, base_tiles, prop_tiles)
        @type = "shroom"
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
        @attack_cooldown = rand(300..700) # Timer between attacks

        @alive = true

        @shroom_plants = Array.new()

        # The spritesheet tiles don't centre the sprites, so some 
        # manual adjusting of hitboxes is required.
        # Setup initial hitbox location, then update every frame:
        @hitbox_dim_x = 44
        @hitbox_dim_y = 52
        @hitbox_offset_x = 21
        @hitbox_offset_y = 46
        @hitbox_x = @x + @hitbox_offset_x
        @hitbox_y = @y + @hitbox_offset_y

        # Load spritesheet and cut into tiles
        spritesheet_file = "shroom96.png"
        @sprites = Gosu::Image.load_tiles('sprites/' + spritesheet_file, 
        CHARACTER_SPRITE_DIM, CHARACTER_SPRITE_DIM, :tileable => true)

        # Define Animations
        @ani_idle_horizontal = @sprites[0]
        @ani_idle_up = @sprites[1]
        @ani_idle_down = @sprites[2]
    
        @ani_move_horizontal = Animation.new(@sprites[4..7], 0.2)
        @ani_move_up = Animation.new(@sprites[8..11], 0.2)
        @ani_move_down = Animation.new(@sprites[12..15], 0.2)
    
        @ani_attack_horizontal = Animation.new(@sprites[16..19], 0.2)
        @ani_attack_up = Animation.new(@sprites[20..23], 0.2)
        @ani_attack_down = Animation.new(@sprites[24..27], 0.2)
    
        @ani_shrooms = Animation.new(@sprites[28..31], 0.2)
        @ani_poison = Animation.new(@sprites[32..35], 0.2)
    
        @ani_death = Animation.new(@sprites[40..43], 0.3)
    end

    def move_randomly
        if @select_direction_timer <= 0
            # Select random direction
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

    # Attack - create new attack object. Reset cooldown and state timer.
    def attack
        @attacking = true
        plant = ShroomPlant.new(@x, @y, @ani_shrooms, @ani_poison)
        @shroom_plants << plant
        @attack_cooldown = rand(500..600)
        @attack_state_timer = 60
        # puts "Shroom seeding!"
    end

    # Run every frame in game loop update function.
    # Handles enemy status and changes if alive.
    def update
        # Query return alive status of array elements.
        # Return array with only alive elements.
        @shroom_plants.select!{|plant| plant.alive?}
        # Run update for each attack in the array.
        @shroom_plants.each do |i|
            i.update
        end
       
        # If alive, update the object
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
            # If not attacking, move and resfresh attack animations
            else
                move_randomly
                @ani_attack_horizontal.reset
                @ani_attack_up.reset
                @ani_attack_down.reset
                @ani_death.reset # Prepare the death animation
            end
        end
    end

    # Run every frame in game loop draw function
    # If alive, draw enemy given status variables.
    def draw
        # Draw hitbox for troubleshooting
=begin
        Gosu.draw_rect(@hitbox_x, @hitbox_y, @hitbox_dim_x, @hitbox_dim_y, 
                        Gosu::Color::rgba(255, 100, 100, 100), ZOrder::MIDDLE)
=end
        # Call draw function of any current plants
        @shroom_plants.each do |plant|
            plant.draw
        end

        if !@alive
            @ani_death.play_once.draw(@x, @y, ZOrder::TOP)
        elsif @attacking
            case @facing
            when :left
                # Flip the sprite and modify x location when moving left
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
                case @facing
                when :left
                    @ani_idle_horizontal.draw(@x + CHARACTER_SPRITE_DIM, @y, 
                                                ZOrder::TOP, -1)
                when :right
                    @ani_idle_horizontal.draw(@x, @y, ZOrder::TOP)
                when :up
                    @ani_idle_up.draw(@x, @y, ZOrder::TOP)
                when :down
                    @ani_idle_down.draw(@x, @y, ZOrder::TOP)
                end
            when :left
                @ani_move_horizontal.play_loop.draw(@x + CHARACTER_SPRITE_DIM, @y, 
                                                    ZOrder::TOP, -1)
            when :right
                @ani_move_horizontal.play_loop.draw(@x, @y, ZOrder::TOP)
            when :up
                @ani_move_up.play_loop.draw(@x, @y, ZOrder::TOP)
            when :down
                @ani_move_down.play_loop.draw(@x, @y, ZOrder::TOP)
            end
        else
            case @facing
            when :left
                @ani_idle_horizontal.draw(@x + CHARACTER_SPRITE_DIM, @y, 
                                            ZOrder::TOP, -1)
            when :right
                @ani_idle_horizontal.draw(@x, @y, ZOrder::TOP)
            when :up
                @ani_idle_up.draw(@x, @y, ZOrder::TOP)
            when :down
                @ani_idle_down.draw(@x, @y, ZOrder::TOP)
            end
        end
    end
end

# Created when the Shroom object attacks. Captured in parent object array.
# Draw and Update are methods are called by the parent, which is in turn
# Called by the main update and draw methods.
class ShroomPlant
    # These attributes need to be readable for collison detection.
    attr_reader :x, :y, :hitbox_dim_x, :hitbox_dim_y, :hitbox_x, :hitbox_y

    def initialize(x, y, ani_shrooms, ani_poison)
        @x = x
        @y = y

        # The spritesheet tiles don't centre the sprites, so some 
        # manual adjusting of hitboxes is required.
        # Set hitbox location
        @hitbox_dim_x = 54
        @hitbox_dim_y = 50
        @hitbox_offset_x = 23
        @hitbox_offset_y = 42
        @hitbox_x = @x + @hitbox_offset_x
        @hitbox_y = @y + @hitbox_offset_y

        @lifespan = rand(500..1000)

        @ani_shrooms = ani_shrooms
        @ani_poison = ani_poison
    end

    # Returns true if the attack is dead.
    def alive?
        @lifespan > 0
    end

    # Decrement lifespan once per frame
    def update
        @lifespan -= 1
    end

    def draw
        # Draw hitbox for troubleshooting
=begin
        Gosu.draw_rect(@hitbox_x, @hitbox_y, @hitbox_dim_x, @hitbox_dim_y, 
                        Gosu::Color::rgba(255, 100, 100, 100), ZOrder::MIDDLE)
=end
        @ani_shrooms.play_loop.draw(@x, @y, ZOrder::MIDDLE)
        @ani_poison.play_loop.draw(@x, @y - 10, ZOrder::MIDDLE)
    end
end