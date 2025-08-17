package haxel.hxlstd.display;

class RGBA {
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var a:Int;

	public function new(r:Int, g:Int, b:Int, a:Int) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	public function add(other:RGBA):RGBA
		return new RGBA(Std.int(Math.min(255, r + other.r)), Std.int(Math.min(255, g + other.g)), Std.int(Math.min(255, b + other.b)),
			Std.int(Math.min(255, a + other.a)));

	public function scale(f:Float):RGBA
		return new RGBA(Std.int(Math.min(255, r * f)), Std.int(Math.min(255, g * f)), Std.int(Math.min(255, b * f)), Std.int(Math.min(255, a * f)));

	public function toInt():Int
		return (a & 0xFF) << 24 | (r & 0xFF) << 16 | (g & 0xFF) << 8 | (b & 0xFF);

	public function clone():RGBA
		return new RGBA(r, g, b, a);

	public function toString():String
		return 'RGBA(' + r + ', ' + g + ', ' + b + ')';

	public function toHexString():String
		return StringTools.hex(toInt(), 8);
}
