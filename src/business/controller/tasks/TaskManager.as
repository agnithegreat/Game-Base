package business.controller.tasks {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * @author virich
	 */
	public class TaskManager extends EventDispatcher {
		
		private static var loader: TaskManager;
		private static var game: TaskManager;
		
		private static var _allowInstantiation : Boolean = false;
		public static function getInstance($loader: Boolean = false):TaskManager {
			var instance: TaskManager;
			if ($loader) {
				instance = loader;
			} else {
				instance = game;
			}
			if (!instance) {
				_allowInstantiation = true;
				instance = new TaskManager();
				_allowInstantiation = false;
			}
			if ($loader) {
				loader = instance;
			} else {
				game = instance;
			}
			return instance;
		}
		
		
		private var _loaded: int = 0;
		public function get loaded():int {
			return _loaded;
		}
		
		private var _total: int = 0;
		public function get total():int {
			return _total;
		}
		
		public function clearCount():void {
			_loaded = 0;
			_total = 0;
		}
		
		private var _tasks: Vector.<Task>;
		
		private var _currentTasks: Array = [];
		public function get processing():Boolean {
			return Boolean(_currentTasks.length>0);
		}
		
		private var _paused: Boolean;
		public function set paused($paused: Boolean):void {
			_paused = $paused;
			if (!_paused) {
				continueTask();
			}
		}
		
		private var _nextWhilePaused: Boolean;

		public function TaskManager() {
			if (!_allowInstantiation) {
				throw new Error("Can't instantiate TaskManager class using new TaskManager(). Try TaskManager.getInstance().");
			}

			_tasks = new Vector.<Task>();
		}
		
		public function addTask($task: Task):void {
			_tasks.push($task);
			_total++;
			
			run();
		}
		
		public function run():void {
			if (processing) {
				return;
			}
			next();
		}
		
		public function addCurrentTask($task: Task):void {
			if ($task) {
				_currentTasks.push($task);
				$task.addEventListener(Task.TASK_COMPLETE, handleNext);
				$task.run();
			}
		}

		private function handleNext(e : Event) : void {
			if (e) {
				var task: Task = e.currentTarget as Task;
				for (var i : int = 0; i < _currentTasks.length; i++) {
					if (_currentTasks[i] == task) {
						task.removeEventListener(Task.TASK_COMPLETE, handleNext);
						_currentTasks.splice(i,1);
						break;
					}
				}
			}
			next();
		}
		
		public function continueTask():void {
			if (_nextWhilePaused) {
				_nextWhilePaused = false;
				next();
			}
		}
		
		private function next():void {
			if (_paused) {
				_nextWhilePaused = true;
				return;
			}
			_loaded++;
			var task: Task = _tasks.length>0 ? _tasks.shift() : null;
			if (task) {
				addCurrentTask(task);
				dispatchEvent(new Event(Task.NEXT_TASK));
			} else {
				dispatchEvent(new Event(Task.TASK_COMPLETE));
			}
		}
		
		public function clear():void {
			while (_tasks.length>0) {
				var task: Task = _tasks.shift();
				if (task.hasEventListener(Task.TASK_COMPLETE)) {
					task.removeEventListener(Task.TASK_COMPLETE, handleNext);
				} else {
					task.run();
				}
			}
		}
	}
}
