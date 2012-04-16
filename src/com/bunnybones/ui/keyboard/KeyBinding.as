package com.bunnybones.ui.keyboard 
{
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class KeyBinding 
	{
		
		public var callback:Function;
		public var keyCode:uint;
		public var ctrl:Boolean;
		public var shift:Boolean;
		public var alt:Boolean;
		public var instantRepeat:Boolean;
		public function KeyBinding(callback:Function, keyCode:uint, ctrl:Boolean = false, shift:Boolean = false, alt:Boolean = false, instantRepeat:Boolean = false)
		{
			this.callback = callback;
			this.keyCode = keyCode;
			this.ctrl = ctrl;
			this.shift = shift;
			this.alt = alt;
			this.instantRepeat = instantRepeat;
		}
		
		public function testKey(e:KeyboardEvent):void
		{
			if (e.keyCode == keyCode && e.shiftKey == shift && e.ctrlKey == ctrl && e.altKey == alt) callback();
		}
		
		public function matches(callback:Function, keyCode:uint, ctrl:Boolean, shift:Boolean, alt:Boolean):Boolean 
		{
			if (this.callback != callback) return false;
			if (this.keyCode != keyCode) return false;
			if (this.ctrl != ctrl) return false;
			if (this.shift != shift) return false;
			if (this.alt != alt) return false;
			return true;
		}
		
	}

}