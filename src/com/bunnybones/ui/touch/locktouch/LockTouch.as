package com.bunnybones.ui.touch.locktouch 
{
	import com.bunnybones.console.Console;
	import com.bunnybones.display.graphics.Circle;
	import com.bunnybones.geom.MatrixUtils;
	import com.bunnybones.ui.touch.locktouch.LockTouch;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
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
		static private var cursorDecorA:Sprite;
		static private var cursorDecorB:Sprite;
		static private var cursorA:Sprite;
		static private var cursorB:Sprite;
		static private var anchorA:Sprite;
		static private var anchorB:Sprite;
		static private var stage:Stage;
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
			
			cursorDecorA = new Sprite();
			cursorA = new Sprite();
			
			cursorA.addChild(cursorDecorA);
			Circle.drawCircle(cursorDecorA.graphics, 50, 0x00ff00);
			cursorA.visible = false;
			stage.addChild(cursorA);
			
			cursorDecorB = new Sprite();
			cursorB = new Sprite();
			
			cursorB.addChild(cursorDecorB);
			Circle.drawCircle(cursorDecorB.graphics, 50, 0xff0000);
			cursorB.visible = false;
			stage.addChild(cursorB);
			
			anchorA = new Sprite();
			Circle.drawCircle(anchorA.graphics, 75, 0x0000ff, .25);
			anchorB = new Sprite();
			Circle.drawCircle(anchorB.graphics, 75, 0x0000ff, .25);
		}
		
		static private function onEnterFrame(e:Event):void 
		{
			updateViewMatrix();
		}
		
		static private function updateViewMatrix():void 
		{
			var cursor:Sprite;
			var anchor:Sprite;
			var matrix:Matrix;
			var matrixCursor:Matrix; 
			var matrixAnchor:Matrix;
			var alreadyDownCursorLock:Sprite = alreadyOneDown();
			if (alreadyDownCursorLock) cursor = alreadyDownCursorLock;
			else if (cursorA.visible) cursor = cursorA;
			
			//TODO transform view transform matrix to align any/all cursors
			//return;
			if (cursor)
			{
				anchor = cursor == cursorA ? anchorA : anchorB;
				matrix = view.transform.matrix.clone();
				var inverseViewMatrix:Matrix = matrix.clone();
				inverseViewMatrix.invert();
				var cursorViewCoord:Point = inverseViewMatrix.transformPoint(new Point(cursor.x, cursor.y));
				var anchorViewMatrix:Matrix = MatrixUtils.getMatrixDown(anchor, view);
				var anchorViewCoord:Point = anchorViewMatrix.transformPoint(new Point());
				var delta:Point = cursorViewCoord.subtract(anchorViewCoord);
				matrix.translate(delta.x, delta.y);
				//view.transform.matrix = matrix;
				if (!alreadyDownCursorLock)
				{
					if (anchor == anchorA)
					{
						anchor = anchorB;
						cursor = anchorB;
					}
					else 
					{
						anchor = anchorA
						cursor = anchorA;
					}
					//matrix = view.transform.matrix.clone();
					
					var inverseViewMatrix:Matrix = matrix.clone();
					inverseViewMatrix.invert();
					var cursorAViewCoord:Point = inverseViewMatrix.transformPoint(new Point(cursorA.x, cursorA.y));
					var cursorBViewCoord:Point = inverseViewMatrix.transformPoint(new Point(cursorB.x, cursorB.y));
					var anchorAViewMatrix:Matrix = MatrixUtils.getMatrixDown(anchorA, view);
					//var anchorAViewMatrix:Matrix = MatrixUtils.getMatrixUp(view, anchorA);
					var anchorBViewMatrix:Matrix = MatrixUtils.getMatrixDown(anchorB, view);
					//var anchorBViewMatrix:Matrix = MatrixUtils.getMatrixUp(view, anchorB);
					var anchorAViewCoord:Point = anchorAViewMatrix.transformPoint(new Point());
					var anchorBViewCoord:Point = anchorBViewMatrix.transformPoint(new Point());
					dtrace(anchorBViewCoord.x, anchorBViewCoord.y);
					dtrace(anchorB.x, anchorB.y);
					dtrace(cursorBViewCoord.x, cursorBViewCoord.y);
					var deltaCursors:Point = cursorAViewCoord.subtract(cursorBViewCoord);
					var deltaAnchors:Point = anchorAViewCoord.subtract(anchorBViewCoord);
					var angleAnchors:Number = Math.atan2(deltaAnchors.y, deltaAnchors.x);
					var angleCursors:Number = Math.atan2(deltaCursors.y, deltaCursors.x);
					var angleDelta:Number = angleAnchors - angleCursors;
					var deltaLengthRatio:Number = deltaAnchors.length / deltaCursors.length;
					
					//matrix.translate(-cursorAViewCoord.x, -cursorAViewCoord.y);
					matrix.rotate(-angleDelta);
					//matrix.translate(cursorAViewCoord.x, cursorAViewCoord.y);
					//Console.singleton.print(int((angleLocks / Math.PI / 2) * 360));
					//Console.singleton.print(int((angleCursors / Math.PI / 2) * 360));
					//dtrace(angleLocks);
					
					
				}
				view.transform.matrix = matrix;
			}
			//Console.singleton.print(view.transform.matrix);
		}
		
		static private function onTouchBegin(e:TouchEvent):void 
		{
			//establish which of A or B the touch is beginning with
			var cursor:Sprite;
			var alreadyDownCursor:Sprite = alreadyOneDown();
			if (alreadyDownCursor) cursor = getOtherCursor(alreadyDownCursor);
			else cursor = getClosestCursor(new Point(e.stageX, e.stageY));
			var anchor:Sprite = cursor === cursorA ? anchorA : anchorB;
			
			cursor.x = e.stageX;
			cursor.y = e.stageY;
			//the target which was just touched
			var target:DisplayObjectContainer = e.target as DisplayObjectContainer;
			if (target == stage)
			{
				var mView:Matrix = view.transform.matrix.clone();
				mView.invert();
				var viewCoord:Point = mView.transformPoint(new Point(e.localX, e.localY));
				anchor.x = viewCoord.x;
				anchor.y = viewCoord.y;
				target = view;
			}
			else
			{
				anchor.x = e.localX;
				anchor.y = e.localY;
			}
			target.addChild(anchor);
			cursor.visible = true;
		}
		
		static private function onTouchEnd(e:TouchEvent):void 
		{
			var cursor:Sprite;
			var alreadyDownCursorLock:Sprite = alreadyOneDown();
			if (alreadyDownCursorLock) cursor = alreadyDownCursorLock;
			else cursor = getClosestCursor(new Point(e.stageX, e.stageY));
			var lockAnchor:Sprite = cursor === cursorA ? anchorA : anchorB;
			cursor.visible = false;
			lockAnchor.parent.removeChild(lockAnchor);
		}
		
		static private function onTouchMove(e:TouchEvent):void 
		{
			var lockCursor:Sprite;
			var alreadyDownCursorLock:Sprite = alreadyOneDown();
			if (alreadyDownCursorLock) lockCursor = alreadyDownCursorLock;
			else lockCursor = getClosestCursor(new Point(e.stageX, e.stageY));
			lockCursor.x = e.stageX;
			lockCursor.y = e.stageY;
			var lockCursorDecor:Sprite = lockCursor == cursorA ? cursorDecorA : cursorDecorB;
			lockCursorDecor.scaleX = lockCursorDecor.scaleY = 1 + e.pressure * 3;
			//Console.singleton.print(e.pressure);
			updateViewMatrix();
		}
		
		static private function getClosestCursor(stageCoord:Point):Sprite 
		{
			var A:Point = new Point(cursorA.x, cursorA.y);
			var B:Point = new Point(cursorB.x, cursorB.y);
			var lenA:Number = A.subtract(stageCoord).length;
			var lenB:Number = B.subtract(stageCoord).length;
			
			if (lenA < lenB) return cursorA;
			else return cursorB;
		}
		
		static private function getOtherCursor(cursor:Sprite):Sprite
		{
			if (cursor == cursorA) return cursorB;
			else if (cursor == cursorB) return cursorA;
			return null;
		}
		
		static private function alreadyOneDown():Sprite 
		{
			if (cursorA.visible && !cursorB.visible) return cursorA;
			else if (!cursorA.visible && cursorB.visible) return cursorB;
			else return null;
		}
	}
}






