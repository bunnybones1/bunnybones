package com.bunnybones.away3d.pano.tools 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	import away3d.containers.Scene3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;
	import com.bunnybones.color.Color;
	import com.bunnybones.away3d.pano.Layer;
	import com.bunnybones.color.Color3D;
	import com.bunnybones.ui.keyboard.KeyBinding;
	import com.bunnybones.ui.keyboard.KeyButton;
	import com.bunnybones.ui.keyboard.OnScreenKeyboard;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class Brush 
	{
		static public var layer:Layer;
		static public const BRUSHSIZE_PIXEL_SCALE:Number = 16;
		static public const BRUSHSIZE_STEP:Number = .1;
		static private var lastUV:Point = new Point();
		static private var cursor:Mesh;
		static private var _brushSize:Number = 1;
		static private var _pressure:Number = 1;
		static public var active:Boolean = true;
		static private var _brushColor:Color3D = new Color3D(0x456789);
		static private var brushAlpha:Number = .1;
		static private var cursorMaterial:ColorMaterial;
		
		public function Brush() 
		{
			
		}
		
		static public function bind(scene:Scene3D):void
		{
			Color3D.staticInit();
			StageKeyBoard.bindKey("Increase Brush Size", Keyboard.RIGHTBRACKET, increaseBrushSize);
			StageKeyBoard.bindKey("Decrease Brush Size", Keyboard.LEFTBRACKET, decreaseBrushSize);
			
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
			
			addAlphaSetKey("Alpha 10%", Keyboard.NUMBER_1, .1);
			addAlphaSetKey("Alpha 20%", Keyboard.NUMBER_2, .2);
			addAlphaSetKey("Alpha 30%", Keyboard.NUMBER_3, .3);
			addAlphaSetKey("Alpha 40%", Keyboard.NUMBER_4, .4);
			addAlphaSetKey("Alpha 50%", Keyboard.NUMBER_5, .5);
			addAlphaSetKey("Alpha 60%", Keyboard.NUMBER_6, .6);
			addAlphaSetKey("Alpha 70%", Keyboard.NUMBER_7, .7);
			addAlphaSetKey("Alpha 80%", Keyboard.NUMBER_8, .8);
			addAlphaSetKey("Alpha 80%", Keyboard.NUMBER_9, .9);
			addAlphaSetKey("Alpha 100%", Keyboard.NUMBER_0, 1);
			
			addAlphaAdjustKey("Increase Alpha", Keyboard.Y, .1);
			addAlphaAdjustKey("Decrease Alpha", Keyboard.T, -.1);
			
			
			var cursorShape:Shape = new Shape();
			cursorShape.graphics.beginFill(0xff0000);
			cursorShape.graphics.drawCircle(0, 0, 32);
			cursorShape.graphics.endFill();
			var cursorBitmapData:BitmapData = new BitmapData(128, 128, true, 0xffffffff);
			var m:Matrix = new Matrix();
			m.translate(64, 64);
			cursorBitmapData.draw(cursorShape, m);
			var cursorTexture:BitmapTexture = new BitmapTexture(cursorBitmapData);
			cursorMaterial = new ColorMaterial(0xffff0000);
			//var cursorMaterial:TextureMaterial = new TextureMaterial(cursorTexture);
			//cursorMaterial.alphaBlending = true;
			var cursorSphere:SphereGeometry = new SphereGeometry(10);
			cursor = new Mesh(cursorSphere, cursorMaterial);
			//cursor.visible = false;
			scene.addChild(cursor);
		}
		
		static private function addAlphaAdjustKey(label:String, keyCode:uint, amt:Number):void 
		{
			var tempFunc:Function = function ():void { brushAlpha += amt; };
			addAlphaFunctionKey(label, keyCode, tempFunc);
		}
		
		static private function addAlphaSetKey(label:String, keyCode:uint, amt:Number):void 
		{
			var tempFunc:Function = function ():void { brushAlpha = amt; };
			addAlphaFunctionKey(label, keyCode, tempFunc);
		}
		
		static private function addAlphaFunctionKey(label:String, keyCode:uint, funct:Function):void
		{
			StageKeyBoard.bindKey(label, keyCode, funct , null, false, false, false, false);
			if (StageKeyBoard.onScreenKeyboard) {
				var keyButton:KeyButton = StageKeyBoard.onScreenKeyboard.getKeyButtonByKeyCode(keyCode);
				keyButton.color = brushColor.giveBirth();
			}
		}
		
		static private function addColorKey(label:String, keyCode:uint, callbackOnDown:Function, colorMatrix:Matrix3D):void 
		{
			var keyBinding:KeyBinding = StageKeyBoard.bindKey(label, keyCode, callbackOnDown, null, false, false, false, true);
			if (StageKeyBoard.onScreenKeyboard) {
				var keyButton:KeyButton = StageKeyBoard.onScreenKeyboard.getKeyButtonByKeyCode(keyCode);
				
				keyButton.color = brushColor.giveBirth(colorMatrix);
				//keyButton.attachColorMatrix(this, colorMatrix);
			}
			
		}
		
		static public function decreaseRed():void 
		{
			brushColor.r -= 10;
		}
		
		static public function increaseRed():void 
		{
			brushColor.r += 10;
		}
		
		static public function decreaseGreen():void 
		{
			brushColor.g -= 10;
		}
		
		static public function increaseGreen():void 
		{
			brushColor.g += 10;
		}
		
		static public function decreaseBlue():void 
		{
			brushColor.b -= 10;
		}
		
		static public function increaseBlue():void 
		{
			brushColor.b += 10;
		}
		
		static public function decreaseAlpha():void 
		{
			brushAlpha = Math.max(0, brushAlpha - .02);
		}
		
		static public function increaseAlpha():void 
		{
			brushAlpha = Math.min(1, brushAlpha + .02);
		}
		
		//HSV
		
		static public function decreaseHue():void 
		{
			brushColor.rotateHue(-5);
		}
		
		static public function increaseHue():void 
		{
			brushColor.rotateHue(5);
		}
		
		static public function decreaseSaturation():void 
		{
			brushColor.saturate(-5);
		}
		
		static public function increaseSaturation():void 
		{
			brushColor.saturate(5);
		}
		
		static public function decreaseValue():void 
		{
			brushColor.brighten(-5);
		}
		
		static public function increaseValue():void 
		{
			brushColor.brighten(5);
		}
		//
		static public function initBrush(layer:Layer):void
		{
			if (Brush.layer)
			{
				Brush.layer.mouseEnabled = false;
				Brush.layer.removeEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDownSphere);
				Brush.layer.removeEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMoveCursor);
				//cursor.visible = false;
			}
			Brush.layer = layer;
			layer.scene.addChild(cursor);
			Brush.layer.mouseEnabled = true;
			Brush.layer.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDownSphere);
			Brush.layer.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMoveCursor);
			//cursor.visible = true
			cursor.scaleX = cursor.scaleY = cursor.scaleZ = Brush.layer.scaleX * _brushSize;
			//trace("cursor", cursor.scaleX, layer.scaleX);
		}
		
		static private function onMouseMoveCursor(e:MouseEvent3D):void 
		{
			cursor.moveTo(e.sceneX, e.sceneY, e.sceneZ);
		}
		
		static private function onMouseDownSphere(e:MouseEvent3D):void 
		{
			layer.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUpSphere);
			layer.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMoveSphere);
			lastUV = e.uv;
		}
		
		static private function onMouseUpSphere(e:MouseEvent3D):void 
		{
			layer.removeEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMoveSphere);
			layer.removeEventListener(MouseEvent3D.MOUSE_UP, onMouseUpSphere);
		}
		
		static private function onMouseMoveSphere(e:MouseEvent3D):void 
		{
			if (!active) return;
			var brushStroke:Shape = new Shape();
			brushStroke.graphics.lineStyle(pressure * brushSize * BRUSHSIZE_PIXEL_SCALE, brushColor.hex, brushAlpha);
			var deltaU:Number = lastUV.x - e.uv.x;
			//trace(deltaU);
			var direction:Number = deltaU > 0 ? 1 : -1;
			if (Math.abs(deltaU) > .5)
			{
				brushStroke.graphics.moveTo(lastUV.x * layer.texture.width, lastUV.y * layer.texture.height);
				brushStroke.graphics.lineTo((e.uv.x+direction) * layer.texture.width, e.uv.y * layer.texture.height);
				brushStroke.graphics.moveTo((lastUV.x-direction) * layer.texture.width, lastUV.y * layer.texture.height);
				brushStroke.graphics.lineTo(e.uv.x * layer.texture.width, e.uv.y * layer.texture.height);
			}
			else
			{
				brushStroke.graphics.moveTo(lastUV.x * layer.texture.width, lastUV.y * layer.texture.height);
				brushStroke.graphics.lineTo(e.uv.x * layer.texture.width, e.uv.y * layer.texture.height);
			}
			lastUV = e.uv;
			layer.texture.bitmapData.draw(brushStroke,null, null, null, null);
			layer.texture.invalidateContent();
		}
		
		static public function get brushSize():Number 
		{
			return _brushSize;
		}
		
		static public function set brushSize(value:Number):void 
		{
			_brushSize = value;
			cursor.scaleX = cursor.scaleY = cursor.scaleZ = value * layer.scaleX;
			dtag(_brushSize);
		}
		
		static public function get brushColor():Color3D
		{
			return _brushColor;
		}
		
		static public function set brushColor(value:Color3D):void 
		{
			if (_brushColor) _brushColor.removeEventListener(Event.CHANGE, onColorChange);
			_brushColor = value;
			if (_brushColor) _brushColor.addEventListener(Event.CHANGE, onColorChange);
		}
		
		static private function onColorChange(e:Event):void 
		{
			cursorMaterial.color = _brushColor.hex;
		}
		
		static public function get pressure():Number 
		{
			return _pressure;
		}
		
		static public function set pressure(value:Number):void 
		{
			_pressure = value;
		}
		
		static public function increaseBrushSize():void
		{
			brushSize = Math.max(1, brushSize + BRUSHSIZE_STEP);
		}
		
		static public function decreaseBrushSize():void
		{
			brushSize = Math.max(0, brushSize - BRUSHSIZE_STEP);
		}
		
	}

}