package business.controller.sound {
	
	/**
	 * @author virich
	 */
	public class SoundManager {
		
		private static var _currentMusic: SoundContainer;
		
		private static var _sounds: Object = {};
		
		private static var _controller: Object;
		static public function get controller() : Object {
			return _controller;
		}
		
		public static function init($controller: Object):void {
			_controller = $controller;
		}
		
		public static function addSound($id: String):SoundContainer {
			if (!_sounds[$id]) {
				var sound: SoundContainer = new SoundContainer($id);
				_sounds[$id] = sound;
			}
			return _sounds[$id];
		}
		
		public static function playSound($id: String):SoundContainer {
			var sound: SoundContainer = _sounds[$id];
			if (!sound) {
				sound = addSound($id);
			}
			sound.play();
			if (sound.sound.isMusic) {
				_currentMusic = sound;
			}
			return sound;
		}
		
		public static function stopSound($id: String):void {
			var sound: SoundContainer = _sounds[$id];
			if (!sound) {
				return;
			}
			sound.stop();
		}
		
		public static function updateAll():void {
			for (var i : String in _sounds) {
				var sound: SoundContainer = _sounds[i];
				if (!_controller.sound && sound.sound.isSound) {
					sound.stop();
				}
			}
			if (_currentMusic) {
				if (_controller.music) {
					_currentMusic.play();
				} else {
					_currentMusic.stop();
				}
			}
		}
	}
}
