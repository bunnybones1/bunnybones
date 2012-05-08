package com.bunnybones.color.examples 
{
	import com.bunnybones.color.Color;
	import com.bunnybones.display.graphics.Circle;
	import com.bunnybones.display.MainSprite;
	import com.bunnybones.time.Clock;
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	
	public class ColorUtilsMain extends MainSprite 
	{
		static private const SPACING:Number = 50;
		static private const RADIUS:Number = 25;
		private var circle:Shape;
		private var color:Color;
		
		public function ColorUtilsMain() 
		{
			super();
		}
		override protected function init():void 
		{
			super.init();
			color = new Color(0xff0000);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			color.h++;
			if(circle) removeChild(circle);
			circle = Circle.newShape(RADIUS, color.hex);
			circle.x = 100;
			circle.y = 100;
			addChild(circle);
		}
	}

}