package business.utils.secure {
	
	/**
	 * @author virich
	 */
	public class SecureValue {
		
		private var _modifier: int;
		
		protected var _value: String;
		
		public function set value($value: Number):void {
			_value = ($value*_modifier).toString();
		}
		public function get value():Number {
			return Number(_value)/_modifier;
		}
		
		public function SecureValue($value: Number = 0) {
			_modifier = Math.random()*1000+1;
			value = $value;
		}
	}
}
