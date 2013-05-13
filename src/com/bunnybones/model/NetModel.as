package com.bunnybones.model 
{
	import com.bunnybones.model.io.IModelIO;
	import com.bunnybones.model.io.ModelIONull;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class NetModel extends Model implements IEventDispatcher
	{
		static public var ioClass:Class;
		private var io:IModelIO;
		private var _url:String;
		private var dispatcher:EventDispatcher;
		private var initing:Boolean;
		public function NetModel(tagName:String=null) 
		{
			if (!ioClass ) ioClass = ModelIONull;
			io = new ioClass();
			super(tagName);
			dispatcher = new EventDispatcher(this);
		}
		
		public function save(url:String = null, includeFileNameAsNode:Boolean = false):void
		{
			if (!url) url = this.url;
			else this.url = url;
			//dtrace("save", url);
			var xml:XML = composeXML(true) 
			if (includeFileNameAsNode)
			{
				var fileNode:XML = <file />;
				fileNode.@name = url;
				xml.appendChild(fileNode);
			}
			io.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			io.addEventListener(Event.COMPLETE, onSaveComplete);
			io.save(xml, url);
		}
		
		private function onSaveComplete(e:Event):void 
		{
			dispatchEvent(e);
			deinitIOSave();
		}
		
		private function onSaveError(e:IOErrorEvent):void 
		{
			deinitIOSave();
			if (!initing) 
			{
				dispatchEvent(e);
			}
			else
			{
				dtrace("2:save failed, but continuing as if successful");
			}
		}
		
		private function deinitIOSave():void 
		{
			io.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			io.removeEventListener(Event.COMPLETE, onSaveComplete);
		}
		
		public function load(url:String = null):void
		{
			if (!url) url = this.url;
			else this.url = url;
			this.url = url;
			io.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			io.addEventListener(Event.COMPLETE, onLoadComplete);
			io.load(url);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			dtrace("0:" + url + " found and loaded");
			parseXML(new XML(io.data));
			deinitIOLoad();
			dispatchEvent(e);
		}
		
		private function onLoadError(e:IOErrorEvent):void 
		{
			dtrace("2:" + url + " not found; initializing");
			deinitIOLoad();
			if (initing) 
			{
				save();
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else throw(e);
		}
		
		private function deinitIOLoad():void 
		{
			io.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			io.removeEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		public function init(url:String):void 
		{
			this.url = url;
			initing = true;
			load(url);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReferences:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReferences);
		}
		
		public function dispatchEvent (event:Event) : Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener (type:String) : Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener (type:String, listener:Function, useCapture:Boolean = false) : void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger (type:String) : Boolean
		{
			return dispatcher.willTrigger(type);
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function set url(value:String):void 
		{
			_url = value;
		}
		
	}

}