package com.bunnybones.ui.keyboard 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class StageKeyBoard 
	{
		static private var keyStates:Vector.<Boolean> = new Vector.<Boolean>;
		static private var keyBindings:Vector.<Array> = new Vector.<Array>;
		static private var unsortedKeyBindings:Vector.<KeyBinding> = new Vector.<KeyBinding>;
		static private var staticInitd:Boolean = false;
		public function StageKeyBoard() 
		{
			
		}
		
		static public function bind(stage:Stage):void
		{
			trace("StageKeyBoard bound to stage.");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		static private function onEnterFrame(e:Event):void 
		{
			for each(var keyBinding:KeyBinding in unsortedKeyBindings)
			{
				if (keyBinding.instantRepeat)
				{
					if (keyStates[keyBinding.keyCode])
					{
						if (keyBinding.ctrl == keyStates[Keyboard.CONTROL] && keyBinding.shift == keyStates[Keyboard.SHIFT] && keyBinding.alt == keyStates[Keyboard.ALTERNATE])
						{
							keyBinding.callback();
						}
					}
				}
			}
		}
		
		static private function onKeyUp(e:KeyboardEvent):void 
		{
			keyStates[e.keyCode] = false;
		}
		
		static private function onKeyDown(e:KeyboardEvent):void 
		{
			keyStates[e.keyCode] = true;
			var keyCodeBindings:Array = keyBindings[e.keyCode];
			for each(var keyBinding:KeyBinding in keyCodeBindings)
			{
				keyBinding.testKey(e);
			}
		}
		
		static public function isDown(keyCode:uint):Boolean
		{
			return keyStates[keyCode];
		}
		
		static public function areDown(keyCodes:Array):Boolean
		{
			for each(var keyCode:int in keyCodes)
			{
				if (!isDown(keyCode)) return false;
			}
			return true;
		}
		
		static public function bindKey(callback:Function, keyCode:uint, ctrl:Boolean = false, shift:Boolean = false, alt:Boolean = false, instantRepeat:Boolean = false):void 
		{
			staticInit();
			var keyBinding:KeyBinding = new KeyBinding(callback, keyCode, ctrl, shift, alt, instantRepeat);
			var keyCodeBindings:Array = keyBindings[keyCode];
			keyCodeBindings.push(keyBinding);
			unsortedKeyBindings.push(keyBinding);
		}
		
		static public function releaseKey(callback:Function, keyCode:uint, ctrl:Boolean = false, shift:Boolean = false, alt:Boolean = false):void 
		{
			var keyCodeBindings:Array = keyBindings[keyCode];
			for (var i:int = keyCodeBindings.length - 1; i >= 0; i--)
			{
				var toRemove:Array;
				if ((keyCodeBindings[i] as KeyBinding).matches(callback, keyCode, ctrl, shift, alt)) toRemove = keyCodeBindings.splice(i, 1);
				unsortedKeyBindings.splice(unsortedKeyBindings.indexOf(toRemove[0]), 1);
			}
		}
		
		static private function staticInit():void 
		{
			if (staticInitd) return;
			staticInitd = true;
			trace("Tool: StageKeyBoard Initd");
			for (var i:int = 0; i <= 255; i++)
			{
				keyStates[i] = false;
				keyBindings[i] = new Array();
			}
		}
	}

}