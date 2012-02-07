package business.data.dicts {
	
	/**
	 * @author virich
	 */
	public class SoundVO {
		
		public static const ID: String = "sounds";
		
		
		public static const MUSIC_TYPE: String = "music";
		public static const SOUND_TYPE: String = "sound";
		
		public static const MUSIC_GAME: String = "music_game";
		
		public static const BUTTON: String = "button";
		public static const UNLOCK: String = "unlock";
		public static const CHARGED: String = "charged";
		public static const DISCHARGED: String = "discharged";
		public static const GAMESTART: String = "game_start";
		public static const SELECT: String = "select";
		public static const MATCH: String = "match";
		public static const COIN: String = "coin";
		public static const BONUS_APPEARED: String = "bonus_appeared";
		public static const BOMB: String = "bomb";
		public static const LIGHTNING: String = "lightning";
		public static const TIME: String = "time";
		public static const ONE_COLOR: String = "one_color";
		public static const X2: String = "x2";
		public static const HINT: String = "hint";
		public static const GAME_OVER: String = "game_over";
		public static const FIRST_PLACE: String = "first_place";
		
		public static var SOUNDS: Object = {};
		public static function getSoundByID($id: String):SoundVO {
			return SOUNDS[$id];
		}
		
		public static var SOUNDS_ARRAY: Array = [];
		
		public static function parse($data: Object):void {
			for (var i : String in $data) {
				var sound: SoundVO = new SoundVO();
				sound.id = $data[i].id;
				sound.sound_id = $data[i].sound_id;
				sound.file_name = $data[i].file_name;
				sound.type = $data[i].type;
				sound.volume = $data[i].volume;
				SOUNDS[sound.sound_id] = sound;
				SOUNDS_ARRAY.push(sound);
			}
		}
		
		public var id: int;
		public var sound_id: String;
		public var file_name: String;
		public var type: String;
		public var volume: int;
		
		public function get isSound():Boolean {
			return type==SoundVO.SOUND_TYPE;
		}
		
		public function get isMusic():Boolean {
			return type==SoundVO.MUSIC_TYPE;
		}
	}
}
