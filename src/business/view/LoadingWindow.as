package business.view {
	import business.controller.windows.WindowManager;
	import business.controller.windows.Layer;
	import business.controller.windows.Window;

	/**
	 * @author virich
	 */
	public class LoadingWindow extends Window {
		
		public static const ID: String = "Loading";
		
		public static var enabled: Boolean = true;

		private static var _loading: Array = [];
		public static function addLoad($id: String = null):void {
			if ($id) {
				if (_loading.indexOf($id)!=-1) {
					return;
				}
				_loading.push($id);
			}
			var window: Window = WindowManager.getWindow(ID);
			if (window && enabled) {
				window.open();
			}
		}
		public static function endLoad($id: String):void {
			if ($id) {
				var index: int = _loading.indexOf($id);
				if (index!=-1) {
					_loading.splice(index, 1);
				}
			}
			if (_loading.length>0) {
				return;
			}
			var window: Window = WindowManager.getWindow(ID);
			if (window) {
				window.close();
			}
		}
		
		public function LoadingWindow() {
			super(ID, null, Layer.LOADER_LAYER, true, false);
		}
		
		override protected function init():void {
			setAlign(CENTER, CENTER);
		}
	}
}
