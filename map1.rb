require 'gosu'

########## This builds the first map ##########
##########         from tiles        ##########

####### Further maps can be constructed #######
#######   without altering game logic   #######

def define_map1
    # Define base tile arrays
    # Master 'first row' array
    @base_tile_columns = Array.new(TILE_X_COUNT)
    i = 0
    while (i < TILE_X_COUNT)
        # Seed each element in the first row with a column array
        @base_tile_columns[i] = Array.new(TILE_Y_COUNT)
        z = 0
        while z < TILE_Y_COUNT
            # At initialization, populate tiles as nil.
            @base_tile_columns[i][z] = nil
            z += 1
        end
        i += 1
    end

    # Build a second array set for Prop + UI tiles
    # These are render over the base tiles via ZOrder
    @propui_tile_columns = Array.new(TILE_X_COUNT)
    i = 0
    while (i < TILE_X_COUNT)
        @propui_tile_columns[i] = Array.new(TILE_Y_COUNT)
        z = 0
        while z < TILE_Y_COUNT
            @propui_tile_columns[i][z] = nil
            z += 1
        end
        i += 1
    end

        #############################

    # Populate every tile with the floor sprite
    i = 0
    while i < TILE_X_COUNT
        z = 0
        while z < TILE_Y_COUNT
            @base_tile_columns[i][z] = @tile_floor
            z += 1
        end
        i += 1
    end

    # Ring the map with black walls
    i = 0
    while i < TILE_X_COUNT
        @base_tile_columns[i][0] = @tile_black
        i += 1
    end

    i = 0
    while i < TILE_X_COUNT
        @base_tile_columns[i][TILE_Y_COUNT - 1] = @tile_black
        i += 1
    end

    i = 0
    while i < TILE_Y_COUNT
        @base_tile_columns[0][i] = @tile_black
        i += 1
    end

    i = 0
    while i < TILE_Y_COUNT
        @base_tile_columns[TILE_X_COUNT - 1][i] = @tile_black
        i += 1
    end

    ###############################
    ##### POPULATE BASE LAYER #####
    ###############################

    @base_tile_columns[1][1] = @tile_wallblue
    @base_tile_columns[2][1] = @tile_wallblue
    @base_tile_columns[3][1] = @tile_wallblue
    @base_tile_columns[4][1] = @tile_blackturnrightblue
    @base_tile_columns[5][1] = @tile_blackturnleftblue
    @base_tile_columns[6][1] = @tile_wallblue 
    @base_tile_columns[7][1] = @tile_wallblue
    @base_tile_columns[8][1] = @tile_wallblue
    @base_tile_columns[9][1] = @tile_wallblue
    @base_tile_columns[10][1] = @tile_wallblue
    @base_tile_columns[11][1] = @tile_wallblue
    @base_tile_columns[12][1] = @tile_wallblue
    @base_tile_columns[13][1] = @tile_wallblue
    @base_tile_columns[14][1] = @tile_wallblue
    @base_tile_columns[15][1] = @tile_blackturnrightblue
    @base_tile_columns[16][1] = @tile_blackturnleftblue
    @base_tile_columns[17][1] = @tile_wallblue
    @base_tile_columns[18][1] = @tile_wallblue
    @base_tile_columns[19][1] = @tile_wallblue

    @base_tile_columns[4][2] = @tile_wallblue
    @base_tile_columns[5][2] = @tile_wallblue

    @base_tile_columns[15][2] = @tile_wallblue
    @base_tile_columns[16][2] = @tile_wallblue

    @base_tile_columns[4][6] = @tile_black_floortopleft
    @base_tile_columns[5][6] = @tile_black 
    @base_tile_columns[6][6] = @tile_black
    @base_tile_columns[7][6] = @tile_black_floortopright
    @base_tile_columns[13][6] = @tile_black_floortopleft
    @base_tile_columns[14][6] = @tile_black 
    @base_tile_columns[15][6] = @tile_black
    @base_tile_columns[16][6] = @tile_black_floortopright

    @base_tile_columns[1][7] = @tile_black
    @base_tile_columns[2][7] = @tile_black
    @base_tile_columns[3][7] = @tile_black
    @base_tile_columns[4][7] = @tile_black
    @base_tile_columns[5][7] = @tile_black 
    @base_tile_columns[6][7] = @tile_black 
    @base_tile_columns[7][7] = @tile_wallred
    @base_tile_columns[13][7] = @tile_wallgreen
    @base_tile_columns[14][7] = @tile_black
    @base_tile_columns[15][7] = @tile_black
    @base_tile_columns[16][7] = @tile_black
    @base_tile_columns[17][7] = @tile_black 
    @base_tile_columns[18][7] = @tile_black 
    @base_tile_columns[19][7] = @tile_black

    @base_tile_columns[1][8] = @tile_wallred
    @base_tile_columns[2][8] = @tile_wallred
    @base_tile_columns[3][8] = @tile_wallred
    @base_tile_columns[4][8] = @tile_blackturnrightred
    @base_tile_columns[5][8] = @tile_black 
    @base_tile_columns[6][8] = @tile_blackturnleftred

    @base_tile_columns[14][8] = @tile_blackturnrightgreen
    @base_tile_columns[15][8] = @tile_black 
    @base_tile_columns[16][8] = @tile_blackturnleftgreen
    @base_tile_columns[17][8] = @tile_wallgreen
    @base_tile_columns[18][8] = @tile_wallgreen 
    @base_tile_columns[19][8] = @tile_wallgreen

    @base_tile_columns[4][9] = @tile_wallred
    @base_tile_columns[5][9] = @tile_wallred
    @base_tile_columns[6][9] = @tile_wallred
    @base_tile_columns[14][9] = @tile_wallgreen
    @base_tile_columns[15][9] = @tile_wallgreen
    @base_tile_columns[16][9] = @tile_wallgreen

    @base_tile_columns[1][11] = @tile_black_floortopright
    @base_tile_columns[19][11] = @tile_black_floortopleft
    
    @base_tile_columns[1][12] = @tile_wallred
    @base_tile_columns[19][12] = @tile_wallgreen

    @base_tile_columns[5][13] = @tile_black_floortopleft
    @base_tile_columns[6][13] = @tile_black_floortopright
    @base_tile_columns[14][13] = @tile_black_floortopleft
    @base_tile_columns[15][13] = @tile_black_floortopright

    @base_tile_columns[4][14] = @tile_black_floortopleft
    @base_tile_columns[5][14] = @tile_black
    @base_tile_columns[6][14] = @tile_black
    @base_tile_columns[14][14] = @tile_black
    @base_tile_columns[15][14] = @tile_black
    @base_tile_columns[16][14] = @tile_black_floortopright
    
    ###############################
    ##### POPULATE PROP LAYER #####
    ###############################

    @propui_tile_columns[10][1] = @tile_yellowdoor_closed
    @propui_tile_columns[10][2] = @tile_door_shadow

    @propui_tile_columns[9][1] = @prop_wallswords
    @propui_tile_columns[11][1] = @prop_wallswords
    @propui_tile_columns[7][1] = @prop_painting1
    @propui_tile_columns[13][1] = @prop_painting2
    @propui_tile_columns[2][1] = @prop_window1
    @propui_tile_columns[18][1] = @prop_window1
    @propui_tile_columns[6][2] = @prop_barrel_damaged
    @propui_tile_columns[14][2] = @prop_chest_empty
    @propui_tile_columns[4][2] = @prop_doubletorch
    @propui_tile_columns[16][2] = @prop_doubletorch

    @propui_tile_columns[8][1] = @prop_wizarddown_top
    @propui_tile_columns[8][2] = @prop_wizarddown_middle
    @propui_tile_columns[8][3] = @prop_wizarddown_bottom

    @propui_tile_columns[12][1] = @prop_wizarddown_top
    @propui_tile_columns[12][2] = @prop_wizarddown_middle
    @propui_tile_columns[12][3] = @prop_wizarddown_bottom

    @propui_tile_columns[16][4] = @prop_carpetorange_leftend
    @propui_tile_columns[17][4] = @prop_carpetorange_rightend
    @propui_tile_columns[19][2] = @prop_chest_closed
    @propui_tile_columns[19][3] = @prop_wizardleft_top
    @propui_tile_columns[19][4] = @prop_wizardleft_middle
    @propui_tile_columns[19][5] = @prop_wizardleft_bottom
    @propui_tile_columns[17][6] = @prop_barrel_open
    
    @propui_tile_columns[3][4] = @prop_carpetorange_leftend
    @propui_tile_columns[4][4] = @prop_carpetorange_rightend
    @propui_tile_columns[1][2] = @prop_chest_open
    @propui_tile_columns[1][3] = @prop_wizardright_top
    @propui_tile_columns[1][4] = @prop_wizardright_middle
    @propui_tile_columns[1][5] = @prop_wizardright_bottom
    @propui_tile_columns[3][6] = @prop_barrel_closed

    @propui_tile_columns[10][3] = @prop_carpetorange_topend
    @propui_tile_columns[10][4] = @prop_carpetorange_x
    @propui_tile_columns[10][5] = @prop_carpetorange_vertical
    @propui_tile_columns[10][6] = @prop_carpetorange_vertical
    @propui_tile_columns[10][7] = @prop_carpetorange_bottomend
    @propui_tile_columns[6][4] = @prop_carpetorange_leftend
    @propui_tile_columns[7][4] = @prop_carpetorange_horizontal
    @propui_tile_columns[8][4] = @prop_carpetorange_horizontal
    @propui_tile_columns[9][4] = @prop_carpetorange_horizontal
    @propui_tile_columns[11][4] = @prop_carpetorange_horizontal
    @propui_tile_columns[12][4] = @prop_carpetorange_horizontal
    @propui_tile_columns[13][4] = @prop_carpetorange_horizontal
    @propui_tile_columns[14][4] = @prop_carpetorange_rightend

    @propui_tile_columns[10][8] = @prop_wizardup_top
    @propui_tile_columns[10][9] = @prop_wizardup_middle
    @propui_tile_columns[10][10] = @prop_wizardup_bottom

    @propui_tile_columns[9][10] = @prop_hole_topleft
    @propui_tile_columns[10][10] = @prop_hole_top
    @propui_tile_columns[11][10] = @prop_hole_topright
    @propui_tile_columns[9][11] = @prop_hole_middleleft
    @propui_tile_columns[10][11] = @prop_hole_middle
    @propui_tile_columns[11][11] = @prop_hole_middleright
    @propui_tile_columns[9][12] = @prop_hole_bottomleft
    @propui_tile_columns[10][12] = @prop_hole_bottom
    @propui_tile_columns[11][12] = @prop_hole_bottomright

    @propui_tile_columns[7][7] = @prop_singletorch
    @propui_tile_columns[13][7] = @prop_singletorch

    @propui_tile_columns[18][8] = @prop_window2

    @propui_tile_columns[2][8] = @prop_singletorch
    @propui_tile_columns[3][8] = @prop_wallbarsleft
    @propui_tile_columns[1][8] = @prop_wallbarsright

    @propui_tile_columns[14][9] = @prop_wallaxeright
    @propui_tile_columns[16][9] = @prop_wallaxeleft
    @propui_tile_columns[15][9] = @tile_greendoor_closed
    @propui_tile_columns[15][10] = @tile_door_shadow

    @propui_tile_columns[5][9] = @prop_wallshield
    @propui_tile_columns[7][13] = @prop_barrel_damaged

    @propui_tile_columns[4][11] = @prop_carpetred_leftend
    @propui_tile_columns[5][11] = @prop_carpetred_horizontal
    @propui_tile_columns[6][11] = @prop_carpetred_horizontal
    @propui_tile_columns[7][11] = @prop_carpetred_rightend
    @propui_tile_columns[13][11] = @prop_carpetgreen_leftend
    @propui_tile_columns[14][11] = @prop_carpetgreen_horizontal
    @propui_tile_columns[15][11] = @prop_carpetgreen_horizontal
    @propui_tile_columns[16][11] = @prop_carpetgreen_rightend
    
    @propui_tile_columns[1][10] = @prop_barrel_open
    @propui_tile_columns[1][11] = @prop_dwarfright_top
    @propui_tile_columns[1][12] = @prop_dwarfright_middle
    @propui_tile_columns[1][13] = @prop_dwarfright_bottom
    @propui_tile_columns[1][14] = @prop_chest_closed

    @propui_tile_columns[19][10] = @prop_barrel_damaged
    @propui_tile_columns[19][11] = @prop_dwarfleft_top
    @propui_tile_columns[19][12] = @prop_dwarfleft_middle
    @propui_tile_columns[19][13] = @prop_dwarfleft_bottom
    @propui_tile_columns[19][14] = @prop_chest_closed

    @propui_tile_columns[8][14] = @prop_barrel_closed
    @propui_tile_columns[13][14] = @prop_chest_open

    #########################
    ##### CREATE COINS  #####
    #########################

    @propui_tile_columns[19][6] = @prop_coin
    @propui_tile_columns[1][6] = @prop_coin
    @propui_tile_columns[5][4] = @prop_coin
    @propui_tile_columns[15][4] = @prop_coin
    @propui_tile_columns[3][11] = @prop_coin
    @propui_tile_columns[17][11] = @prop_coin
    @propui_tile_columns[10][14] = @prop_coin
    
    @coins = Array.new()

    @coins << @propui_tile_columns[19][6]
    @coins << @propui_tile_columns[1][6]
    @coins << @propui_tile_columns[5][4]
    @coins << @propui_tile_columns[15][4]
    @coins << @propui_tile_columns[3][11]
    @coins << @propui_tile_columns[17][11]
    @coins << @propui_tile_columns[10][14]

    #########################
    ##### SPAWN ENEMIES #####
    #########################

    # Array holding enemies. Define enemies on the map, add to array.
    @enemies = Array.new()

    @slime = Slime.new(170, 110, @base_tile_columns, @propui_tile_columns)
    @enemies << @slime

    @slime = Slime.new(600, 500, @base_tile_columns, @propui_tile_columns)
    @enemies << @slime

    @slime = Slime.new(650, 140, @base_tile_columns, @propui_tile_columns)
    @enemies << @slime

    @shroom = Shroom.new(90, 180, @base_tile_columns, @propui_tile_columns)
    @enemies << @shroom

    @shroom = Shroom.new(450, 300, @base_tile_columns, @propui_tile_columns)
    @enemies << @shroom

    @ghast = Ghast.new(800, 110, @base_tile_columns, @propui_tile_columns)
    @enemies << @ghast

    @ghast = Ghast.new(370, 600, @base_tile_columns, @propui_tile_columns)
    @enemies << @ghast

    @ghast = Ghast.new(80, 550, @base_tile_columns, @propui_tile_columns)
    @enemies << @ghast

    @ghast = Ghast.new(808, 525, @base_tile_columns, @propui_tile_columns)
    @enemies << @ghast
end