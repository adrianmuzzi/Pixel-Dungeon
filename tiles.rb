require 'gosu'

# Tiles take an array of sprites to enable animation
class Tile
    # Wall status readable for collision detection
    attr_reader :wall, :score

    # By default a tile isn't worth score.
    def initialize(sprites, wall, score_tile = false)
        @sprites = sprites
        @wall = wall
        @score = score_tile

        # Create tile animation.
        if @sprites.length > 1
            @tile_ani = Animation.new(@sprites[0..@sprites.length], 
                        rand(0.2..0.4))
        end
    end

    # Draw sprite given animated or not, position and ZOrder 
    def draw(x, y, tile_layer)
        @x = x
        @y = y
        if @sprites.length == 1
            @sprites[0].draw(@x, @y, tile_layer)
        else
            @tile_ani.play_loop.draw(@x, @y, tile_layer)
        end
    end
end

# Unpack spreadsheet and define all map tiles and items
def define_tileset
    @tiles = Gosu::Image.load_tiles('sprites/tilesetpropsui48.png', 48, 48, 
                                    :tileable => true)
        
    # Create tile objects
    @tile_black = Tile.new(array = [@tiles[2]], true)

    @tile_floor = Tile.new(array = [@tiles[150]], false)

    @tile_wallblue = Tile.new(array = [@tiles[32]], true)
    @tile_wallblueleftturn = Tile.new(array = [@tiles[61]], true)
    @tile_wallbluerightturn = Tile.new(array = [@tiles[63]], true)
    @tile_blackturnleftblue = Tile.new(array = [@tiles[31]], true)
    @tile_blackturnrightblue = Tile.new(array = [@tiles[33]], true)

    @tile_wallred = Tile.new(array = [@tiles[37]], true)
    @tile_wallredleftturn = Tile.new(array = [@tiles[66]], true)
    @tile_wallredrightturn = Tile.new(array = [@tiles[68]], true)
    @tile_blackturnleftred = Tile.new(array = [@tiles[36]], true)
    @tile_blackturnrightred = Tile.new(array = [@tiles[38]], true)

    @tile_wallgreen = Tile.new(array = [@tiles[47]], true)
    @tile_wallgreenleftturn = Tile.new(array = [@tiles[76]], true)
    @tile_wallgreenrightturn = Tile.new(array = [@tiles[78]], true)
    @tile_blackturnleftgreen = Tile.new(array = [@tiles[46]], true)
    @tile_blackturnrightgreen = Tile.new(array = [@tiles[48]], true)

    @tile_black_floortopright = Tile.new(array = [@tiles[91]], true)
    @tile_black_floortopleft = Tile.new(array = [@tiles[93]], true)

    @tile_bluedoor_closed = Tile.new(array = [@tiles[162]], true)
    @tile_bluedoor_open = Tile.new(array = [@tiles[163]], true)
    @tile_reddoor_closed = Tile.new(array = [@tiles[165]], true)
    @tile_reddoor_open = Tile.new(array = [@tiles[166]], true)
    @tile_yellowdoor_closed = Tile.new(array = [@tiles[168]], true)
    @tile_yellowdoor_open = Tile.new(array = [@tiles[169]], true)
    @tile_greendoor_closed = Tile.new(array = [@tiles[171]], true)
    @tile_greendoor_open = Tile.new(array = [@tiles[172]], true)
    @tile_door_shadow = Tile.new(array = [@tiles[192]], false)

    @prop_barrel_closed = Tile.new(array = [@tiles[226]], false)
    @prop_barrel_open = Tile.new(array = [@tiles[228]], false)
    @prop_barrel_empty = Tile.new(array = [@tiles[227]], false)
    @prop_barrel_damaged = Tile.new(array = [@tiles[229]], false)

    @prop_chest_closed = Tile.new(array = [@tiles[230]], false)
    @prop_chest_open = Tile.new(array = [@tiles[231]], false)
    @prop_chest_empty = Tile.new(array = [@tiles[232]], false)

    @prop_coin = Tile.new(array = [@tiles[600], @tiles[601]], false, true)

    @prop_singletorch = Tile.new(array = [@tiles[80], @tiles[81]], false)
    @prop_doubletorch = Tile.new(array = [@tiles[82], @tiles[83]], false)
    @prop_wallshield = Tile.new(array = [@tiles[20]], false)
    @prop_wallswords = Tile.new(array = [@tiles[21]], false)
    @prop_wallaxeright = Tile.new(array = [@tiles[22]], false)
    @prop_wallaxeleft = Tile.new(array = [@tiles[23]], false)
    @prop_wallbarsleft = Tile.new(array = [@tiles[24]], false)
    @prop_wallbarsright = Tile.new(array = [@tiles[25]], false)
    @prop_window1 = Tile.new(array = [@tiles[26]], false)
    @prop_window2 = Tile.new(array = [@tiles[27]], false)
    @prop_painting1 = Tile.new(array = [@tiles[28]], false)
    @prop_painting2 = Tile.new(array = [@tiles[29]], false)

    @prop_wizardright_top = Tile.new(array = [@tiles[425]], false)
    @prop_wizardright_middle = Tile.new(array = [@tiles[455]], true)
    @prop_wizardright_bottom = Tile.new(array = [@tiles[485]], false)

    @prop_wizardleft_top = Tile.new(array = [@tiles[426]], false)
    @prop_wizardleft_middle = Tile.new(array = [@tiles[456]], true)
    @prop_wizardleft_bottom = Tile.new(array = [@tiles[486]], false)

    @prop_wizardup_top = Tile.new(array = [@tiles[428]], false)
    @prop_wizardup_middle = Tile.new(array = [@tiles[458]], true)
    @prop_wizardup_bottom = Tile.new(array = [@tiles[488]], false)

    @prop_wizarddown_top = Tile.new(array = [@tiles[427]], false)
    @prop_wizarddown_middle = Tile.new(array = [@tiles[457]], true)
    @prop_wizarddown_bottom = Tile.new(array = [@tiles[487]], false)

    @prop_dwarfright_top = Tile.new(array = [@tiles[429]], false)
    @prop_dwarfright_middle = Tile.new(array = [@tiles[459]], true)
    @prop_dwarfright_bottom = Tile.new(array = [@tiles[489]], false)

    @prop_dwarfleft_top = Tile.new(array = [@tiles[430]], false)
    @prop_dwarfleft_middle = Tile.new(array = [@tiles[460]], true)
    @prop_dwarfleft_bottom = Tile.new(array = [@tiles[490]], false)

    @prop_carpetred_topend = Tile.new(array = [@tiles[281]], false)
    @prop_carpetred_vertical = Tile.new(array = [@tiles[311]], false)
    @prop_carpetred_horizontal = Tile.new(array = [@tiles[342]], false)
    @prop_carpetred_x = Tile.new(array = [@tiles[341]], false)
    @prop_carpetred_bottomend = Tile.new(array = [@tiles[371]], false)
    @prop_carpetred_leftend = Tile.new(array = [@tiles[340]], false)
    @prop_carpetred_rightend = Tile.new(array = [@tiles[343]], false)

    @prop_carpetorange_topend = Tile.new(array = [@tiles[288]], false)
    @prop_carpetorange_vertical = Tile.new(array = [@tiles[318]], false)
    @prop_carpetorange_horizontal = Tile.new(array = [@tiles[349]], false)
    @prop_carpetorange_x = Tile.new(array = [@tiles[348]], false)
    @prop_carpetorange_bottomend = Tile.new(array = [@tiles[378]], false)
    @prop_carpetorange_leftend = Tile.new(array = [@tiles[347]], false)
    @prop_carpetorange_rightend = Tile.new(array = [@tiles[350]], false)

    @prop_carpetgreen_topend = Tile.new(array = [@tiles[295]], false)
    @prop_carpetgreen_vertical = Tile.new(array = [@tiles[325]], false)
    @prop_carpetgreen_horizontal = Tile.new(array = [@tiles[356]], false)
    @prop_carpetgreen_x = Tile.new(array = [@tiles[355]], false)
    @prop_carpetgreen_bottomend = Tile.new(array = [@tiles[385]], false)
    @prop_carpetgreen_leftend = Tile.new(array = [@tiles[354]], false)
    @prop_carpetgreen_rightend = Tile.new(array = [@tiles[357]], false)

    @prop_hole_topleft = Tile.new(array = [@tiles[300]], true)
    @prop_hole_top = Tile.new(array = [@tiles[301]], true)
    @prop_hole_topright = Tile.new(array = [@tiles[302]], true)
    @prop_hole_middleleft = Tile.new(array = [@tiles[330]], true)
    @prop_hole_middle = Tile.new(array = [@tiles[331]], true)
    @prop_hole_middleright = Tile.new(array = [@tiles[332]], true)
    @prop_hole_bottomleft = Tile.new(array = [@tiles[360]], true)
    @prop_hole_bottom = Tile.new(array = [@tiles[361]], true)
    @prop_hole_bottomright = Tile.new(array = [@tiles[362]], true)
end