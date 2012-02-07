package business.model {
	import flash.display.Sprite;
	import business.event.DataUpdateEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 * @author virich
	 */
	public class User extends EventDispatcher {
		
		public static const FRIENDS: Object = {};
		public static function getFriendsList():Array {
			var users: Array = getFriends(true);
//			users.push(GameSystem.player);
			users.sortOn("highscore", Array.DESCENDING + Array.NUMERIC);
			return users;
		}
		public static function getFriends($users: Boolean):Array {
			var users: Array = [];
			for (var i : String in FRIENDS) {
				var user: User = FRIENDS[i];
				if (!$users || user.isUser) {
					users.push(user);
				}
			}
			return users;
		}
		public static function parseFriends($data: Object):void {
			for (var i : String in $data) {
				var data: Object = $data[i];
				if (!data) {
					continue;
				}
				var user: User = getUserByUID(data.user.uid);
				user.parseUser(data.user);
				if (user.uid && !FRIENDS[user.uid]) {
					FRIENDS[user.uid] = user;
				}
			}
		}
		public static function parseFriendsSocial($data: Object):void {
			for (var i : String in $data) {
				var data: Object = $data[i];
				if (!data) {
					continue;
				}
				var user: User = getUserByUID(data.uid);
				user.parseSocial(data);
				if (user.uid && !FRIENDS[user.uid]) {
					FRIENDS[user.uid] = user;
				}
			}
		}
		public static function getFriendsCount():int {
			return getFriends(true).length;
		}
		public static function getFriendsUIDS():Array {
			var users: Array = getFriends(false);
			var uids: Array = [];
			for (var i : int = 0; i < users.length; i++) {
				uids.push(users[i].uid);
			}
			return uids;
		}
		
		public static function isFriend($uid: String):Boolean {
			return FRIENDS[$uid];
		}
		
		public static function parseTokened($tokened: Object, $activated: Object):void {
			var users: Array = getFriends(false);
			for (var i : int = 0; i < users.length; i++) {
				users[i].tokened = false;
				users[i].activated = false;
			}
			for (var key : String in $tokened) {
				var user: User = getUserByUID(key);
				user.tokened = true;
			}
			for (key in $activated) {
				user = getUserByUID(key);
				user.activated = true;
			}
		}
		public static function getUntokenedFriends():Array {
			var users: Array = [];
			for (var i : String in FRIENDS) {
				var user: User = FRIENDS[i];
				if (!user.tokened) {
					users.push(user);
				}
			}
			users.sortOn("highscore", Array.DESCENDING + Array.NUMERIC);
			return users;
		}
		
		public static const USERS: Object = {};
		public static function getUserByUID($uid: String):User {
			return USERS[$uid] ? USERS[$uid] : new User();
		}
		public static function getUsers($sortOn: String = "highscore"):Array {
			var users: Array = [];
			for (var i : String in USERS) {
				var user: User = USERS[i];
				users.push(user);
			}
			if ($sortOn) {
				users.sortOn($sortOn, Array.NUMERIC+Array.DESCENDING);
			}
			return users;
		}
		public static function getFirst($friends: Boolean):User {
			var users: Array;
			users = $friends ? getFriendsList() : getUsers("highscore");
			return users && users.length>0 ? users[0] : null;
		}
		
		public static function getRatings():Array {
			var users: Array = getUsers("highscore");
			users = users.splice(0, 100);
//			if (users.indexOf(GameSystem.player)==-1) {
//				users.push(GameSystem.player);
//			}
			return users;
		}
		
		public static function getWithoutSocial():Array {
			var users: Array = [];
			for (var i : String in USERS) {
				var user: User = USERS[i];
				if (!user.social) {
					users.push(user.uid);
				}
			}
			return users;
		}
		
		public static function parseRatings($data: Object):void {
			for (var i : String in $data.hex) {
				var data: Object = $data.hex[i];
				var user: User = getUserByUID(data.uID);
				user.parseScore(data);
			}
		}
		
		public static function parse($data: Object):void {
			for (var i : String in $data) {
				var data: Object = $data[i];
				if (!data) {
					continue;
				}
				var user: User = User.getUserByUID(data.user.uid);
				user.parseUser(data.user);
			}
		}
		
		private var _uid: String;
		public function get uid():String {
			return _uid;
		}
		
		private var _social: Object;
		public function get social():Object {
			return _social;
		}
		
		public function get name():String {
			if (!_social) {
				return "";
			}
			return _social.first_name+" "+_social.last_name;
		}
		
		protected var _highscore: int;
		public function get highscore():int {
			return _highscore;
		}
		
		protected var _record: int;
		protected var _ts_record: Date;
		
		protected var _ts_register: uint;
		public function get ts_register():uint {
			return _ts_register;
		}
		
		public var tokened: Boolean = false;
		
		protected var _activated: Boolean = false;
		public function get activated() : Boolean {
			return _activated;
		}
		public function set activated(activated : Boolean) : void {
			_activated = activated;
			update();
		}
		
		protected var _isUser: Boolean;
		public function get isUser():Boolean {
			return _isUser;
		}
		
		private var _updateLocked: Boolean;
		
		public function User() {
		}
		
		public function getRecordHighscore():int {
			return _record;
		}
		
		public function getPlace():int {
			var users: Array = getRatings();
			for (var i : int = 0; i < users.length; i++) {
				if (users[i]==this) {
					return i+1;
				}
			}
			return 0;
		}
		
		public function parseUser($data: Object, $lock: Boolean = false):void {
			if ($data.uid && !_uid) {
				_uid = $data.uid;
			}
			_isUser = true;
			_highscore = $data.high_score2;
			_record = $data.record_hex;
			_ts_record = new Date($data.ts_record_hex*1000);
			_ts_register = $data.ts_register;
			
			if (!USERS[_uid]) {
				USERS[_uid] = this;
			}
			
			if (!$lock) {
				update();
			}
		}
		
		public function parseScore($data: Object):void {
			if ($data.uID && !_uid) {
				_uid = $data.uID;
			}
			_isUser = true;
			_highscore = $data.score;
			
			if (!USERS[_uid]) {
				USERS[_uid] = this;
			}
			
			update();
		}
		
		public function parseSocial($data: Object):void {
			if (!social && $data) {
				_social = $data;
			}
			
			if (!_uid && $data.uid) {
				_uid = $data.uid;
			}
			
			if (social) {
				USERS[social.uid] = this;
			}
			
			dispatchEvent(new DataUpdateEvent(DataUpdateEvent.USER_SOCIAL_LOADED));
			update();
		}
		
		public function load():void {
			if (_social) {
				_social.load(handleLoadComplete);
			}
		}
		
		public function get hasPhoto():Boolean {
			return _social && _social.photo;
		}
		
		public function getPhoto():Sprite {
			var photo: Sprite = new Sprite();
			if (!_social.photo) {
				return null;
			}
			photo.addChild(_social.photo);
			var sx: Number = 50/photo.width;
			var sy: Number = 50/photo.height;
			var scale: Number = Math.min(sx, sy);
			photo.scaleX *= scale;
			photo.scaleY *= scale;
			photo.x = (50-photo.width)/2;
			photo.y = (50-photo.height)/2;
			return photo;
		}
		
		private function handleLoadComplete(e : Event) : void {
			dispatchEvent(new DataUpdateEvent(DataUpdateEvent.USERPIC_LOADED));
		}
		
		public function lockUpdate():void {
			_updateLocked = true;
		}
		
		public function unlockUpdate():void {
			_updateLocked = false;
		}
		
		public function update():void {
			dispatchEvent(new DataUpdateEvent(DataUpdateEvent.USER_UPDATED));
		}
	}
}
