package;

import haxe.Timer;
import openfl.display.BitmapData;
import haxe.io.Bytes;
import hl.video.Webm;
import hl.video.Aom;
import flixel.FlxSprite;

// most of the code is stolen from heaps lmao!!!
// yeah this is the reason you have to use hlvideo

enum FrameState {
	Free;
	Loading;
	Ready;
	Ended;
}

typedef Frame = {
	var data:haxe.io.Bytes;
	var time:Float;
	var state:FrameState;
}

class FrameBuffer {
	var frameBuffer:Array<Frame> = [];
	var readIndex:Int = 0;
	var writeIndex:Int = 0;
	var width:Int = 0;
	var height:Int = 0;

	public function new(webm:Webm, size:Int) {
		width = webm.width;
		height = webm.height;
		for (_ in 0...size) {
			frameBuffer.push({
				data: haxe.io.Bytes.alloc(webm.width * webm.height),
				time: 0,
				state: Free
			});
		}
	}

	public function currentFrame():Frame
		return frameBuffer[readIndex];

	public function nextFrame():Bool {
		var nextIndex = (readIndex + 1) % frameBuffer.length;
		frameBuffer[readIndex].state = Free;
		readIndex = nextIndex;
		return true;
	}

	function frameBufferSize():Int {
		if(writeIndex < readIndex)
			return frameBuffer.length - readIndex + writeIndex;
		else
			return writeIndex - readIndex;
	}

	public function isFull():Bool {
		if(writeIndex < readIndex)
			return frameBuffer.length - readIndex + writeIndex >= frameBuffer.length - 1;
		else
			return writeIndex - readIndex >= frameBuffer.length - 1;
	}

	public function isEmpty():Bool
		return readIndex == writeIndex;

	public function prepareFrame(webm:Webm, codec:Codec, loop : Bool) : Frame {
		if(frameBuffer[writeIndex].state != Free)
			return null;

		var savedCursor = writeIndex;
		var f = frameBuffer[writeIndex];

		var time = webm.readFrame(codec, f.data);
		if(time == null) {
			if(loop) {
				webm.rewind();
				time = webm.readFrame(codec, f.data);
			}
			else {
				f.time = 0;
				f.state = Ended;
				return f;
			}
		}
		f.time = time;
		f.state = Ready;
		writeIndex++;
		if(writeIndex >= frameBuffer.length)
			writeIndex %= frameBuffer.length;
		return f;
	}

	public function dispose() {
		for (f in frameBuffer)
			f.data = null;
	}
}

class Video extends FlxSprite
{
	public var playbackRate:Float = 1;
	public var bufferSize:Int = 24;

	var startTime:Float;
	var webm:Webm;
	var codec:AV1;
	var buffer:FrameBuffer;
	var playing:Bool = false;


	public function loadPath(path:String)
	{
		webm = Webm.fromFile(path);
		play();
	}

	public function play()
	{
		webm.init();
		codec = webm.createCodec();

		
		buffer = new FrameBuffer(webm, bufferSize);

        buffer.nextFrame();
        trace(webm, codec, buffer.currentFrame());
		buffer.prepareFrame(webm, codec, true);
        startTime = Timer.stamp();
		playing = true;

	}

	override public function destroy() {
		webm.close();
		codec.close();
		buffer.dispose();
		super.destroy();
	}


	override public function update(delta:Float)
	{
		super.update(delta);

		if (!playing)
			return;
		if(!(buffer.currentFrame() != null && buffer.currentFrame().state == Ready)) return; 
        if ((Timer.stamp() - startTime) >= (buffer.currentFrame().time / playbackRate)) {
            pixels = BitmapData.fromBytes(openfl.utils.ByteArray.fromBytes(buffer.currentFrame().data));
            buffer.nextFrame();
			buffer.prepareFrame(webm, codec, true);
        }
	}
}