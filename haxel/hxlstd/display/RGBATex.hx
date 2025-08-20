package haxel.hxlstd.display;

import format.png.Reader;
import format.png.Tools;
import sys.io.File;

class RGBATex {
	public var width(get, never):Int;
	public var height(get, never):Int;
	public var pixels:Array<Array<RGBA>>;

	private var _width:Int;

	private function get_width():Int
		return _width;

	private var _height:Int;

	private function get_height():Int
		return _height;

	public function new(width:Int, height:Int, ?pixels:Array<Array<RGBA>>) {
		this._width = width;
		this._height = height;
		if (pixels == null)
			blankPixels();
		else
			this.pixels = pixels;
	}

	public function blankPixels() {
		pixels = [];
		for (_ in 0...width) {
			var column = new Array<RGBA>();
			for (_ in 0...height)
				column.push(new RGBA(0, 0, 0, 0));
			pixels.push(column);
		}
	}

	public function getPixel(x:Int, y:Int):RGBA
		return pixels[x][y];

	public function setPixel(x:Int, y:Int, color:RGBA)
		pixels[x][y] = color;

	public function resize(width:Int, height:Int) {
		_width = width;
		_height = height;
		blankPixels();
	}

	public function clone():RGBATex {
		var result = new RGBATex(width, height);
		for (y in 0...height) {
			for (x in 0...width) {
				result.setPixel(x, y, getPixel(x, y).clone());
			}
		}
		return result;
	}

	public function toString():String
		return 'RGBATex($width, $height)';

	public static function fromPng(path:String):RGBATex {
		var bytes = File.read(path, true);
		var data = new Reader(bytes).read();
		var pixelBytes = Tools.extract32(data);
		var width = Tools.getHeader(data).width;
		var height = Tools.getHeader(data).height;
		var pixels:Array<Array<RGBA>> = [];
		for (x in 0...width) {
			var column:Array<RGBA> = [];
			for (y in 0...height) {
				var offset = (y * width + x) * 4;
				var r = pixelBytes.get(offset + 2);
				var g = pixelBytes.get(offset + 1);
				var b = pixelBytes.get(offset);
				var a = pixelBytes.get(offset + 3);

				column.push(new RGBA(r, g, b, a));
			}
			pixels.push(column);
		}
		return new RGBATex(width, height, pixels);
	}
}
