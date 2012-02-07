package business.data.dicts {
	
	/**
	 * @author agnithegreat
	 */
	public class HintVO {
		
		public static var HINTS: Array = [];
		
		public var id: String;
		public var text: String;
		
		public static function parseData($data: Object):void {
			for (var key:String in $data) {
				var hint: HintVO = new HintVO();
				hint.id = $data[key].id;
				hint.text = $data[key].text;
				HINTS.push(hint);
			}
			HINTS.sortOn("id");
		}
		
		public static function getHint(id: String):HintVO {
			var len: int = HINTS.length;
			for (var i : int = 0; i < len; i++) {
				if (HINTS[i].id == id) {
					return HINTS[i];
				}
			}
			return null;
		}
	}
}
