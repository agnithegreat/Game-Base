package business.data.dicts {
	
	/**
	 * @author virich
	 */
	public class CurrencyVO {
		
		public static const ID: String = "currency";
		
		public static const GOLD_CURRENCY: String = "gold";
		public static const LIVES_CURRENCY: String = "lives";
		
		public static var CURRENCY: Object = {};
		public static var GOLD: Array = [];
		public static var LIVES: Array = [];
		
		public static function getCurrency($id: int):CurrencyVO {
			return CURRENCY[$id];
		}
		
		public static function parse($data: Object):void {
			for (var i : String in $data) {
				var currency: CurrencyVO = new CurrencyVO();
				currency.id = $data[i].id;
				currency.sn = $data[i].sn;
				currency.lives = $data[i].lives;
				currency.gold = $data[i].gold;
				currency.currency = $data[i].currency;
				currency.value = $data[i].value;
				if (currency.gold) {
					GOLD.push(currency);
				} else {
					LIVES.push(currency);
				}
				CURRENCY[currency.id] = currency;
			}
		}
		
		public var id: int;
		public var sn: String;
		public var gold: int;
		public var lives: int;
		public var currency: String;
		public var value: int;
	}
}
