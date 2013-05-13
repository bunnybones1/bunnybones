package com.bunnybones.panoPainter.model 
{
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class PanoramaLayerModel extends NetModel 
	{
		static public const IMAGEURL:String = "imageNotFound.png";
		public var imageURL:String;
		public function PanoramaLayerModel() 
		{
			super();
		}
		
		static public function fromXML(xml:XML):PanoramaLayerModel 
		{
			var model:PanoramaLayerModel = new PanoramaLayerModel();
			model.parseXML(xml);
			return model;
		}
		
	}

}