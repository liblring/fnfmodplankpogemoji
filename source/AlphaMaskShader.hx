package;
import flixel.system.FlxAssets.FlxShader;

class AlphaMaskShader extends FlxShader {
	@:glFragmentSource('
	#pragma header

	uniform sampler2D mask;
	void main(void) {
		vec4 texel = flixel_texture2D(mask, openfl_TextureCoordv);
		texel.rgb = flixel_texture2D(bitmap, openfl_TextureCoordv).rgb;
		if (texel.a > 0.0)
			gl_FragColor = texel;
		else
			gl_FragColor = vec4(0., 0., 0., 0.);
	}
	')

	public function new() { super(); }
}