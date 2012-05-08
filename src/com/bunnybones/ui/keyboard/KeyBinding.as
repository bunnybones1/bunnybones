package com.bunnybones.ui.keyboard 
{
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class KeyBinding 
	{
		public var keyCode:uint;
		public var callbackOnDown:Function;
		public var callbackOnUp:Function;
		public var ctrl:Boolean;
		public var shift:Boolean;
		public var alt:Boolean;
		public var instantRepeat:Boolean;
		public function KeyBinding(keyCode:uint, callbackOnDown:Function = null, callbackOnUp:Function = null, ctrl:Boolean = false, shift:Boolean = false, alt:Boolean = false, instantRepeat:Boolean = false)
		{
			this.keyCode = keyCode;
			this.callbackOnDown = callbackOnDown;
			this.callbackOnUp = callbackOnUp;
			this.ctrl = ctrl;
			this.shift = shift;
			this.alt = alt;
			this.instantRepeat = instantRepeat;
		}
		
		public function testKeyDown(e:KeyboardEvent):void
		{
			testKey(e);
		}
		
		public function testKeyUp(e:KeyboardEvent):void
		{
			testKey(e, false, false);
		}
		
		public function testKey(e:KeyboardEvent, strictOnModifiers:Boolean = true, down:Boolean = true):void
		{
			var callback:Function = down ? callbackOnDown : callbackOnUp;
			if (!callback) return;
			if (e.keyCode == keyCode)
			{
				if (strictOnModifiers) 
				{
					if (e.shiftKey == shift && e.ctrlKey == ctrl && e.altKey == alt) callback();
				}
				else callback();
			}
		}
		
		public function matches(callback:Function, keyCode:uint, ctrl:Boolean, shift:Boolean, alt:Boolean):Boolean 
		{
			if (this.callbackOnDown != callback) return false;
			if (this.keyCode != keyCode) return false;
			if (this.ctrl != ctrl) return false;
			if (this.shift != shift) return false;
			if (this.alt != alt) return false;
			return true;
		}
		
	}

}