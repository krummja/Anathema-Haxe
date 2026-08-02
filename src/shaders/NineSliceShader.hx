package shaders;

import h2d.Tile;
import h3d.mat.Texture;
import hxsl.Types.Vec;

class NineSliceShader extends hxsl.Shader {
	static var SRC = {
        // @formatter:off

        @param var texture: Sampler2D;
        @param var width: Float;
        @param var height: Float;
        @param var scale: Vec2;
        @param var right: Int;
        @param var top: Int;
        @param var left: Int;
        @param var bottom: Int;

        var pixelColor: Vec4;
        var calculatedUV: Vec2;

        function map(value: Float, originalMin: Float, originalMax: Float, newMin: Float, newMax: Float): Float {
            return (value - originalMin) / (originalMax - originalMin) * (newMax - newMin) + newMin;
        }

        function processAxis(coord: Float, pixel: Float, texPixel: Float, start: Float, end: Float): Float {
            if (coord > 1.0 - end * pixel) {
                return map(coord, 1.0 - end * pixel, 1.0, 1.0 - texPixel * end, 1.0);
            } else if (coord > start * pixel) {
                return map(coord, start * pixel, 1.0 - end * pixel, start * texPixel, 1.0 - end * texPixel);
            } else {
                return map(coord, 0.0, start * pixel, 0.0, start * texPixel);
            }
        }

        function texelSize(width: Float, height: Float): Vec2 {
            return vec2(1.0 / width, 1.0 / height);
        }

        function fragment() {
            var texPixelSize = vec2(1.0 / width, 1.0 / height);
            var pxSize = texPixelSize / scale;
            var uv = calculatedUV;

            var mappedUV: Vec2 = vec2(
                processAxis(uv.x, pxSize.x, texPixelSize.x, float(left), float(right)),
                processAxis(uv.y, pxSize.y, texPixelSize.y, float(top), float(bottom)),
            );

            pixelColor = texture.get(mappedUV);
        }
        // @formatter:on
	};

	public function new(
		texture: Texture,
		width: Float,
		height: Float,
		sx: Float,
		sy: Float,
		right: Int,
		top: Int,
		left: Int,
		bottom: Int
	) {
		super();

		this.texture = texture;
		this.width = width;
		this.height = height;
		this.scale = new Vec(sx, sy);
		this.right = right;
		this.top = top;
		this.left = left;
		this.bottom = bottom;
	}
}
