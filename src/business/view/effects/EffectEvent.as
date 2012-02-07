package business.view.effects {
	import flash.events.Event;

	/**
	 * @author virich
	 */
	public class EffectEvent extends Event {
		
		public static const EFFECT_UPDATE: String = "effect_update";
		public static const EFFECT_STOP: String = "effect_stop";
		
		private var _data: Object;
		public function get data():Object {
			return _data;
		}
		
		public function EffectEvent(type : String, data: Object = null, bubbles : Boolean = false, cancelable : Boolean = false) {
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new EffectEvent(type, data, bubbles, cancelable);
		}
	}
}
