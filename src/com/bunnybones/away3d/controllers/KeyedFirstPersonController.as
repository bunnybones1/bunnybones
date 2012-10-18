package com.bunnybones.away3d.controllers 
{
	import away3d.entities.Entity;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.ui.mouse.StageMouse;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class KeyedFirstPersonController extends FirstPersonController
	{
		static public const MOUSE_SPEED:Number = .3;
		private var speed:Number = .25;
		
		public function KeyedFirstPersonController(targetObject:Entity = null, forceHeight:Number = NaN) 
		{
			super(targetObject);
			this.forceHeight = forceHeight;
			StageKeyBoard.bindKey(Keyboard.W, function():void { incrementWalk(speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.S, function():void { incrementWalk(-speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.D, function():void { incrementStrafe(speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.A, function():void { incrementStrafe( -speed) }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.Q, function():void { _targetObject.y += speed }, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.Z, function():void { _targetObject.y -= speed }, null, false, false, false, true);
			StageMouse.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			autoUpdate = true;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_targetObject.pitch(StageMouse.moveSinceLastFrame.y * MOUSE_SPEED);
			_targetObject.yaw(StageMouse.moveSinceLastFrame.x * MOUSE_SPEED);
			var lookAtTarget:Vector3D = _targetObject.scenePosition.add(_targetObject.forwardVector);
			_targetObject.lookAt(lookAtTarget);
			notifyUpdate();
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
			if (!isNaN(forceHeight)) _targetObject.y = forceHeight;
		}
	}

}