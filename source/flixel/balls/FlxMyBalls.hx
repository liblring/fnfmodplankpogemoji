package flixel.balls;

import flixel.FlxBasic;

enum abstract FlxBallState(String) to String {
  var NORMAL = "normal";
  var ITCHING = "itching";
}

class FlxMyBalls extends FlxBasic {
  public var state(default, never):FlxBallState = ITCHING;
  
  public function new() {
    super();
  }
}
