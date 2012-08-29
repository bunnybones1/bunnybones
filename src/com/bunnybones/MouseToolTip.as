package com.bunnybones 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class MouseToolTip 
	{
		static private var stage:Stage;
		static private var staticInitd:Boolean;
		static private var tips:Boolean;
		static private var container:Sprite;
		
		public function MouseToolTip() 
		{
			
		}
		
		static public function bind(stage:Stage):void 
		{
			staticInit();
			MouseToolTip.stage = stage;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			container = new Sprite();
			container.mouseChildren = false;
			container.mouseEnabled = false;
			stage.addChild(container);
		}
		
		static private function onMouseMove(e:MouseEvent):void 
		{
			container.x = e.stageX;
			container.y = e.stageY + 20;
		}
		
		static public function show(description:String):void 
		{
			container.alpha = 1;
			clear();
			var textfield:TextField = new TextField();
			textfield.background = true;
			textfield.text = description;
			textfield.autoSize = TextFieldAutoSize.LEFT;
			container.addChild(textfield);
		}
		
		static public function hide():void 
		{
			clear();
		}
		
		static public function notify(string:String):void 
		{
			show(string);
			TweenLite.to(container, 2, { delay:2, alpha:0 } );
		}
		
		static private function clear():void 
		{
			while (container.numChildren > 0) container.removeChildAt(0);
		}
		
		static private function staticInit():void 
		{
			if (staticInitd) return;
			staticInitd = true;
		}
		
	}

}