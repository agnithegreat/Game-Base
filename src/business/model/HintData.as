package business.model {
	import business.controller.localization.LocalizationManager;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * @author agnithegreat
	 */
	public class HintData extends EventDispatcher {
		
		public static const ROLL_OVER: String = "roll_over_HintData";		public static const ROLL_OUT: String = "roll_out_HintData";
		
		private var _id: String;
		public function set id($id: String):void {
			_id = $id;
		}
		public function get id() : String {
			return _id;
		}
		
		private var _target: DisplayObject;
		public function get target():DisplayObject {
			return _target;
		}
		
		public function get text():String {
			return LocalizationManager.getText(_id, _replaces);
		}
		
		private var _replaces: Object;
		
		public function HintData($id: String, $target: DisplayObject, $replaces: Object = null) {
			_id = $id;
			_target = $target;
			
			updateReplaces($replaces);
			
			target.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			target.addEventListener(MouseEvent.MOUSE_DOWN, handleRollOut);
			target.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
		}
		
		public function updateReplaces($data: Object):void {
			_replaces = $data;
		}
		
		private function handleRollOver(e: MouseEvent) : void {
			dispatchEvent(new Event(ROLL_OVER));
		}		private function handleRollOut(e: MouseEvent) : void {
			dispatchEvent(new Event(ROLL_OUT));
		}
	}
}
