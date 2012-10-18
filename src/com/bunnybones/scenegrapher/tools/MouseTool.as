package com.bunnybones.scenegrapher.tools 
{
	import com.bunnybones.scenegrapher.SceneGrapherMain;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class MouseTool 
	{
		static protected var sceneGrapher:SceneGrapherMain;
		static private var _currentTool:MouseTool;
		public var prev:MouseTool;
		public var next:MouseTool;
		
		public function MouseTool() 
		{
			if (!_currentTool) {
				currentTool = this;
				prev = currentTool;
				next = currentTool;
			}
			else 
			{
				next = _currentTool.next;
				prev = _currentTool;
				prev.next = this;
				next.prev = this;
			}
		}
		
		public function deactivate():void 
		{
			this.prev.next = next;
			this.next.prev = prev;
			currentTool = next;
		}
		
		static public function bind(sceneGrapher:SceneGrapherMain):void
		{
			MouseTool.sceneGrapher = sceneGrapher;
			sceneGrapher.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		static private function onMouseWheel(e:MouseEvent):void 
		{
			if (!_currentTool) throw new Error("No Mousetools initialized!");
			if (!e.ctrlKey) return;
			if(e.delta > 0) currentTool = currentTool.next;
			else currentTool = currentTool.prev;
			dtrace("current tool:" + currentTool);
		}
		
		static public function get currentTool():MouseTool 
		{
			return _currentTool;
		}
		
		static public function set currentTool(value:MouseTool):void 
		{
			if (currentTool) currentTool.deinit();
			_currentTool = value;
			if (currentTool) currentTool.init();
		}
		
		public function init():void 
		{
			trace("init", this);
		}
		
		public function deinit():void 
		{
			trace("deinit", this);
		}
		
	}

}