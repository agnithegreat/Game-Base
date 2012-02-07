package business.utils {
	import business.controller.localization.LocalizationManager;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * @author virich
	 */
	public class Utils {
		
		public static function parseTime($timeInSeconds: int):String {
			var output: String = "";
			var m: int = ($timeInSeconds/60)%60;
			output += output.length>0 ? ":"+parseTimeValue(m) : parseTimeValue(m);
			var s: int = $timeInSeconds%60;
			output += output.length>0 ? ":"+parseTimeValue(s) : parseTimeValue(s);
			return output;
		}
		
		public static function parseDate($date: Date):String {
			var output: String = "[d].[m].[y]";
			var d: int = $date.getUTCDate();
			output = output.replace("[d]", parseTimeValue(d, 2));
			var m: int = $date.getUTCMonth()+1;
			output = output.replace("[m]", parseTimeValue(m, 2));
			var y: int = $date.getUTCFullYear();
			output = output.replace("[y]", parseTimeValue(y, 4));
			return output;
		}
		
		public static function parseTimeToReset($timeInSeconds: int):String {
			var d: int = ($timeInSeconds/60/60/24)%7;
			var h: int = ($timeInSeconds/60/60)%24;
			var m: int = ($timeInSeconds/60)%60;
			var s: int = ($timeInSeconds)%60;
			return LocalizationManager.getText("tournament.tf_time", {"d": d, "h": h, "m": m, "s": s});
		}
		
		private static function parseTimeValue(value: int, length: int = 2):String {
			var s: String = String(value);
			while (s.length<length) {
				s = "0"+s;
			}
			return s;
		}
		
		public static function validateCurrency(value: int, plus: Boolean = false, red: Boolean = false):String {
			var currency: String = String(value).replace( /\d{1,3}(?=(\d{3})+(?!\d))/g , "$& ");
			if (red && value<0) {
				currency = "<font color='#7B0000'>"+currency+"</font>";
			}
			return plus ? "+"+currency : currency;
		}
		
		public static function getStagePosition($target: DisplayObject, $center: Boolean = false):Point {
			var point: Point = new Point($target.x, $target.y);
			var parent: DisplayObject = $target.parent;
			while (parent) {
				point.x += parent.x;
				point.y += parent.y;
				parent = parent.parent;
			}
			return $center ? point.add(new Point($target.width/2, $target.height/2)) : point;
		}
		
		public static function validateAS3DateToSQLDate(datetime : Date):String {
			if (!datetime) return "";
			var year: String = String(datetime.getUTCFullYear());
			var month: String = (datetime.getUTCMonth()+1<10) ? "0"+String(datetime.getUTCMonth()+1) : String(datetime.getUTCMonth()+1);
			var date: String = (datetime.getUTCDate()<10) ? "0"+String(datetime.getUTCDate()) : String(datetime.getUTCDate());
			var hours: String = (datetime.getUTCHours()<10) ? "0"+String(datetime.getUTCHours()) : String(datetime.getUTCHours());
			var minutes: String = (datetime.getUTCMinutes()<10) ? "0"+String(datetime.getUTCMinutes()) : String(datetime.getUTCMinutes());
			var seconds: String = (datetime.getUTCSeconds()<10) ? "0"+String(datetime.getUTCSeconds()) : String(datetime.getUTCSeconds());
			return String(year+"-"+month+"-"+date+" "+hours+":"+minutes+":"+seconds);
		}
		
		public static function validateSQLDateToAS3Date($date: *):Date {
			if (!$date) {
				return null;
			}
			return new Date($date*1000);
		}
		
		public static function validateNumber(str: String, start: int, end: int):int {
			if (!str) return 0;
			var s: String = str.slice(start, end);
			return int(s);
		}
		
		public static function parseStringObject($string: String):Object {
			var obj: Object = {};
			var data: Array = $string.split(",");
			for (var i : int = 0; i < data.length; i++) {
				var value: Array = data[i].split(":");
				obj[value[0]] = value[1];
			}
			return obj;
		}
		
		public static function getDatesDifference($date1: Date, $date2: Date = null):int {
			if (!$date1) {
				$date1 = new Date();
			}
			if (!$date2) {
				$date2 = new Date();
			}
			return ($date2.time-$date1.time)/1000;
		}
		
		public static function parseShortScore(value: int):String {
			var s: String = value>=1000 ? String(int(value/1000))+"K" : String(value/1000);
			return s;
		}
	}
}
