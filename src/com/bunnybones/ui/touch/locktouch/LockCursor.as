package com.bunnybones.ui.touch.locktouch 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import com.bunnybones.display.graphics.Circle;
	import flash.display.Stage;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LockCursor extends Shape 
	{
		private var _lock:Lock;
		
		public function LockCursor(color:uint) 
		{
			Circle.drawCircle(graphics, 50, color, .5);
		}
		
		public function setTarget(target:DisplayObject, localX:Number, localY:Number):void 
		{
			_lock = new Lock(target, localX, localY);
		}
		
		public function releaseTarget():void
		{
			_lock.release();
			_lock = null;
		}
		
		public function get lock():Lock 
		{
			return _lock;
		}
		
	}

}