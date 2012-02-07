package business.controller.windows {
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author agnithegreat
	 */
	public class Layer extends Window {
		
		public static const EVENT_EMPTY: String = "empty_Layer";
		public static const EVENT_NOT_EMPTY: String = "not_empty_Layer";
		
		public static const MAIN_LAYER : String = "main_Layer";
		public static const MENU_LAYER : String = "menu_Layer";
		public static const WINDOWS_LAYER : String = "windows_Layer";
		public static const POPUP_LAYER : String = "popup_Layer";
		public static const PAYMENTS_LAYER : String = "payments_Layer";		public static const TUTORIAL_LAYER : String = "tutorial_Layer";
		public static const HINT_LAYER : String = "hint_Layer";		public static const LOADER_LAYER : String = "loader_Layer";
		
		public static const SINGLE: String = "single_Layer";
		public static const MULTIPLE : String = "multiple_Layer";
		
		protected var _layer: Sprite;
		
		protected var _type: String;
		protected var _stack: Vector.<Window>;
		public function get stack():Vector.<Window> {
			return _stack;
		}
		
		public function get isEmpty():Boolean {
			var statics: int = 0;
			var len: int = _stack.length;
			for (var i : int = 0; i < len; i++) {
				if (_stack[i].isStatic || !_stack[i].bluring) {
					statics++;
				}
			}
			return len==statics;
		}
		
		protected var _depth: int;
		public function get depth():int {
			return _depth;
		}
		
		public function Layer($id: String, $type: String, $depth: int = 0, $size: String = null, $parent: String = null, $bluring: Boolean = false, $flashing: Boolean = false, $priority: int = 0, $static: Boolean = false) {
			super($id, $size, $parent, $bluring, $flashing, $priority, $static);
			
			_depth = $depth;
			
			_type = $type;
			_stack = new Vector.<Window>();
			
			_layer = new Sprite();
			
			WindowManager.registerLayer(this);
			
			$id = null;
			$type = null;
			$parent = null;
		}
		
		public function push($id: String):void {
			var window: Window = WindowManager.getWindow($id);
			if (_stack.indexOf(window)!=-1) {
				return;
			}
			switch (_type) {
				case SINGLE:
					_stack[0] = window;
					break;
				case MULTIPLE:
					_stack.push(window);
					break;
			}
			update();
			
			$id = null;
		}
		
		public function closeWindow($id: String):void {
			var len: int = _stack.length;
			for (var i : int = 0; i < len; i++) {
				if (_stack[i].id==$id) {
					_stack.splice(i, 1);
					update();
					return;
				}
			}
			
			$id = null;
		}
		
		public function pop():void {
			_stack.pop();
			update();
		}
		
		override protected function update():void {
			super.update();
			
			_stack.sort(sortFunction);
			
			while (_layer.numChildren>0) {
				(_layer.getChildAt(0) as Window).hide();			}
			var len: int = _stack.length;
			for (var i : int = 0; i < len; i++) {
				_stack[i].show();
			}

			if (isEmpty) {
				addListeners();
				dispatchEvent(new Event(EVENT_EMPTY));
			} else {
				dispatchEvent(new Event(EVENT_NOT_EMPTY));
				removeListeners();
			}
		}
		
		protected function sortFunction(w1: Window, w2: Window):int {
			if (w1.priority > w2.priority) {
				return 1;
			} else if (w1.priority == w2.priority) {
				return 0;
			} else {
				return -1;
			}
		}
	}
}
