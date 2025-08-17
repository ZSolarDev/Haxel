package haxel.hxlstd.math;

class Vec4 {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;

	public function new(x:Float, y:Float, z:Float, w:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public function add(other:Vec4):Vec4
		return new Vec4(x + other.x, y + other.y, z + other.z, w + other.w);

	public function subtract(other:Vec4):Vec4
		return new Vec4(x - other.x, y - other.y, z - other.z, w - other.w);

	public function multiply(other:Vec4):Vec4
		return new Vec4(x * other.x, y * other.y, z * other.z, w * other.w);

	public function divide(other:Vec4):Vec4
		return new Vec4(x / other.x, y / other.y, z / other.z, w / other.w);

	public function addScalar(scalar:Float):Vec4
		return new Vec4(x + scalar, y + scalar, z + scalar, w + scalar);

	public function subtractScalar(scalar:Float):Vec4
		return new Vec4(x - scalar, y - scalar, z - scalar, w - scalar);

	public function multiplyScalar(scalar:Float):Vec4
		return new Vec4(x * scalar, y * scalar, z * scalar, w * scalar);

	public function divideScalar(scalar:Float):Vec4
		return new Vec4(x / scalar, y / scalar, z / scalar, w / scalar);

	public function dot(other:Vec4):Float
		return x * other.x + y * other.y + z * other.z + w * other.w;

	public function cross(other:Vec4):Vec4
		return new Vec4(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x, 0);

	public function normalize():Vec4
		return divideScalar(length());

	public function length():Float
		return Math.sqrt(x * x + y * y + z * z + w * w);

	public function clone():Vec4
		return new Vec4(x, y, z, w);

	public function toString():String
		return 'Vec4(' + x + ', ' + y + ', ' + z + ', ' + w + ')';
}
