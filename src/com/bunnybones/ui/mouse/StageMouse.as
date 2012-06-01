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
		static public var stagePos:Point = new Point();
		static public var stagePosAtLastDown:Point = new Point();
		static public var stagePosAtLastUp:Point = new Point();
		static private var movesSinceLastFrame:Vector.<MouseEvent> = new Vector.<MouseEvent>();
		static private var stage:Stage;
		static public var moveSinceLastFrame:Point = new Point();
		
		public function StageMouse() 
		{
			
		}
		
		static public function bind(stage:Stage):void 
		{
			StageMouse.stage = stage;
			dtrace("StageMouse bound to stage.");
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		static public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		static private function onMouseMove(e:MouseEvent):void 
		{
			movesSinceLastFrame.push(e);
			stagePos.x = e.stageX;
			stagePos.y = e.stageY;
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
			stagePosAtLastDown.x = e.stageX;
			stagePosAtLastDown.y = e.stageY;
		}
		
		static private function onMouseUp(e:MouseEvent):void 
		{
			stagePosAtLastUp.x = e.stageX;
			stagePosAtLastUp.y = e.stageY;
		}
		
	}

}