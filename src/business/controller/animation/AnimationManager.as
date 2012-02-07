package business.controller.animation {
	import flash.display.DisplayObject;
	
	/**
	 * @author virich
	 */
	public class AnimationManager {
		
		private static var _objects: Object = {};
		public static function registerObject($id: String, $object: DisplayObject):void {
			if (!_objects[$id]) {
				_objects[$id] = [];
			}
			_objects[$id].push($object);
		}
		
		public static function getObject($id: String, $count: int = 0):DisplayObject {
			return _objects[$id] && _objects[$id].length>$count ? _objects[$id][$count] : null;
		}
		
		private static var _animating: Object = {};
	}
}
