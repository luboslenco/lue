package wings.core;

import composure.traits.AbstractTrait;

class Trait extends AbstractTrait {

	// TODO: Rename
	public var parent(get, never):Object;

	public function new() {
		super();
	}

	inline function get_parent():Object {
		return cast(item, Object);
	}
}
