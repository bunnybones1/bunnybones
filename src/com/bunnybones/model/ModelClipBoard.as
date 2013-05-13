package com.bunnybones.model
{
	import com.jam3media.keyboard.StageKeyBoard;
	import flash.display.Stage;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class DataClipBoard 
	{
		public static var clipboard:Data;
		public function DataClipBoard() 
		{
			
		}
		
		public static function init():void
		{
			StageKeyBoard.bindKey(copy, Keyboard.C, true, true);
			StageKeyBoard.bindKey(paste, Keyboard.V, true, true);
		}
		
		static private function paste():void 
		{
			
		}
		
		static private function copy():void 
		{
			
		}
	}

}