package {
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Mad Mike
	*/
	public class Unit {
		private var costume:MovieClip;
		private var costumeSelected:MovieClip;
		public var location:Point;
		private var movingDestination:Point;
		private var pushingDestination:Point;
		private var maxSpeed:Number = 5;
		private var health:Number = 100;
		
		public function Unit(parent:DisplayObjectContainer, loc:Point) {
			location = loc.clone();
			addCostumes();
			teleportTo(location);
			parent.addChild(costume);
			parent.addChild(costumeSelected);
			costume.addEventListener(MouseEvent.CLICK, selectThis);
			costumeSelected.addEventListener(MouseEvent.CLICK, selectThis);
		}
		
		private function selectThis(e:MouseEvent):void {
			Generals.selectUnit(this);
		}
		
		private function addCostumes():void {
			costume = new MovieClip();
			costume.graphics.beginFill(0x008040);
			var radius:Number = 10;
			costume.graphics.drawCircle( -radius / 2, -radius / 2, radius);
			costume.graphics.endFill();
			costumeSelected = new MovieClip();
			costumeSelected.graphics.beginFill(0xFFFF00);
			costumeSelected.graphics.drawCircle( -radius / 2, -radius / 2, radius);
			costumeSelected.graphics.endFill();
			costumeSelected.visible = false;
		}
		
		public function checkIntersection(rect:Rectangle):Boolean {
			if (rect.containsPoint(location)) {
				return true;
			} else {
				return false;
			}
		}
		
		public function checkSelection(rect:Rectangle):Boolean {
			var intersects:Boolean = checkIntersection(rect);
			if (intersects) {
				select();
			} else {
				diselect();
			}
			return intersects;
		}
		
		public function select():void {
			costume.visible = false;
			costumeSelected.visible = true;
		}
		
		public function diselect():void {
			costume.visible = true;
			costumeSelected.visible = false;
		}
		
		public function teleportTo(loc:Point):void {
			costume.x = loc.x;
			costume.y = loc.y;
			costumeSelected.x = loc.x;
			costumeSelected.y = loc.y;
			location = loc.clone();
		}
		
		public function moveTo(loc:Point):void {
			movingDestination = loc.clone();
		}
		
		public function sendTo(destination:Point, pos:int):void {
			var loc:Point = destination.clone();
			loc.x += pos%3 * 22;
			loc.y += int(pos/3) * 22;
			moveTo(loc);
		}
		
		public function pushFrom(rect:Rectangle):void {
			if (pushingDestination) return void;
			var loc:Point = new Point(rect.x + 10, rect.y + 10);
			var vec:Point = new Point(location.x - loc.x, location.y - loc.y);
			var angle:Number = Math.atan2(vec.x, vec.y);
			var moveVec:Point = Point.polar(maxSpeed*5, angle);
			var destination:Point = location.subtract(moveVec);
			pushingDestination = destination.clone();
			//trace(loc.x + " " + loc.y + " " + vec.x + " " + vec.y + " " + angle + " " + pushingDestination.toString());
			//trace(movingDestination.toString() + " " + pushingDestination.toString());
			movingDestination = null;
		}
		
		private function countNextMove(loc:Point):Point {
			var vec:Point = new Point(location.x - loc.x, location.y - loc.y);
			var distance:Number = Point.distance(location, loc);
			var angle:Number = Math.atan2(vec.y, vec.x);
			var moveVec:Point = new Point();
			if (distance > maxSpeed) {
				moveVec = Point.polar(maxSpeed, angle);
			} else {
				moveVec = Point.polar(distance, angle);
				if (pushingDestination) {
					pushingDestination = null;	
				} else {	
					movingDestination = null;
				}
			}
			var destination:Point = location.subtract(moveVec);
			return destination;
		}
		
		public function update():void {
			if (movingDestination) {
				var destination:Point = countNextMove(movingDestination);
				var rect:Rectangle = new Rectangle(destination.x - 10, destination.y - 10, 20, 20);
				Generals.checkIntersection(rect, this);
				teleportTo(destination);
			} else if (pushingDestination) {
				teleportTo(countNextMove(pushingDestination));
			}
		}
	}
}