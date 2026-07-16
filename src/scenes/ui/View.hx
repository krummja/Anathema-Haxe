package scenes.ui;

import haxe.Exception;
import hxd.Key;
import h2d.Object;
import engine.MainLoop;
import engine.RenderLayerManager.RenderLayerType;
import engine.Frame;
import engine.Scene;
import common.struct.Size;
import common.struct.Rect;
import common.struct.IntPoint;

typedef ViewSettings = {
	var ?scene: Null<Scene>;
	var ?layout: Null<Layout>;
	var ?subviews: Null<Array<View>>;
	var ?frame: Null<Rect>;
	var ?clear: Null<Bool>;
	var ?layer: Null<RenderLayerType>;
}

class View {
	public var layoutSpec(default, null): Rect;
	public var intrinsicSize(default, null): Size;
	public var isFirstResponder(default, null): Bool;
	public var superview(default, null): Null<View>;
	public var scene(get, null): Scene;

	public var firstResponderContainerView(get, never): Null<View>;
	public var leftmostLeaf(get, never): View;
	public var postorderTraversal(get, never): Iterator<View>;
	public var ancestors(get, never): Iterator<View>;

	@:allow(scenes.ui.Layout)
	private var frame: Rect;

	@:allow(scenes.ui.Layout)
	private var bounds: Rect;

	private var subviews: Array<View>;
	private var firstResponder: Null<View> = null;

	private var layoutOptions: Layout;
	private var clear: Bool;
	private var isHidden: Bool;
	private var layer: RenderLayerType;
	private var ob: Object;
	private var needsLayout: Bool = false;

	public function new(settings: ViewSettings) {
		this.frame = settings.frame.or(Layout.ZERO_RECT);

		this.scene = settings.scene;
		this.superview = null;
		this.bounds = this.frame.withOrigin(new IntPoint(0, 0));
		this.needsLayout = true;

		this.clear = settings.clear;
		this.firstResponder = null;
		this.isFirstResponder = false;
		this.isHidden = false;

		this.subviews = [];
		this.addSubviews(settings.subviews.or([]));

		this.layoutSpec = this.frame;
		this.layoutOptions = settings.layout.or(new Layout({}));
		this.layer = settings.layer.or(HUD);

		this.ob = new Object();
	}

	public function init() {
		MainLoop.getInstance().render(this.layer, ob);
		for (view in subviews) {
			view.init();
		}
	}

	// Overridable API

	public function descendantDidBecomeFirstResponder(view: View): Bool {
		return false;
	}

	public function descendantDidResignFirstResponder(view: View): Bool {
		return false;
	}

	public function handleInput(key: Key): Bool {
		return false;
	}

	public function handleTextInput(text: String): Bool {
		return false;
	}

	public function canBecomeFirstResponder(): Bool {
		return false;
	}

	public function containsFirstResponders(): Bool {
		return false;
	}

	public function canResignFirstResponder(): Bool {
		return false;
	}

	public function update(frame: Frame) {}

	// Layout API

	public function setNeedsLayout(value: Bool = true) {
		this.needsLayout = value;
	}

	public function addSubview(subview: View) {
		addSubviews([subview]);
	}

	public function addSubviews(subviews: Array<View>): Void {
		for (view in subviews) {
			view.superview = this;
		}

		this.subviews.concat(subviews);
	}

	public function reviewSubview(subview: View) {
		removeSubviews([subview]);
	}

	public function removeSubviews(subviews: Array<View>) {
		for (view in subviews) {
			view.superview = null;
		}

		this.subviews = this.subviews.filter((v) -> !subviews.contains(v));
	}

	public function performUpdate(frame: Frame) {
		if (isHidden) {
			return;
		}

		update(frame);

		for (view in subviews) {
			view.performUpdate(frame);
		}
	}

	public function performLayout() {
		if (needsLayout) {
			layoutSubviews();
			needsLayout = false;
		}

		for (view in subviews) {
			view.performLayout();
		}
	}

	public function layoutSubviews() {
		for (view in subviews) {
			view.applySpringsAndStrutsLayoutInSuperview();
		}
	}

	public function didBecomeFirstRespoder() {
		setNeedsLayout(true);
		isFirstResponder = true;
	}

	public function didResignFirstResponder() {
		setNeedsLayout(true);
		isFirstResponder = false;
	}

	public function getAncestorMatching(predicate: (View) -> Bool): Null<View> {
		for (ancestor in ancestors) {
			if (predicate(ancestor)) {
				return ancestor;
			}
		}

		return null;
	}

	public function setBounds(value: Rect): Rect {
		if (value.origin.x != 0 && value.origin.y != 0) {
			throw new Exception("Bounds must always be anchored at (0, 0)");
		}

		if (value == this.bounds) {
			return this.bounds;
		}

		this.bounds = value;
		this.frame = this.frame.withSize(value.size);
		return value;
	}

	public function applySpringsAndStrutsLayoutInSuperview(): Void {
		var options = layoutOptions;
		var spec = layoutSpec;
		var superviewBounds = superview.bounds;

		var fields = [
			["left", "right", "x", "width"],
			["top", "bottom", "y", "height"]
		];

		var finalFrame = new Rect(new IntPoint(-1000, -1000), new Size(-1000, -1000));

		for (fieldList in fields) {
			switch (fieldList) {
				case [start, end, coord, size]:
					var matches = [
						options.isDefined(start),
						options.isDefined(size),
						options.isDefined(end)
					];

					switch (matches) {
						case [true, true, true]:
							trace("Invalid spring/strut definition");
							break;
						case [false, false, false]:
							trace("Invalid spring/strut definition");
							break;
						case [true, false, false]:
							Reflect.setField(finalFrame, coord, options.getValue(start, this));
							Reflect.setField(finalFrame, size, Reflect.field(spec, size));
							break;
						case [true, true, false]:
							Reflect.setField(finalFrame, coord, options.getValue(start, this));
							Reflect.setField(finalFrame, size, options.getValue(size, this));
							break;
						case [false, true, false]:
							var sizeVal = options.getValue(size, this);
							Reflect.setField(finalFrame, size, sizeVal);
							Reflect.setField(finalFrame, coord, Reflect.field(superviewBounds, size) / 2 - sizeVal / 2);
							break;
						case [false, true, true]:
							var sizeVal = options.getValue(size, this);
							Reflect.setField(finalFrame, size, sizeVal);
							Reflect.setField(finalFrame, coord, Reflect.field(superviewBounds, size) - options.getValue(end, this) - sizeVal);
							break;
						case [false, false, true]:
							Reflect.setField(finalFrame, coord, Reflect.field(superviewBounds, size) - options.getValue(end, this));
							Reflect.setField(finalFrame, size, Reflect.field(spec, size));
							break;
						case [true, false, true]:
							var startVal = options.getValue(start, this);
							var endVal = options.getValue(end, this);
							Reflect.setField(finalFrame, coord, startVal);
							Reflect.setField(finalFrame, size, Reflect.field(superviewBounds, size) - startVal - endVal);
							break;
						case _:
							trace("Unhandled spring/strut definition case");
							break;
					}
				case _:
					trace("Invalid field values");
					break;
			}
		}

		frame = finalFrame.floored;
		trace([frame.x, frame.y, frame.x2, frame.y2]);
	}

	private function get_scene(): Scene {
		if (this.scene != null) {
			return this.scene;
		}

		return this.superview.scene;
	}

	private function set_frame(value: Rect): Rect {
		if (value == this.frame) {
			return this.frame;
		}
		this.frame = value;
		setBounds(value.withOrigin(new IntPoint(0, 0)));
		this.setNeedsLayout(true);
		return value;
	}

	private function get_firstResponderContainerView(): Null<View> {
		if (firstResponder != null) {
			return this;
		}

		for (view in ancestors) {
			if (view.firstResponder != null) {
				return view;
			}
		}

		return null;
	}

	private function get_leftmostLeaf(): Null<View> {
		if (subviews != null && subviews.length > 0) {
			return subviews[0].leftmostLeaf;
		}

		return this;
	}

	private function get_postorderTraversal(): Iterator<View> {
		var views = subviews.copy();
		views.push(this);
		return views.iterator();
	}

	private function get_ancestors(): Iterator<View> {
		var view = superview;
		var ancestors = [];

		while (view != null) {
			ancestors.push(view);
			view = view.superview;
		}

		return ancestors.iterator();
	}
}
