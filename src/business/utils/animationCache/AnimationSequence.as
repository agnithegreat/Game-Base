package business.utils.animationCache {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * @author virich
	 */
	public class AnimationSequence {
		
		public static const ANIMATIONS : Object = {};
		
		public static function getAnimationSequence($id: String):AnimationSequence {
			if (!ANIMATIONS[$id]) {
				var sequence: AnimationSequence = new AnimationSequence();
				sequence.id = $id;
				sequence.sequence = new Vector.<BitmapData>;
				ANIMATIONS[$id] = sequence;
			}
			return ANIMATIONS[$id];
		}
		
		public var id: String;
		public var sequence: Vector.<BitmapData>;
		public var bounds : Rectangle;
		public var completed: Boolean;
	}
}
