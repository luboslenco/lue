package wings.w2d.tiles;

class Layer {

	public var tiles:Array<Int>;
	public var w:Int;
	public var h:Int;

	public function new(tiles:Array<Int>, w:Int, h:Int) {
		this.tiles = tiles;
		this.w = w;
		this.h = h;
	}
}
