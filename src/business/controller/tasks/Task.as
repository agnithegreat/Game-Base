package business.controller.tasks {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * @author virich
	 */
	public class Task extends EventDispatcher {
		
		public static const NEXT_TASK: String = "next_task";
		public static const TASK_COMPLETE: String = "task_complete";
		
		public function Task() {
		}
		
		public function run():void {
			
		}
		
		public function complete():void {
			dispatchEvent(new Event(TASK_COMPLETE));
		}
	}
}
