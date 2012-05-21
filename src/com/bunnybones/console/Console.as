package com.bunnybones.console 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Console extends Sprite 
	{
		static public const MAXLINES:int = 500;
		private var _linesToDisplay:int = 0;
		private var lineHeight:int = 16;
		private var textFormat:TextFormat;
		private var textLines:Vector.<String> = new Vector.<String>;
		private var lines:Vector.<TextField> = new Vector.<TextField>;
		private var rootObject:Object;
		static private var _singleton:Console;
		public function Console(rootObject:Object) 
		{
			this.rootObject = rootObject;
			textFormat = new TextFormat("courier new", 10, 0xffffff);
			_singleton = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			parent.addEventListener(Event.ADDED, onAdded);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownConsole);
			stage.addEventListener(Event.RESIZE, onResizeStage);
			linesToDisplay = 10;
			//var result:Task = Task.parse("hello(\"one\", hello(\"wonderful\", hello()))") as Task;
			//tag(result.execute(rootObject));
			
			dtrace("Console initialized");
		}
		
		private function onAdded(e:Event):void 
		{
			parent.addChild(this);
		}
		
		private function onMouseDownConsole(e:MouseEvent):void 
		{
			stage.focus = lines[0];
		}
		
		private function onResizeStage(e:Event):void 
		{
			for each(var line:TextField in lines)
			{
				line.width = stage.stageWidth;
			}
		}
		
		public function get linesToDisplay():int 
		{
			return _linesToDisplay;
		}
		
		public function set linesToDisplay(value:int):void 
		{
			var difference:int = value - _linesToDisplay;
			while (difference > 0)
			{
				var line:TextField = new TextField();
				line.defaultTextFormat = textFormat;
				line.background = true;
				line.backgroundColor = 0x000000;
				line.multiline = false;
				line.width = stage.stageWidth;
				line.height = lineHeight;
				lines.push(line);
				line.y = lines.length * -lineHeight;
				if (lines.length == 1)
				{
					line.type = TextFieldType.INPUT;
					line.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				}
				else
				{
					line.type =  TextFieldType.DYNAMIC;
				}
				addChild(line);
				difference--;
			}
			
			while(difference < 0)
			{
				removeChild(lines.pop());
				difference++;
			}
			_linesToDisplay = value;
			y = _linesToDisplay * lineHeight;
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
					parseInput(e.target.text);
					addLine(e.target.text);
					e.target.text = "";
					break;
			}
		}
		
		private function parseInput(input:String):void 
		{
			var something:Object = Task.parse(input);
			if (something is Task) dtrace((something as Task).execute(rootObject));
			if (something is ObjectReference) dtrace((something as ObjectReference).resolve(rootObject));
		}
		
		public function addLine(str:String):void
		{
			//tag(rootObject[str]);
			textLines.unshift(str);
			if (textLines.length > MAXLINES) textLines.pop();
			for (var i:int = 1; i < lines.length; i++) 
			{
				var line:TextField = lines[i];
				if (i-1 < textLines.length) line.text = textLines[i - 1];
				else return;
			}
		}
		
		public function print(...rest):void
		{
			addLine(String(rest));
		}
		
		public function toggle():void 
		{
			visible = !visible;
		}
		
		static public function get singleton():Console 
		{
			return _singleton;
		}
		
	}

}