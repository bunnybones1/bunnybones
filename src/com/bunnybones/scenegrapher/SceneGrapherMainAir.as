package com.bunnybones.scenegrapher
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	[SWF(backgroundColor="#7f7f7f", frameRate="60", width="1024", height="768")]
	public class SceneGrapherMainAir extends SceneGrapherMain 
	{
		
		public function SceneGrapherMainAir(useMode3D:Boolean = false):void 
		{
			super(useMode3D);
		}
		
		override protected function init():void 
		{
			super.init();
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		override protected function quicksave():void
		{
			super.quicksave();
			var xml:XML = exportGraph();
			
			var appDir:File = File.applicationStorageDirectory;
			var dskTopFileStream:FileStream = new FileStream();
			var fileString:String = appDir.nativePath;
			var dskTopFile:File = File.documentsDirectory;
			trace(dskTopFile.url);
			dskTopFile = dskTopFile.resolvePath(fileString+"\\quicksave.xml");
			trace(dskTopFile.url);
			dskTopFileStream.openAsync (dskTopFile, FileMode.WRITE);
			dskTopFileStream.writeUTFBytes (xml);
			dskTopFileStream.close ();
		}
		
		override protected function quickload():void
		{
			super.quickload();
			var appDir:File = File.applicationStorageDirectory;
			var fileString:String = appDir.nativePath;
			var dskTopFile:File = File.documentsDirectory;
			dskTopFile = dskTopFile.resolvePath(fileString+"\\quicksave.xml");
			var xmlString:URLRequest = new URLRequest(dskTopFile.url); 
			xmlLoader = new URLLoader(xmlString); 
			xmlLoader.addEventListener("complete", onXMLLoadComplete);
			graphXML = new XMLDocument(); 
			graphXML.ignoreWhite = true;
		}
	}
	
}