package business.controller {
	import business.model.HintData;
	import business.view.HintView;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * @author agnithegreat
	 */
	public class HintManager {
		
		private static var _hints: Vector.<HintData>;
		private static var _stack: Array = [];
		
		private static var _hintView: HintView;
		
		public static function init(stage : Stage) : void {
			_hints = new Vector.<HintData>();
			
			_hintView = new HintView();
			stage.addChild(_hintView);
			hideHint();
		}
		
		public static function registerHint(hint: HintData):void {
			_hints.push(hint);
			hint.addEventListener(HintData.ROLL_OVER, handleRollOver);			hint.addEventListener(HintData.ROLL_OUT, handleRollOut);
		}

		private static function handleRollOver(e : Event) : void {
			if (_stack.length > 0 && _stack[_stack.length - 1] == e.currentTarget) {
				return;
			}
			var hint : HintData = e.currentTarget as HintData;
			if (hint.id) {
				showHint(hint);
				_stack.push(hint);
			}
		}		private static function handleRollOut(e : Event) : void {
			_stack.pop();
			hideHint();
			
			if (_stack.length > 0) {
				var hint: HintData = _stack.pop();
				hint.dispatchEvent(new Event(HintData.ROLL_OVER));
			}
		}
	
		public static function showHint(hint: HintData) : void {
			if (!hint) {
				return;
			}
			_hintView.showHint(hint);
			_hintView.visible = true;
			
			_hintView.positionHint(hint.target.getRect(_hintView.parent));

			_hintView.updateHint();
		}
		
		public static function hideHint():void {
			if (_hintView) {
				_hintView.visible = false;
			}
		}
	}
}
