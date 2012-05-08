package com.bunnybones.structures.linkedList 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Item 
	{
		protected var _next:Item;
		protected var _prev:Item;
		protected var _object:Object;
		
		public function Item(object:Object) 
		{
			this._object = object;
		}
		
		public function append(item:Item):void 
		{
			item.next = next;
			item.prev = this;
			next.prev = item;
			next = item;
		}
		
		public function remove():void
		{
			prev.next = next;
			next.prev = prev;
			prev = null;
			next = null;
		}
		
		public function get object():Object 
		{
			return _object;
		}
		
		public function get next():Item 
		{
			return _next;
		}
		
		public function set next(value:Item):void 
		{
			_next = value;
		}
		
		public function get prev():Item 
		{
			return _prev;
		}
		
		public function set prev(value:Item):void 
		{
			_prev = value;
		}
		
	}

}