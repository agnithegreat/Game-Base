package business.utils {
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	/**
	 * @author virich
	 */
	public class SliderControl extends EventDispatcher {
		
		private var _control: MovieClip;
		
		private var _count : int;
		public function set count($count: int):void {
			_count = Math.max($count, 0);
			_position = Math.min(Math.max(_position, 0), _count);
			update();
		}
		
		private var _minHeight: int;
		private var _maxHeight: int;
		
		private function get length():int {
			return _maxHeight-_minHeight;
		}
		private function get step():int {
			return length/_count;
		}
		
		private var _position: int;
		public function set progress($progress: int):void {
			_position = $progress;
		}
		public function get progress():int {
			return _position;
		}
		
		private var _callback: Function;
		
		private var _btnUp : ButtonContainer;
		private var _btnDown : ButtonContainer;
		private var _btnSlider : ButtonContainer;
		
		public function SliderControl($control: MovieClip, $callback: Function, $count: int, $minHeight: int = 50, $maxHeight: int = 330) {
			_control = $control;
			
			_btnUp = new ButtonContainer(_control.btn_up, handleClick);
			_btnDown = new ButtonContainer(_control.btn_down, handleClick);
			_btnSlider = new ButtonContainer(_control.slider, handleClick, true, null);
			
			_control.slider.addEventListener(MouseEvent.MOUSE_DOWN, handleSliderDown);
			
			_callback = $callback;
			_count = $count;
			
			_minHeight = $minHeight;
			_maxHeight = $maxHeight;
		}
		
		private function handleSliderDown(e : MouseEvent) : void {
			_control.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMove);
			_control.stage.addEventListener(MouseEvent.MOUSE_UP, handleSliderUp);
		}

		private function handleMove(e : MouseEvent) : void {
			var newPos: int = Math.round((_control.mouseY-_minHeight)/step);
			if (newPos != _position) {
				_position = Math.min(Math.max(newPos, 0), _count);
				update();
			}
		}

		private function handleSliderUp(e : MouseEvent) : void {
			_control.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMove);
			_control.stage.removeEventListener(MouseEvent.MOUSE_UP, handleSliderUp);
		}
		
		private function update():void {
			_control.slider.y = Math.min(Math.max(_minHeight+_position*step, _minHeight), _maxHeight);
			_callback();
			
			_btnSlider.enabled = _count>0;
			_btnUp.enabled = _count>0 && progress>0;
			_btnDown.enabled = _count>0 && progress<_count;
		}

		private function handleClick(e: MouseEvent) : void {
			switch (e.currentTarget) {
				case _control.btn_up:
					_position--;
					update();
					break;
				case _control.btn_down:
					_position++;
					update();
					break;
			}
		}
	}
}
