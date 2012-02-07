package business.data.dicts {
	import business.controller.localization.LocalizationManager;
	import flash.geom.Point;
	
	/**
	 * @author virich
	 */
	public class TutorialVO {
		
		public static const ID: String = "tutorial";
		
		public static var MAIN: String = "main";
		public static var ADD: String = "add";
		
		public static var TUTORIAL: Object = {};
		public static var TUTORIAL_CHAINS: Object = {};
		
		public static function getTutorial($id: int):TutorialVO {
			var tutor: TutorialVO = TUTORIAL[$id];
			while (tutor && tutor.checkpoint) {
				tutor = TUTORIAL[tutor.id+tutor.checkpoint];
			}
			if (tutor && tutor.action>2) {
				return null;
			}
			return tutor;
		}
		
		public static function getTutorialByChain($chain: String, $count: int = 0):TutorialVO {
			return TUTORIAL_CHAINS[$chain] ? TUTORIAL_CHAINS[$chain][$count] : null;
		}
		
		public static function parse($data: Object):void {
			for (var i : String in $data) {
				var tutor: TutorialVO = new TutorialVO();
				tutor.id = $data[i].id;
				tutor.target_id = $data[i].target_id;
				tutor.chain = $data[i].chain;
				tutor.arrow_dir = $data[i].arrow_dir;
				tutor.arrow_pos = parsePoint($data[i].arrow_pos);
				tutor.message_pos = parsePoint($data[i].message_pos);
				tutor.hiders = $data[i].hiders;
				tutor.action = $data[i].action;
				tutor.event = $data[i].event;
				tutor.condition = $data[i].condition;
				tutor.checkpoint = $data[i].checkpoint;
				tutor.state = $data[i].state;
				TUTORIAL[tutor.id] = tutor;
				
				if (!TUTORIAL_CHAINS[tutor.chain]) {
					TUTORIAL_CHAINS[tutor.chain] = [];
				}
				TUTORIAL_CHAINS[tutor.chain].push(tutor);
			}
		}
		
		public var id: int;
		public var target_id: String;
		public var chain: String;
		public var arrow_dir: int;
		public var arrow_pos: Point;
		public var message_pos: Point;
		public var hiders: String;
		public var action: int;
		public var event: String;
		public var condition: *;
		public var checkpoint: int;
		public var state: String;
		
		public var started: Boolean = false;
		public var finished: Boolean = false;
		
		public function getHiders():Array {
			var hids: Array = [];
			if (hiders) {
				var hh: Array = hiders.replace(" ", "").split(";");
				for (var i : int = 0; i < hh.length; i++) {
					hids.push(hh[i].split(","));
				}
			}
			return hids;
		}
		
		private static function parsePoint($str: String):Point {
			var arr: Array = $str.split(" ");
			return new Point(arr[0], arr[1]);
		}
		
		public function get title():String {
			return LocalizationManager.getText("tutorial."+id);
		}
	}
}
