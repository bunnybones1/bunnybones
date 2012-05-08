package com.bunnybones.ui.keyboard.examples 
{
	import com.bunnybones.display.MainSprite;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class StageKeyboardMain extends MainSprite
	{
		
		public function StageKeyboardMain() 
		{
			super();
		}
		
		override protected function init():void 
		{
			super.init();
			StageKeyBoard.bind(stage);
			//standard binding reacts like typing, repeat is delayed
			StageKeyBoard.bindKey(Keyboard.NUMBER_1, testDown, testUp);
			//instantRepeat binding repeats instantly, better for games
			StageKeyBoard.bindKey(Keyboard.NUMBER_2, testDown, testUp, false, false, false, true);
		}
		
		private function testDown():void 
		{
			dtrace("DOWN");
		}
		
		private function testUp():void 
		{
			dtrace("UP");
		}
	}

}