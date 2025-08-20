package haxel.hxlstd.display3d;

import haxel.hxlstd.display.FloatColor;

class FloatTex3D {
	public var width(get, never):Int;
	public var length(get, never):Int;
	public var height(get, never):Int;
	public var pixels:Array<Array<Array<FloatColor>>>;

	private var _width:Int;

	private function get_width():Int
		return _width;

	private var _length:Int;

	private function get_length():Int
		return _length;

	private var _height:Int;

	private function get_height():Int
		return _height;

	public function new(width:Int, height:Int, length:Int, ?pixels:Array<Array<Array<FloatColor>>>) {
		this._width = width;
		this._length = length;
		this._height = height;
		if (pixels == null)
			blankPixels();
		else
			this.pixels = pixels;
	}

	public function blankPixels() {
		pixels = [];
		for (_ in 0...width) {
			var column = new Array<Array<FloatColor>>();
			for (_ in 0...height) {
				var splt = new Array<FloatColor>();
				for (_ in 0...length)
					splt.push(new FloatColor(0, 0, 0, 0));
				column.push(splt);
			}
			pixels.push(column);
		}
	}

	public function getPixel(x:Int, y:Int, z:Int):FloatColor
		return pixels[x][y][z];

	public function setPixel(x:Int, y:Int, z:Int, color:FloatColor)
		pixels[x][y][z] = color;

	public function resize(width:Int, height:Int, length:Int) {
		_width = width;
		_height = height;
		_length = length;
		blankPixels();
	}

	public function clone():FloatTex3D {
		var result = new FloatTex3D(width, height, length);
		for (y in 0...height)
			for (x in 0...width)
				for (z in 0...length)
					result.setPixel(x, y, z, getPixel(x, y, z).clone());
		return result;
	}

	public function toString():String
		return 'FloatTex($width, $height, $length)';
}
