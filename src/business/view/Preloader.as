package business.view {
	import business.controller.windows.Layer;
	import business.controller.windows.Window;

	/**
	 * @author virich
	 */
	public class Preloader extends Window {
		
		public function Preloader() {
			super(Window.PRELOADER, null, Layer.LOADER_LAYER, true, false);
		}
		
		override protected function init():void {
			showProgress(0);
		}
		
		public function showProgress($progress: Number):void {
			if (loaded) {
				_asset.progress.bar.barMask.scaleX = $progress;
			}
		}
	}
}
