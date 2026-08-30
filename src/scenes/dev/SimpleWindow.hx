package scenes.dev;

import haxe.ui.containers.windows.Window;

@:xml('
    <window title="Simple Window" width="350">
        <window-title width="100%">
        </window-title>
        <box id="windowBody" width="100%" height="100%">
            <label text="Hello" />
        </box>
        <window-footer>
            <label text="Footer" />
        </window-footer>
    </window>
')
class SimpleWindow extends Window {}
