package com.bunnybones.ui.touch.locktouch 
{
	import com.bunnybones.console.Console;
	import com.bunnybones.display.graphics.Circle;
	import com.bunnybones.geom.MatrixUtils;
	import com.bunnybones.tag;
	import com.bunnybones.ui.touch.locktouch.LockTouch;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LockTouch 
	{
		static private var cursorA:LockCursor;
		static private var cursorB:LockCursor;
		static private var lockGraphicA:Shape;
		static private var lockGraphicB:Shape;
		static private var stage:Stage;
		static private var lastLiveAPosition:Point = new Point();
		static private var view:Sprite;
		
		public function LockTouch() 
		{
			
		}
		
		static public function bind(view:Sprite):void 
		{
			LockTouch.view = view;
			if (view.stage) init();
			else view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		static private function onAddedToStage(e:Event):void 
		{
			view.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		static private function init():void
		{
			LockTouch.stage = view.stage;
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			cursorA = new LockCursor(0x00ff00);
			cursorA.visible = false;
			view.addChild(cursorA);
			cursorB = new LockCursor(0xff0000);
			cursorB.visible = false;
			view.addChild(cursorB);
			lockGraphicA = new Shape();
			Circle.drawCircle(lockGraphicA.graphics, 75, 0x0000ff, .25);
			view.addChild(lockGraphicA);
			lockGraphicB = new Shape();
			Circle.drawCircle(lockGraphicB.graphics, 75, 0x0000ff, .25);
			view.addChild(lockGraphicB);
		}
		
		static private function onEnterFrame(e:Event):void 
		{
			keepCursorLive();
			updateViewMatrix();
		}
		
		static private function updateViewMatrix():void 
		{
			if (cursorA.visible) updateLockCursor(cursorA, lockGraphicA);
			if (cursorB.visible) updateLockCursor(cursorB, lockGraphicB);
			
			if (cursorB.visible)
			{
				var matrix:Matrix = view.transform.matrix.clone();
				//var deltaCursor:Matrix = MatrixUtils.getMatrixDown(cursorB, stage);
				//var deltaLock:Matrix = MatrixUtils.getMatrixDown(lockGraphicB, stage);
				var deltaCursor:Matrix = MatrixUtils.getMatrixUp(view, cursorB);
				var deltaLock:Matrix = MatrixUtils.getMatrixUp(view, lockGraphicB);
				
				deltaLock.invert();
				//Console.singleton.print(deltaCursor);
				//Console.singleton.print(deltaLock);
				deltaCursor.concat(deltaLock);
				//Console.singleton.print(delta);
				matrix.concat(deltaCursor);
				//matrix.invert();
				view.transform.matrix = matrix;
			}
		}
		
		static private function updateLockCursor(cursor:LockCursor, lockCursor:Shape):void
		{
			//var matrix:Matrix = MatrixUtils.getMatrixDown(cursor.lock.target, stage);
			var matrix:Matrix = MatrixUtils.getMatrixUp(view, cursor.lock.target);
			//matrix.invert();
			var lockedP:Point = matrix.transformPoint(new Point(cursor.lock.localX, cursor.lock.localY));
			lockCursor.x = lockedP.x;
			lockCursor.y = lockedP.y;
		}
		
		static private function onTouchBegin(e:TouchEvent):void 
		{
			var cursor:LockCursor;
			if (alreadyOneDown()) cursor = getOtherCursor(alreadyOneDown());
			else cursor = getClosestCursor(e.stageX, e.stageY);
			var lockGraphic:Shape = cursor === cursorA ? lockGraphicA : lockGraphicB;
			
			var curP:Point = projectCoord(e.stageX, e.stageY);
			cursor.x = curP.x;
			cursor.y = curP.y;
			//local doesnt work the way i thought it would. must be because of the stage matrix hacking
			//so lets do it manually
			
			cursor.setTarget(e.target as DisplayObject, e.localX, e.localY);
			Console.singleton.print(e.localX, e.localY);
			
			cursor.visible = lockGraphic.visible = true;
			updateCursors(e);
		}
		
		static private function onTouchEnd(e:TouchEvent):void 
		{
			var cursor:LockCursor;
			if (alreadyOneDown()) cursor = alreadyOneDown();
			else cursor = getClosestCursor(e.stageX, e.stageY);
			var lockGraphic:Shape = cursor === cursorA ? lockGraphicA : lockGraphicB;
			cursor.releaseTarget();
			cursor.visible = lockGraphic.visible = false;
			updateCursors(e);
		}
		
		static private function getClosestCursor(x:Number, y:Number):LockCursor 
		{
			var curP:Point = projectCoord(x, y);
			var A:Point = new Point(cursorA.x, cursorA.y);
			var B:Point = new Point(cursorB.x, cursorB.y);
			var lenA:Number = A.subtract(curP).length;
			var lenB:Number = B.subtract(curP).length;
			
			if (lenA < lenB) return cursorA;
			else return cursorB;
		}
		
		static private function projectCoord(stageX:Number, stageY:Number):Point
		{
			var inverseMatrix:Matrix = view.transform.matrix.clone();
			inverseMatrix.invert();
			var curP:Point = new Point(stageX, stageY);
			curP = inverseMatrix.transformPoint(curP);
			return curP;
		}
		
		static private function getOtherCursor(cursor:LockCursor):LockCursor
		{
			if (cursor == cursorA) return cursorB;
			else if (cursor == cursorB) return cursorA;
			return null;
		}
		
		static private function alreadyOneDown():LockCursor 
		{
			if (cursorA.visible && !cursorB.visible) return cursorA;
			else if (!cursorA.visible && cursorB.visible) return cursorB;
			else return null;
		}
		
		static private function onTouchMove(e:TouchEvent):void 
		{
			updateCursors(e);
		}
		
		static private function updateCursors(e:TouchEvent):void 
		{
			lastLiveAPosition.x = e.stageX;
			lastLiveAPosition.y = e.stageY;
			keepCursorLive();
			updateViewMatrix();
		}
		
		static private function keepCursorLive():void
		{
			var cursor:LockCursor = getClosestCursor(lastLiveAPosition.x, lastLiveAPosition.y);
			var curP:Point = projectCoord(lastLiveAPosition.x, lastLiveAPosition.y);
			cursor.x = curP.x;
			cursor.y = curP.y;
			
		}
	}
}






