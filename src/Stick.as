package 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import starling.textures.Texture;
	
	public class Stick extends Sprite 
	{
		
		public var Speed : Number = 10;
		private var keyPressed : Boolean;
		private var position : String;
		private var moveDirection : int;
		public function get DeltaMovement () : Number { return moveDirection * Speed; }
		
		private var _min : Number;
		private var _max : Number;
		
		private var picture : Image;
		
		public function Stick(pos:String, posX : int, posY : int, width : int, height : int, pic : Texture, min:Number, max:Number ) 
		{
			super();
			
			picture = new Image(pic);
			x = posX;
			y = posY;
			picture.width = width;
			picture.height = height;
			this.addChild(picture);
			
			position = pos;
			_min = min;
			_max = max;
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, CheckKeyDown);
			this.addEventListener(KeyboardEvent.KEY_UP, CheckKeyUp);
			this.addEventListener(starling.events.Event.ENTER_FRAME, Move);
		}
		
		private function CheckKeyDown (event:KeyboardEvent) : void
		{
			switch (position)
			{
				case "top":
					if (event.keyCode == Keyboard.A) {
						keyPressed = true;
						moveDirection = -1;
					}
					if (event.keyCode == Keyboard.D) {
						keyPressed = true;
						moveDirection = 1;
					}
					break;
				case "bottom":
					if (event.keyCode == Keyboard.LEFT) {
						keyPressed = true;
						moveDirection = -1;
					}
					if (event.keyCode == Keyboard.RIGHT) {
						keyPressed = true;
						moveDirection = 1;
					}
					break;
				case "left":
					if (event.keyCode == Keyboard.W) {
						keyPressed = true;
						moveDirection = -1;
					}
					if (event.keyCode == Keyboard.S) {
						keyPressed = true;
						moveDirection = 1;
					}
					break;
				case "right":
					if (event.keyCode == Keyboard.UP) {
						keyPressed = true;
						moveDirection = -1;
					}
					if (event.keyCode == Keyboard.DOWN) {
						keyPressed = true;
						moveDirection = 1;
					}
					break;
					
			}
		}
		
		private function CheckKeyUp (event:KeyboardEvent) : void
		{
			switch (position) 
			{
				case "left":
					if (event.keyCode == Keyboard.W || event.keyCode == Keyboard.S)
						keyPressed = false;
					break;
				case "right":
					if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN)
						keyPressed = false;
					break;
				case "top":
					if (event.keyCode == Keyboard.A || event.keyCode == Keyboard.D)
						keyPressed = false;
					break;
				case "bottom":
					if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
						keyPressed = false;
					break;
			}
		}
		
		private function Move (event:Event) :void
		{
			if (keyPressed)
			{
				if (position == "top" || position == "bottom")
				{
					if (moveDirection < 0 && x > _min)
						x += moveDirection * Speed;
					else if (moveDirection > 0 && x + picture.width < _max)
						x += moveDirection * Speed;
				}
				else
				{
					if (moveDirection < 0 && y > _min)
						y += moveDirection * Speed;
					else if (moveDirection > 0 && y + picture.height< _max)
						y += moveDirection * Speed;
				}
			}
		}
		
	}

}