package com.bunnybones.ui.joystick 
{
	import flash.display.Stage;
	import away3d.entities.Entity;
	import awayphysics.dynamics.AWPRigidBody;
	import com.bunnybones.away3d.entities.guns.GunBase;
	import com.bunnybones.Callback;
	import com.bunnybones.ui.mouse.StageMouse;
	import extension.JoyQuery.Joystick;
	import flash.events.Event;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class JoystickBind
	{
		private var axisCallbacks:Vector.<Vector.<Callback>>;
		private var buttonCallbacks:Vector.<Vector.<Callback>>;
		private var joystickID:int;
		private var speed:Number = .125;
		static private var availability:Array;
		static private var joystick:Joystick;
		private var virtualAxisValues:Array;
		private var filterSpeed:Number = .6;
		private var desensitizeAxis:Number = .2;
		private var resensitizeAxis:Number = 1 / (1 - desensitizeAxis);
		private var buttonValues:Vector.<Boolean>;
		public function JoystickBind() 
		{
			super();
			joystickID = getAvailableJoystick();
			initBindings();
		}
		
		private function initBindings():void 
		{
			var i:int;
			virtualAxisValues = new Array();
			axisCallbacks = new Vector.<Vector.<Callback>>;
			buttonValues = new Vector.<Boolean>;
			buttonCallbacks = new Vector.<Vector.<Callback>>;
			for (i = 0; i < 5; i++) 
			{
				virtualAxisValues[i] = 0;
				axisCallbacks[i] = new Vector.<Callback>;
			}
			for (i = 0; i < 16; i++) 
			{
				buttonValues[i] = false;
				buttonCallbacks[i] = new Vector.<Callback>;
			}
		}
		
		public function setAxisCallback(axisID:int, callback:Callback):void
		{
			axisCallbacks[axisID].push(callback);
		}
		
		public function setButtonCallback(buttonID:int, callback:Callback):void
		{
			buttonCallbacks[buttonID].push(callback);
		}
		
		static private function getAvailableJoystick():int
		{
			if (!joystick) 
			{
				joystick = new Joystick();
				availability = [true, true, true, true];
			}
			for (var i:int = 0; i < availability.length; i++) 
			{
				if (availability[i]) 
				{
					availability[i] = false;
					return i;
				}
			}
			return -1;
		}
		
		public function update():void 
		{
			var totalCallbacks:int;
			var callback:Callback;
			var axisVal:Number;
			var buttonVal:Boolean;
			
			var i:int;
			for(i = 0; i < joystick.getTotalAxes(joystickID); i++)
			{
				axisVal = filterAxis(i, joystick.getAxis(joystickID, i));
				totalCallbacks = axisCallbacks[i].length;
				for (var j:int = 0; j < totalCallbacks; j++)
				{
					callback = axisCallbacks[i][j];
					switch(i)
					{
						case 0:
						case 1:
						case 2:
							callback.setValue(axisVal * speed);
							break;
						case 3:
						case 4:
							callback.setValue(axisVal * 3);
							break;
					}
				}
			}
			
			for(i = 0; i < joystick.getTotalButtons(joystickID); i++)
			{
				buttonVal = joystick.buttonIsDown(joystickID, i);
				for each (callback in buttonCallbacks[i]) 
				{
					if (!buttonValues[i] && buttonVal)
					{
						buttonValues[i] = true;
						callback.setValue(buttonVal);
						dtrace(i);
					}
					else if (buttonValues[i] && !buttonVal)
					{
						buttonValues[i] = false;
						callback.setValue(buttonVal);
					}
				}
			}
		}
		
		public function onEnterFrame(e:Event):void 
		{
			update();
		}
		
		private function filterAxis(axisID:int, axisVal:Number):Number
		{
			var flip:Boolean;
			if (axisVal < 0) 
			{
				axisVal = -axisVal;
				flip = true;
			}
			axisVal = Math.max(0, axisVal - desensitizeAxis) * resensitizeAxis;
			if (flip) axisVal = -axisVal;
			
			virtualAxisValues[axisID] -= (virtualAxisValues[axisID] - axisVal) * filterSpeed;
			
			return virtualAxisValues[axisID];
		}
	}

}