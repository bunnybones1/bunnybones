package com.bunnybones.scenegrapher.tools 
{
	import com.bunnybones.scenegrapher.tools.Selection;
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import flash.display.DisplayObject;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Destroyer 
	{
		static private var staticInitd:Boolean = false;
		
		public function Destroyer() 
		{
			
		}
		
		public static function staticInit():void
		{
			if (staticInitd) return;
			staticInitd = true;
			dtrace("Tool: Destroyer Initd");
			StageKeyBoard.bindKey("delete selected", Keyboard.DELETE, destroySelected);
			StageKeyBoard.bindKey("delete selected", Keyboard.BACKSPACE, destroySelected);
		}
		
		static public function destroySelected():void 
		{
			Selection.apply(destroy);
		}
		
		static public function destroy(object:DisplayObject):void 
		{
			object.parent.removeChild(object);
		}
	}

}