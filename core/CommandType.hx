package core;


enum abstract CommandType(String) to String
{
    var CMD_SAVE = "save";
    var CMD_CONFIRM = "confirm";
    var CMD_CYCLE_INPUT = "tab input";
    var CMD_CYCLE_INPUT_REVERSE = "tab input (reverse)";
    var CMD_CANCEL = "cancel";
    var CMD_WAIT = "wait";
    var CMD_CONSOLE = "console";
    var CMD_MOVE_N = "move_n";
    var CMD_MOVE_NE = "move_ne";
    var CMD_MOVE_E = "move_e";
    var CMD_MOVE_SE = "move_se";
    var CMD_MOVE_S = "move_s";
    var CMD_MOVE_SW = "move_sw";
    var CMD_MOVE_W = "move_w";
    var CMD_MOVE_NW = "move_nw";
}
