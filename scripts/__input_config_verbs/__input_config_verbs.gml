// Feather disable all

//This script contains the default profiles, and hence the default bindings and verbs, for your game
//
//  Please edit this macro to meet the needs of your game!
//
//The struct return by this script contains the names of each default profile.
//Default profiles then contain the names of verbs. Each verb should be given a binding that is
//appropriate for the profile. You can create bindings by calling one of the input_binding_*()
//functions, such as input_binding_key() for keyboard keys and input_binding_mouse() for
//mouse buttons

function __input_config_verbs()
{
    return {
        keyboard_and_mouse:
        {
            up:    [input_binding_key(vk_up),    input_binding_key("W")],
            down:  [input_binding_key(vk_down),  input_binding_key("S")],
            left:  [input_binding_key(vk_left),  input_binding_key("A")],
            right: [input_binding_key(vk_right), input_binding_key("D")],
            
            accept:  input_binding_key(vk_space),
            cancel:  input_binding_key(vk_backspace),
            action:  input_binding_key(vk_enter),
            special: input_binding_key(vk_shift),
            
            crouch: input_binding_key(vk_lcontrol),
            dash: input_binding_key(vk_shift),
            
            //No aiming verbs since we use the mouse for that (see below for aiming verb examples)
            shoot: input_binding_mouse_button(mb_left),
            
            pause: input_binding_key(vk_escape),
            
            //Custom
            test: input_binding_key("T"),
        },
        
    };
}