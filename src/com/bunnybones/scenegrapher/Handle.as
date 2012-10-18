package com.bunnybones.scenegrapher 
{
	import com.bunnybones.IColored;
	import com.jam3media.display.animation.AnimatedSprite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import com.bunnybones.scenegrapher.tools.Selection;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Handle extends AnimatedSprite implements IColored
	{
		
		static public const DOUBLE_CLICK_DURATION:Number = 200;
		static private var idCounter:int = 0;
		private var lastClickTime:Number = 0;
		protected var _id:int;
		protected var _colorFill:uint = 0x222222;
		protected var _colorLine:uint = 0x222222;
		protected var _contentType:String = ContentType.UNKNOWN;
		protected var _description:String = "description";

		public function Handle(id:int = -1) 
		{
			buttonMode = true;
			Selection.register(this);
			if (id < 0)
			{
				_id = idCounter;
				idCounter++;
			}
			else
			{
				_id = id;
				idCounter = Math.max(idCounter + 1, id);
			}
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onClick(e:MouseEvent):void 
		{
			if ((new Date()).time - lastClickTime < DOUBLE_CLICK_DURATION)
			{
				trace("DOUBLE CLICK");
				dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK, true, false, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta));
			}
			lastClickTime = (new Date()).time;
		}
		
		public function initRename():void 
		{
		}
		
		protected function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			delete (parent as SceneGrapherMain).handlesByID[_id];
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get colorFill():uint 
		{
			return _colorFill;
		}
		
		public function set colorFill(value:uint):void 
		{
			_colorFill = value;
		}
		
		public function get colorLine():uint 
		{
			return _colorLine;
		}
		
		public function set colorLine(value:uint):void 
		{
			_colorLine = value;
		}
		
		public function get description():String 
		{
			return _description;
		}
		
		public function set description(value:String):void 
		{
			_description = value;
		}
		
		public function get contentType():String 
		{
			
			return _contentType;
		}
		
		public function set contentType(value:String):void 
		{
			_contentType = value;
		}
	}

}