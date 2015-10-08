package {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Mad Mike
	*/
	public class Building {
		public var costume:MovieClip;
		public var rect:Rectangle;
		
		public function Building(parent:DisplayObjectContainer, loc:Point) {
			costume = new MovieClip();
			costume.x = loc.x;
			costume.y = loc.y;
			costume.graphics.beginFill(0x004040);
			costume.graphics.drawRect(0, 0, 100, 70);
			costume.graphics.endFill();
			parent.addChild(costume);
			rect = new Rectangle(loc.x, loc.y, 100, 70);
		}
	}
}