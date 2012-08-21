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
		static public const SAVE:String = "save";
		static public const OPEN:String = "open";
		
		public function DialogFileName(type:String = OPEN, path:String = "", description:String = "open particle field file") 
		{
			super("use dialogBox");
			text.editable = false;
			text.selectable = false;
			var file:File = File.applicationDirectory;
			file = file.resolvePath(path);
			file.addEventListener(Event.SELECT, onSelect);
			file.addEventListener(Event.CANCEL, onCancel);
			switch (type) 
			{
				case SAVE:
					file.browseForSave(description);
				break;
				case OPEN:
					file.browseForOpen(description);
				break;
				default:
					throw new Error(type + "is not a valid type of file dialog");
			}
		}
		
		private function onCancel(e:Event):void 
		{
			var file:File = e.target as File;
			deinitFile(file);
		}
		
		private function onSelect(e:Event):void 
		{
			var file:File = e.target as File;
			var appPath:String = File.applicationDirectory.nativePath;
			var path:String;
			if (file.nativePath.indexOf(appPath) != -1)
				path = file.nativePath.substring(appPath.length + 1, file.nativePath.length);
			else
				path = file.nativePath;
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