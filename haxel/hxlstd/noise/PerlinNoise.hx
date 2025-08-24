package haxel.hxlstd.noise;

class PerlinNoise {
	private var PERMUTATIONS:Array<Int> = [];
	private var P:Array<Int>;

	public var repeat:Int;

	public function new(repeat:Int = -1):Void {
		this.repeat = repeat;
		var perm = [for (i in 0...256) i];
		var i = 255;
		while (i > 0) {
			var j = Std.int(haxel.hxlstd.math.HMath.random(0, i));
			var tmp = perm[i];
			perm[i] = perm[j];
			perm[j] = tmp;
			i--;
		}

		PERMUTATIONS = perm.concat(perm);
		P = [for (x in 0...512) PERMUTATIONS[x % 256]];
	}

	public function perlin(x:Float, y:Float, z:Float):Float {
		if (this.repeat > 0) {
			x = x % repeat;
			y = y % repeat;
			z = z % repeat;
		}

		var xi:Int = Math.floor(x) & 255;
		var yi:Int = Math.floor(y) & 255;
		var zi:Int = Math.floor(z) & 255;

		var xf:Float = x - Math.ffloor(x);
		var yf:Float = y - Math.ffloor(y);
		var zf:Float = z - Math.ffloor(z);

		var u:Float = fade(xf);
		var v:Float = fade(yf);
		var w:Float = fade(zf);

		var aaa = P[P[P[xi] + yi] + zi];
		var aba = P[P[P[xi] + inc(yi)] + zi];
		var aab = P[P[P[xi] + yi] + inc(zi)];
		var abb = P[P[P[xi] + inc(yi)] + inc(zi)];
		var baa = P[P[P[inc(xi)] + yi] + zi];
		var bba = P[P[P[inc(xi)] + inc(yi)] + zi];
		var bab = P[P[P[inc(xi)] + yi] + inc(zi)];
		var bbb = P[P[P[inc(xi)] + inc(yi)] + inc(zi)];

		var x1 = lerp(grad(aaa, xf, yf, zf), grad(baa, xf - 1, yf, zf), u);
		var x2 = lerp(grad(aba, xf, yf - 1, zf), grad(bba, xf - 1, yf - 1, zf), u);
		var y1 = lerp(x1, x2, v);

		var x3 = lerp(grad(aab, xf, yf, zf - 1), grad(bab, xf - 1, yf, zf - 1), u);
		var x4 = lerp(grad(abb, xf, yf - 1, zf - 1), grad(bbb, xf - 1, yf - 1, zf - 1), u);
		var y2 = lerp(x3, x4, v);

		return (lerp(y1, y2, w) + 1) / 2;
	}

	public function octavePerlin(x:Float, y:Float, z:Float, octaves:Int, persistence:Float, frequency:Float):Float {
		var total:Float = 0.0;
		var maxValue:Float = 0.0;
		var amplitude:Float = 1.0;

		for (i in 0...octaves) {
			total += perlin(x * frequency, y * frequency, z * frequency) * amplitude;
			maxValue += amplitude;

			amplitude *= persistence;
			frequency *= 2.0;
		}

		return total / maxValue;
	}

	public function fade(t:Float):Float {
		return t * t * t * (t * (t * 6 - 15) + 10);
	}

	public function inc(num:Int):Int {
		num++;
		if (repeat > 0)
			num %= repeat;

		return num;
	}

	function grad(hash:Int, x:Float, y:Float, z:Float):Float {
		var h = hash & 15;
		var u = h < 8 ? x : y;
		var v = h < 4 ? y : (h == 12 || h == 14 ? x : z);
		return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
	}

	public function lerp(a:Float, b:Float, x:Float) {
		return a + (x * (b - a));
	}
}
