package com.bunnybones 
{
	import com.jam3media.utils.StringUtils;
	import flash.events.Event;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class DialogFileName extends Dialog 
	{
		
		public function DialogFileName(path:String = "") 
		{
			super("use dialogBox");
			text.editable = false;
			text.selectable = false;
			var file:File = File.applicationDirectory;
			file = file.resolvePath(path);
			file.addEventListener(Event.SELECT, onSelect);
			file.addEventListener(Event.CANCEL, onCancel);
			file.browseForOpen("open particle field file");
			
		}
		
		private function onCancel(e:Event):void 
		{
			var file:File = e.target as File;
			deinitFile(file);
		}
		
		private function onSelect(e:Event):void 
		{
			var file:File = e.target as File;
			var path:String = file.nativePath.substring(File.applicationDirectory.nativePath.length + 1, file.nativePath.length);
			path = StringUtils.replaceAll(path, "\\", "/");
			text.text = path;
			//text.text = File.applicationDirectory.nativePath;
			dispatchEvent(new Event(Event.COMPLETE));
			deinitFile(file);
		}
		
		private function deinitFile(file:File):void 
		{
			file.removeEventListener(Event.SELECT, onSelect);
			file.removeEventListener(Event.CANCEL, onCancel);
			deinit();
		}
		
	}

}