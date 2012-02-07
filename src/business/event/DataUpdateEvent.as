package business.event {
	import flash.events.Event;

	/**
	 * @author virich
	 */
	public class DataUpdateEvent extends Event {
		
		public static const DATA_UPDATED : String = "data_updated_DataUpdateEvent";
		
		public static const USER_UPDATED: String = "user_updated_DataUpdateEvent";
		public static const USER_SETTINGS_UPDATED: String = "user_settings_updated_DataUpdateEvent";
		public static const USER_SOCIAL_LOADED: String = "user_social_loaded_DataUpdateEvent";
		public static const USERPIC_LOADED : String = "userpic_loaded_DataUpdateEvent";
		
		private var _data: Object;
		public function get data():Object {
			return _data;
		}
		
		public function DataUpdateEvent(type : String, data: Object = null, bubbles : Boolean = false, cancelable : Boolean = false) {
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new DataUpdateEvent(type, data, bubbles, cancelable);
		}
	}
}
