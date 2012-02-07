package business.event {
	import flash.events.Event;

	/**
	 * @author virich
	 */
	public class GameEvent extends Event {
		
		// from model
		public static const GAME_INIT : String = "game_init_GameEvent";
		public static const GAME_UPDATE: String = "game_update_GameEvent";
		public static const GAME_LIGHT : String = "game_light_GameEvent";
		public static const GAME_PAUSE : String = "game_pause_GameEvent";
		public static const GAME_CLEAR : String = "game_clear_GameEvent";
		public static const GAME_OVER : String = "game_over_GameEvent";
		public static const TIME_ADDED: String = "time_added_GameEvent";
		public static const TIME_OFF: String = "time_off_GameEvent";
		
		public static const SUPER : String = "super_GameEvent";
		public static const SUPER_COMBO : String = "super_combo_GameEvent";
		public static const NO_MATCHES : String = "no_matches_GameEvent";
		
		public static const GEM_CREATE: String = "gem_create_GameEvent";
		public static const GEM_BONUS_USED: String = "gem_bonus_used_GameEvent";
		public static const GEM_EXPLODE: String = "gem_explode_GameEvent";
		public static const GEM_UPDATE: String = "gem_update_GameEvent";
		
		public static const PING_VIEW : String = "ping_view";
		
		public static const HINT_SHOW: String = "hint_show_GameEvent";
		public static const HINT_HIDE: String = "hint_hide_GameEvent";
		
		public static const CHAIN_UPDATE: String = "chain_update_GameEvent";
		
		public static const GOD_UPDATE: String = "god_update_GameEvent";
		public static const GOD_CHARGED: String = "god_charged_GameEvent";
		
		public static const LOTTERY_SPIN: String = "lottery_spin_GameEvent";
		
		// from view
		public static const GEM_SELECT: String = "gem_select_GameEvent";
		public static const CHAIN_START: String = "chain_start_GameEvent";
		public static const CHAIN_BREAK : String = "chain_break_GameEvent";
		
		private var _data: Object;
		public function get data():Object {
			return _data;
		}
		
		public function GameEvent(type : String, data: Object = null, bubbles : Boolean = false, cancelable : Boolean = false) {
			_data = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new GameEvent(type, data, bubbles, cancelable);
		}
	}
}
