package business.controller.windows {
	import business.controller.timeline.TimelineController;
	import flash.events.Event;
	import business.controller.windows.Layer;

	/**
	 * @author virich
	 */
	public class PopupLayer extends Layer {
		
		protected var _waitWindows: Vector.<Window>;
		
		public function PopupLayer($id: String, $depth: int, $size: String = null, $parent: String = null, $bluring: Boolean = false, $flashing: Boolean = false) {
			super($id, Layer.SINGLE, $depth, $size, $parent, $bluring, $flashing);
			
			_waitWindows = new Vector.<Window>();
		}
		
		override public function push($id: String):void {
			var window : Window = WindowManager.getWindow($id);
			if (_stack.indexOf(window) != -1 || _waitWindows.indexOf(window) != -1) {
				return;
			}
			if (_stack.length>0) {
				_stack[0].removeEventListener(Window.EVENT_CLOSE, handleNext);
				_waitWindows.push(_stack.shift());
			}
			_waitWindows.push(window);
			_waitWindows.sort(sortFunction);
			showWindow(_waitWindows.pop());
			
			TimelineController.stop();
		}
		
		private function showWindow($window: Window):void {
			_stack[0] = $window;
			$window.addEventListener(Window.EVENT_CLOSE, handleNext);
			update();
		}
		
		private function handleNext(e: Event):void {
			if (_stack.length>0) {
				_stack[0].removeEventListener(Window.EVENT_CLOSE, handleNext);
				_stack.shift();
			}
			if (_waitWindows.length > 0) {
				showWindow(_waitWindows.pop());
			} else {
				dispatchEvent(new Event(EVENT_EMPTY));
				
				TimelineController.start();
			}
		}
		
		override public function close():void {
			super.close();
			
			_waitWindows = new Vector.<Window>();
			handleNext(null);
		}
	}
}
