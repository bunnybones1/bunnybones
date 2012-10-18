package com.bunnybones.away3d.controllers 
{
	import away3d.entities.Entity;
	import awayphysics.dynamics.AWPRigidBody;
	import com.bunnybones.away3d.entities.guns.GunBase;
	import com.bunnybones.Callback;
	import com.bunnybones.ui.joystick.JoystickBind;
	import com.bunnybones.ui.mouse.StageMouse;
	import extension.JoyQuery.Joystick;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class XBox360FirstPersonController extends FirstPersonController
	{
		private var _joystick:JoystickBind;
		public function XBox360FirstPersonController(targetObject:Entity = null, forceHeight:Number = NaN, awpBody:AWPRigidBody = null)
		{
			super(targetObject, forceHeight, awpBody);
			_joystick = new JoystickBind();
			_joystick.setAxisCallback(0, new Callback(this, "immediateStrafe"));
			_joystick.setAxisCallback(1, new Callback(this, "immediateWalk"));
			_joystick.setAxisCallback(2, new Callback(this, "immediateAscend"));
			_joystick.setAxisCallback(3, new Callback(this, "immediateTilt"));
			_joystick.setAxisCallback(4, new Callback(this, "immediatePan"));
			autoUpdate = true;
			StageMouse.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		override public function update():void 
		{
			_joystick.update();
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var lookAtTarget:Vector3D = _targetObject.scenePosition.add(_targetObject.forwardVector);
			_targetObject.lookAt(lookAtTarget);
			notifyUpdate();
		}
		
	}

}