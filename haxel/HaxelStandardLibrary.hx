package haxel;

class HaxelStandardLibrary {
	public static var basehxlstd:Array<String> = [
		'hxlstd.HXLStd',
		/* ----------------     DISPLAY     --------------- */
		'hxlstd.display.RGB',
		'hxlstd.display.RGBA',
		'hxlstd.display.FloatColor',
		'hxlstd.display.RGBTex',
		'hxlstd.display.RGBATex',
		'hxlstd.display.FloatTex',
		/* ----------------      MATH      --------------- */
		'hxlstd.math.Vec2', // vectors of T type, not just floats.
		'hxlstd.math.Vec3',
		'hxlstd.math.Vec4',
		'hxlstd.math.HMath',
		/* ---------------- COMPUTE SHADERS --------------- */
		'hxlstd.compute.ComputeShaderInterface',
		'hxlstd.compute.ComputeShaderResult',
		///------ Compute Shader Types ------///
		'hxlstd.compute.types.Vec2',
		'hxlstd.compute.types.Vec3',
		'hxlstd.compute.types.Vec4',
		'hxlstd.compute.types.IVec2',
		'hxlstd.compute.types.IVec3',
		'hxlstd.compute.types.IVec4',
		'hxlstd.compute.types.BVec2',
		'hxlstd.compute.types.BVec3',
		'hxlstd.compute.types.BVec4',
		'hxlstd.compute.types.Mat2',
		'hxlstd.compute.types.Mat3',
		'hxlstd.compute.types.Mat4',
		'hxlstd.compute.types.Mat2x3',
		'hxlstd.compute.types.Mat3x2',
		'hxlstd.compute.types.Mat2x4',
		'hxlstd.compute.types.Mat4x2',
		'hxlstd.compute.types.Mat3x4',
		'hxlstd.compute.types.Mat4x3',
		///------ Haxel Specific Compute Shader Types ------///
		'hxlstd.compute.types.ComputeArray',
		/* 
			Sadly these are slower then things like sampler2d or image 2d cause those were
			built with built in support with compute shaders instead of boiler-plate added
			onto the shader, and they were made to be very integrated with the graphics API
			in use. sampler/image2d's would be a hassle to port- especially cause vulkan 
			is being used for running compute shaders. So instead I've settled on these slow 
			but functional alternatives instead. Maybe one day they'll be ported, not anytime 
			soon, though.

			:<
		 */
		'hxlstd.compute.types.RGB',
		'hxlstd.compute.types.RGBA',
		'hxlstd.compute.types.RGBTex',
		'hxlstd.compute.types.RGBATex',
		'hxlstd.compute.types.FloatTex',
		'hxlstd.compute.types.RGBTex3D',
		'hxlstd.compute.types.RGBATex3D',
		'hxlstd.compute.types.FloatTex3D',
	];

	public static var exthxlstd:Array<String> = [
		/* --------------     DISPLAY3D     --------------- */
		'hxlstd.display3d.RGBTex3D',
		'hxlstd.display3d.RGBATex3D',
		'hxlstd.display3d.FloatTex3D',
		'hxlstd.display3d.projection.IProjector',
		'hxlstd.display3d.projection.PerspectiveProjector',
		'hxlstd.display3d.projection.OrthographicProjector',
		'hxlstd.display3d.raytracing.Ray',
		'hxlstd.display3d.camera.FrustumCuller',
		'hxlstd.display3d.camera.BasicPlaneClipper',
		'hxlstd.display3d.raytracing.Scene',
		/* ----------------      NOISE      --------------- */
		'hxlstd.noise.NormalNoise',
		'hxlstd.noise.PerlinNoise',
		'hxlstd.noise.DiamondSquareNoise',
		'hxlstd.noise.SimplexNoise',
		'hxlstd.noise.WorleyNoise',
		/* ---------------     GEOMETRY     --------------- */
		'hxlstd.geom.IShape',
		'hxlstd.geom.Rect', // a polygon
		'hxlstd.geom.Polygon', // also a polygon
		'hxlstd.geom.Line', // also also a polygon
		'hxlstd.geom.AdvancedLine', // also also also a polygon
		'hxlstd.geom.Circle', // ...not a polygon
		'hxlstd.geom.CubicBezier', // also not a polygon
		'hxlstd.geom.Spline', // also not a polygon
		'hxlstd.geom.Collide', // ...not a polygon and not a not a polygon
	];
}
