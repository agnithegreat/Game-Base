package business.event {
	import flash.events.Event;

	/**
	 * @author AgnI
	 */
	public class APIEvent extends Event {
		
		public static const DATA_RECIEVED: String = "data_recieved_APIConnectorEvent";
		public static const ERROR: String = "error_APIConnectorEvent";
		
		private var _method: String;		private var _data: Object;

		public function get method() : String {
			return _method;
		}
		
		public function get data() : Object {
			return _data;
		}
		
		public function APIEvent(type : String, method: String, data: Object = null, bubbles: Boolean = false) {
			_method = method;
			_data = data;
			super(type, bubbles, false);
		}
		
		override public function clone():Event {
			return new APIEvent(type, _method, _data);
		}
	}
}
