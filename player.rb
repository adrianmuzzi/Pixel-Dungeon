require 'gosu'
require_relative 'animation'
require_relative 'character'
require_relative 'tiles'

# IDEALLY, CHARACTER CLASSES WOULD USE INHERITENCE 
# AND FUNCTION OVERLOADING TO REDUCE REPEATED CODE

class Player < Character
    # Create accessors for modifying values from outside the player class
    attr_accessor :x, :y, :hitbox_dim_x, :hitbox_dim_y, :hitbox_x, :hitbox_y

    # Specify size of sprite tiles
    CHARACTER_SPRITE_DIM = 96
    
    def initialize(x, y, base_tiles, prop_tiles)
        @type = "player"
        # Initialise position and status variables
        @x = x
        @y = y

        @base_tiles = base_tiles
        @prop_tiles = prop_tiles

        @facing = :right
        @moving = false

        @attacking = false
        @attack_cooldown = 0

        @alive = true

        @score = 0
        @score_font = Gosu::Font.new(25)

        @winlose_font = Gosu::Font.new(60)

        # The spritesheet tiles don't centre the sprites, so some 
        # manual adjusting of hitboxes is required.
        # Setup initial hitbox location, then update every frame:
        @hitbox_dim_x = 49
        @hitbox_dim_y = 49
        @hitbox_offset_x = 23
        @hitbox_offset_y = 49
        @hitbox_x = @x + @hitbox_offset_x
        @hitbox_y = @y + @hitbox_offset_y

        # Capture Spritesheet and divide into tiles
        @sprites = Gosu::Image.load_tiles("sprites/dwarf96.png", 
        CHARACTER_SPRITE_DIM, CHARACTER_SPRITE_DIM, :tileable => true)

        # Define Animations
        @ani_idle_horizontal = @sprites[0]
        @ani_idle_up = @sprites[1]
        @ani_idle_down = @sprites[2]

        @ani_move_horizontal = Animation.new(@sprites[4..7], 0.2)
        @ani_move_up = Animation.new(@sprites[8..11], 0.2)
        @ani_move_down = Animation.new(@sprites[12..15], 0.2)

        @ani_attack_horizontal = Animation.new(@sprites[16..19], 0.2)
        @ani_attack_down = Animation.new(@sprites[20..23], 0.2)
        @ani_attack_up = Animation.new(@sprites[24..27], 0.2)

        @ani_death = Animation.new(@sprites[32..35], 0.3)
    end

    # Called by button presses in update. A key is passed in.
    def move(direction)
        # Calculate new potential position given direction
        new_x, new_y = @x, @y
        case direction
        when :none
            @moving = false
            return # Break out of function if no attempted movement
        when :left
            new_x -= 2
        when :right
            new_x += 2
        when :up
            new_y -= 2
        when :down
            new_y += 2
        end
        
        # Check if the movement is valid and update position if it is
        if valid_movement?(new_x, new_y)
            @x, @y = new_x, new_y
            @moving = true
            @facing = direction
        else
            @moving = false
            #puts "Invalid player movement"
        end
    end

    # Set controlling variable to true, start cooldown timer
    def attack
        @attacking = true
        @attack_cooldown = 60
    end

    # Look for collisions
    def manage_enemy_collisions(enemies)
        # Update hitbox to current position
        @hitbox_x = @x + @hitbox_offset_x
        @hitbox_y = @y + @hitbox_offset_y
        
        # Look for collisions with Shroom plants and Ghast bullets
        enemies.each do |enemy|
            if enemy.type == "shroom"
                enemy.shroom_plants.each do |plant|
                    if collides_with?(plant)
                        puts "YOU DIED!"
                        die
                    end
                end
            elsif enemy.type == "ghast"
                enemy.bullets.each do |bullet|
                    if collides_with?(bullet)
                        puts "YOU DIED!"
                        die
                        bullet.die
                    end
                end
            end
        end 

        # When attacking, colliding with an enemy kills
        if @attacking
            enemies.each do |enemy|
                if collides_with?(enemy)
                    enemy.die
                end
            end
        end
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

    # Set attack animations timers to current frame
    def reset_attack_animations
        @ani_attack_horizontal.reset
        @ani_attack_up.reset
        @ani_attack_down.reset
    end

    # Run every frame in game loop update function
    # Handles player status.
    def update(enemies)
        # Skip all status and input checks if player is dead.
        if @alive
            # Assume no movement
            @moving = false
            # Attacking blocks all other actions
            if @attack_cooldown == 0
                # Set attacking to false if this is the first update 
                # cycle after an attack cycle
                @attacking = false if @attacking != false

                # Prepare attack animations
                reset_attack_animations
                
                # Query move input and attack input
                move(:left) if Gosu.button_down? (Gosu::KB_LEFT)
                move(:right) if Gosu.button_down? (Gosu::KB_RIGHT)
                move(:up) if Gosu.button_down? (Gosu::KB_UP)
                move(:down) if Gosu.button_down? (Gosu::KB_DOWN)

                attack if Gosu.button_down? (Gosu::KB_SPACE)
            else
                @attack_cooldown -= 1
            end

            # Pass in all enemies. Look for collisions.
            manage_enemy_collisions(enemies)
            @ani_death.reset # Prepare the death animation
        end
    end

    # Run every frame in game loop draw function
    # Draw player given moving status and direction.
    def draw
        # Draw hitbox for troubleshooting
=begin
        Gosu.draw_rect(@hitbox_x, @hitbox_y, @hitbox_dim_x, @hitbox_dim_y, 
                        Gosu::Color::rgba(255, 0, 0, 100), ZOrder::MIDDLE)
=end
        # Draw score to screen
        @score_font.draw("Score: #{@score}", 50, 13, z = ZOrder::TOP, 1.0, 1.0, Gosu::Color::WHITE)
        
        if !@alive
            @ani_death.play_once.draw(@x, @y, ZOrder::TOP)
            @winlose_font.draw("You Died!", 390, 500, z = ZOrder::TOP, 1.0, 1.0, Gosu::Color::WHITE)
        else
            # Print win message upon max score
            if @score == 7
                @winlose_font.draw("You Win!", 395, 500, z = ZOrder::TOP, 1.0, 1.0, Gosu::Color::WHITE)
            end
            case @facing
            # Flip the sprite and modify x location when moving left
            when :left
                if @moving
                    @ani_move_horizontal.play_loop.draw(@x + CHARACTER_SPRITE_DIM, 
                                                        @y, ZOrder::TOP, -1)
                elsif @attacking
                    @ani_attack_horizontal.play_once.draw(@x + CHARACTER_SPRITE_DIM, 
                                                            @y, ZOrder::TOP, -1)
                else    
                    @ani_idle_horizontal.draw(@x + CHARACTER_SPRITE_DIM, @y, 
                                                ZOrder::TOP, -1)
                end
            when :right
                if @moving
                    @ani_move_horizontal.play_loop.draw(@x, @y, ZOrder::TOP)
                elsif @attacking
                    @ani_attack_horizontal.play_once.draw(@x, @y, ZOrder::TOP)
                else
                    @ani_idle_horizontal.draw(@x, @y, ZOrder::TOP)
                end
            when :up
                if @moving
                    @ani_move_up.play_loop.draw(@x, @y, ZOrder::TOP)
                elsif @attacking
                    @ani_attack_up.play_once.draw(@x, @y, ZOrder::TOP)
                else
                    @ani_idle_up.draw(@x, @y, ZOrder::TOP)
                end
            when :down
                if @moving
                    @ani_move_down.play_loop.draw(@x, @y, ZOrder::TOP)
                elsif @attacking
                    @ani_attack_down.play_once.draw(@x, @y, ZOrder::TOP)
                else
                    @ani_idle_down.draw(@x, @y, ZOrder::TOP)
                end
            end
        end
    end
end