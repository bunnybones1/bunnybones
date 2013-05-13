package com.bunnybones.panoPainter.model
{
	import com.bunnybones.model.NetModel;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class PanoramaModel extends NetModel
	{
		private var layers:Vector.<PanoramaLayerModel>;
		
		public function PanoramaModel() 
		{
			layers = new Vector.<PanoramaLayerModel>();
			super();
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			layers = new Vector.<PanoramaLayerModel>;
			var totalLayers:int = xml.PanoramaLayerModel.Length;
			for (var i:int = 0; i < totalLayers; i++) {
				addLayer(PanoramaLayerModel.fromXML(xml.PanoramaLayerModel[i]));
			}
		}
		
		override public function composeXML(omitDefaults:Boolean = true):XML 
		{
			var xml:XML = super.composeXML(omitDefaults);
			var totalLayers:int = layers.length;
			for (var i:int = 0; i < totalLayers; i++) {
				xml.appendChild(layers[i].composeXML(omitDefaults));
			}
			return xml;
		}
		
		public function addLayer(model:PanoramaLayerModel = null):void 
		{
			model = model || new PanoramaLayerModel();
			layers.push(model);
		}
		
		public function getLayerModelAt(index:int):PanoramaLayerModel
		{
			return layers[index];
		}
		
		public function saveAs():void 
		{
			this.url = null;
			save();
		}
		
		public function loadAs():void 
		{
			this.url = null;
			load();
		}
		
		public function get numLayers():int 
		{
			return layers.length;
		}
	}

}