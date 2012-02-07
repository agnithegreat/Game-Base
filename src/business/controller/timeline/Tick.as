package business.controller.timeline {
	
	/**
	 * @author virich
	 */
	public class Tick {
		
		private var _event: Function;
		public function set event(event : Function) : void {
			_event = event;
		}
		public function get hasEvent() : Boolean {
			return Boolean(_event);
		}
		
		private var _duration: int;
		public function get duration():int {
			return _duration;
		}
		public function set duration(duration : int) : void {
			_duration = duration;
		}
		
		public function Tick($event: Function = null, $duration: int = 0) {
			_event = $event;
			_duration = $duration;
		}
		
		public function tick():void {
			if (_event is Function) {
				_event();
			}
			destroy();
		}
		
		public function destroy():void {
			_event = null;
		}
	}
}
