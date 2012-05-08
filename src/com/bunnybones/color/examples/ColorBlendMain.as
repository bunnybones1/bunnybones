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
	
	public class ColorBlendMain extends MainSprite 
	{
		static private const SPACING:Number = 50;
		static private const RADIUS:Number = 25;
		private var colors1:Vector.<Color>;
		private var colors2:Vector.<Color>;
		private var blendedShapes:Vector.<Shape> = new Vector.<Shape>;
		
		public function ColorBlendMain() 
		{
			super();
		}
		override protected function init():void 
		{
			super.init();
			Clock.init(stage);
			//commonly used temp vars
			var color:Color;
			var i:int;
			var j:int;
			
			
			var red1:Color = new Color(0xff0000); //same as 0x00ff0000
			var red2:Color = new Color(0xff0000, true); //same as 0x00ff0000
			var red3:Color = new Color(0xffff0000, true);
			var red4:Color = new Color(0x7fff0000, true);
			var red5:Color = new Color(0x9fff7f00, true);
			
			colors1 = new <Color>[red1, red2, red3, red4, red5];
			for (i = 0; i < colors1.length; i++) 
			{
				color = colors1[i];
				var circle:Shape = Circle.newShape(RADIUS, color.hexRGB, color.alpha);
				addChild(circle);
				circle.x = i * SPACING + SPACING * 2;
				circle.y = SPACING;
			}
			
			var blue1:Color = new Color(0x0000ff);
			var blue2:Color = new Color(0x0000ff, true);
			var blue3:Color = new Color(0xff0000ff, true);
			var blue4:Color = new Color(0x7f0000ff, true);
			var blue5:Color = new Color(0xff00ffff, true);
			
			colors2 = new <Color>[blue1, blue2, blue3, blue4, blue5];
			for (i = 0; i < colors2.length; i++) 
			{
				color = colors2[i];
				var circle:Shape = Circle.newShape(RADIUS, color.hexRGB, color.alpha);
				addChild(circle);
				circle.y = i * SPACING + SPACING * 2;
				circle.x = SPACING;
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			updateBlends();
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var amt:Number = Math.sin(Clock.time * .003);
			amt = amt * .5 + .5;
			updateBlends(amt);
		}
		
		private function updateBlends(amt:Number = .5):void 
		{
			while (blendedShapes.length > 0) removeChild(blendedShapes.pop());
			for (var i:int = 0; i < colors1.length; i++) 
			{
				for (var j:int = 0; j < colors2.length; j++) 
				{
					var color:Color = colors1[i].clone().blend(colors2[j], amt, true);
					//color = colors1[i].clone();
					var circle:Shape = Circle.newShape(RADIUS, color.hexRGB, color.alpha);
					blendedShapes.push(circle);
					addChild(circle);
					circle.x = i * SPACING + SPACING * 2;
					circle.y = j * SPACING + SPACING * 2;
				}
			}
		}
	}

}