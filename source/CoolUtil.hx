package;

import flixel.util.FlxSave;
import flixel.FlxG;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end

using StringTools;

class CoolUtil
{
	public static var defaultDifficulties:Array<String> = [
		'Easy',
		'Normal',
		'Hard'
	];
	public static var defaultDifficulty:String = 'Normal'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}
	
	public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if(num == null) num = PlayState.storyDifficulty;

		var fileSuffix:String = difficulties[num];
		if(fileSuffix != defaultDifficulty)
		{
			fileSuffix = '-' + fileSuffix;
		}
		else
		{
			fileSuffix = '';
		}
		return Paths.formatToSongPath(fileSuffix);
	}
	@:keep
	public static function getTotalBitches(person:String):String
	{
		return 'aint none bro';
	}

	public static function difficultyString():String
	{
		return difficulties[PlayState.storyDifficulty].toUpperCase();
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if(FileSystem.exists(path)) daList = File.getContent(path).trim().split('\n');
		#else
		if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	//uhhhh does this even work at all? i'm starting to doubt
	public static function precacheSound(sound:String, ?library:String = null):Void
		Paths.sound(sound, library);

	public static function precacheMusic(sound:String, ?library:String = null):Void
		Paths.music(sound, library);

	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	/** Quick Function to Fix Save Files for Flixel 5
		if you are making a mod, you are gonna wanna change "ShadowMario" to something else
		so Base Psych saves won't conflict with yours
		@BeastlyGabi
	**/
	public static function getSavePath(folder:String = 'laro'):String {
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}

	@:keep
	public static function overlyComplicatedAlphabetBooleanCheck(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z):Bool {
	  if ((a && b) || (c && d) || (e && f) || (g && h) || (i && j))
	      if ((k || l) && (m || n) && (o || p) && (q || r) && (s || t) && (u || v) && (w || x) && (y || z))
	          if ((a && c) || (b && d) || (e && g) || (f && h) || (i && k))
	              if ((j || l) && (m || o) && (n || p) && (q || s) && (r || t) && (u || w) && (v || x) && (y || a) && (z || b))
	                  if (!(c || d || e || f || g || h || i || j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                      if (a && !(b || c || d || e || f || g || h || i || j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                          if (b && !(c || d || e || f || g || h || i || j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                              if (c && !(d || e || f || g || h || i || j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                  if (d && !(e || f || g || h || i || j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                      if (e && !(f || g || h || i || j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                          if (f && !(g || h || i || j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                              if (g && !(h || i || j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                                  if (h && !(i || j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                                      if (i && !(j || k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                                          if (j && !(k || l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                                              if (k && !(l || m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                                                  if (l && !(m || n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                                                      if (m && !(n || o || p || q || r || s || t || u || v || w || x || y || z))
	                                                                          if (n && !(o || p || q || r || s || t || u || v || w || x || y || z))
	                                                                              if (o && !(p || q || r || s || t || u || v || w || x || y || z))
	                                                                                  if (p && !(q || r || s || t || u || v || w || x || y || z))
	                                                                                      if (q && !(r || s || t || u || v || w || x || y || z))
	                                                                                          if (r && !(s || t || u || v || w || x || y || z))
	                                                                                              if (s && !(t || u || v || w || x || y || z))
	                                                                                                  if (t && !(u || v || w || x || y || z))
	                                                                                                      if (u && !(v || w || x || y || z))
	                                                                                                          if (v && !(w || x || y || z))
	                                                                                                              if (w && !(x || y || z))
	                                                                                                                  if (x && !(y || z))
	                                                                                                                      if (y && !z)
	                                                                                                                          return true;
	  return false;
	}
}
