package com.bunnybones.model 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	public class Model 
	{
		static public const NAME:String = "model";
		private var tagName:String = null;
		public var name:String;
		private var classHierarchy:Vector.<Class>;
		private var CDATA:Array;
		private var defaults:Dictionary;
		public function Model(tagName:String = null) 
		{
			this.tagName = tagName;
			buildClassHierarchy();
			buildDefaultsDictionary();
			setDefaults();
			enforceTemplate();
			CDATA = new Array();
		}
		
		public function buildDefaultsDictionary():void 
		{
			defaults = new Dictionary();
			var classIndex:int;
			var classThatHasDefaultConst:Class;
			var description:XML = describeType(this);
			var numVariables:int = description.variable.length();
			for (var i:int = 0; i < numVariables; i++) 
			{
				var variable:XML = description.variable[i];
				var attributeName:String;
				var attributeType:String;
				for each(var a:* in variable.attributes())
				{
					if(a.name() == "name") attributeName = a;
					if(a.name() == "type") attributeType = a;
				}
				
				var defaultFound:Boolean = false;
				classIndex = 0;
				classThatHasDefaultConst = classHierarchy[classIndex];
				while (classThatHasDefaultConst && !defaultFound)
				{
					//dtrace(classHierarchy[0], "looking for default const in", classThatHasDefaultConst);
					if (classThatHasDefaultConst[attributeName.toUpperCase()] != undefined)
					{
						defaultFound = true;
						//dtrace(classHierarchy[0], "default const found in", classThatHasDefaultConst);
						continue;
					}
					classIndex++;
					if (classIndex < classHierarchy.length)	classThatHasDefaultConst = classHierarchy[classIndex];
					else classThatHasDefaultConst = null;
				}
				if (classThatHasDefaultConst)
				{
					defaults[attributeName] = classThatHasDefaultConst[attributeName.toUpperCase()];
				}
			}
		}
		
		public function specifyCDATA(property:String):void 
		{
			CDATA.push(property);
		}
		
		public function unspecifyCDATA(property:String):void 
		{
			if(CDATA.indexOf(property) != -1) CDATA.splice(CDATA.indexOf(property), 1);
		}

		private function setDefaults():void 
		{
			for (var propName:String in defaults)
			{
				this[propName] = defaults[propName];
			}
		}
		
		
		public function getNonDefaultPropertyNames():Vector.<String> 
		{
			var list:Vector.<String> = new Vector.<String>;
			for (var propName:String in defaults)
			{
				if( this[propName] != defaults[propName]) list.push(propName);
			}
			return list;
		}
		
		private function buildClassHierarchy():void 
		{
			classHierarchy = new Vector.<Class>;
			var superClass:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
			while (superClass != Object)
			{
				classHierarchy.push(superClass);
				superClass = getDefinitionByName(getQualifiedSuperclassName(superClass)) as Class;
			}
		}
		
		public function composeXML(omitDefaults:Boolean = true):XML
		{
			var description:XML = describeType(this);
			
			var classIndex:int;
			var classThatHasDefaultConst:Class;
			if (!tagName)
			{
				tagName = description.@name;
				tagName = tagName.substring(tagName.lastIndexOf("::")+2, tagName.length);
			}
			var xml:XML = new XML("<" + tagName + " />");
			var numVariables:int = description.variable.length();
			for (var i:int = 0; i < numVariables; i++) 
			{
				var variable:XML = description.variable[i];
				var attributeName:String;
				var attributeType:String;
				for each(var a:* in variable.attributes())
				{
					if(a.name() == "name") attributeName = a;
					if(a.name() == "type") attributeType = a;
				}
				if (omitDefaults)
				{
					var defaultFound:Boolean = false;
					classIndex = 0;
					classThatHasDefaultConst = classHierarchy[classIndex];
					while (classThatHasDefaultConst && !defaultFound)
					{
						//dtrace(classHierarchy[0], "looking for default const in", classThatHasDefaultConst);
						if (classThatHasDefaultConst[attributeName.toUpperCase()] !== undefined)
						{
							defaultFound = true;
							//dtrace(classHierarchy[0], "default const found in", classThatHasDefaultConst);
							continue;
						}
						classIndex++;
						if (classIndex < classHierarchy.length)	classThatHasDefaultConst = classHierarchy[classIndex];
						else classThatHasDefaultConst = null;
					}
					if (classThatHasDefaultConst)
					{
						if (this[attributeName] == classThatHasDefaultConst[attributeName.toUpperCase()])
						{
							//dtrace(classHierarchy[0], "omitting attribute:", attributeName, this[attributeName], "for matching default in", classThatHasDefaultConst, classThatHasDefaultConst[attributeName.toUpperCase()] );
							continue;
						}
					}
				}
				//dtrace(classHierarchy[0], "serealizing", attributeName, attributeType);
				switch(attributeType)
				{
					case "String":
						if (CDATA.indexOf(attributeName) == -1)
						{
							//dtrace("String inline");
							xml["@" + attributeName] = this[attributeName];
						}
						else
						{
							//dtrace("String CDATA");
							var stringXML:XML = new XML("<" + attributeName + "/>");
							stringXML.text = new XML("<![CDATA[" + this[attributeName] + "]]>");
							xml.appendChild(stringXML);
						}
						break;
					case "Class":
						if (this[attributeName])
						{
							xml["@" + attributeName] = getQualifiedClassName(this[attributeName]);
						}
						break;
					default:
						if (attributeType.indexOf("__AS3__.vec::Vector.<") != -1)
						{
							var numThings:int = this[attributeName].length;
							for (var j:int = 0; j < numThings; j++) 
							{
								var thing:Object = this[attributeName][j];
								if (thing is Model) xml.appendChild((thing as Model).composeXML());
							}
						}
						else
						{
							if (this[attributeName] is Model) xml.appendChild((this[attributeName] as Model).composeXML());
							else xml["@" + attributeName] = this[attributeName];
						}
				}
			}
			return xml;
		}
		
		public function parseXML(xml:XML):void
		{
			var description:XML = describeType(this);
			var thisClass:Class = getDefinitionByName(description.@name) as Class;
			var numVariables:int = description.variable.length();
			for (var i:int = 0; i < numVariables; i++) 
			{
				var variable:XML = description.variable[i];
				var attributeName:String;
				var attributeType:String;
				var value:String;
				for each(var a:* in variable.attributes())
				{
					if(a.name() == "name") attributeName = a;
					if(a.name() == "type") attributeType = a;
				}
				value = xml["@" + attributeName];
				if (value == "" && CDATA.indexOf(attributeName) == -1) continue;
				
				//dtrace(thisClass, attributeName, attributeType, value);
				switch(attributeType)
				{
					case "String":
						if (CDATA.indexOf(attributeName) == -1)
						{
							this[attributeName] = value;
						}
						else
						{
							for each(var textXML:XML in xml[attributeName])
							{
								if (attributeName == String(textXML.name())) {
									this[attributeName] = textXML;
								}
							}
						}
						break;
					case "int":
						this[attributeName] = int(value);
						break;
					case "uint":
						this[attributeName] = uint(value);
						break;
					case "Number":
						this[attributeName] = Number(value);
						break;
					case "Class":
						var tempClass:Class;
						try
						{
							tempClass = getDefinitionByName(value) as Class;
						}
						catch (e:Error)
						{
							dtrace("Warning: Cannot find referenced class, defaulting to null");
							tempClass = null;
						}
						this[attributeName] = tempClass;
						break;
					case "Boolean":
						this[attributeName] = value == "true";
						break;
					default:
					//	dtrace("unkown type:", attributeName, "?", value);
						//xml["@" + attributeName] = this[attributeName];
				}
			}
		}
		
		public function castTemplate(target:Model):void
		{
			takeProperties(target);
			enforceTemplate();
			giveProperties(target);
		}
		
		
		protected function enforceTemplate():void 
		{
			
		}
		
		public function giveProperties(other:Object):void 
		{
			copyProperties(this, other);
		}
		
		public function takeProperties(other:Object, exclude:Array = null):void 
		{
			copyProperties(other, this, exclude);
		}
		
		public function copyProperties(source:Object, destination:Object, exclude:Array = null):void
		{
			var description:XML = describeType(source);
			//trace(xml);
			for each(var variable:XML in description.variable)
			{
				var attributeName:String;
				var attributeType:String;
				var value:String;
				for each(var a:* in variable.attributes())
				{
					if(a.name() == "name") attributeName = a;
					if(a.name() == "type") attributeType = a;
				}
				if (exclude) if (exclude.indexOf(attributeName) != -1) continue;
				try
				{
					//dtrace("copying", attributeName);
					destination[attributeName] = source[attributeName];
				}
				catch (e:Error)
				{
					//dtrace("attributes does not exist on other Model:", attributeName);
				}
			}
		}
	}

}