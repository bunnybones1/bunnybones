package com.bunnybones.ui.touch.locktouch 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Lock 
	{
		private var _target:DisplayObject;
		private var _localX:Number;
		private var _localY:Number;
		
		public function Lock(target:DisplayObject, localX:Number, localY:Number) 
		{
			_localY = localY;
			_localX = localX;
			_target = target;
			
		}
		
		public function release():void 
		{
			_target = null;
		}
		
		public function get target():DisplayObject 
		{
			return _target;
		}
		
		public function get localX():Number 
		{
			return _localX;
		}
		
		public function get localY():Number 
		{
			return _localY;
		}
		
	}

}