package com.bunnybones.scenegrapher.tools 
{
	import com.bunnybones.IColored;
	import com.bunnybones.NavigableSprite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ColorPicker extends Sprite 
	{
		static private var stage:Stage;
		static private var staticInitd:Boolean = false;
		static private var currentColor:uint;
		static private const stageMargin:Number = 80;
		static private var colorTarget:Function;
		
		public function ColorPicker() 
		{
		}
		
		public static function bind(stage:Stage):void
		{
			staticInit();
			ColorPicker.stage = stage;
		}
		
		public static function staticInit():void
		{
			if (staticInitd) return;
			staticInitd = true;
			trace("Tool: ColorPicker Initd");
			bindKeys();
		}
		
		static private function bindKeys():void 
		{
			StageKeyBoard.bindKey(Keyboard.B, colorLineDialog, null, true);
			StageKeyBoard.bindKey(Keyboard.B, colorFillDialog, null, true, true);
		}
		
		static private function releaseKeys():void 
		{
			StageKeyBoard.releaseKey(colorLineDialog, Keyboard.B, true);
			StageKeyBoard.releaseKey(colorFillDialog, Keyboard.B, true, true);
		}
		
		static private function colorFillDialog():void 
		{
			colorTarget = colorFillTarget;
			colorDialog();
		}
		
		static private function colorLineDialog():void 
		{
			colorTarget = colorLineTarget;
			colorDialog();
		}
		
		static private function colorDialog():void 
		{
			var dialog:ColorSwatchDialog = new ColorSwatchDialog();
			dialog.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageColorSwatchDialog);
			stage.addChild(dialog);
			dialog.x = Math.max(stageMargin, Math.min(stage.stageWidth - stageMargin, NavigableSprite.stageMousePosition.x));
			dialog.y = Math.max(stageMargin, Math.min(stage.stageHeight - stageMargin, NavigableSprite.stageMousePosition.y));
			releaseKeys();
		}
		
		static private function onRemovedFromStageColorSwatchDialog(e:Event):void 
		{
			(e.target as ColorSwatchDialog).removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageColorSwatchDialog);
			bindKeys();
		}
		
		static public function colorSelected(color:uint):void 
		{
			currentColor = color;
			Selection.apply(colorTarget);
		}
		
		public static function colorLineTarget(target:IColored):void
		{
			target.colorLine = currentColor;
		}
		public static function colorFillTarget(target:IColored):void
		{
			target.colorFill = currentColor;
		}
	}

}
import Box2D.Common.b2Color;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import com.bunnybones.ui.keyboard.StageKeyBoard;
import com.bunnybones.scenegrapher.tools.ColorPicker;

class ColorSwatchDialog extends Sprite
{
	static public const SWATCH_RADIUS:Number = 16;
	private const THIRD_OF_CIRCLE:Number = Math.PI * 2 / 3;

	
	public function ColorSwatchDialog()
	{
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onAddedToStage(e:Event):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.addEventListener(Event.RESIZE, onResizeStage);
		//onResizeStage(null);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		StageKeyBoard.bindKey(Keyboard.ESCAPE, cancel);
		
		var hex:HexColorSwatch = new HexColorSwatch(0);
		hex.addEventListener(MouseEvent.CLICK, onMouseClickSwatch);
		addChild(hex);
		createRingOfSwatches(.5, .25, .15, 1.75);
		createRingOfSwatches(1, 1, .5, 3.05);
		createRingOfSwatches(.5, 1, .5, 3.5);
	}
	
	private function createRingOfSwatches(angleOffset:Number, colorScale:Number, colorOffset:Number, placementRadiusScale:Number):void
	{
		var angle:Number;
		var color:b2Color;
		var hex:HexColorSwatch;
		for (var i:int = 0; i < 6; i++)
		{
			angle = Math.PI * 2 * ((i + angleOffset) / 6);
			color = new b2Color(Math.sin(angle)*colorScale+colorOffset, Math.sin(angle + THIRD_OF_CIRCLE)*colorScale+colorOffset, Math.sin(angle + THIRD_OF_CIRCLE*2)*colorScale+colorOffset);
			hex = new HexColorSwatch(color.color);
			hex.addEventListener(MouseEvent.CLICK, onMouseClickSwatch);
			addChild(hex);
			hex.x = Math.cos(angle) * SWATCH_RADIUS * placementRadiusScale;
			hex.y = Math.sin(angle) * SWATCH_RADIUS * placementRadiusScale;
		}
	}
	
	private function onMouseClickSwatch(e:MouseEvent):void 
	{
		var hex:HexColorSwatch = e.target as HexColorSwatch;
		ColorPicker.colorSelected(hex.color);
		destroy();
	}
	
	private function cancel():void 
	{
		destroy();
	}
	
	private function destroy():void
	{
		StageKeyBoard.releaseKey(cancel, Keyboard.ESCAPE);
		stage.removeEventListener(Event.RESIZE, onResizeStage);
		while (numChildren > 0)
		{
			(removeChildAt(0) as HexColorSwatch).removeEventListener(MouseEvent.CLICK, onMouseClickSwatch);
		}
		parent.removeChild(this);
	}
	
	private function onResizeStage(e:Event):void 
	{
		x = stage.stageWidth * .5;
		y = stage.stageHeight * .5;
	}
	
	private function onRemovedFromStage(e:Event):void 
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}
}

class HexColorSwatch extends Sprite
{
	private var _color:uint;
	public function HexColorSwatch(color:uint)
	{
		_color = color;
		var angle:Number;
		var x:Number;
		var y:Number;
		graphics.beginFill(color);
		for (var i:int = 0; i <= 6; i++)
		{
			angle = Math.PI * 2 * (i / 6);
			x = Math.cos(angle) * ColorSwatchDialog.SWATCH_RADIUS;
			y = Math.sin(angle) * ColorSwatchDialog.SWATCH_RADIUS;
			if (i == 0) graphics.moveTo(x, y);
			else graphics.lineTo(x, y);
		}
		graphics.endFill();
		buttonMode = true;
	}
	
	public function get color():uint 
	{
		return _color;
	}
}
