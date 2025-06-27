require 'gosu'
require_relative 'player'
require_relative 'slime'
require_relative 'shroom'
require_relative 'ghast'
require_relative 'animation'
require_relative 'tiles'
require_relative 'map1'

module ZOrder
  BASE_TILES, PROPS_UI, MIDDLE, TOP = *0..3
end

# Define constant dimensions for the map
TILE_DIMENSION = 48
TILE_X_COUNT = 21
TILE_Y_COUNT = 16

class GameWindow < Gosu::Window

    # Initialize game window
    def initialize
        super(TILE_DIMENSION * TILE_X_COUNT, TILE_DIMENSION * TILE_Y_COUNT, false)
        self.caption = "Pixel Dungeon"
        
    #   Use multidimensional arrays to map the playing area.
    #   Break tiles into an array. Map tile images to objects that have various
    #   attributes - for example, their sprite, can be passed through etc
    #   Set the array map tiles to object tiles to populate the map.

        # Initialize the tileset objects
        define_tileset
        # Create map arrays and enemy arrays, populate
        define_map1

        # Initialize spawn values for player
        @player_spawn_x = ((TILE_DIMENSION * TILE_X_COUNT) / 2) - 49
        @player_spawn_y = (TILE_DIMENSION * 2) - 29

        # Create the player character
        @player = Player.new(@player_spawn_x, @player_spawn_y, 
                            @base_tile_columns, @propui_tile_columns)

        # Load and play game track
        @song = Gosu::Song.new("music.wav")
        @song.play(looping = true)
    end

    # Run update function on all enemy objects
    def update_enemies(enemies)
        enemies.each do |enemy|
            if enemy.type == "slime" 
                enemy.update(@player)
            else
                enemy.update
            end
        end
    end

    # Run draw function on all enemy objects
    def draw_enemies(enemies)
        enemies.each do |enemy|
            enemy.draw
        end
    end

    # Called every frame
    def update
        # Update enemies and player
        update_enemies(@enemies)
        @player.update(@enemies)

        # For debugging, output coordinates to console.
        # puts ("player x = " + @player.x.to_s())
        # puts ("player y = " + @player.y.to_s())

    end

    # Draw (or Redraw) the window every frame
    def draw
        # Draw enemies and player
        draw_enemies(@enemies)
        @player.draw

        # Draw the base tiles. Don't draw 'empty' tiles
        i = 0
        while i < TILE_X_COUNT
            z = 0
            while z < TILE_Y_COUNT
                if @base_tile_columns[i][z] != nil
                    @base_tile_columns[i][z].draw(i * TILE_DIMENSION, 
                                            z * TILE_DIMENSION, ZOrder::BASE_TILES)
                end
                z += 1
            end
            i += 1
        end

        # Draw the prop ui tiles. Don't draw 'empty' tiles
        i = 0
        while i < TILE_X_COUNT
            z = 0
            while z < TILE_Y_COUNT
                if @propui_tile_columns[i][z] != nil
                    @propui_tile_columns[i][z].draw(i * TILE_DIMENSION, 
                                            z * TILE_DIMENSION, ZOrder::PROPS_UI)
                end
                z += 1
            end
            i += 1
        end
    end
end

@window = GameWindow.new
@window.show