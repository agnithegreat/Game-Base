package business.controller.windows {
	import business.controller.HintManager;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	
	/**
	 * @author AgnI
	 */
	public class WindowManager {
		
		public static var count: int = 0;
		
		private static var _bg: Bitmap;
		private static var _bmd: BitmapData;
		private static var _hider: Shape;
		
		private static var _windows: Object = {};
		public static function getWindow($id: String):Window {
			if (!_windows[$id]) {
				trace("Window with id "+$id+" isn't registered");
			}
			return _windows[$id];
		}
				private static var _layers: Object = {};
		public static function getLayer($id: String) : Layer {
			if (!_layers[$id]) {
				throw new Error("Layer with id "+$id+" isn't registered");
			}
			return _layers[$id];
		}
		
		public static var stage: Stage;
		
		private static var _container: Sprite;
		private static var _viewPort: Sprite;
		
		private static var _mainLayers: Vector.<Layer>;
		public static function addMainLayer($layer: Layer):void {
			_mainLayers.push($layer);
		}
		
		public static function init($stage: Stage):void {
			stage = $stage;
			if (!_mainLayers) {
				_mainLayers = new Vector.<Layer>();
				
				_viewPort = new Sprite();
				stage.addChild(_viewPort);
			}
		}
		
		public static function registerWindow($window: Window):void {
			if (_windows[$window.id]) {
				throw new Error("Window with id "+$window.id+" is already registered");
			}
			_windows[$window.id] = $window;
			count++;
		}
		
		public static function registerLayer($layer: Layer):void {
			if (_layers[$layer.id]) {
				throw new Error("Layer with id "+$layer.id+" is already registered");
			}
			_layers[$layer.id] = $layer;
		}
		
		public static function closeWindow($id: String) : void {
			var window: Window = getWindow($id);
			(window.parent as Layer).closeWindow($id);
			
			$id = null;
		}
		
//		public static function buildWay($way: String):void {
//			if (!$way) {
//				return;
//			}
//			var way : Array = $way.split(".");
//			var len: int = way.length;
//			for (var i : int = 0; i < len; i++) {
//				var window: Window = getWindow(way[i]);
//				window.open();
//			}
//			
//			$way = null;
//			way = null;
//		}
		
		public static function updateWindows():void {
			_container = new Sprite();
			
			for (var i : int = 0; i < _mainLayers.length; i++) {
				var layer: Layer = _mainLayers[i];
				if (!layer.isEmpty && layer.visible) {
					_container.addChild(layer);
				}
				addChildrenWindows(layer);
			}
			
			updateHider();
			updateViewport();
		}
		
		private static function addChildrenWindows($layer: Layer):void {
			if (!$layer || !$layer.visible) {
				return;
			}
			var children: int = $layer.stack.length;
			for (var i : int = 0; i < children; i++) {
				var window: Window = $layer.stack[i];
				_container.addChild(window);
				if (window is Layer) {
					addChildrenWindows(window as Layer);
				}
			}
		}
		
		private static function updateHider():void {
			if (!_bg) {
				_bg = new Bitmap();
			}
			if (!_bmd) {
				_bmd = new BitmapData(Settings.WIDTH, Settings.HEIGHT, true, 0x00000000);
			}
			
			if (!_hider) {
				_hider = new Shape();
				_hider.graphics.beginFill(0,0.7);
				_hider.graphics.drawRect(0, 0, Settings.WIDTH, Settings.HEIGHT);
			}
		}
		
		private static function updateViewport():void {
			HintManager.hideHint();
			
			while (_viewPort.numChildren>0) {
				_viewPort.removeChildAt(0);
			}
			
			var temp: Vector.<Window> = new Vector.<Window>();
			
			var last: Window;
			while (_container.numChildren>0) {
				last = _container.getChildAt(_container.numChildren-1) as Window;
				temp.unshift(last);
				_container.removeChild(last);
				if (last.bluring) {
					break;
				}
			}
			
			_bmd.draw(_container);
			_bmd.draw(_hider);
			_bg.bitmapData = _bmd;
			
			_viewPort.addChild(_bg);
			for (var i: int = 0; i < temp.length; i++) {
				_viewPort.addChild(temp[i]);
			}
		}
	}
}
