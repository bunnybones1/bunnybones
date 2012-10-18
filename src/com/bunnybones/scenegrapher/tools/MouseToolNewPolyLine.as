package com.bunnybones.scenegrapher.tools 
{
	import com.bunnybones.scenegrapher.PolyLineShape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class MouseToolNewPolyLine extends MouseTool 
	{
		private var tempCursorHandle:PolyLineShape;
		
		public function MouseToolNewPolyLine() 
		{
			super();
		}
		
		static public function activate():void 
		{
			new MouseToolNewPolyLine();
		}
		
		override public function init():void 
		{
			super.init();
			sceneGrapher.stage.addEventListener(MouseEvent.CLICK, onClickFirst);
		}
		
		private function onClickFirst(e:MouseEvent):void 
		{
			if (e.target is Stage)
			{
				if (e.ctrlKey)
				{
					tempCursorHandle = new PolyLineShape();
					tempCursorHandle.x = sceneGrapher.lastMouseMovePositionLocal.x;
					tempCursorHandle.y = sceneGrapher.lastMouseMovePositionLocal.y;
					sceneGrapher.addChild(tempCursorHandle);
					tempCursorHandle.addEventListener(Event.COMPLETE, onPolyLineComplete);
					sceneGrapher.stage.removeEventListener(MouseEvent.CLICK, onClickFirst);
				}
			}
		}
		
		private function onPolyLineComplete(e:Event):void 
		{
			sceneGrapher.stage.addEventListener(MouseEvent.CLICK, onClickFirst);
		}		
	}

}