package haxel.hxlstd.math;

class Vec3 {
	public var x:Float;
	public var y:Float;
	public var z:Float;

	public function new(x:Float, y:Float, z:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function add(other:Vec3):Vec3
		return new Vec3(x + other.x, y + other.y, z + other.z);

	public function subtract(other:Vec3):Vec3
		return new Vec3(x - other.x, y - other.y, z - other.z);

	public function multiply(scalar:Float):Vec3
		return new Vec3(x * scalar, y * scalar, z * scalar);

	public function divide(scalar:Float):Vec3
		return new Vec3(x / scalar, y / scalar, z / scalar);

	public function addScalar(scalar:Float):Vec3
		return new Vec3(x + scalar, y + scalar, z + scalar);

	public function subtractScalar(scalar:Float):Vec3
		return new Vec3(x - scalar, y - scalar, z - scalar);

	public function multiplyScalar(scalar:Float):Vec3
		return new Vec3(x * scalar, y * scalar, z * scalar);

	public function divideScalar(scalar:Float):Vec3
		return new Vec3(x / scalar, y / scalar, z / scalar);

	public function dot(other:Vec3):Float
		return x * other.x + y * other.y + z * other.z;

	public function cross(other:Vec3):Vec3
		return new Vec3(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x);

	public function normalize():Vec3
		return divideScalar(length());

	public function length():Float
		return Math.sqrt(x * x + y * y + z * z);

	public function clone():Vec3
		return new Vec3(x, y, z);

	public function toString():String
		return 'Vec3(' + x + ', ' + y + ', ' + z + ')';
}
