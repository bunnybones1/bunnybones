package com.bunnybones 
{
	import com.bit101.components.Text;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Dialog extends Sprite
	{
		static private const TEXTWIDTH:Number = 200;
		static private const TEXTWIDTHHALF:Number = TEXTWIDTH * .5;
		static private const TEXTHEIGHT:Number = 20;
		static private const TEXTHEIGHTHALF:Number = TEXTHEIGHT * .5;
		protected var text:Text;
		
		public function Dialog(defaultText:String = "lol") 
		{
			text = new Text(this, -TEXTWIDTHHALF, -TEXTHEIGHTHALF);
			text.width = TEXTWIDTH;
			text.height = TEXTHEIGHT;
			text.text = defaultText;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
			StageKeyBoard.bind(stage);
			StageKeyBoard.bindKey(Keyboard.ESCAPE, onKeyDownEscape);
			StageKeyBoard.bindKey(Keyboard.ENTER, onKeyDownEnter);
			stage.focus = text.textField;
			onResize(null);
		}
		
		private function onResize(e:Event):void 
		{
			x = stage.stageWidth * .5;
			y = stage.stageHeight * .5;
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			StageKeyBoard.releaseKey(onKeyDownEscape, Keyboard.ESCAPE);
			StageKeyBoard.releaseKey(onKeyDownEnter, Keyboard.ENTER);
		}
		
		private function onKeyDownEnter():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			deinit();
		}
		
		private function onKeyDownEscape():void
		{
			dispatchEvent(new Event(Event.CANCEL));
			deinit();
		}
		
		protected function deinit():void 
		{
			stage.focus = stage;
			parent.removeChild(this);
		}
		
		public function get value():String
		{
			return text.text;
		}
	}

}