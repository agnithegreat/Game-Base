package business.data.dicts {
	import business.utils.secure.SecureValue;
	
	/**
	 * @author virich
	 */
	public class GameSettingsVO {
		
		public static const ID: String = "settings";
		
		public static const POINTS: String = "points";
		public static const ROUND_TIME: String = "round_time";
		public static const TIMER_BLINK_TIME: String = "timer_blink_time";
		public static const COINS_GENERATED: String = "coins_generated";
		public static const COINS_CHANCE: String = "coins_chance";
		public static const COINS_MULTIPLIER: String = "coins_multiplier";
		public static const GEM_TYPES: String = "gem_types";
		public static const COIN_MATCH: String = "coin_match";
		public static const BOMB_MATCH: String = "bomb_match";
		public static const LINE_MATCH: String = "line_match";
		public static const SUPER_COMBO: String = "super_combo";
		public static const AUTO_HINT: String = "autohint";
		public static const LOTTERY_PRICE: String = "lottery_price_gold";
		
		public static const LIVES_GEN_TIME: String = "lives_gen_time";
		public static const TOKEN_REWARD_FRIENDS: String = "token_reward_friend";
		
		public static const LONG_MATCH_LENGTH: String = "long_match_length";
		public static function get longMatchLength():int {
			return SETTINGS[LONG_MATCH_LENGTH].value;
		}
		
		public static const SUPER_MODE_VALUE: String = "super_mode_value";
		public static const SUPER_MODE_DELTA: String = "super_mode_delta";
		public static const SUPER_MODE_TIME: String = "super_mode_time";
		
		public static var SETTINGS: Object = {};
		public static function getSettings($name: String):Number {
			return SETTINGS[$name].value;
		}
		
		public static function get coinsChance():int {
			return SETTINGS[COINS_CHANCE].value ? SETTINGS[COINS_CHANCE].value : 10000;
		}
		
		public static function get coinMatch():int {
			return SETTINGS[COIN_MATCH].value ? SETTINGS[COIN_MATCH].value : 1000;
		}
		public static function get bombMatch():int {
			return SETTINGS[BOMB_MATCH].value ? SETTINGS[BOMB_MATCH].value : 1000;
		}
		public static function get lineMatch():int {
			return SETTINGS[LINE_MATCH].value ? SETTINGS[LINE_MATCH].value : 1000;
		}
		
		public static function get tokenRewardFriend():int {
			return SETTINGS[TOKEN_REWARD_FRIENDS].value;
		}
		
		public static function parse($data: Object):void {
			for (var i : String in $data) {
				SETTINGS[$data[i].name] = new SecureValue($data[i].value);
			}
		}
	}
}
