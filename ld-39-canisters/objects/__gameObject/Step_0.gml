/// @description DescriptionGoesHere

if (global.GAME_OVER == true) {
    if (global.MUSIC != noone && audio_is_playing(global.MUSIC)) {
        audio_stop_sound(global.MUSIC);
        global.MUSIC = noone;
    }
    
    if (message_handler == noone) {
        message_handler = instance_create_depth(x, y, 0, __gameDialogueOver);   
    }
    
    audio_play_sound(snd_thank, 0, false);

    if (message_handler.messages_last == false) {
        var a_button = action1Pressed() || mouse_check_button_pressed(mb_left);
        var b_button = action2Pressed() || mouse_check_button_pressed(mb_right);
        if (a_button == true) room_restart();
        if (b_button == true) room_goto(rm_titleScreen);
    }
} else {
    // End Game
    if (global.GAME_END == true) {
        if (global.MUSIC != noone && audio_is_playing(global.MUSIC)) {
            audio_stop_sound(global.MUSIC);
            global.MUSIC = noone;
        }
        
        if (message_handler == noone) {
            message_handler = instance_create_depth(x, y, 0, __gameDialogueEnd);
        }
    
        if (message_handler.messages_last == false) {
            var a_button = action1Pressed() || mouse_check_button_pressed(mb_left);
            var b_button = action2Pressed() || mouse_check_button_pressed(mb_right);
    
            if (a_button == true) room_restart();
            if (b_button == true) room_goto(rm_titleScreen);
        }
    }
    
    if (global.MUSIC != noone && audio_sound_get_track_position(global.MUSIC) >= 222.86) {
        audio_sound_set_track_position(global.MUSIC, 58.33);
    }

    // Game
    if (global.GAME_MID == true  && global.GAME_BUILD == false && global.PLAYER == noone) {
        global.GAME_BUILD = true;
        instance_create_depth(0, 0, 0, obj_levelBuilder);
    }

    if (global.GAME_MID == true && global.GAME_BUILD == true) {
        // Is player dead?
        if (global.PLAYER != noone && global.PLAYER.player_health <= 0 
            || global.PLAYER != noone && global.PLAYER.player_ammo <= 0) {
            global.GAME_MID = false;
        
            // End game
            __endGame();
            
            audio_play_sound(snd_toobad, 0, false);
        
            global.GAME_END = true;
        }
    
        if (global.GAME_ENEMY == 0 && global.GAME_PASS == false && global.PLAYER != noone) {
            __nextLevel();
        
            global.GAME_PASS = true;
            global.GAME_ENEMY = -1;
        
            // Next Level
            global.GAME_CURR += 1;
            if (global.GAME_CURR == 100) {
                global.GAME_OVER = true;
            } else {
                message_handler = instance_create_depth(x, y, 0, __gameDialogueLevel);
        
                // 
                audio_play_sound(snd_goodjob, 0, false);
            }
        }
    
        if (global.GAME_ENEMY == -1 && global.GAME_PASS == true && message_handler != noone) {
            if (message_handler.messages_last == false) {
                if (action1Pressed() == true || mouse_check_button_pressed(mb_left) == true) {
                    message_handler.messages_last = true;
                    global.GAME_PASS = false;
                    instance_destroy(message_handler);
                    with(obj_textboxDraw) {
                        instance_destroy();
                    }
                    message_handler = noone;
                    instance_create_depth(0, 0, 0, obj_levelBuilder);
                }
            }
        }
    }

    if (global.GAME_INI == false) {
        if (global.MUSIC != noone && audio_is_playing(global.MUSIC)) {
            audio_stop_sound(global.MUSIC);
            global.MUSIC = noone;
        }
        
        global.MUSIC = audio_play_sound(music_item, false, false);
        
        global.GAME_INI = true;
        message_handler = instance_create_depth(x, y, 0, __gameDialogue);

        audio_play_sound(snd_hello, 0, false);
    } else if (global.GAME_INI && message_handler != noone && message_handler.messages_last == true) {
        instance_destroy(message_handler);
        message_handler = noone;
        global.GAME_MID = true;
    }
}
