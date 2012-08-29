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
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
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
		static public var pressure:Number = 0;
		static public var active:Boolean = true;
		static private var _brushColor:Color3D = new Color3D(0x456789);
		static private var brushAlpha:Number = .1;
		static private var cursorMaterial:ColorMaterial;
		
		public function Brush() 
		{
			
		}
		
		static public function bind(scene:Scene3D):void
		{
			StageKeyBoard.bindKey(Keyboard.RIGHTBRACKET, increaseBrushSize, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.LEFTBRACKET, decreaseBrushSize, null, false, false, false, true);
			
			StageKeyBoard.bindKey(Keyboard.W, increaseHue, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.Q, decreaseHue, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.S, increaseSaturation, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.A, decreaseSaturation, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.X, increaseValue, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.Z, decreaseValue, null, false, false, false, true);
			
			StageKeyBoard.bindKey(Keyboard.R, increaseRed, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.E, decreaseRed, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.F, increaseGreen, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.D, decreaseGreen, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.V, increaseBlue, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.C, decreaseBlue, null, false, false, false, true);
			
			StageKeyBoard.bindKey(Keyboard.NUMBER_1, function ():void { brushAlpha = .1;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.NUMBER_2, function ():void { brushAlpha = .2;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.NUMBER_3, function ():void { brushAlpha = .3;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.NUMBER_4, function ():void { brushAlpha = .4;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.NUMBER_5, function ():void { brushAlpha = .5;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.NUMBER_6, function ():void { brushAlpha = .6;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.NUMBER_7, function ():void { brushAlpha = .7;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.NUMBER_8, function ():void { brushAlpha = .8;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.NUMBER_9, function ():void { brushAlpha = .9;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.NUMBER_0, function ():void { brushAlpha = 1;}, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.Y, increaseAlpha, null, false, false, false, true);
			StageKeyBoard.bindKey(Keyboard.T, decreaseAlpha, null, false, false, false, true);
			var cursorShape:Shape = new Shape();
			cursorShape.graphics.beginFill(0xff0000);
			cursorShape.graphics.drawCircle(0, 0, 32);
			cursorShape.graphics.endFill();
			var cursorBitmapData:BitmapData = new BitmapData(128, 128, true, 0xff000000);
			var m:Matrix = new Matrix();
			m.translate(64, 64);
			cursorBitmapData.draw(cursorShape, m);
			var cursorTexture:BitmapTexture = new BitmapTexture(cursorBitmapData);
			cursorMaterial = new ColorMaterial(0xffff0000);
			//var cursorMaterial:TextureMaterial = new TextureMaterial(cursorTexture);
			//cursorMaterial.alphaBlending = true;
			var cursorSphere:SphereGeometry = new SphereGeometry(10);
			cursor = new Mesh(cursorSphere, cursorMaterial);
			cursor.visible = false;
			scene.addChild(cursor);
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
			brushColor.rotateHue(-1);
		}
		
		static public function increaseHue():void 
		{
			brushColor.rotateHue(1);
		}
		
		static public function decreaseSaturation():void 
		{
			brushColor.saturate(-1);
		}
		
		static public function increaseSaturation():void 
		{
			brushColor.saturate(1);
		}
		
		static public function decreaseValue():void 
		{
			brushColor.brighten(-1);
		}
		
		static public function increaseValue():void 
		{
			brushColor.brighten(1);
		}
		//
		static public function initBrush(layer:Layer):void
		{
			if (Brush.layer)
			{
				Brush.layer.mouseEnabled = false;
				Brush.layer.removeEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDownSphere);
				Brush.layer.removeEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMoveCursor);
				cursor.visible = false;
			}
			Brush.layer = layer;
			Brush.layer.mouseEnabled = true;
			Brush.layer.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDownSphere);
			Brush.layer.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMoveCursor);
			cursor.visible = true
			cursor.scaleX = cursor.scaleY = cursor.scaleZ = Brush.layer.scaleX * _brushSize;
			trace("cursor", cursor.scaleX, layer.scaleX);
		}
		
		static private function onMouseMoveCursor(e:MouseEvent3D):void 
		{
			cursor.moveTo(e.sceneX * .9, e.sceneY * .9, e.sceneZ * .9);
			cursorMaterial.color = brushColor.hex;
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
		}
		
		static public function get brushColor():Color3D
		{
			return _brushColor;
		}
		
		static public function set brushColor(value:Color3D):void 
		{
			_brushColor = value;
		}
		
		static public function increaseBrushSize():void
		{
			brushSize = Math.min(1, brushSize + BRUSHSIZE_STEP);
		}
		
		static public function decreaseBrushSize():void
		{
			brushSize = Math.max(0, brushSize - BRUSHSIZE_STEP);
		}
		
	}

}