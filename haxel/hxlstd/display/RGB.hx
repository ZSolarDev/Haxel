package haxel.hxlstd.display;

class RGB {
	public var r:Int;
	public var g:Int;
	public var b:Int;

	public function new(r:Int, g:Int, b:Int) {
		this.r = r;
		this.g = g;
		this.b = b;
	}

	public function add(other:RGB):RGB
		return new RGB(Std.int(Math.min(255, r + other.r)), Std.int(Math.min(255, g + other.g)), Std.int(Math.min(255, b + other.b)));

	public function scale(f:Float):RGB
		return new RGB(Std.int(Math.min(255, r * f)), Std.int(Math.min(255, g * f)), Std.int(Math.min(255, b * f)));

	public function toInt():Int
		return (r & 0xFF) << 16 | (g & 0xFF) << 8 | (b & 0xFF);

	public function clone():RGB
		return new RGB(r, g, b);

	public function toString():String
		return 'RGB(' + r + ', ' + g + ', ' + b + ')';

	public static function fromInt(rgb:Int):RGB
		return new RGB((rgb >> 16) & 0xFF, (rgb >> 8) & 0xFF, rgb & 0xFF);

	public function toHexString():String
		return StringTools.hex(toInt(), 6);
}
