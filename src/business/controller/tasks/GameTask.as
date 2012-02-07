package business.controller.tasks {
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	/**
	 * @author virich
	 */
	public class GameTask extends Task {
		
		private var _task: Function;
		private var _time: Number;
		public function get time() : Number {
			return _time;
		}
		
		private var _interval: int;
		
		public function GameTask($task: Function, $time: Number = 0) {
			_task = $task;
			_time = $time;
		}
		
		override public function run():void {
			if (_task is Function) {
				_task();
				if (_time>0) {
					_interval = setInterval(handleComplete, _time*1000);
				} else {
					complete();
				}
			}
		}
		
		private function handleComplete():void {
			clearInterval(_interval);
			complete();
		}
	}
}
