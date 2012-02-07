package business.utils.animationCache {
	import flash.events.Event;
	import business.controller.windows.ResourceContainer;

	/**
	 * @author virich
	 */
	public class Animation extends ResourceContainer {
		
		private var _loop: Boolean;
		
		public function Animation($id : String, $loop: Boolean) {
			super($id);
			_loop = $loop;
		}
		
		public function play():void {
			_asset.play();
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		public function stop():void {
			_asset.stop();
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		public function gotoAndPlay($id: int):void {
			_asset.gotoAndPlay($id);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		public function gotoAndStop($id: int):void {
			_asset.gotoAndStop($id);
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		private function handleEnterFrame(e : Event) : void {
			if (_asset.currentFrame==_asset.totalFrames) {
				dispatchEvent(new Event(AnimationCache.ANIMATION_LOOP));
				if (!_loop) {
					stop();
				}
			}
		}
	}
}
