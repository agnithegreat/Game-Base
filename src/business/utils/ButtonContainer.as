package business.utils {
	import business.controller.sound.SoundContainer;
	import business.controller.sound.SoundManager;
	import business.data.dicts.SoundVO;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * @author virich
	 */
	public class ButtonContainer {
		
		public static const NORMAL: int = 1;
		public static const HOVERED: int = 2;
		public static const PRESSED: int = 3;
		public static const DISABLED: int = 4;
		
		private var _instance: MovieClip;
		public function get instance():MovieClip {
			return _instance;
		}
		
		private var _callback: Function;
		
		private var _sound: SoundContainer;
		
		private var _enabled: Boolean = true;
		public function get enabled() : Boolean {
			return _enabled;
		}
		public function set enabled($enabled : Boolean) : void {
			_enabled = $enabled;
			_instance.mouseEnabled = _enabled || _onOff;
			handleNormal(null);
			if (!_enabled && !_onOff) {
				handleDisabled(null);
			}
		}
		
		public function get visible() : Boolean {
			return _instance.visible;
		}
		public function set visible($visible : Boolean) : void {
			_instance.visible = $visible;
		}
		
		private var _onOff: Boolean = false;
		public function set onOff($set: Boolean):void {
			_onOff = $set;
		}
		
		private var _currentState: int;
		
		private var _state: int = 0;
		public function set state($state: int):void {
			_state = $state;
			update();
		}
		
		public function ButtonContainer($instance: MovieClip, $callback: Function, $states: Boolean = true, $sound: String = SoundVO.BUTTON) {
			_instance = $instance;
			_callback = $callback;
			
			_currentState = NORMAL;
			
			if ($sound) {
				_sound = SoundManager.addSound($sound);
			}
			
			if ($states) {
				_instance.addEventListener(MouseEvent.ROLL_OVER, handleHover);
				_instance.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			}
			_instance.addEventListener(MouseEvent.CLICK, _callback);
			
			_instance.stop();
			_instance.mouseChildren = false;
			
			_instance.buttonMode = true;
		}

		private function handleHover(e : MouseEvent) : void {
			if (_enabled || _onOff) {
				_currentState = !_enabled && _onOff ? DISABLED : HOVERED;
				update();
				_instance.addEventListener(MouseEvent.ROLL_OUT, handleNormal);
			}
		}
		
		private function handlePress(e : MouseEvent) : void {
			if (_enabled || _onOff) {
				_currentState = !_enabled && _onOff ? DISABLED : PRESSED;
				update();
				_instance.addEventListener(MouseEvent.MOUSE_UP, handleNormal);
				
				if (_sound) {
					_sound.play();
				}
			}
		}
		
		private function handleNormal(e : MouseEvent) : void {
			if (_enabled || _onOff) {
				_currentState = !_enabled && _onOff ? DISABLED : NORMAL;
				update();
				_instance.removeEventListener(MouseEvent.ROLL_OUT, handleNormal);
				_instance.removeEventListener(MouseEvent.MOUSE_UP, handleNormal);
			}
		}
		
		private function handleDisabled(e : MouseEvent) : void {
			_currentState = DISABLED;
			update();
		}
		
		private function update():void {
			_instance.gotoAndStop(_state+_currentState);
		}
	}
}
