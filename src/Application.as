package {
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import business.controller.windows.PopupLayer;
	import business.utils.FPSCounter;
	import business.controller.windows.WindowManager;
	import business.controller.windows.Layer;
	import business.controller.windows.ResourceManager;
	import business.controller.KeyboardController;
	import flash.display.Sprite;

	public class Application extends Sprite {
		
		public static var animation_layer: Sprite;
		
		public function init($settings: Object, $wrapper: Object) : void {
			Security.allowDomain("*");
			
			Settings.init($settings);
			
			WindowManager.init(stage);
			ResourceManager.init();
			KeyboardController.init(stage);
			
			WindowManager.addMainLayer(new Layer(Layer.MAIN_LAYER, Layer.MULTIPLE));
			WindowManager.addMainLayer(new Layer(Layer.WINDOWS_LAYER, Layer.MULTIPLE, 5));
			WindowManager.addMainLayer(new PopupLayer(Layer.POPUP_LAYER, 10));
			WindowManager.addMainLayer(new Layer(Layer.PAYMENTS_LAYER, Layer.SINGLE, 15));
			WindowManager.addMainLayer(new Layer(Layer.MENU_LAYER, Layer.SINGLE, 20));
			WindowManager.addMainLayer(new Layer(Layer.LOADER_LAYER, Layer.SINGLE, 35));
			
			animation_layer = new Sprite();
			animation_layer.mouseEnabled = animation_layer.mouseChildren = false;
			stage.addChild(animation_layer);
			
//			GameSystem.init($wrapper);
			
			if (Settings.battle) {
				return;
			}
			
			stage.addChild(new FPSCounter(0,0,0,true,0xFFFFFF));
			
			// show chords
			_chords = new TextField();
			_chords.background = true;
			_chords.backgroundColor = 0xFFFFFF;
			_chords.autoSize = TextFieldAutoSize.LEFT;
			stage.addChild(_chords);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, updateChords);
		}
		
		private var _chords: TextField;
		private function updateChords(e: MouseEvent):void {
			_chords.text = "{x: "+mouseX+", y: "+mouseY+"}";
			_chords.x = (Settings.WIDTH-_chords.width);
		}
	}
}
