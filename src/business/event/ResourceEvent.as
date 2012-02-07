package business.event {
	import flash.events.Event;

	/**
	 * @author agnithegreat
	 */
	public class ResourceEvent extends Event {
		
		public static const RESOURCE_LOADED: String = "resource_loaded_ResourceEvent";
		
		private var _data: *;

		public function get data() : * {
			return _data;
		}
		
		public function ResourceEvent(type : String, data : * = null) {
			_data = data;
			super(type, false, false);
		}
		
		override public function clone():Event {
			return new ResourceEvent(type, data);
		}
	}
}
