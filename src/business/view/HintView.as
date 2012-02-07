package business.view {
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import business.controller.windows.ResourceContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import business.controller.windows.WindowManager;
	import business.model.HintData;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author agnithegreat
	 */
	public class HintView extends ResourceContainer {
		
		public static const ID: String = "Tooltip";
		
		private static var _gap: int = 7;
		
		public static var delay: int = 1000;
		public static var alphaSteps: int = 1;
		
		private var _count: int;
		
		private var _static: Boolean = false;
		private var _rect: Rectangle;
		
		private var _height: int;
		
		public function HintView() {
			super(ID);
		}

		override protected function init() : void {
			_rect = new Rectangle();
			
			mouseEnabled = mouseChildren = false;
			
			filters = [new GlowFilter(0, 0.7, 3, 3, 3, 3), new DropShadowFilter()];
		}
		
		public function showHint(hint: HintData) : void {
			if (!_loaded) {
				return;
			}
			
			_asset.graphics.clear();
			
			_asset.tf_text.autoSize = TextFieldAutoSize.LEFT;
			_asset.tf_text.multiline = true;
			_asset.tf_text.wordWrap = true;
			_asset.tf_text.htmlText = hint.text;
			
			_asset.tf_text.width = Math.max(Math.min(_asset.tf_text.width, 190), 60);
			
			_height = _asset.tf_text.height+6;
			
			_asset.graphics.beginFill(0xE0C984);
			_asset.graphics.drawRoundRect(0, 0, _asset.tf_text.width+8, _height, 10);
			
			start();
		}
		
		private function start():void {
			alpha = 0;
			_count = 0;
			WindowManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMove);
			addEventListener(Event.ENTER_FRAME, handleTimer);
		}

		private function handleMove(e : MouseEvent) : void {
			WindowManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMove);
			removeEventListener(Event.ENTER_FRAME, handleTimer);
			start();
		}

		private function handleTimer(e : Event) : void {
			if (!_static && _count<10) {
				positionHint(_rect);
				updateHint();
			}
			
			_count++;
			alpha = Math.round(Math.max(_count*stage.frameRate/delay, 0)/alphaSteps);
			if (alpha>=1) {
				WindowManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMove);
				removeEventListener(Event.ENTER_FRAME, handleTimer);
			}
		}
		
		public function positionHint($rect: Rectangle):void {
			x = parent.mouseX;
			y = $rect.height+30<Settings.HEIGHT-parent.mouseY ?  parent.mouseY+30 : parent.mouseY-30-$rect.height;
		}
		
		public function updateHint():void {
			var rect: Rectangle = getBounds(parent);
			
			if (rect.x < _gap) {
				x = _gap;
			}
			if (rect.x > Settings.WIDTH-rect.width-_gap) {
				x = Settings.WIDTH-rect.width-_gap;
			}
			if (rect.y < _gap) {
				y = _gap;
			}
			if (rect.y > Settings.HEIGHT-_height-_gap) {
				y = Settings.HEIGHT-_height-_gap;
			}
		}
	}
}
