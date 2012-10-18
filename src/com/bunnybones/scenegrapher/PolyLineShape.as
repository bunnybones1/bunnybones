package com.bunnybones.scenegrapher 
{
	import com.bunnybones.IColored;
	import com.bunnybones.scenegrapher.tools.Selection;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class PolyLineShape extends Sprite implements IColored
	{
		private var _colorFill:uint = 0x777799;
		private var _colorLine:uint = 0x997755;
		private var _vertices:Vector.<VertexHandle> = new Vector.<VertexHandle>;
		private var dirty:Boolean = true;
		private var lastVert:VertexHandle;
		private var firstVert:VertexHandle;
		public function PolyLineShape() 
		{
			firstVert = newVertex(new Point(0, 0));
			firstVert.addEventListener(MouseEvent.CLICK, onClickFirstVertexHandle);
			newVertex(new Point(0, 0));
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			Selection.register(this);
			addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function newVertex(pos:Point):VertexHandle 
		{
			var vertexHandle:VertexHandle = new VertexHandle(pos);
			
			if(lastVert is VertexHandle) lastVert.removeEventListener(MouseEvent.CLICK, onClickLastVertexHandle);
			vertexHandle.addEventListener(MouseEvent.CLICK, onClickLastVertexHandle);
			
			lastVert = vertexHandle;
			_vertices.push(vertexHandle);
			addChildAt(vertexHandle,0);
			dirty = true;
			return vertexHandle;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (dirty) draw();
		}
		
		private function draw():void 
		{
			graphics.clear();
			graphics.lineStyle(6, _colorLine, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE);
			graphics.beginFill(colorFill, 1);
			graphics.moveTo(firstVert.x, firstVert.y);
			for (var i:int = 1; i < _vertices.length; i++)
			{
				var vert:VertexHandle = _vertices[i];
				graphics.lineTo(vert.x, vert.y);
			}
			graphics.endFill();
		}
		
		private function onClickFirstVertexHandle(e:MouseEvent):void 
		{
			var delta:Point = firstVert.pos.clone();
			delta = delta.subtract(firstVert.posOnMouseDown);
			if(delta.length < 5) dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onClickLastVertexHandle(e:MouseEvent):void 
		{
			newVertex(globalToLocal(new Point(e.stageX, e.stageY)));
		}
		
		private function onComplete(e:Event):void 
		{
			firstVert.removeEventListener(MouseEvent.CLICK, onClickFirstVertexHandle);
			lastVert.removeEventListener(MouseEvent.CLICK, onClickLastVertexHandle);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_vertices.pop();
			draw();
			while (numChildren > 0) removeChildAt(0);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			//trace(e.stageX, e.stageY);
			var pos:Point = globalToLocal(new Point(e.stageX, e.stageY));
			trace(pos);
			lastVert.pos.x = pos.x;
			lastVert.pos.y = pos.y;
			dirty = true;
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function get colorFill():uint 
		{
			return _colorFill;
		}
		
		public function set colorFill(value:uint):void 
		{
			_colorFill = value;
			dirty = true;
		}
		
		public function get colorLine():uint 
		{
			return _colorLine;
		}
		
		public function set colorLine(value:uint):void 
		{
			_colorLine = value;
			dirty = true;
		}
		
	}
}
import com.bunnybones.scenegrapher.SceneGrapherMain;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

class VertexHandle extends Sprite
{
	private var _pos:Point;
	private var _posOnMouseDown:Point;
	public function VertexHandle(pos:Point)
	{
		this.pos = pos;
		graphics.beginFill(Math.random() * 0xffffff);
		graphics.drawCircle(0, 0, 10);
		graphics.endFill();
		buttonMode = true;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onAddedToStage(e:Event):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	private function onMouseDown(e:MouseEvent):void 
	{
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		posOnMouseDown = pos.clone();
	}
	
	private function onMouseMove(e:MouseEvent):void 
	{
		var mousePos:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));
		pos.x = mousePos.x;
		pos.y = mousePos.y;
	}
	
	private function onMouseUp(e:MouseEvent):void 
	{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	private function onRemovedFromStage(e:Event):void 
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame(e:Event):void 
	{
		x = pos.x;
		y = pos.y;
		scaleX = scaleY = 1 / (parent.parent as SceneGrapherMain).transform.matrix.a;
	}
	
	public function get pos():Point 
	{
		return _pos;
	}
	
	public function set pos(value:Point):void 
	{
		_pos = value;
	}
	
	public function get posOnMouseDown():Point 
	{
		return _posOnMouseDown;
	}
	
	public function set posOnMouseDown(value:Point):void 
	{
		_posOnMouseDown = value;
	}
}