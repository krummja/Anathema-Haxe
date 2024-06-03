package data;

import core.Command;
import core.KeyCode;
import core.CommandType;
import core.InputDomainType;


class Commands
{
    public static var values: Array<Command>;

    public static function Init()
    {
        values = new Array();

        // @formatter:off
        //  Domain                  Type                        Key         Shift   Ctrl    Alt
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_CONSOLE,                KEY_COMMA,  true,   false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_CYCLE_INPUT,            KEY_TAB,    false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_CYCLE_INPUT_REVERSE,    KEY_TAB,    true,   false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_CONFIRM,                KEY_ENTER,  false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_CANCEL,                 KEY_ESCAPE, false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_MOVE_N,                 KEY_W,      false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_MOVE_NE,                KEY_E,      false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_MOVE_E,                 KEY_D,      false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_MOVE_SE,                KEY_C,      false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_MOVE_S,                 KEY_X,      false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_MOVE_SW,                KEY_Z,      false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_MOVE_W,                 KEY_A,      false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_MOVE_NW,                KEY_Q,      false,  false,  false);
        cmd(INPUT_DOMAIN_DEFAULT,   CMD_WAIT,                   KEY_S,      false,  false,  false);
        // @formatter:on
    }

    public static function GetForDomain(domains: Array<InputDomainType>): Array<Command>
    {
        return values.filter((c) -> domains.has(c.domain));
    }

    private static function cmd(
        domain: InputDomainType,
        type: CommandType,
        key: KeyCode,
        shift: Bool = false,
        ctrl: Bool = false,
        alt: Bool = false,
    ) {
        values.push({
            domain: domain,
            type: type,
            key: key,
            shift: shift,
            ctrl: ctrl,
            alt: alt
        });
    }
}
