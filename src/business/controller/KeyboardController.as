package business.controller {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	
	/**
	 * @author virich
	 */
	public class KeyboardController {
		
		public static const STATE_OFF: String = "off";
		public static const STATE_WORKED_OUT: String = "worked_out";
		public static const STATE_ON: String = "on";
		
		private static var _stage: Stage;
		
		private static var _registeredKeys: Object;
		public static function registerKey($key: int, $callback: Function):void {
			_registeredKeys[$key] = $callback;
		}
		public static function unregisterKey($key: int, $callback: Function):void {
			_registeredKeys[$key] = null;
		}
		
		private static var _keys: Object;
		public static function isKeyPressed($key: int):Boolean {
			return (_keys[$key] == STATE_ON) && _enabled;
		}
		
		private static var _timer: Timer;
		
		private static var _enabled: Boolean;
		public static function set enabled($enabled: Boolean):void {
			_enabled = $enabled;
		}
		
		public static function init($stage: Stage):void {
			_stage = $stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			
			_registeredKeys = {};
			_keys = {};
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			_timer.start();
			
			_enabled = true;
		}

		private static function handleKeyDown(e: KeyboardEvent) : void {
			if (_keys[e.keyCode] == STATE_OFF) {
				_keys[e.keyCode] = STATE_ON;
			}
		}
		
		private static function handleKeyUp(e: KeyboardEvent) : void {
			_keys[e.keyCode] = STATE_OFF;
		}

		private static function handleTimer(e: TimerEvent) : void {
			for (var key : String in _registeredKeys) {
				if (isKeyPressed(int(key))) {
					_registeredKeys[key]();
					_keys[key] = STATE_WORKED_OUT;
				}
			}
		}
	}
}
