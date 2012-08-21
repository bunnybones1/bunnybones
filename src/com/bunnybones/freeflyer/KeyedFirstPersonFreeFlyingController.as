package com.bunnybones.freeflyer 
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Entity;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.ui.mouse.StageMouse;
	import com.jam3.away3d.controllers.FirstPersonFreeFlyingController;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class KeyedFirstPersonFreeFlyingController extends FirstPersonFreeFlyingController
	{
		static public const MOUSE_SPEED:Number = .3;
		private var speed:Number = 05;
		
		public function KeyedFirstPersonFreeFlyingController(targetObject:Entity = null) 
		{
			super(targetObject);
			StageKeyBoard.bindKey(Keyboard.W, function():void { incrementWalk(speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.S, function():void { incrementWalk(-speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.D, function():void { incrementStrafe(speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.A, function():void { incrementStrafe( -speed) }, null, false, false, false, true);
			
			StageKeyBoard.bindKey(Keyboard.W, function():void { incrementWalk(speed*3) }, null, false, true, false, true);
			StageKeyBoard.bindKey(Keyboard.S, function():void { incrementWalk(-speed*3) }, null, false, true, false, true);
			StageKeyBoard.bindKey(Keyboard.D, function():void { incrementStrafe(speed*3) }, null, false, true, false, true);
			StageKeyBoard.bindKey(Keyboard.A, function():void { incrementStrafe( -speed*3) }, null, false, true, false, true);
			StageMouse.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_targetObject.yaw(StageMouse.moveSinceLastFrame.x * MOUSE_SPEED);
			_targetObject.pitch(StageMouse.moveSinceLastFrame.y * MOUSE_SPEED);
		}
		
	}

}