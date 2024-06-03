package core;


@:structInit class Command
{
    public var domain: InputDomainType;
    public var type: CommandType;
    public var key: KeyCode;
    public var shift: Bool;
    public var ctrl: Bool;
    public var alt: Bool;

    public var name(get, never): String;

    public function isMatch(event: KeyEvent): Bool
    {
        return (
            key == event.key &&
            shift == event.shift &&
            ctrl == event.ctrl &&
            alt == event.alt
        );
    }

    public function toString(): String
    {
        return name;
    }

    public function friendlyKey(): String
    {
        var val = "";

        if (shift) val += "shift+";
        if (ctrl) val += "ctrl+";
        if (alt) val += "alt+";

        val += key.toChar();

        return val;
    }

    private function get_name(): String
    {
        return this.type;
    }
}
