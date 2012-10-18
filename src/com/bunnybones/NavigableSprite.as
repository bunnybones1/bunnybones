package com.bunnybones 
{
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import com.bunnybones.NavigableSprite;
	import com.jam3media.fancyengine.display.lights.PointLight;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class NavigableSprite extends Sprite 
	{
		private var _lastMouseDownPosition:Point = new Point();
		private var _lastMouseMovePosition:Point = new Point();
		private var _lastMouseMoveDelta:Point = new Point();
		//local
		private var _lastMouseDownPositionLocal:Point = new Point();
		private var _lastMouseMovePositionLocal:Point = new Point();
		private var _lastMouseMoveDeltaLocal:Point = new Point();
		//global (screen)
		private var _lastScreenPosition:Point = new Point();
		private var _lastScreenDelta:Point = new Point();
		
		protected var _pan:Number = 0;
		protected var _tilt:Number = 0;
		
		public var useMode3D:Boolean;
		public var pivot3D:Sprite;
		private var relMatrix:Matrix3D;
		public var ratioOfScreenHeightToPivot3DAround:Number = .75;
		static public const SPEED_TILT:Number = .5;
		static public const SPEED_PAN:Number = .2;
		static public var singleton:NavigableSprite;
		
		public function NavigableSprite(useMode3D:Boolean = false) 
		{
			this.useMode3D = useMode3D;
			singleton = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		protected function init():void 
		{
			StageKeyBoard.bind(stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			StageKeyBoard.bindKey(Keyboard.EQUAL, zoomInStep, null, true, false, false, true);
			StageKeyBoard.bindKey(Keyboard.MINUS, zoomOutStep, null, true, false, false, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			if (useMode3D) 
			{
				relMatrix = new Matrix3D();
				parent.addChild(pivot3D = new Sprite());
				pivot3D.z = 0; //init 3D
				pivot3D.addChild(this);
				_tilt = 70;
				updateViewMatrix();
			}
		}
		
		private function zoomOutStep():void 
		{
			stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, false, false, lastMouseDownPositionLocal.x, lastMouseDownPositionLocal.y, null, false, false, false, false, -1));
		}
		
		private function zoomInStep():void 
		{
			stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, false, false, lastMouseDownPositionLocal.x, lastMouseDownPositionLocal.y, null, false, false, false, false, 1));
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			updateScreenPosition(e);
		}
		
		private function updateScreenPosition(e:MouseEvent):void 
		{
			_lastScreenDelta.x = e.stageX - _lastScreenPosition.x;
			_lastScreenDelta.y = e.stageY - _lastScreenPosition.y;
			_lastScreenPosition.x = e.stageX;
			_lastScreenPosition.y = e.stageY;
			
			var targetPosition:Point;
			if (useMode3D)
			{
				var globalVec:Vector3D = pivot3D.globalToLocal3D(_lastScreenPosition);
				targetPosition = new Point(globalVec.x, globalVec.y);
			}
			else
			{
				targetPosition = _lastScreenPosition;
			}

			lastMouseMoveDelta.x = targetPosition.x - lastMouseMovePosition.x;
			lastMouseMoveDelta.y = targetPosition.y - lastMouseMovePosition.y;
			lastMouseMovePosition.x = targetPosition.x;
			lastMouseMovePosition.y = targetPosition.y;
			var inverseMatrix:Matrix = transform.matrix.clone();
			inverseMatrix.invert();
			_lastMouseMovePositionLocal = inverseMatrix.transformPoint(lastMouseMovePosition);
			_lastMouseMoveDeltaLocal = inverseMatrix.deltaTransformPoint(lastMouseMoveDelta);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			updateScreenPosition(e);
			lastMouseDownPosition.x = _lastMouseMovePosition.x;
			lastMouseDownPosition.y = _lastMouseMovePosition.y;
			var inverseMatrix:Matrix = transform.matrix.clone();
			inverseMatrix.invert();
			_lastMouseDownPositionLocal = inverseMatrix.transformPoint(lastMouseDownPosition);
			if ((e.target is Stage && !e.ctrlKey) || StageKeyBoard.isDown(Keyboard.SPACE))
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onNavigationDrag);
				stage.addEventListener(MouseEvent.MOUSE_UP, onNavigationStop);
			}
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (e.ctrlKey && useMode3D)
			{
			}
			else
			{
				
				var matrix:Matrix = transform.matrix.clone();
				var direction:int = e.delta < 0 ? -1 : 1;
				var screenMousePos:Point = lastMouseMovePosition.clone();
				/*
				if (direction == -1)
				{
					screenMousePos.x = stage.stageWidth - screenMousePos.x;
					screenMousePos.y = stage.stageHeight - screenMousePos.y;
				}
				*/
				matrix.translate( -_lastMouseMovePosition.x,  -_lastMouseMovePosition.y);
				var scale:Number = 1 + e.delta * .05;
				matrix.scale(scale, scale);
				matrix.translate(_lastMouseMovePosition.x, _lastMouseMovePosition.y);
				transform.matrix = matrix;
			}
		}
		
		protected function updateViewMatrix():void 
		{
			var tx:Number = stage.stageWidth * .5;
			var ty:Number = stage.stageHeight * ratioOfScreenHeightToPivot3DAround;
			relMatrix.identity();
			relMatrix.appendTranslation(-tx, -ty, 0);
			relMatrix.appendRotation(_pan, Vector3D.Z_AXIS);
			relMatrix.appendRotation(-_tilt, Vector3D.X_AXIS);
			relMatrix.appendTranslation(tx, ty, 0);
			pivot3D.transform.matrix3D = relMatrix;
		}
		
		private function onNavigationDrag(e:MouseEvent):void 
		{
			if (StageKeyBoard.areDown([Keyboard.SPACE]))
			{
				var matrix:Matrix = transform.matrix.clone();
				matrix.translate(lastMouseMoveDelta.x, lastMouseMoveDelta.y);
				transform.matrix = matrix;
			}
			else if(useMode3D)
			{
				_tilt -= _lastScreenDelta.y * SPEED_TILT;
				_pan += _lastScreenDelta.x * SPEED_PAN;
				updateViewMatrix();
			}
			//trace("navigation drag");
		}
		
		private function onNavigationStop(e:MouseEvent):void 
		{
			//trace("navigation stop");
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onNavigationDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onNavigationStop);
		}
		
		public function get lastMouseDownPosition():Point 
		{
			return _lastMouseDownPosition;
		}
		
		public function get lastMouseMovePosition():Point 
		{
			return _lastMouseMovePosition;
		}
		
		public function get lastMouseMoveDelta():Point 
		{
			return _lastMouseMoveDelta;
		}
		
		public function get lastMouseDownPositionLocal():Point 
		{
			return _lastMouseDownPositionLocal;
		}
		
		public function get lastMouseMovePositionLocal():Point 
		{
			return _lastMouseMovePositionLocal;
		}
		
		public function get lastMouseMoveDeltaLocal():Point 
		{
			return _lastMouseMoveDeltaLocal;
		}
		
		static public function get stageMousePosition():Point 
		{
			return singleton.lastMouseMovePosition;
		}
		
	}

}