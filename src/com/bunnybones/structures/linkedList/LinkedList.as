package com.bunnybones.structures.linkedList 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LinkedList 
	{
		protected var _first:Item;
		protected var _itemClass:Class = Item;
		
		public function LinkedList() 
		{
			
		}
		
		public function addItem(object:Object):void 
		{
			var item:Item = new _itemClass(object);
			if (!_first)
			{
				_first = item;
				_first.next = item;
				_first.prev = item;
			}
			else
			{
				_first.prev.append(item);
			}
		}
		
		public function collectObjects():Vector.<Object>
		{
			var collection:Vector.<Object> = new <Object>[_first.object];
			var cursor:Item = first.next;
			while (cursor != first)
			{
				collection.push(cursor.object);
				cursor = cursor.next;
			}
			return collection;
		}
		
		public function collectItems():Vector.<Item>
		{
			var collection:Vector.<Item> = new <Item>[_first];
			var cursor:Item = first.next;
			while (cursor != first)
			{
				collection.push(cursor);
				cursor = cursor.next;
			}
			return collection;
		}
		
		public function get first():Item 
		{
			return _first;
		}
		
		
	}

}
