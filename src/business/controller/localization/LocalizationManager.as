package business.controller.localization {
	import api.com.adobe.json.JSON;
	import flash.text.TextField;
	
	/**
	 * @author virich
	 */
	public class LocalizationManager {
		
		public static function parseXML($xml: XML):void {
			var names: XMLList = $xml.*.*.*.@name;
			var texts: XMLList = $xml.*.*.*.@text;
			for (var i : String in names) {
				registerText(names[i], texts[i]);
			}
			update();
		}
		
		private static var _storage: Object = {};
		public static function registerTextField($id: String, $tf: TextField):void {
			if (!_storage[$id]) {
				_storage[$id] = [];
			}
			_storage[$id].push($tf);
			$tf.text = _texts[$id] ? _texts[$id].text : "";
		}
		
		private static var _texts: Object = {};
		public static function registerText($id: String, $text: String):void {
			_texts[$id] = new LocaleString($id, $text);
		}
		public static function getText($id: String, $replaces: Object = null):String {
			return _texts[$id] ? _texts[$id].getText($replaces) : "";
		}
		
		public static function getVariantDecorator($id: String, $replace: Object, $select: Boolean):String {
			var decorator: Object = {id: $id, variant: $id, select: $select};
			var locale: LocaleString = new LocaleString($id, JSON.encode(decorator));
			var repl: Object = {};
			repl[$id] = $replace;
			return locale.getText(repl);
		}
		
		public static function update():void {
			for (var i : String in _storage) {
				var arr: Array = _storage[i];
				if (arr) {
					for (var j : int = 0; j < arr.length; j++) {
						updateTextField(i, arr[j]);
					}
				}
			}
		}
		
		public static function updateTextField($id: String, $tf: TextField):void {
			if ($tf) {
				$tf.text = _texts[$id] ? _texts[$id].text : "";
			}
		}
	}
}
