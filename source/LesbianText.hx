package;

import flixel.FlxG;
import flixel.FlxObject;
import openfl.text.TextField;
import openfl.display.GraphicsShader;
import openfl.geom.Matrix;
import flixel.math.FlxAngle;

class LesbianText extends FlxObject {
	public var textField:TextField;
	public var scaleX:Float;
	public var scaleY:Float;

	private var _matrix:Matrix;

	public function new(text:String):Void {
		super();
		textField = new TextField();
		textField.text = text;

		_matrix = new Matrix();

		angle = 0;
		scaleX = scaleY = 1;
	}

	override public function draw() {
		_matrix.identity();
		_matrix.translate(x, y);
		_matrix.scale(scaleX, scaleY);
		_matrix.rotate(FlxAngle.TO_RAD * angle);
		for (cam in cameras) {
			@:privateAccess cam.canvas.graphics.beginBitmapFill(textField.__cacheBitmap.bitmapData, _matrix, false, false);
			cam.canvas.graphics.drawRect(0, 0, _matrix.a + _matrix.c, _matrix.b + _matrix.d);
		}
	}
}

typedef GayText = LesbianText;
typedef BiText = LesbianText;