package business.view.effects {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.display.DisplayObject;
	
	/**
	 * @author AgnI
	 */
	public class BlinkEffect extends Effect {
		
		private var _strength: Number;
		private var _min: Number;		private var _max: Number;		private var _color: int;
		
		private var _glow: GlowFilter;
				private var _time: int;
		
		private var _offset: Number;
		
		public function BlinkEffect($target : DisplayObject, $time: int = 0, $min: Number = 0, $max: Number = 1, $color: int = 0xD0D0D0):void {
			_time = $time;			_min = $min;
			_max = $max;
			_color = $color;
			
			_offset = Math.random()*Math.PI*2;
			
			_glow = new GlowFilter(0, 0, 10, 10, 3, 1);
			
			super($target, 1);
			
			if ($time) {
				start();
			}
		}
		
		public function listenMouse():void {
			_target.addEventListener(MouseEvent.ROLL_OVER, start);
			_target.addEventListener(MouseEvent.ROLL_OUT, stop);
		}
		
		override public function start(e: Event = null):void {
			_strength = 0;
			super.start();		}
		
		override public function stop(e: Event = null):void {
			super.stop();
			_target.filters = [];
		}

		override protected function tick($time: int):void {
			_strength = (Math.sin(_timer.currentCount/Math.PI/2+_offset)+1)/2*(_max-_min)+_min;
			_glow.color = _color;
			_glow.alpha = _strength; 
			_target.filters = [_glow];
			
			if (_time > 0 && _time <= $time * _timer.delay) {
				stop();
			}
		}
		
		public static function add(obj: DisplayObject, min: Number = 0.3, max: Number = 1, color: int = 0xD0D0D0):BlinkEffect {
			var blinker: BlinkEffect = new BlinkEffect(obj, 0, min, max, color);
			blinker.listenMouse();
			return blinker;
		}
	}
}
