package business.utils {
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author virich
	 */
	public class TargetMoveDispatcher {
		
		private var _target: InteractiveObject;
		private var _memory: Point;
		
		private var _callback: Function;
		
		private var _timer: Timer;
		
		public function TargetMoveDispatcher($target: InteractiveObject, $callback: Function) {
			_target = $target;
			_callback = $callback;
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		public function start():void {
			_timer.start();
		}
		
		public function stop():void {
			_memory = null;
			_timer.stop();
		}

		private function handleTimer(e: TimerEvent) : void {
			if (_callback is Function) {
				if (!_memory || _target.x!=_memory.x || _target.y!=_memory.y) {
					_memory = new Point(_target.x, _target.y);
					_callback(_target);
				}
			}
		}
	}
}
