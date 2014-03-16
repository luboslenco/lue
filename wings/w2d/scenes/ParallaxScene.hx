package wings.w2d.scenes;

// Based on https://github.com/wagerfield/parallax

import wings.wxd.Pos;

class ParallaxScene extends Scene {

	public var layers:Array<Object2D>;
	public var depths:Array<Float>;

	var velocityX:Float;
	var velocityY:Float;

	var motionX:Float;
	var motionY:Float;

	var frictionX:Float;
	var frictionY:Float;

	var scalarX:Float;
	var scalarY:Float;

	var invertX:Bool;
	var invertY:Bool;

	var limitX:Float;
	var limitY:Float;

	var calibrateX:Bool;
	var calibrateY:Bool;

	var cx:Float;
	var cy:Float;

	public function new(depths:Array<Float>) {
		super();

		this.depths = depths;
		layers = new Array();

		// Generate layers
		for (i in 0...depths.length) {
			layers.push(new Object2D());
			addChild(layers[i]);
		}

		velocityX = 0;
		velocityY = 0;

		motionX = 0;
		motionY = 0;

		frictionX = 1;
		frictionY = 1;

		scalarX = 100;
		scalarY = 100;

		invertX = false;
		invertY = false;

		limitX = 0;
		limitY = 0;

		calibrateX = false;
		calibrateY = false;

		cx = 0;
		cy = 0;
	}

	public function move(ix:Float, iy:Float) {

		ix = (ix - Pos.w / 2) / (Pos.w / 2);
    	iy = (iy - Pos.h / 2) / (Pos.h / 2);

		var dx = ix - cx;
	    var dy = iy - cy;

	    this.motionX = (calibrateX ? dx : ix) * this.scalarX;
	    this.motionY = (calibrateY ? dy : iy) * this.scalarY;

	    if (limitX != 0) {
	    	if (motionX < -limitX) motionX = -limitX;
	    	if (motionX > limitX) motionX = limitX;
	    }
	    if (limitY != 0) {
	    	if (motionY < -limitY) motionY = -limitY;
	    	if (motionY > limitY) motionY = limitY;
	    }

	    velocityX += (motionX - velocityX) * frictionX;
	    velocityY += (motionY - velocityY) * frictionY;
	    for (i in 0...layers.length) {
	      var layer = layers[i];
	      var depth = depths[i];
	      var xOffset = velocityX * depth * (invertX ? -1 : 1);
	      var yOffset = velocityY * depth * (invertY ? -1 : 1);
	      layer.x = xOffset;
	      layer.y = yOffset;
	    }
	}
}
