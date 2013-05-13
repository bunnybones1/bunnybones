package com.bunnybones.scenegrapher.tools 
{
	import com.bunnybones.ui.keyboard.StageKeyBoard;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Selection 
	{
		static private var _selection:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		static private var _selectable:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		static private var staticInitd:Boolean = false;
		static public var outlineSelection:Boolean = true;
		public function Selection() 
		{
		}
		
		static private function staticInit():void
		{
			if (staticInitd) return;
			staticInitd = true;
			trace("Tool: Selection Initd");
			StageKeyBoard.bindKey("select all", Keyboard.A, selectAll, null, true, false, false);
			StageKeyBoard.bindKey("deselect all", Keyboard.A, deselectAll, null, true, true, false);
		}
		
		static public function select(object:DisplayObject):void
		{
			if (!isSelected(object)) _select(object);
		}
		
		static private function _select(object:DisplayObject):void
		{
			_selection.push(object);
			if(outlineSelection) object.filters = [new GlowFilter(0xffff00, 1, 4, 4, 100, 1)];
		}
		
		static public function deselect(object:DisplayObject):void
		{
			if (isSelected(object)) _deselect(object);
		}
		
		static private function _deselect(object:DisplayObject):void
		{
			for (var i:int = _selection.length - 1; i >= 0; i--)
			{
				if (_selection[i] == object)
				{
					_selection.splice(i, 1);
				}
			}
			if(outlineSelection) object.filters = [];
		}
		
		static public function deselectAll():void
		{
			for (var i:int = _selection.length - 1; i >= 0; i--)
			{
				var object:Object = _selection.pop();
				if(outlineSelection) object.filters = [];
			}
		}
		
		static public function selectAll():void
		{
			deselectAll();
			for each(var obj:DisplayObject in _selectable)
			{
				_select(obj);
			}
			//trace(_selection);
		}
		
		static public function toggle(object:DisplayObject):void 
		{
			if (isSelected(object)) _deselect(object);
			else _select(object);
		}
		
		static public function isSelected(object:Object):Boolean
		{
			for each(var obj:Object in _selection)
			{
				if (obj == object) return true;
			}
			return false;
		}
		
		static public function apply(func:Function):void
		{
			for (var i:int = _selection.length - 1; i >= 0; i--)
			{
				func(_selection[i]);
			}
		}
		
		static public function register(object:DisplayObject):void
		{
			staticInit();
			//trace("registering", object);
			object.addEventListener(MouseEvent.CLICK, onClick);
			object.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_selectable.push(object);
		}
		
		static private function onRemovedFromStage(e:Event):void 
		{
			var object:DisplayObject = e.target as DisplayObject;
			object.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			unregister(object);
		}
		
		static private function onClick(e:MouseEvent):void 
		{
			var object:DisplayObject = e.target as DisplayObject;
			while (!isSelectable(object) && object.parent)
			{
				object = object.parent;
			}
			if (!isSelectable(object)) return;
			if (!e.shiftKey)
			{
				deselectAll();
				_select(object);
			}
			else
			{
				toggle(object);
			}
		}
		
		static public function isSelectable(object:DisplayObject):Boolean
		{
			for each(var obj:DisplayObject in _selectable)
			{
				if (obj == object) return true;
			}
			return false;
		}
		
		static public function unregister(object:DisplayObject):void
		{
			deselect(object);
			//trace("unregistering", object);
			
			for (var i:int = _selectable.length - 1; i >= 0; i--)
			{
				if (_selectable[i] == object)
				{
					_selectable.splice(i, 1);
				}
			}
		}
		
	}

}