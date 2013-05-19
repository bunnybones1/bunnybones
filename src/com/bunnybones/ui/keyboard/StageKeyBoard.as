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
		static private var _onScreenKeyboard:OnScreenKeyboard;
		static public var isBound:Boolean = false;
		public function StageKeyBoard() 
		{
			
		}
		
		static public function bind(stage:Stage, tabGUI:Boolean = true):void
		{
			dtrace("StageKeyBoard bound to stage.");
			staticInit();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (tabGUI) {
				_onScreenKeyboard = new OnScreenKeyboard()
				stage.addChild(_onScreenKeyboard);
				bindKey("Toggle on-screen keyboard.", Keyboard.TAB, toggleStageKeyboard);
			}
			isBound = true;
		}
		
		static private function toggleStageKeyboard():void 
		{
			_onScreenKeyboard.visible = !_onScreenKeyboard.visible;
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
							keyBinding.callbackOnDown();
						}
					}
				}
			}
		}
		
		static private function onKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode > 255) return;
			keyStates[e.keyCode] = false;
			var keyCodeBindings:Array = keyBindings[e.keyCode];
			for each(var keyBinding:KeyBinding in keyCodeBindings)
			{
				keyBinding.testKeyUp(e);
			}
		}
		
		static private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode > 255) return;
			//var firstDown:Boolean = !keyStates[e.keyCode];
			keyStates[e.keyCode] = true;
			var keyCodeBindings:Array = keyBindings[e.keyCode];
			for each(var keyBinding:KeyBinding in keyCodeBindings)
			{
				//if(!keyBinding.instantRepeat && firstDown) keyBinding.testKeyDown(e);
				if(!keyBinding.instantRepeat) keyBinding.testKeyDown(e);
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
		
		static public function bindKey(label:String, keyCode:uint, callbackOnDown:Function = null, callbackOnUp:Function = null, ctrl:Boolean = false, shift:Boolean = false, alt:Boolean = false, instantRepeat:Boolean = false):KeyBinding
		{
			staticInit();
			var keyBinding:KeyBinding = new KeyBinding(label, keyCode, callbackOnDown, callbackOnUp, ctrl, shift, alt, instantRepeat);
			var keyCodeBindings:Array = keyBindings[keyCode];
			keyCodeBindings.push(keyBinding);
			unsortedKeyBindings.push(keyBinding);
			//if (_onScreenKeyboard) _onScreenKeyboard.updateKey(keyBinding);
			return keyBinding;
		}
		
		static public function releaseKey(callback:Function, keyCode:uint, ctrl:Boolean = false, shift:Boolean = false, alt:Boolean = false):void 
		{
			var keyCodeBindings:Array = keyBindings[keyCode];
			for (var i:int = keyCodeBindings.length - 1; i >= 0; i--)
			{
				var toRemove:Array;
				if ((keyCodeBindings[i] as KeyBinding).matches(callback, keyCode, ctrl, shift, alt)) toRemove = keyCodeBindings.splice(i, 1);
				if(toRemove) unsortedKeyBindings.splice(unsortedKeyBindings.indexOf(toRemove[0]), 1);
			}
		}
		
		static public function listKeys(keyCode:uint):String
		{
			var string:String = "";
			var keyCodeBindings:Array = keyBindings[keyCode];
			for (var i:int = 0; i < keyCodeBindings.length; i++ ) {
				var binding:KeyBinding = keyCodeBindings[i];
				if(i>0)string += "\n";
				string += String(binding.label);
			}
			return string;
		}
		
		
		static private function staticInit():void 
		{
			if (staticInitd) return;
			staticInitd = true;
			//dtrace("Tool: StageKeyBoard Initd");
			for (var i:int = 0; i <= 255; i++)
			{
				keyStates[i] = false;
				keyBindings[i] = new Array();
			}
		}
		
		static public function get onScreenKeyboard():OnScreenKeyboard 
		{
			return _onScreenKeyboard;
		}
	}

}