package business.data.dicts {
	
	/**
	 * @author virich
	 */
	public class LibsLinksVO {
		
		public static var LINKS: Object = {};
		
		public static function parse($data: Object):void {
			for (var i : String in $data) {
				LINKS[i] = $data[i];
			}
		}
	}
}
