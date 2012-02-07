package business.data.dicts {
	import business.controller.localization.LocalizationManager;
	
	/**
	 * @author virich
	 */
	public class WallPostVO {
		
		public static const ID: String = "wallPosts";
		
		public static const TARGET_SELF: String = "self";
		public static const TARGET_FRIEND: String = "friend";
		
		public static const TOURNAMENT: String = "wallPost.tournament";
		public static const TOKEN_SEND: String = "wallPost.token.send";
		public static const TOKEN_REQUEST: String = "wallPost.token.request";
		public static const REMIND: String = "wallPost.remind";
		public static const FIRST_PLACE_TOP: String = "wallPost.first_place_top";
		public static const FIRST_PLACE_FRIENDS: String = "wallPost.first_place_friends";
		public static const TOP_TEN: String = "wallPost.top_10";
		public static const TOP_100: String = "wallPost.top_100";
		public static const ACHIEVEMENT: String = "wallPost.achievement";
		
		public static function getPostId($post_id: String):String {
			return $post_id.replace("wallPost.","");
		}
		
		public static var POSTS: Object = {};
		public static function getWallPost($id: String):WallPostVO {
			return POSTS[$id];
		}
		
		public var id: int;
		public var image: String;
		public var text: String;
		public var target: String;
		
		public static function parse($data: Object):void {
			for (var i : String in $data) {
				var post: WallPostVO = new WallPostVO();
				post.id = $data[i].id;
				post.image = $data[i].image;
				post.text = $data[i].text;
				post.target = $data[i].target;
				
				POSTS[post.text] = post;
			}
		}
		
		public function getSexMessage($replaces: Object = null):String {
			return LocalizationManager.getText(text, $replaces);
		}
		
		public function get isSelf():Boolean {
			return target==TARGET_SELF;
		}
		
		public function get isFriend():Boolean {
			return target==TARGET_FRIEND;
		}
	}
}
