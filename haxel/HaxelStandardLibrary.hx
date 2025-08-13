package;

// TODO: actually write the hxlstd
class HaxelStandardLibrary
{
    var hxlstd:Map<String, String> = [
        /* ----------------     DISPLAY     --------------- */
        'hxlstd.display.RGB' => '',
        'hxlstd.display.RGBA' => '',
        'hxlstd.display.RGBTex' => '',
        'hxlstd.display.RGBATex' => '',
        'hxlstd.display.FloatTex' => '',

        /* --------------     DISPLAY3D     --------------- */
        'hxlstd.display3d.3DRGBTex' => '',
        'hxlstd.display3d.3DRGBATex' => '',
        'hxlstd.display3d.3DFloatTex' => '',
        'hxlstd.display3d.projection.IPorojector' => '',
        'hxlstd.display3d.projection.PerspectiveProjector' => '',
        'hxlstd.display3d.projection.OrthographicProjector' => '',
        'hxlstd.display3d.raytracing.Ray' => '',
        'hxlstd.display3d.FrustumCuller' => '',
        'hxlstd.display3d.BasicPlaneClipper' => '',
        'hxlstd.display3d.raytracing.Scene' => '',

        /* ----------------      MATH      --------------- */
        'hxlstd.math.Vec2' => '', // vectors of T type, not just floats.
        'hxlstd.math.Vec3' => '',
        'hxlstd.math.Vec4' => '',
        'hxlstd.Statistics' => '', // (mean, median, std deviation, etc.)
        'hxlstd.Math' => '',

        /* ----------------      NOISE      --------------- */
        'hxlstd.noise.NormalNoise' => '',
        'hxlstd.noise.PerlinNoise' => '',
        'hxlstd.noise.DiamondSquareNoise' => '',
        'hxlstd.noise.SimplexNoise' => '',
        'hxlstd.noise.WorleyNoise' => ''

        /* ---------------      TWEENS      --------------- */
        'hxlstd.tweens.Tween' => '',
        // I have a lot of eases to code.....
        'hxlstd.tweens.eases.IEase' => '',
        'hxlstd.tweens.eases.Linear' => '',
        'hxlstd.tweens.eases.SineIn' => '',
        'hxlstd.tweens.eases.SineOut' => '',
        'hxlstd.tweens.eases.SineInOut' => '',
        'hxlstd.tweens.eases.QuadIn' => '',
        'hxlstd.tweens.eases.QuadOut' => '',
        'hxlstd.tweens.eases.QuadInOut' => '',
        'hxlstd.tweens.eases.CubeIn' => '',
        'hxlstd.tweens.eases.CubeOut' => '',
        'hxlstd.tweens.eases.CubeInOut' => '',
        'hxlstd.tweens.eases.QuartIn' => '',
        'hxlstd.tweens.eases.QuartOut' => '',
        'hxlstd.tweens.eases.QuartInOut' => '',
        'hxlstd.tweens.eases.ExpoIn' => '',
        'hxlstd.tweens.eases.ExpoOut' => '',
        'hxlstd.tweens.eases.ExpoInOut' => '',
        'hxlstd.tweens.eases.CircIn' => '',
        'hxlstd.tweens.eases.CircOut' => '',
        'hxlstd.tweens.eases.CircInOut' => '',
        'hxlstd.tweens.eases.ElasticIn' => '',
        'hxlstd.tweens.eases.ElasticOut' => '',
        'hxlstd.tweens.eases.ElasticInOut' => '',
        'hxlstd.tweens.eases.BackIn' => '',
        'hxlstd.tweens.eases.BackOut' => '',
        'hxlstd.tweens.eases.BackInOut' => '',
        'hxlstd.tweens.eases.BounceIn' => '',
        'hxlstd.tweens.eases.BounceOut' => '',
        'hxlstd.tweens.eases.BounceInOut' => '',

        /* ---------------     GEOMETRY     --------------- */
        'hxlstd.geom.IShape' => '',
        'hxlstd.geom.Rect' => '', // a polygon
        'hxlstd.geom.Polygon' => '', // also a polygon
        'hxlstd.geom.BasicLine' => '', // also also a polygon
        'hxlstd.geom.AdvancedLine' => '', // also also also a polygon
        'hxlstd.geom.Circle' => '', // ...not a polygon
        'hxlstd.geom.Collide' => ''

        /* ---------------- COMPUTE SHADERS --------------- */
        'hxlstd.compute.ComputeShaderInterface' => '',
        'hxlstd.compute.ComputeShaderResult' => '',

        ///------ Compute Shader Types ------///
        'hxlstd.compute.types.Vec2' => '',
        'hxlstd.compute.types.Vec3' => '',
        'hxlstd.compute.types.Vec4' => '',
        'hxlstd.compute.types.IVec2' => '',
        'hxlstd.compute.types.IVec3' => '',
        'hxlstd.compute.types.IVec4' => '',
        'hxlstd.compute.types.BVec2' => '',
        'hxlstd.compute.types.BVec3' => '',
        'hxlstd.compute.types.BVec4' => '',
        'hxlstd.compute.types.Mat2' => '',
        'hxlstd.compute.types.Mat3' => '',
        'hxlstd.compute.types.Mat4' => '',
        'hxlstd.compute.types.Mat2x3' => '',
        'hxlstd.compute.types.Mat3x2' => '',
        'hxlstd.compute.types.Mat2x4' => '',
        'hxlstd.compute.types.Mat4x2' => '',
        'hxlstd.compute.types.Mat3x4' => '',
        'hxlstd.compute.types.Mat4x3' => '',

        ///------ Haxel Specific Compute Shader Types ------///
        'hxlstd.compute.types.ComputeArray' => '',

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
        'hxlstd.compute.types.RGB' => '',
        'hxlstd.compute.types.RGBA' => '',
        'hxlstd.compute.types.RGBTex' => '',
        'hxlstd.compute.types.RGBATex' => '',
        'hxlstd.compute.types.FloatTex' => '',
        'hxlstd.compute.types.3DRGBTex' => '',
        'hxlstd.compute.types.3DRGBATex' => '',
        'hxlstd.compute.types.3DFloatTex' => '',
    ];
}