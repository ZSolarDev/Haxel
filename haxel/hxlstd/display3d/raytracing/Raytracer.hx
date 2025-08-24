#if hl
package haxel.hxlstd.display3d.raytracing;

import haxe.Json;
import haxel.hxlstd.math.Vec3;
import hl.F32;

/**
 * The result of a ray trace.
 */
typedef RaytraceResult = {
	var hit:Bool;
	var distance:Float;
	var hitPos:Vec3;
	var geomID:Int;
	var geom:GeometryMeshPart;
	var triangleID:Int;
}

/**
 * A ray. (duh..)
 */
typedef Ray = {
	var pos:Vec3;
	var dir:Vec3;
}

/**
 * The geometry to raytrace.
 */
typedef Geometry = {
	var meshes:Array<GeometryMesh>;
}

/**
 * A mesh in the geometry.
 */
typedef GeometryMesh = {
	var meshParts:Array<GeometryMeshPart>;
}

/**
 * A part of a mesh in the geometry.
 */
typedef GeometryMeshPart = {
	var indices:Array<Int>;
	var vertices:Array<Vec3>;
}

/**
 * A Raytracer. It's very easy to use:
 * ```haxe
 * var raytracer = new Raytracer();
 * 
 * // Setting the geometry
 * raytracer.geometry = {meshes: [...]};
 * // Automatically rebuilds/builds the bvh *if needed.* If the geometry didnt change, it doesnt waste performance rebuilding.
 * raytracer.updateGeometry(); 
 * 
 * // Tracing a ray
 * var ray = {
 *     pos: new Vec3(0, 0, 0), // origin of the ray
 *     dir: new Vec3(0, 0, -1) // NORMALIZED direction it'll trace in. This shouldn't be zero!
 * };
 * var hitResult = raytracer.traceRay(ray);
 * 
 * // Getting the result
 * var hit = hitResult.hit;
 * if (hit){
 *     var distanceFromOriginToHit = hitResult.distance;
 *     var geometryIDHit = hitResult.geomID;
 *     var geometryMeshPartHit = hitResult.geom;
 *     var triangleIDOfGeometryHit = hitResult.triangleID;
 *     var positionOfHit = hitResult.hitPos;
 *     // Do something with the result
 * }
 * 
 * // Disposing the raytracer
 * raytracer.dispose(); // YOU CANNOT USE IT AFTER THIS! It will cause undefined behavior.
 * ```
 */
class Raytracer {
	public var raytracer:RaytracerBackend;
	public var geometry:Geometry = {
		meshes: []
	};
	public var geomParts(get, never):Array<GeometryMeshPart> = [];

	function get_geomParts():Array<GeometryMeshPart> {
		var parts = [];
		for (mesh in geometry.meshes)
			for (meshPart in mesh.meshParts)
				parts.push(meshPart);
		return parts;
	}

	public var prevGeoms:Array<Geometry> = [];

	public function new() {
		raytracer = new RaytracerBackend();
	}

	function jsonifyGeom(geom:Geometry):String {
		var _geometry:JGeometry = {
			geometry: []
		}
		for (mesh in geometry.meshes) {
			var geometryMesh:JGeometryMesh = {
				meshParts: []
			}
			for (meshPart in mesh.meshParts) {
				var vertices = [];
				for (vertex in meshPart.vertices) {
					vertices.push(vertex.x);
					vertices.push(vertex.y);
					vertices.push(vertex.z);
				}
				var geometryMeshPart:JGeometryMeshPart = {
					indices: meshPart.indices,
					vertices: vertices
				}
				geometryMesh.meshParts.push(geometryMeshPart);
			}
			_geometry.geometry.push(geometryMesh);
		}
		return Json.stringify(_geometry);
	}

	public function updateGeometry() {
		var jsonified = jsonifyGeom(geometry);
		if (prevGeoms.length != 0) {
			if (geometry != prevGeoms[prevGeoms.length - 1]) {
				var oldJsonified = jsonifyGeom(prevGeoms[0]);
				if (oldJsonified != jsonified) {
					raytracer.geometry = jsonified;
					raytracer.rebuildBVH();
				}
				prevGeoms.shift(); // remove oldest
			}
		} else {
			raytracer.geometry = jsonified;
			raytracer.buildBVH();
		}
		// keep a history of the last 20 geoms to detect if theres a big enough change to rebuild the bvh
		if (prevGeoms.length < 20) {
			var meshes:Array<GeometryMesh> = [];
			for (gMesh in geometry.meshes) {
				var mesh:GeometryMesh = {
					meshParts: []
				};
				for (gMeshPart in gMesh.meshParts) {
					var meshPart:GeometryMeshPart = {
						indices: gMeshPart.indices.copy(),
						vertices: gMeshPart.vertices.clone()
					}
					mesh.meshParts.push(meshPart);
				}
				meshes.push(mesh);
			}
			prevGeoms.push({meshes: meshes});
		}
	}

	public function traceRay(ray:Ray):RaytraceResult {
		var res = raytracer.traceRay(ray);
		return {
			hit: res.hit,
			distance: res.distance,
			geomID: res.geomID,
			hitPos: ray.pos.add(ray.dir.multiplyScalar(res.distance)),
			geom: geomParts[res.geomID],
			triangleID: res.primID
		}
	}

	/**
	 * Disposes of this raytracer. This raytracer becomes unusable after running this.
	 * Running functions on this raytracer after calling dispose ***will*** result in undefined behavior.
	 */
	public function dispose()
		raytracer.dispose();
}

//------ DONT MESS WITH THIS STUFF. ------//

@:noCompletion
typedef JGeometry = {
	var geometry:Array<JGeometryMesh>;
}

@:noCompletion
typedef JGeometryMesh = {
	var meshParts:Array<JGeometryMeshPart>;
}

@:noCompletion
typedef JGeometryMeshPart = {
	var indices:Array<Int>;
	var vertices:Array<Float>;
}

@:noCompletion
class TraceResult {
	public var hit:Bool;
	public var distance:F32;
	public var geomID:Int;
	public var primID:Int;

	public function new() {}
}

@:noCompletion
class SimpleRay {
	public var posx:F32;
	public var posy:F32;
	public var posz:F32;
	public var dirx:F32;
	public var diry:F32;
	public var dirz:F32;

	public function new() {}
}

class RaytracerBackend {
	public static var ID:Int = 0;

	private var _ID:Int = 0;
	private var _raytracerExt:RaytracerExt;

	public var geometry(default, set):String = '';

	function set_geometry(val:String) {
		geometry = val;
		_raytracerExt.loadGeometry(val, _ID);
		return val;
	}

	public function new() {
		_ID = ID + 1;
		ID = _ID;
		_raytracerExt = new RaytracerExt();
		_raytracerExt.newRaytracer();
	}

	public function buildBVH() {
		_raytracerExt.buildBVH(_ID);
	}

	public function rebuildBVH() {
		_raytracerExt.rebuildBVH(_ID);
	}

	public function traceRay(ray:Ray):TraceResult {
		var simpleRay = new SimpleRay();
		simpleRay.posx = ray.pos.x;
		simpleRay.posy = ray.pos.y;
		simpleRay.posz = ray.pos.z;
		simpleRay.dirx = ray.dir.x;
		simpleRay.diry = ray.dir.y;
		simpleRay.dirz = ray.dir.z;
		return _raytracerExt.traceRay(_ID, simpleRay);
	}

	public function dispose() {
		_raytracerExt.dispose(_ID);
	}
}

@:noCompletion
private class RaytracerExt {
	public function new() {}

	public function newRaytracer() {
		Raytracing.new_raytracer();
	}

	public function dispose(id:Int) {
		Raytracing.dispose_raytracer(id);
	}

	public function buildBVH(id:Int) {
		Raytracing.build_bvh(id);
	}

	public function refitBVH(id:Int) {
		Raytracing.refit_bvh(id);
	}

	public function rebuildBVH(id:Int) {
		Raytracing.rebuild_bvh(id);
	}

	public function loadGeometry(geometry:String, id:Int) {
		Raytracing.load_geometry(geometry, id);
	}

	public function traceRay(id:Int, ray:SimpleRay):TraceResult {
		var result = Raytracing.trace_ray(id, ray);
		return result;
	}
}

@:hlNative("haxelraytracing")
@:noCompletion
private class Raytracing {
	public static function new_raytracer():Void {}

	public static function dispose_raytracer(id:Int):Void {}

	public static function build_bvh(id:Int):Void {}

	public static function refit_bvh(id:Int):Void {}

	public static function rebuild_bvh(id:Int):Void {}

	public static function load_geometry(string:String, id:Int):Void {}

	public static function trace_ray(id:Int, ray:SimpleRay):TraceResult
		return null;
}
#end
