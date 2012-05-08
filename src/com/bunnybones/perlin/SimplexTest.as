package com.bunnybones.perlin 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class SimplexTest extends Sprite 
	{
		static public const WIDTH:int = 64;
		static public const HEIGHT:int = 48;
		
		private var matrix:Matrix3D;
		private var mapData:BitmapData;
		private var map:Bitmap;
		private var zDepth:Number = 0;
		
		public function SimplexTest() 
		{
			Simplex.init();
			matrix = new Matrix3D();
			//matrix.appendScale(.05, .05, .05);
			//matrix.appendTranslation(10, 10, 10);
			//matrix.rotate(10);
			mapData = Simplex.bitmapData(WIDTH, HEIGHT, zDepth, matrix);
			map = new Bitmap(mapData);
			addChild(map);
			map.scaleX = map.scaleY = 10;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			//matrix.appendRotation(1, new Vector3D(1, 0, 0), new Vector3D(5, 5, 5));
			//matrix.appendTranslation(-.01, 0);
			matrix.identity();
			matrix.appendScale(.05, .05, .05);
			matrix.appendTranslation(0, 0, 1+Math.sin(new Date().time * .0005));
			//zDepth += .01;
			mapData = Simplex.bitmapData(WIDTH, HEIGHT, zDepth, matrix, 3);
			map.bitmapData = mapData;
			//trace("hi");
		}
	}

}