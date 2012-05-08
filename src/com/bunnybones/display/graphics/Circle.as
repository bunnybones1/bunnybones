package com.bunnybones.display.graphics 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Circle 
	{
		
		public function Circle()
		{
			
		}
		
		static public function drawCircle(graphics:Graphics, radius:Number = 20, color:uint = 0xff0000, alpha:Number = .5, x:Number = 0, y:Number = 0):void 
		{
			graphics.beginFill(color, alpha);
			graphics.drawCircle(x, y, radius);
			graphics.endFill();
		}
		
		static public function newShape(radius:Number = 50, color:uint = 0xff0000, alpha:Number = .5):Shape
		{
			var circle:Shape = new Shape();
			drawCircle(circle.graphics, radius, color, alpha);
			return circle;
		}
		
		static public function drawHoop(graphics:Graphics, radiusOuter:Number = 20, radiusInner:Number = 10, color:uint = 0xff0000, alpha:Number = .5, x:Number = 0, y:Number = 0):void 
		{
			trace(color.toString(16), alpha);
			graphics.beginFill(color, alpha);
			graphics.drawCircle(x, y, radiusOuter);
			graphics.drawCircle(x, y, radiusInner);
			graphics.endFill();
		}
	}
}