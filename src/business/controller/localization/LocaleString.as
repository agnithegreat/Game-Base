package business.controller.localization {
	import api.com.adobe.json.JSON;
	
	/**
	 * @author virich
	 */
	public class LocaleString {
		
		private var _id: String;
		public function get id() : String {
			return _id;
		}
		
		private var _text: String;
		public function get text() : String {
			return _text;
		}

		private var _data: Object = {};
		public function getValue($id: String, $value: *):String {
			var data: Object = _data[$id];
			var value: String = String($value);
			if (data && data.variant) {
				if (data.select) {
					value = "";
				} else {
					value += " ";
				}
				if ($value>=10 && $value<=20) {
					value += data.variant[2%data.variant.length];
				} else {
					switch ($value%10) {
						case 1:
							value += data.variant[0%data.variant.length];
							break;
						case 2:
						case 3:
						case 4:
							value += data.variant[1%data.variant.length];
							break;
						case 0:
						case 5:
						case 6:
						case 7:
						case 8:
						case 9:
							value += data.variant[2%data.variant.length];
							break;
					}
				}
			}
			return value;
		}
		
		public function LocaleString($id: String, $text: String) {
			_id = $id;
			parse($text);
		}
		
		private function parse($text: String):void {
			_text = $text;
			
			var pos: int = 0;
			while (pos>=0) {
				pos = _text.search("{");
				if (pos>=0) {
					var end: int = _text.search("}");
					var json: String = _text.slice(pos, end+1);
					var data: Object = JSON.decode(json);
					if (data.variant) {
						data.variant = LocalizationManager.getText("variant."+data.variant).split(",");
					}
					_data[data.id] = data;
					_text = _text.replace(json, "["+data.id+"]");
				}
			}
		}
		
		public function getText($replaces: Object):String {
			var result: String = _text;
			
			if ($replaces) {
				for (var i : String in $replaces) {
					result = result.replace("[" + i + "]", getValue(i, $replaces[i]));
				}
			}
			
			return result;
		}
	}
}
