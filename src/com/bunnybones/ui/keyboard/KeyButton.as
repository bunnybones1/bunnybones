package com.bunnybones.ui.keyboard
{
	import com.bunnybones.color.Color3D;
	import com.bunnybones.ui.keyboard.OnScreenKeyboard;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class KeyButton extends Sprite{
		public static const STANDARD_LENGTH:int = 3;
		private var _hover:Boolean;
		private var _down:Boolean = false;
		private var _keyCode:uint;
		private var widthUnits:int;
		private var heightUnits:int;
		private var labelTextField:TextField;
		private var buttonBase:ButtonBase;
		private var _color:Color3D;
		public function KeyButton(label:String, keyCode:uint, widthUnits:int = STANDARD_LENGTH, heightUnits:int = STANDARD_LENGTH) {
			this.heightUnits = heightUnits;
			this.widthUnits = widthUnits;
			_keyCode = keyCode;
			_color = new Color3D(0xff7f7f7f, true);
			addChild(buttonBase = new ButtonBase(widthUnits, heightUnits, color));

			if (label && label.length > 0) {
				
				
				labelTextField = new TextField();
				var format:TextFormat = new TextFormat("Arial", OnScreenKeyboard.FONT_SIZE_IN_UNITS * OnScreenKeyboard.PIXELS_PER_UNIT, OnScreenKeyboard.BUTTONS_COLOR1);
				labelTextField.defaultTextFormat = format;
				labelTextField.textColor = OnScreenKeyboard.BUTTONS_COLOR1;
				labelTextField.autoSize = TextFieldAutoSize.LEFT;
				labelTextField.mouseEnabled = false;
				labelTextField.text = label;
				addChild(labelTextField);
				var tightBounds:Rectangle = labelTextField.getCharBoundaries(0);
				for (var i:int = 1; i < label.length; i++) {
					tightBounds = tightBounds.union(labelTextField.getCharBoundaries(i));
				}
				
				//getCharBoundaries isn't giving me the expected results
				//hotfix: correcting odd sizing manually
				var scale:Number = 20;
				tightBounds.x *= scale;
				tightBounds.y *= scale;
				tightBounds.width *= scale;
				tightBounds.height *= scale;
				
				//center text
				var center:Point = new Point(tightBounds.x + tightBounds.width * .5, tightBounds.y + tightBounds.height * .5);
				labelTextField.x = widthUnits * .5 * OnScreenKeyboard.PIXELS_PER_UNIT - center.x;
				labelTextField.y = heightUnits * .5 * OnScreenKeyboard.PIXELS_PER_UNIT - center.y;
			}
			
			buttonMode = true;
			this.focusRect = false;
			//DisplayUtils.centerTextrecenterPivot(this);
			//scaleX = .5;
			//scaleY = .5;
		}
		
		public function get keyCode():uint 
		{
			return _keyCode;
		}
		
		public function get down():Boolean 
		{
			return _down;
		}
		
		public function set down(value:Boolean):void 
		{
			_down = value;
			updateScale();
		}
		
		public function get hover():Boolean 
		{
			return _hover;
		}
		
		public function set hover(value:Boolean):void 
		{
			_hover = value;
			updateScale();
		}
		
		public function get color():Color3D
		{
			return _color;
		}
		
		public function set color(value:Color3D):void 
		{
			_color = value;
			buttonBase.color = value;
		}
		
		private function updateScale():void 
		{
			var val:Number = OnScreenKeyboard.DEFAULT_SCALE;
			if (_hover) val *= OnScreenKeyboard.HOVER_SCALE;
			if (_down) val *= OnScreenKeyboard.DOWN_SCALE;
			scaleX = scaleY = val;
		}
	}
}
import com.bunnybones.color.Color3D;
import com.bunnybones.ui.keyboard.OnScreenKeyboard;
import flash.display.Shape;
import flash.events.Event;


class ButtonBase extends Shape {
	private var _color:Color3D;
	private var inset:Number;
	private var widthUnits:int;
	private var heightUnits:int;
	public function ButtonBase(widthUnits:int, heightUnits:int, color:Color3D)
	{
		this.heightUnits = heightUnits;
		this.widthUnits = widthUnits;
		this.color = color;
		inset = OnScreenKeyboard.INSET_IN_UNITS * OnScreenKeyboard.PIXELS_PER_UNIT;
		redraw();
	}
	
	private function onColorChange(e:Event):void 
	{
		redraw();
	}
	
	private function redraw():void 
	{
		graphics.clear();
		graphics.lineStyle(3, OnScreenKeyboard.BUTTONS_COLOR1);
		
		graphics.beginFill(color.hex, color.a/255);
		graphics.drawRoundRect(inset,
							   inset, 
							   widthUnits * OnScreenKeyboard.PIXELS_PER_UNIT - inset * 2,
							   heightUnits * OnScreenKeyboard.PIXELS_PER_UNIT - inset * 2,
							   OnScreenKeyboard.BUTTON_CORNER_RADIUS_IN_UNITS * OnScreenKeyboard.PIXELS_PER_UNIT);
		graphics.endFill();
	}
	
	public function get color():Color3D 
	{
		return _color;
	}
	
	public function set color(value:Color3D):void 
	{
		if (_color) _color.removeEventListener(Event.CHANGE, onColorChange);
		_color = value;
		if (_color) _color.addEventListener(Event.CHANGE, onColorChange);
	}
}