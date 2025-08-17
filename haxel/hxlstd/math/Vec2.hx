package haxel.hxlstd.math;

class Vec2 {
	public var x:Float;
	public var y:Float;

	public function new(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	public function add(other:Vec2):Vec2
		return new Vec2(x + other.x, y + other.y);

	public function subtract(other:Vec2):Vec2
		return new Vec2(x - other.x, y - other.y);

	public function multiply(scalar:Float):Vec2
		return new Vec2(x * scalar, y * scalar);

	public function divide(scalar:Float):Vec2
		return new Vec2(x / scalar, y / scalar);

	public function addScalar(scalar:Float):Vec2
		return new Vec2(x + scalar, y + scalar);

	public function subtractScalar(scalar:Float):Vec2
		return new Vec2(x - scalar, y - scalar);

	public function multiplyScalar(scalar:Float):Vec2
		return new Vec2(x * scalar, y * scalar);

	public function divideScalar(scalar:Float):Vec2
		return new Vec2(x / scalar, y / scalar);

	public function dot(other:Vec2):Float
		return x * other.x + y * other.y;

	public function cross(other:Vec2):Float
		return x * other.y - y * other.x;

	public function normalize():Vec2
		return divideScalar(length());

	public function length():Float
		return Math.sqrt(x * x + y * y);

	public function clone():Vec2
		return new Vec2(x, y);

	public function toString():String
		return 'Vec2(' + x + ', ' + y + ')';
}
