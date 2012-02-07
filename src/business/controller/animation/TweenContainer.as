package business.controller.animation {
	import com.greensock.TweenLite;
	
	/**
	 * @author virich
	 */
	public class TweenContainer {
		
		private var _target: Object;
		private var _duration: Number;
		private var _vars: Object;
		
		public function TweenContainer($target: Object, $duration: Number, $vars: Object) {
			_target = $target;
			_duration = $duration;
			_vars = $vars;
		}
		
		public function call():void {
			TweenLite.to(_target, _duration, _vars);
		}
	}
}
