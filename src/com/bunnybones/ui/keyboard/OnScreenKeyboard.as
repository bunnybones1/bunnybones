package com.bunnybones.ui.keyboard 
{
	import com.bunnybones.MouseToolTip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class OnScreenKeyboard extends Sprite 
	{
		public static const STANDARD_LENGTH:int = 3;
		public static const PIXELS_PER_UNIT:int = 20;
		public static const FONT_SIZE_IN_UNITS:Number = 1.25;
		static public const BUTTONS_COLOR1:uint = 0xffffff;
		static public const BUTTONS_COLOR2:uint = 0x797979;
		static public const BUTTON_CORNER_RADIUS_IN_UNITS:Number = .3;
		static public const INSET_IN_UNITS:Number = .1;
		static public const ROLLED_OVER_SCALE:Number = .95;
		static public const HOVER_SCALE:Number = .95;
		static public const DEFAULT_SCALE:Number = 1;
		static public const DOWN_SCALE:Number = .85;
		
		private var cursor:Point;
		private var keyButtonByKeyCode:Array;
		private var downKeys:Vector.<KeyButton>;
		
		public function OnScreenKeyboard() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function init()
		{
			MouseToolTip.bind(stage);
			downKeys = new Vector.<KeyButton>();
			keyButtonByKeyCode = new Array();
			for (i = 0; i < 256; i++) keyButtonByKeyCode.push(null);
			
			var buttons:Vector.<KeyButton> = new Vector.<KeyButton>;
			cursor = new Point();
			addButton("Esc", Keyboard.ESCAPE, KeyButton.STANDARD_LENGTH);
			addSpace();
			addObviousString("F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12");
			newRow(4);
			addButton("`", Keyboard.BACKQUOTE, 4);
			for (var i:int = 1; i < 10; i++) {
				addNumber(i);
			}
			addNumber(0);
			addButton("-", Keyboard.MINUS);
			addButton("=", Keyboard.EQUAL);
			addButton("Back", Keyboard.BACKSPACE, 5);
			newRow();
			addButton("Tab", Keyboard.TAB, 5);
			addObviousString("Q,W,E,R,T,Y,U,I,O,P");
			addButton("[", Keyboard.LEFTBRACKET);
			addButton("]", Keyboard.RIGHTBRACKET);
			addButton("\\", Keyboard.BACKSLASH, 4);
			newRow();
			addButton("Caps", Keyboard.CAPS_LOCK, 6);
			addReallyObviousString("ASDFGHJKL");
			addButton(";", Keyboard.SEMICOLON);
			addButton("'", Keyboard.QUOTE);
			addButton("Enter", Keyboard.ENTER, 6);
			newRow();
			addButton("Shift", Keyboard.SHIFT, 7);
			addReallyObviousString("ZXCVBNM");
			addButton(",", Keyboard.COMMA);
			addButton(".", Keyboard.PERIOD);
			addButton("/", Keyboard.SLASH);
			addButton("Shift", Keyboard.SHIFT, 8);
			newRow();
			addButton("Ctrl", Keyboard.CONTROL, 5);
			addSpace(5);
			addButton("Alt", Keyboard.ALTERNATE, 5);
			addButton("", Keyboard.SPACE, 5 * KeyButton.STANDARD_LENGTH);
			addButton("Alt", Keyboard.ALTERNATE, 5);
			addSpace(5);
			addButton("Ctrl", Keyboard.CONTROL, 5);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			var keyButton:KeyButton = keyButtonByKeyCode[e.keyCode];
			if(keyButton) keyButton.down = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			var keyButton:KeyButton = keyButtonByKeyCode[e.keyCode];
			if(keyButton) keyButton.down = false;
		}
		
		private function addReallyObviousString(keys:String):void 
		{
			var commadKeys:String = keys.charAt(0);
			for (var i:int = 1; i < keys.length; i++) {
				commadKeys+=",";
				commadKeys += keys.charAt(i);
			}
			addObviousString(commadKeys);
		}
		
		private function addNumber(i:int):void 
		{
			addButton(i.toString(), Keyboard["NUMBER_" + i.toString()]);
		}
		
		private function addObviousString(keys:String):void 
		{
			addObviousBunch(keys.split(","));
		}
		
		private function addObviousBunch(arr:Array):void 
		{
			for (var i:int = 0; i < arr.length; i++) {
				var keyString:String = arr[i];
				addButton(keyString, Keyboard[keyString]);
			}
		}
		
		private function newRow(length:Number = STANDARD_LENGTH):void 
		{
			cursor.x = 0;
			cursor.y += length;
		}
		
		private function addSpace(length:int = STANDARD_LENGTH):void 
		{
			cursor.x += length;
		}
		
		private function addButton(label:String, keyCode:uint, length:int = STANDARD_LENGTH):void 
		{
			var keyButton:KeyButton = new KeyButton(label, keyCode, length);
			keyButton.addEventListener(MouseEvent.ROLL_OVER, onKeyRollOver);
			keyButton.addEventListener(MouseEvent.MOUSE_DOWN, onKeyButtonMouseDown);
			keyButton.x = cursor.x * PIXELS_PER_UNIT;
			keyButton.y = cursor.y * PIXELS_PER_UNIT;
			cursor.x += length;
			keyButtonByKeyCode[keyCode] = keyButton;
			addChild(keyButton);
			
		}
		
		private function onKeyButtonMouseDown(e:MouseEvent):void 
		{
			var button:KeyButton = e.target as KeyButton;
			button.down = true;
			downKeys.push(button);
			stage.addEventListener(MouseEvent.MOUSE_UP, onKeyButtonMouseUp);
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, button.keyCode));
		}
		
		private function onKeyButtonMouseUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onKeyButtonMouseUp);
			var button:KeyButton = downKeys.pop();
			button.down = false;
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 0, button.keyCode));
		}
		
		private function onKeyRollOver(e:MouseEvent):void 
		{
			var button:KeyButton = e.target as KeyButton;
			button.addEventListener(MouseEvent.ROLL_OUT, onKeyRollOut);
			button.hover = true;
			//button.scaleX = button.scaleY = ROLLED_OVER_SCALE;
			//dispatchEvent(e);
			MouseToolTip.notify(StageKeyBoard.listKeys(button.keyCode));
		}
		
		private function onKeyRollOut(e:MouseEvent):void 
		{
			var button:KeyButton = e.target as KeyButton;
			button.removeEventListener(MouseEvent.ROLL_OUT, onKeyRollOut);
			button.scaleX = button.scaleY = DEFAULT_SCALE;
			
		}
		
		public function getKeyButtonByKeyCode(keyCode):KeyButton {
			return keyButtonByKeyCode[keyCode];
		}
		
	}

}
