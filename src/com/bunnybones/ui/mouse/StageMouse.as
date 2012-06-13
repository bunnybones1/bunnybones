package com.bunnybones.ui.mouse 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class StageMouse 
	{
		static public var lastStagePos:Point = new Point();
		static public var stagePos:Point = new Point();
		static public var stagePosAtLastDown:Point = new Point();
		static public var stagePosAtLastUp:Point = new Point();
		static private var movesSinceLastFrame:Vector.<MouseEvent> = new Vector.<MouseEvent>();
		static public var moveSinceLastFrame:Point = new Point();
		static private var _isMouseDown:Boolean;
		static private var mouseActive:Boolean;
		
		public function StageMouse() 
		{
			
		}
		
		static public function bind(stage:Stage):void 
		{
			dtrace("StageMouse bound to stage.");
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		static private function onMouseLeaveStage(e:Event):void 
		{
			//dtrace("mouse left stage");
			mouseActive = false;
			stagePos.x = lastStagePos.x;
			stagePos.y = lastStagePos.y;
		}
		
		static private function onMouseMove(e:MouseEvent):void 
		{
			//dtrace("mouse move", e.stageX, e.stageY);
			movesSinceLastFrame.push(e);
			if (mouseActive)
			{
				lastStagePos.x = stagePos.x;
				lastStagePos.y = stagePos.y;
				stagePos.x = e.stageX;
				stagePos.y = e.stageY;
			}
			mouseActive = true;
		}
		
		static private function onEnterFrame(e:Event):void 
		{
			moveSinceLastFrame.x = 0;
			moveSinceLastFrame.y = 0;
			
			for (var i:int = 1; i < movesSinceLastFrame.length; i++) 
			{
				moveSinceLastFrame.x += movesSinceLastFrame[i].stageX - movesSinceLastFrame[i-1].stageX;
				moveSinceLastFrame.y += movesSinceLastFrame[i].stageY - movesSinceLastFrame[i-1].stageY;
			}
			
			while (movesSinceLastFrame.length > 1) movesSinceLastFrame.shift();
		}
			
		static private function onMouseDown(e:MouseEvent):void 
		{
			_isMouseDown = true;
			stagePosAtLastDown.x = e.stageX;
			stagePosAtLastDown.y = e.stageY;
		}
		
		static private function onMouseUp(e:MouseEvent):void 
		{
			_isMouseDown = false;
			stagePosAtLastUp.x = e.stageX;
			stagePosAtLastUp.y = e.stageY;
		}
		
		static public function get isMouseDown():Boolean 
		{
			return _isMouseDown;
		}
		
	}

}