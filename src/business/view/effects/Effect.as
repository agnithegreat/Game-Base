package business.view.effects {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author agnithegreat
	 */
	public class Effect extends EventDispatcher {
		
		protected var _duration: int;
		protected var _delay: int;
		
		protected var _target: DisplayObject;
		
		protected var _timer: Timer;
		
		public function get progress():Number {
			return (_timer.currentCount*_timer.delay-_delay)/_duration;
		}
		
		public function get started():Boolean {
			return _timer.running;
		}
		
		public function Effect($target: DisplayObject, $duration: int, $delay: int = 0) {
			_target = $target;
			
			_duration = $duration;
			_delay = $delay;
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		public function start(e: Event = null) : void {
			_timer.start();
		}
		
		public function stop(e: Event = null) : void {
			_timer.stop();
			_timer.reset();
		}

		private function handleTimer(e: TimerEvent) : void {
			tick(_timer.currentCount);
		}
		
		protected function tick($time: int):void {
		}
		
		protected function end():void {
			stop();
			dispatchEvent(new EffectEvent(EffectEvent.EFFECT_STOP));
		}
	}
}
