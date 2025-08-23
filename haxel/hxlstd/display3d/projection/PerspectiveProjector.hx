package haxel.hxlstd.display3d.projection;

import haxel.hxlstd.math.Vec3;

class PerspectiveProjector implements IProjector {
	public var fov:Float;
	public var width:Float;
	public var height:Float;
	public var nearPlane:Float = 0.1;
	public var farPlane:Float = 100000;
	public var customProjectionMatrix:Bool = false;
	public var getMatrix:(Float, Float, Float, Float, Float) -> Array<Float> = (fov:Float, width:Float, height:Float, nearPlane:Float, farPlane:Float) -> {
		var fovRadians = fov * Math.PI / 180;
		var f = 1.0 / Math.tan(fovRadians / 2);
		var nf = 1 / (nearPlane - farPlane);
		var aspect = width / height;
		var a = f / aspect;
		var b = (farPlane + nearPlane) * nf;
		var c = (2 * farPlane * nearPlane) * nf;
		return [
			a, 0, 0,  0,
			0, f, 0,  0,
			0, 0, b, -1,
			0, 0, c,  0
		];
	};

	public function new(fov:Float, width:Float, height:Float, nearPlane:Float = 0.1, farPlane:Float = 100000, customProjectionMatrix:Bool = false,
			getMatrix:(Float, Float, Float, Float, Float) -> Array<Float> = null) {
		this.fov = fov;
		this.width = width;
		this.height = height;
		this.nearPlane = nearPlane;
		this.farPlane = farPlane;
		this.customProjectionMatrix = customProjectionMatrix;
		if (customProjectionMatrix)
			this.getMatrix = getMatrix;
	}

	public function project(point:Vec3):Vec3 {
		var x = point.x, y = point.y, z = point.z;

		var projectionMatrix = getMatrix(fov, width, height, nearPlane, farPlane); // only get it once
		var px = x * projectionMatrix[0] + y * projectionMatrix[4] + z * projectionMatrix[8] + projectionMatrix[12];
		var py = x * projectionMatrix[1] + y * projectionMatrix[5] + z * projectionMatrix[9] + projectionMatrix[13];
		var pz = x * projectionMatrix[2] + y * projectionMatrix[6] + z * projectionMatrix[10] + projectionMatrix[14];
		var pw = x * projectionMatrix[3] + y * projectionMatrix[7] + z * projectionMatrix[11] + projectionMatrix[15];

		px /= pw;
		py /= pw;
		pz /= pw;

		var sx = (px + 1) * 0.5 * width;
		var sy = (py + 1) * 0.5 * height;
		var sz = (pz + 1) * 0.5;

		return new Vec3(sx, sy, sz);
	}
}
