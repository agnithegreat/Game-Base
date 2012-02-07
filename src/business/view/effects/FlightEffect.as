package business.view.effects {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author virich
	 */
	public class FlightEffect extends Effect {
		
		private var _canvas: Sprite;
		
		private var _start: Point;
		private var _end: Point;
		
		public function FlightEffect($target: DisplayObject, $canvas: Sprite, $start: Point, $end: Point, $duration: int, $delay: int = 0) {
			super($target, $duration, $delay);
			
			_canvas = $canvas;
			_start = $start;
			_end = $end;
			
			start();
		}
		
		override protected function tick($time: int):void {
			if (progress<0) {
				return;
			}
			
			_canvas.addChild(_target);
			
			if (progress<=1) {
				_target.x = Math.floor(progress*(_end.x-_start.x)+_start.x);
				_target.y = Math.floor(progress*(_end.y-_start.y)+_start.y);
			} else {
				_target.x = int(_end.x);
				_target.y = int(_end.y);
				end();
			}
		}
	}
}
