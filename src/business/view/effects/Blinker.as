package business.view.effects {
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	
	/**
	 * @author AgnI
	 */
	public class Blinker {
		
		private var _timer: Timer;
		private var _strength: Number;
		private var _min: Number;		private var _max: Number;		private var _color: int;		private var _obj: DisplayObject;
		
		private var _glow: GlowFilter;
		
		public function Blinker():void {
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			
			_glow = new GlowFilter(0, 0, 10, 10, 3, 1);
		}

		private function handleTimer(e : TimerEvent) : void {
			_strength = (Math.sin(_timer.currentCount/Math.PI/2)+1)/2*(_max-_min)+_min;
			_glow.color = _color;
			_glow.alpha = _strength; 
			_obj.filters = [_glow];
		}
		
		public function blink(obj : DisplayObject, min: Number = 0, max: Number = 1, color: int = 0xD0D0D0):void {
			_obj = obj;
			_min = min;			_max = max;
			_color = color;

			_obj.addEventListener(MouseEvent.ROLL_OVER, handleMouseOver);
			_obj.addEventListener(MouseEvent.ROLL_OUT, handleMouseOut);
		}
		
		private function handleMouseOver(e: MouseEvent):void {
			_strength = 0;			_timer.start();
		}
		
		private function handleMouseOut(e: MouseEvent):void {
			_timer.stop();
			_timer.reset();
			_obj.filters = [];
		}
		
		public static function add(obj: DisplayObject, min: Number = 0.3, max: Number = 1, color: int = 0xD0D0D0):Blinker {
			var blinker: Blinker = new Blinker();
			obj.cacheAsBitmap = true;
			blinker.blink(obj, min, max, color);
			return blinker;
		}
	}
}
