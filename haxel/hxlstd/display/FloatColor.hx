package haxel.hxlstd.display;

class FloatColor {
	public var r:Float;
	public var g:Float;
	public var b:Float;
	public var a:Float;

	public function new(r:Float, g:Float, b:Float, a:Float) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	public function add(other:FloatColor):FloatColor
		return new FloatColor(other.r + r, other.g + g, other.b + b, other.a + a);

	public function scale(f:Float):FloatColor
		return new FloatColor(r * f, g * f, b * f, a * f);

	public function clone():FloatColor
		return new FloatColor(r, g, b, a);

	public function toString():String
		return 'FloatColor(' + r + ', ' + g + ', ' + b + ', ' + a + ')';
}
