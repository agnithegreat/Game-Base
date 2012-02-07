package business.event {
	import flash.events.Event;

	/**
	 * @author agnithegreat
	 */
	public class TutorialEvent extends Event {
		
		public static const SHOW_MAIN: String = "show_main";
		public static const SHOW_RESULTS: String = "show_results";
		public static const SHOW_BONUS: String = "show_bonus";
		public static const SHOW_GAME: String = "show_game";
		
		public static const BREAK_TUTOR: String = "break_tutor";
		
		private var _data: *;

		public function get data() : * {
			return _data;
		}
		
		public function TutorialEvent(type : String, data : * = null) {
			_data = data;
			super(type, true);
		}
		
		override public function clone():Event {
			return new TutorialEvent(type, data);
		}
	}
}
