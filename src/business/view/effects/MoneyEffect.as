package business.view.effects {
	import business.utils.Utils;
	import flash.display.DisplayObject;
	import flash.text.TextField;

	/**
	 * @author virich
	 */
	public class MoneyEffect extends Effect {
		
		private var _startValue: int;
		private var _value: int;
		
		private function get textField():TextField {
			return _target as TextField;
		}
		
		private var _plus: Boolean;
		
		public function MoneyEffect($target : DisplayObject, $value: int, $duration: int, $delay: int = 0, $plus: Boolean = false) {
			super($target, $duration, $delay);
			
			_value = $value;
			
			_plus = $plus;
			
			start();
		}
		
		override protected function tick($time: int):void {
			if (progress<0) {
				return;
			}
			if (!_startValue) {
				_startValue = getStringValue(textField.text);
			}
			
			if (progress<=1 && _value!=_startValue) {
				var currentValue: int = Math.round(progress*(_value-_startValue)+_startValue);
				textField.text = Utils.validateCurrency(currentValue, _plus);
				dispatchEvent(new EffectEvent(EffectEvent.EFFECT_UPDATE, currentValue));
			} else {
				textField.text = Utils.validateCurrency(_value, _plus);
				end();
			}
		}
		
		private function getStringValue($string: String):int {
			var string: String = "";
			for (var i : int = 0; i < $string.length; i++) {
				var char: String = $string.charAt(i);
				if (char in [1,2,3,4,5,6,7,8,9,0]) {
					string += char;
				}
			}
			return int(string);
		}
	}
}
