package com.bunnybones.freeflyer 
{
	import away3d.core.math.MathConsts;
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Entity;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.ui.mouse.StageMouse;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class KeyedFirstPersonController extends FirstPersonController 
	{
		static public const MOUSE_SPEED:Number = .3;
		private var speed:Number = 05;
		
		public function KeyedFirstPersonController(targetObject:Entity = null) 
		{
			super(targetObject);
			StageKeyBoard.bindKey(Keyboard.W, function():void { incrementWalk(speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.S, function():void { incrementWalk(-speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.D, function():void { incrementStrafe(speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.A, function():void { incrementStrafe( -speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.Q, function():void { _targetObject.y += speed }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.Z, function():void { _targetObject.y -= speed }, null, false, false, false, true);
			StageMouse.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_targetObject.yaw(StageMouse.moveSinceLastFrame.x * MOUSE_SPEED);
			_targetObject.pitch(StageMouse.moveSinceLastFrame.y * MOUSE_SPEED);
			
		}
		
		override public function update():void 
		{
			if (_walkIncrement) {
				_targetObject.moveForward(_walkIncrement);
				_walkIncrement = 0;
			}
			
			if (_strafeIncrement) {
				targetObject.moveRight(_strafeIncrement);
				_strafeIncrement = 0;
			}
			
		}
	}

}