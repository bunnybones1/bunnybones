package com.bunnybones.ui.keyboard 
{
	import com.bunnybones.color.Color3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class StageKeyboardColor 
	{
		static private var _color:Color3D;
		
		public function StageKeyboardColor() 
		{
			super();
			
		}
		
		static public function enable():void 
		{
			if (StageKeyBoard.isBound && StageKeyBoard.onScreenKeyboard) {
				init();
			} else {
				throw new Error("No way, Jose! You need a valid OnStageKeyboard!");
			}
		}
		
		static private function init():void 
		{
			_color = new Color3D(0xff7f7f7f, true);
			addColorKey("Increase Hue", Keyboard.W, increaseHue, Color3D.getHueMatrix(15));
			addColorKey("Decrease Hue", Keyboard.Q, decreaseHue, Color3D.getHueMatrix(-15));
			addColorKey("Increase Saturation", Keyboard.S, increaseSaturation, Color3D.getSaturationMatrix(15));
			addColorKey("Decrease Saturation", Keyboard.A, decreaseSaturation, Color3D.getSaturationMatrix(-15));
			addColorKey("Increase Value", Keyboard.X, increaseValue, Color3D.getValueMatrix(15));
			addColorKey("Decrease Value", Keyboard.Z, decreaseValue, Color3D.getValueMatrix(-15));
			
			addColorKey("Increase Red", Keyboard.R, increaseRed, Color3D.getRedMatrix(15));
			addColorKey("Decrease Red", Keyboard.E, decreaseRed, Color3D.getRedMatrix(-15));
			addColorKey("Increase Green", Keyboard.F, increaseGreen, Color3D.getGreenMatrix(15));
			addColorKey("Decrease Green", Keyboard.D, decreaseGreen, Color3D.getGreenMatrix(-15));
			addColorKey("Increase Blue", Keyboard.V, increaseBlue, Color3D.getBlueMatrix(15));
			addColorKey("Decrease Blue", Keyboard.C, decreaseBlue, Color3D.getBlueMatrix(-15));
		}
		
		static private function addColorKey(label:String, keyCode:uint, callbackOnDown:Function, colorMatrix:Matrix3D):void 
		{
			var keyBinding:KeyBinding = StageKeyBoard.bindKey(label, keyCode, callbackOnDown, null, false, false, false, true);
			var keyButton:KeyButton = StageKeyBoard.onScreenKeyboard.getKeyButtonByKeyCode(keyCode);
			keyButton.color = _color.giveBirth(colorMatrix);
		}
		
		static public function get color():Color3D
		{
			return _color;
		}
		
		static public function set color(value:Color3D):void 
		{
			if (_color) _color.removeEventListener(Event.CHANGE, onColorChange);
			_color = value;
			if (_color) _color.addEventListener(Event.CHANGE, onColorChange);
		}
		
		static private function onColorChange(e:Event):void 
		{
			dtag("color", color.hex);
			//cursorMaterial.color = _brushColor.hex;
		}
		
		
		static public function decreaseRed():void 
		{
			_color.r -= 10;
		}
		
		static public function increaseRed():void 
		{
			_color.r += 10;
		}
		
		static public function decreaseGreen():void 
		{
			_color.g -= 10;
		}
		
		static public function increaseGreen():void 
		{
			_color.g += 10;
		}
		
		static public function decreaseBlue():void 
		{
			_color.b -= 10;
		}
		
		static public function increaseBlue():void 
		{
			_color.b += 10;
		}
		
		static public function decreaseAlpha():void 
		{
			_color.a -= 10;
		}
		
		static public function increaseAlpha():void 
		{
			_color.a += 10;
		}
		
		//HSV
		
		static public function decreaseHue():void 
		{
			_color.rotateHue(-5);
		}
		
		static public function increaseHue():void 
		{
			_color.rotateHue(5);
		}
		
		static public function decreaseSaturation():void 
		{
			_color.saturate(-5);
		}
		
		static public function increaseSaturation():void 
		{
			_color.saturate(5);
		}
		
		static public function decreaseValue():void 
		{
			_color.brighten(-5);
		}
		
		static public function increaseValue():void 
		{
			_color.brighten(5);
		}
		
	}

}