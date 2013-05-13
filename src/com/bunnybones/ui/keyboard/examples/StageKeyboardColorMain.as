package com.bunnybones.ui.keyboard.examples 
{
	import com.bunnybones.display.MainSprite;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.ui.keyboard.StageKeyboardColor;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class StageKeyboardColorMain extends MainSprite 
	{
		
		public function StageKeyboardColorMain() 
		{
			super();
		}
		
		override protected function init():void 
		{
			super.init();
			StageKeyBoard.bind(stage, true);
			StageKeyboardColor.enable();
		}
	}

}