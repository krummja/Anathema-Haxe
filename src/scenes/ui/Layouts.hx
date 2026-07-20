package scenes.ui;

import h2d.Object;
import haxe.ui.containers.Grid;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;

@:xml('
<vbox width="100%" height="100%">
    <style>
    .grid {
        padding: 2px;
    }

    .grid-cell {
        background-opacity: 0.1;
        border-width: 1px;
        border-style: solid;
    }

    .top-row {
        background-color: #b41c2b;
        border-color: #b41c2b;
    }

    .center-row {
        background-color: #009f42;
        border-color: #009f42;
    }

    .bottom-row {
        background-color: #2d70e7;
        border-color: #2d70e7;
    }
    </style>
    <hbox width="100%" height="100%">
        <vbox width="100%" height="100%">
            <grid width="100%" height="100%" id="grid-layout" columns="3">
                <box styleName="top-row grid-cell" id="grid-tl" width="25%" height="20px" />
                <box styleName="top-row grid-cell" id="grid-tc" width="50%" height="20px" />
                <box styleName="top-row grid-cell" id="grid-tr" width="25%" height="20px" />

                <box styleName="center-row grid-cell" id="grid-cl" width="25%" height="100%" />
                <box styleName="center-row grid-cell" id="grid-cc" width="50%" height="100%" />
                <box styleName="center-row grid-cell" id="grid-cr" width="25%" height="100%" />

                <box styleName="bottom-row grid-cell" id="grid-bl" width="25%" height="20px" />
                <box styleName="bottom-row grid-cell" id="grid-bc" width="50%" height="20px" />
                <box styleName="bottom-row grid-cell" id="grid-br" width="25%" height="20px" />
            </grid>
        </vbox>
    </hbox>
</vbox>
')
class GridLayout extends VBox {
	public function new() {
		super();

		trace(gridTl);
	}
}
