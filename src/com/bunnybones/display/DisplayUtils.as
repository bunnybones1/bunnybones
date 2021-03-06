package com.bunnybones.display
{
	import com.bunnybones.ui.keyboard.KeyButton;
	import com.greensock.motionPaths.RectanglePath2D;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class DisplayUtils
	{
		public function DisplayUtils()
		{
		}
		static public function centerText(textfield:TextField, desiredBounds:Rectangle):void
		{
			if (!textfield.stage) throw new Error("Textfield has no stage reference; Text metrics won't work until it does. Use this utility method after it's been added to stage.");
			var charBounds:Rectangle = textfield.getCharBoundaries(0);
			for (var i:int = 1; i < textfield.text.length; i++) {
				charBounds = charBounds.union(textfield.getCharBoundaries(i));
			}
			var textBounds:Rectangle = textfield.getBounds(textfield);
			var offset:Point = new Point(charBounds.x - textBounds.x, charBounds.y - textBounds.y);
			textfield.x = (-charBounds.width + desiredBounds.width) * .5 + desiredBounds.x;
			textfield.y = (-charBounds.height + desiredBounds.height) * .5 + desiredBounds.y;
		}
		
		static public function centerPivot(base:DisplayObjectContainer):void 
		{
			var bounds:Rectangle =  base.getBounds(base);
			var test:Sprite = base as Sprite;
			var offset:Point = new Point(bounds.width * .5, bounds.height * .5);
			for (var i:int = 0; i < base.numChildren; i++) 
			{
				var child:DisplayObject = base.getChildAt(i);
				child.x -= offset.x;
				child.y -= offset.y;
			}
			base.x += offset.x;
			base.y += offset.y;
		}
		
	}
}

