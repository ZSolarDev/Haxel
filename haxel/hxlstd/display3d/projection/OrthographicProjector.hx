package haxel.hxlstd.display3d.projection;

import haxel.hxlstd.math.Vec3;

class OrthographicProjector implements IProjector {
	public var width:Float;
	public var height:Float;
	public var nearPlane:Float = 0.1;
	public var farPlane:Float = 100000;
	public var customProjectionMatrix:Bool = false;
	public var getMatrix:(Float, Float, Float, Float) -> Array<Float> = (width:Float, height:Float, nearPlane:Float, farPlane:Float) -> {
		var Lx = -width / 2;
		var Rx = width / 2;
		var By = -height / 2;
		var Ty = height / 2;
		var Nz = nearPlane;
		var Fz = farPlane;
		var xS = 2 / (Rx - Lx);
		var yS = 2 / (Ty - By);
		var zS = -2 / (Fz - Nz);
		var xO = -(Rx + Lx) / (Rx - Lx);
		var yO = -(Ty + By) / (Ty - By);
		var zO = -(Fz + Nz) / (Fz - Nz);
		return [
			xS,  0,  0, 0,
			 0, yS,  0, 0,
			 0,  0, zS, 0,
			xO, yO, zO, 1
		];
	};

	public function new(width:Float, height:Float, nearPlane:Float = 0.1, farPlane:Float = 100000, customProjectionMatrix:Bool = false,
			getMatrix:(Float, Float, Float, Float) -> Array<Float> = null) {
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

		var projectionMatrix = getMatrix(width, height, nearPlane, farPlane);
		var px = x * projectionMatrix[0] + y * projectionMatrix[4] + z * projectionMatrix[8] + projectionMatrix[12];
		var py = x * projectionMatrix[1] + y * projectionMatrix[5] + z * projectionMatrix[9] + projectionMatrix[13];
		var pz = x * projectionMatrix[2] + y * projectionMatrix[6] + z * projectionMatrix[10] + projectionMatrix[14];

		var sx = (px + 1) * 0.5 * width;
		var sy = (py + 1) * 0.5 * height;
		var sz = (pz + 1) * 0.5;

		return new Vec3(sx, sy, sz);
	}
}
