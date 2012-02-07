package {
	
	/**
	 * @author virich
	 */
	public class Settings {
		
		public static var WIDTH: int = 760;
		public static var HEIGHT: int = 640;
		
		public static function init($data: Object):void {
			server_url = $data.server_url;
			server_key = $data.server_key;
			
			resources_url = server_url+"/client/resources/";
			locale_ru_url = server_url+"/client/locale/strings.xml?_"+(new Date()).time;
			locale_en_url = server_url+"/client/locale/strings_en.xml?_"+(new Date()).time;
			sounds_url = server_url+"/client/sounds/";
			wall_post_url = server_url+"/client/wall_post/";
			images_url = server_url+"/client/images/";
			group_url = $data.group_url;
			
			local = $data.local;
			battle = $data.battle;
		}
		
		public static var server_url: String;
		public static var server_key: String;
		public static var battle: Boolean = false;
		
		public static var resources_url: String;
		public static var locale_ru_url: String;
		public static var locale_en_url: String;
		public static var sounds_url: String;
		public static var wall_post_url: String;
		public static var images_url: String;
		public static var group_url: String;
		
		public static var local: Boolean = true;
	}
}
