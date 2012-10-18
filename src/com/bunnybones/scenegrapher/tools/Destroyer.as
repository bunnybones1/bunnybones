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
			trace("Tool: Destroyer Initd");
			StageKeyBoard.bindKey(Keyboard.DELETE, destroySelected);
			StageKeyBoard.bindKey(Keyboard.BACKSPACE, destroySelected);
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