package haxel.hxlstd.display3d.projection;

import haxel.hxlstd.math.Vec3;

interface IProjector {
	public function project(point:Vec3):Vec3;
}
