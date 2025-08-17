package haxel.hxlstd.math;

class HMath {
	public static function random(min:Float, max:Float):Float
		return min + Math.random() * (max - min);

	public static function randomInt(min:Int, max:Int):Int
		return Math.floor(Math.random() * (max - min)) + min;

	public static function clamp(value:Float, min:Float, max:Float):Float
		return Math.min(Math.max(value, min), max);

	public static function clampInt(value:Int, min:Int, max:Int):Int
		return Std.int(Math.min(Math.max(value, min), max));

	public static function lerp(a:Float, b:Float, t:Float):Float
		return a + (b - a) * clamp(t, 0, 1);

	public static function smoothstep(edge0:Float, edge1:Float, x:Float):Float {
		var t = clamp((x - edge0) / (edge1 - edge0), 0, 1);
		return t * t * (3 - 2 * t);
	}

	public static function map(value:Float, inMin:Float, inMax:Float, outMin:Float, outMax:Float):Float
		return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin);

	public static function toRadians(deg:Float):Float
		return deg * Math.PI / 180;

	public static function toDegrees(rad:Float):Float
		return rad * 180 / Math.PI;

	public static function sign(value:Float):Int
		return value == 0 ? 0 : (value > 0 ? 1 : -1);
}
