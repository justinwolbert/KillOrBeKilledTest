function print(message, prefix = "") {
    if (prefix != "")
    {
        show_debug_message($"{prefix} : {message}");
    } 
    else
    {
        show_debug_message(message);
    }
}

function gui_print(message) {
    draw_text(0,0,message);
}
