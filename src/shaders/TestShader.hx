package shaders;

class TestShader extends hxsl.Shader {
	static var SRC = {
        // @formatter:off
        var pixelColor: Vec4;

        function fragment() {
            pixelColor.rgb /= 2;
        }
        // @formatter:on
	}
}
