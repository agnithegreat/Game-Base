package business.controller.timeline {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author virich
	 */
	public class TimelineController {
		
		public static var delay: int = 30;
		
		private static var _timeline: Vector.<Tick>;
		public static function get totalTime():int {
			return _timeline.length;
		}
		
		private static var _timer: Timer;
		
		private static var _paused: Boolean;
		
		private static var _previousDate: Date;
		private static var _currentDate: Date;
		public static function get timeDelta():Number {
			return (_currentDate.time-_previousDate.time)*0.001;
		}
		
		public static function updateTime():void {
			_previousDate = _currentDate;
			_currentDate = new Date();
		}
		
		private static var _currentTime: int;
		public static function get currentTime():int {
			return _currentTime;
		}
		
		private static var _callback: Function;
		
		public static function get isRunning():Boolean {
			return _currentTime<_timeline.length;
		}
		
		public static function get isActive():Boolean {
			return _timeline && _timer;
		}
		
		public static function init():void {
			clear();
			_timeline = new Vector.<Tick>();
			_currentTime = 0;
			_timer = new Timer(delay);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		public static function start($callback: Function = null):void {
			if (Boolean($callback)) {
				_callback = $callback;
			}
			_timer.start();
			_previousDate = new Date();
			_currentDate = new Date();
		}
		
		public static function pause():void {
			if (!_paused) {
				_paused = true;
				_previousDate = new Date();
				_currentDate = new Date();
			}
		}
		
		public static function unpause():void {
			if (_paused) {
				_paused = false;
				_previousDate = new Date();
				_currentDate = new Date();
			}
		}
		
		public static function stop():void {
			_timer.stop();
			_previousDate = new Date();
			_currentDate = new Date();
		}
		
		public static function addEvent($event: Function, $time: int, $duration: int = 0, $wait: Boolean = false):void {
			if (!_timeline) {
				return;
			}
			
			var newTick: Tick = new Tick($event, $duration);
			while ($time>=_timeline.length) {
				_timeline.push(null);
			}
			var tick: Tick = _timeline[$time];
			var add: int = 0;
			var wait: int = 0;
			while ($wait && wait>0) {
				if (tick && tick.duration) {
					wait = Math.max(wait, tick.duration);
				}
				wait--;
				add++;
				if ($time+add>=_timeline.length) {
					_timeline.push(newTick);
					for (var i : int = 0; i < $duration; i++) {
						_timeline.push(null);
					}
					return;
				}
				tick = _timeline[$time+add];
			}
			while (_timeline[$time+add]) {
				add++;
				if ($time+add>=_timeline.length) {
					_timeline.push(null);
				}
			}
			_timeline[$time+add] = newTick;
		}
		
		private static function tick():void {
			for (var i : int = 0; i < delay; i++) {
				if (!_timeline) {
					return;
				}
				while (_currentTime>=_timeline.length) {
					_timeline.push(null);
				}
				if (_timeline[_currentTime]) {
					_timeline[_currentTime].tick();
				}
				_currentTime++;
			}
		}
		
		public static function clear():void {
			if (_timeline) {
				for (var i : int = 0; i < _timeline.length; i++) {
					if (_timeline[i]) {
						_timeline[i].destroy();
					}
				}
			}
			_timeline = null;
			
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER, handleTimer);
				_timer.stop();
			}
			
			_callback = null;
		}

		private static function handleTimer(e: TimerEvent) : void {
			tick();
			if (!_paused) {
				if (_callback is Function) {
					_callback();
				}
			}
		}
	}
}
