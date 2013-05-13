package com.bunnybones.model.io 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ModelIOAir extends ModelIO implements IModelIO 
	{
		static public const FLASH_BIN:String = "flashBin";
		static public const MY_DOCUMENTS:String = "myDocuments";
		private var dataBuffer:String;
		static public var baseDir:String = FLASH_BIN;
		
		public function ModelIOAir() 
		{
			super();
		}
		
		override public function save(model:XML, url:String = null):void
		{
			dtrace("AIR save xml", url);
			var file:File = generateFileRef(url);
			var fileStream:FileStream = new FileStream();
			fileStream.openAsync(file, FileMode.WRITE);
			fileStream.writeUTFBytes(model.toXMLString());
			fileStream.close();
		}
		
		private function generateFileRef(url:String):File 
		{
			var file:File;
			if (baseDir == FLASH_BIN) {
				file = new File(File.applicationDirectory.resolvePath(url).nativePath);
			} else {
				file = File.documentsDirectory.resolvePath(url);
			}
			dtrace(file.nativePath);
			return file;
		}
		
		override public function load(url:String = null):void
		{
			this.url = url;
			_data = "";
			var file:File = generateFileRef(url);
			var fileStream:FileStream = new FileStream();
			fileStream.openAsync(file, FileMode.READ);
			fileStream.addEventListener(ProgressEvent.PROGRESS, onFileProgress);
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
			fileStream.addEventListener(Event.COMPLETE, onFileComplete);
			/*
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			*/
		}
		
		override protected function onLoadIOError(e:IOErrorEvent):void 
		{
			dispatchEvent(e);
		}
		
		private function onFileComplete(e:Event):void 
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onFileProgress(e:ProgressEvent):void 
		{
			var fileStream:FileStream = e.target as FileStream;
			_data += fileStream.readUTFBytes(fileStream.bytesAvailable);
			dtrace("progress: " + e.bytesLoaded / e.bytesTotal * 100 + "%");
		}
		
	}

}