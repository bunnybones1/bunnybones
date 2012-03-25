package com.bunnybones.git
{
	import com.bunnybones.console.Console;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import com.bunnybones.tag;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Main extends Sprite 
	{
		private var console:Console;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			// entry point
			console = new Console(this);
			addChild(console);
			tag("WTF", stage);
		}
		
		public function hello(one:String = "herp", two:String = "derp"):String
		{
			return one + "%%" + two;
		}
		
	}
	
}