package iron.object;

import kha.graphics4.Graphics;
import iron.math.Mat4;
import iron.Trait;
import iron.data.SceneFormat;
import iron.data.Data;
import iron.data.MaterialData;

class Object {
	static var uidCounter = 0;
	public var uid:Int;
	public var raw:TObj = null;

	public var name:String = "";
	public var transform:Transform;
	public var constraints:Array<Constraint> = null;
	public var traits:Array<Trait> = [];

	public var parent:Object = null;
	public var children:Array<Object> = [];

	public var animation:Animation = null;
	public var visible = true; // Skip render, keep updating
	public var culled = false; // Object was culled last frame

	public function new() {
		uid = uidCounter++;
		transform = new Transform(this);
	}
	
	public function addChild(o:Object) {
		children.push(o);
		o.parent = this;
	}

	public function remove() {
		if (animation != null) animation.remove();
		while (children.length > 0) children[0].remove();
		while (traits.length > 0) traits[0].remove();
		if (parent != null) parent.children.remove(this);
		parent = null;
	}

	public function getChild(name:String):Object {
		if (this.name == name) return this;
		else {
			for (c in children) {
				var r = c.getChild(name);
				if (r != null) return r;
			}
		}
		return null;
	}

	public function getChildOfType(type:Class<Object>):Object {
		if (Std.is(this, type)) return this;
		else {
			for (c in children) {
				var r = c.getChildOfType(type);
				if (r != null) return r;
			}
		}
		return null;
	}

	public function addTrait(t:Trait) {
		traits.push(t);
		t.object = this;

		if (t._add != null) { t._add(); t._add = null; }
	}

	public function removeTrait(t:Trait) {
		if (t._init != null) App.removeInit(t._init);
		if (t._update != null) App.removeUpdate(t._update);
		if (t._lateUpdate != null) App.removeLateUpdate(t._lateUpdate);
		if (t._render != null) App.removeRender(t._render);
		if (t._render2D != null) App.removeRender2D(t._render2D);
		if (t._remove != null) { t._remove(); t._remove = null; }

		traits.remove(t);
		t.object = null;
	}

	public function getTrait(c:Class<Trait>):Dynamic {
		for (t in traits) {
			if (Type.getClass(t) == c) {
				return t;
			}
		}
		return null;
	}

	public function setupAnimation(startTrack:String, names:Array<String>, starts:Array<Int>, ends:Array<Int>, speeds:Array<Float>, loops:Array<Bool>, reflects:Array<Bool>, maxBones = 50) {
		animation = Animation.setupObjectAnimation(this, startTrack, names, starts, ends, speeds, loops, reflects);
	}
}