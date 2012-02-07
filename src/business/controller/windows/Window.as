package business.controller.windows {
	import flash.display.BitmapData;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.display.Bitmap;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.events.Event;

	/**
	 * @author agnithegreat
	 */
	public class Window extends ResourceContainer implements IWindow {
		
		public static const LEFT: String = "left";
		public static const CENTER: String = "center";
		public static const RIGHT: String = "right";
		public static const TOP: String = "top";
		public static const BOTTOM: String = "bottom";
		
		public static const EVENT_OPEN: String = "open_Window";		public static const EVENT_CLOSE: String = "close_Window";
		
		public static const DIALOG_WINDOW : String = "DialogWindow";
		public static const PRELOADER : String = "Preloader";
		public static const MAIN_SCREEN : String = "MainScreen";
		public static const MAIN_MENU : String = "MainMenu";
		public static const GAME_SCREEN : String = "GameScreen";
		public static const FRIENDS : String = "FriendsList";
		public static const TUTORIAL : String = "TutorialWindow";
		
		public static function getWidth($offset: Boolean): int {
			return $offset ? Settings.WIDTH-200 : Settings.WIDTH;
		}
		public static function getHeight(): int {
			return Settings.HEIGHT;
		}
		
		protected var _size : String;
		
		protected var _priority: int;
		public function get priority():int {
			return _priority;
		}
		
		protected var _positionOffset: Point;
		public function get offset():Point {
			if (!_positionOffset) {
				_positionOffset = new Point();
			}
			if (!_positionOffset) {
				_positionOffset = new Point();
			}
			return _positionOffset.add(_parentOffset);
		}
		
		private var _parentOffset: Point;
		
		protected var _parent : String;
		public function get parentLayer():String {
			return _parent;
		}
		
		protected var _bluring: Boolean;
		public function get bluring():Boolean {
			return _bluring;
		}
		
		protected var _flashing: Boolean;
		public function get flashing():Boolean {
			return _flashing;
		}
		
		private var _static: Boolean;
		public function get isStatic():Boolean {
			return _static;
		}
		
		public function get hierarchy():int {
			var par: Window = _parent ? WindowManager.getWindow(_parent) : null;
			if (par && par.visible && parent) {
				var layer: Layer = par as Layer;
				if (layer && layer.depth) {
					return layer.depth+1;
				}
				return par.hierarchy+1;
			}
			return 0;
		}
		
		public function get position():Point {
			var pos: Point = new Point(x,y);
			var par: Window = _parent ? WindowManager.getWindow(_parent) : null;
			if (par) {
				return par.position.add(pos);
			}
			return pos;
		}
		
		public function Window($id: String, $size: String = null, $parent: String = null, $bluring: Boolean = true, $flashing: Boolean = true, $priority: int = 0, $static: Boolean = false) {
			_parentOffset = new Point();
			_size = $size;
			if (_size) {
				_resource = ResourceManager.getResource(_size);
			}
			_bluring = $bluring;
			_flashing = $flashing;
			_priority = $priority;
			_parent = $parent;
			_static = $static;
			
			super($id);
			
			WindowManager.registerWindow(this);
		}
		
		public function setAlign($h: String, $v: String):void {
			switch ($h) {
				case LEFT:
					x = offset.x;
					break;
				case CENTER:
					x = offset.x+(getWidth(true)-_assetContainer.width)/2;
					break;
				case RIGHT:
					x = offset.x+(getWidth(false)-_assetContainer.width);
					break;
			}
			switch ($v) {
				case TOP:
					y = offset.y;
					break;
				case CENTER:
					y = offset.y+(getHeight()-_assetContainer.height)/2;
					break;
				case BOTTOM:
					y = offset.y+(getHeight()-_assetContainer.height);
					break;
			}
		}
			
		public function open():void {
			var par: Window = _parent ? WindowManager.getWindow(_parent) : null;
			if (par) {
				_parentOffset.x = par.offset.x-par.x;
				_parentOffset.y = par.offset.y-par.y;
			}
			
			visible = true;
			if (parentLayer && !parent) {
				WindowManager.getLayer(parentLayer).push(id);
			}
			
			dispatchEvent(new Event(EVENT_OPEN));
			
			WindowManager.updateWindows();
		}
		
		public function close():void {
//			if (_flashing && !_animating) {
//				if (!_flash) {
//					_flash = new Bitmap();
//				}
//				
//				if (!_flash.parent) {
//					var bmd: BitmapData = new BitmapData(_assetContainer.width, _assetContainer.height, true, 0x00000000);
//					bmd.draw(_assetContainer);
//					_flash.bitmapData = bmd;
//					_interval = setInterval(unflash, 100);
//					_animating = true;
//				}
//				return;
//			}
			closeEnd();
		}
		
		private function closeEnd():void {
			if (parentLayer && parent) {
				WindowManager.getLayer(parentLayer).closeWindow(id);
			}
			visible = false;
			dispatchEvent(new Event(EVENT_CLOSE));
			
			WindowManager.updateWindows();
		}

		public function show() : void {
			addListeners();
			
			if (_flashing && !_animating) {
				if (!_flash) {
					_flash = new Bitmap();
				}
				
				if (!_flash.parent) {
					_assetContainer.visible = false;
					var bmd: BitmapData = new BitmapData(_assetContainer.width, _assetContainer.height, true, 0x00000000);
					bmd.draw(_assetContainer);
					_flash.bitmapData = bmd;
					_interval = setInterval(flash, 100);
					_animating = true;
				}
			}
		}
		
		private var _animating: Boolean;
		private var _interval: int;
		private var _flash: Bitmap;
		private function flash():void {
			clearInterval(_interval);
			
			_flash.x = width/4;
			_flash.y = height/4;
			_flash.scaleX = _flash.scaleY = 0.5;
			_flash.alpha = 0;
			addChild(_flash);
			
			TweenLite.to(_flash, 0.1, {x: 0, y: 0, scaleX: 1, scaleY: 1, alpha: 1, onComplete: afterFlash});
		}
		private function afterFlash():void {
			removeChild(_flash);
			_assetContainer.visible = true;
			
			_animating = false;
		}
		
		private function unflash():void {
			clearInterval(_interval);
			
			_flash.x = 0;
			_flash.y = 0;
			_flash.scaleX = _flash.scaleY = 1;
			_flash.alpha = 1;
			addChild(_flash);
			_assetContainer.visible = false;
			
			TweenLite.to(_flash, 0.1, {x: width/4, y: height/4, scaleX: 0.5, scaleY: 0.5, alpha: 0, onComplete: afterUnflash});
		}
		private function afterUnflash():void {
			removeChild(_flash);
			_assetContainer.visible = true;
			
			_animating = false;
			
			closeEnd();
		}

		public function hide() : void {			removeListeners();
		}
		
		protected function update():void {
		}
		
		protected function addListeners():void {
			
		}
		
		protected function removeListeners():void {
			
		}
	}
}
