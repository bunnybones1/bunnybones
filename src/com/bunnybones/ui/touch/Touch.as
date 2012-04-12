package com.bunnybones.ui.touch 
{
	import com.bunnybones.display.graphics.Circle;
	import flash.display.Stage;
	import com.bunnybones.ui.touch.locktouch.LockTouch;
	import flash.desktop.NativeApplication;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.PressAndTapGestureEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import com.bunnybones.ui.touch.Touch;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Touch 
	{
		static private var cursor:Shape;
		static private var stage:Stage;
		
		public function Touch() 
		{
			
		}
		
		static public function bind(stage:Stage):void 
		{
			Touch.stage = stage;
			stage.addEventListener(TransformGestureEvent.GESTURE_PAN, onPan);
			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, onRotate);
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
			stage.addEventListener(PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP, onPressAndTap);
			cursor = Circle.newShape(50, 0xff0000, .5);
			stage.addChild(cursor);
		}
		static private function onPan(e:TransformGestureEvent):void 
		{
			trace("pan", e.offsetX, e.offsetY);
			var matrix:Matrix = stage.transform.matrix.clone();
			matrix.translate(e.offsetX, e.offsetY);
			stage.transform.matrix = matrix;
			updateCursor(e);
		}
		
		static private function onRotate(e:TransformGestureEvent):void 
		{
			trace("rotate", e.rotation, e.stageX, e.stageY);
			var matrix:Matrix = stage.transform.matrix.clone();
			matrix.translate(-e.stageX, -e.stageY);
			matrix.rotate(e.rotation / 180 * Math.PI);
			matrix.translate(e.stageX, e.stageY);
			stage.transform.matrix = matrix;
			updateCursor(e);
		}
		
		static private function onSwipe(e:TransformGestureEvent):void 
		{
			trace("swipe");
		}
		
		static private function onZoom(e:TransformGestureEvent):void 
		{
			trace("zoom", e.scaleX, e.stageX, e.stageY);
			var matrix:Matrix = stage.transform.matrix.clone();
			matrix.translate(-e.stageX, -e.stageY);
			matrix.scale(e.scaleX, e.scaleY);
			matrix.translate(e.stageX, e.stageY);
			stage.transform.matrix = matrix;
			updateCursor(e);
		}
		
		static private function onPressAndTap(e:PressAndTapGestureEvent):void 
		{
			trace("press and tap");
		}
		
		static private function updateCursor(e:TransformGestureEvent):void 
		{
			var inverseMatrix:Matrix = stage.transform.matrix.clone();
			inverseMatrix.invert();
			cursor.transform.matrix = inverseMatrix;
			var curP:Point = new Point(e.stageX, e.stageY);
			curP = inverseMatrix.transformPoint(curP);
			
			cursor.x = curP.x;
			cursor.y = curP.y;
			//cursor.x = e.localX;
			//cursor.y = e.localY;
		}
		
	}

}