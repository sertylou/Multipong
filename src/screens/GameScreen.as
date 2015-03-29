package screens 
{
	// Debugg imports
	import flash.media.Sound;
	import starling.text.TextField;
	import starling.utils.Color;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class GameScreen extends Sprite 
	{
		private var debugg:String = "Hola mundo";
		private var debuggText : TextField;
		
		private var ball:Ball;
		private var leftStick : Stick;
		private var rightStick : Stick;
		private var topStick : Stick;
		private var bottomStick : Stick;
		
		private var gameObjects : Vector.<Hability> = new <Hability>[];
		private var timeToSpawn : Number = 5;
		private var rangeTimeSpawn : int = 2;
		private var spawnTimer  : Number = 0;
		private var spawnArea : int = 100;
		
		public function GameScreen() 
		{
			super();
			drawScreen();
			addEventListener(Event.ENTER_FRAME, devolverPelota);
			addEventListener(Event.ENTER_FRAME, comprobarColisiones);
			addEventListener(Event.ENTER_FRAME, spawnObject);
		}
		
		private function comprobarColisiones (event:Event) : void
		{
			if (imageCollision (leftStick, ball))
				ball.CollideWith (leftStick);
			else
				ball.EndCollisionWith (leftStick);
			
			if (imageCollision (rightStick, ball))
				ball.CollideWith (rightStick);
			else
				ball.EndCollisionWith (rightStick);
			
			if (imageCollision (topStick, ball))
				ball.CollideWith (topStick);
			else
				ball.EndCollisionWith (topStick);
			
			if (imageCollision (bottomStick, ball))
				ball.CollideWith (bottomStick);
			else
				ball.EndCollisionWith (bottomStick);
				
			for (var i:int = 0; i < gameObjects.length; ++i)
			{
				if (imageCollision(gameObjects[i], ball))
				{
					gameObjects[i].DoThing(ball);
					removeChild (gameObjects[i]);
					gameObjects.splice (i, 1);
				}
				else
					ball.EndCollisionWith (bottomStick);
			}
		}
		
		private function devolverPelota (event:Event) : void
		{
			// Texto para mostrar cosas
			debugg = spawnTimer.toString() + ":" + timeToSpawn.toString();
			removeChild(debuggText);
			debuggText = new TextField(800, 600, debugg, "Arial", 12, Color.RED);
			this.addChild(debuggText);
			
			if (ball.x < 0 || ball.x > 800 || ball.y < 0 || ball.y > 600) 
			{
				ball.x = width/2;
				ball.y = height / 2;
				ball.ResetSpeed();
			}
		}
		
		private function drawScreen():void
		{
			ball = new Ball(400, 300, 25, 25, Assets.getTexture("BallPic"));
			this.addChild(ball);
			
			// Dimensiones de las palas
			var stickWidth : int = 200;
			var stickThickness : int = 20;
			
			// Maximos y minimos para las barras
			var minX : Number = 50;
			var maxX : Number = 770;
			var minY : Number = 50;
			var maxY : Number = 570;
			
			leftStick = new Stick ("left", minX, 150, stickThickness, stickWidth, Assets.getTexture("StickPic"), minY, maxY);
			this.addChild(leftStick);
			rightStick = new Stick ("right", maxX - stickThickness, 100, stickThickness, stickWidth, Assets.getTexture("StickPic"), minY, maxY);
			this.addChild(rightStick);
			topStick = new Stick ("top", 400, minY, stickWidth, stickThickness, Assets.getTexture("StickPic"), minX, maxX);
			this.addChild(topStick);
			bottomStick = new Stick ("bottom", 500, maxY - stickThickness, stickWidth, stickThickness, Assets.getTexture("StickPic"), minX, maxX);
			this.addChild(bottomStick);
			
		}
		
		// Comprueba si dos objetos colisionan
		private function imageCollision (pic1:Sprite, pic2:Sprite) : Boolean
		{
			if (pic1.x > pic2.x + pic2.width)
				return false;
			if (pic1.x + pic1.width < pic2.x)
				return false;
			if (pic1.y > pic2.y + pic2.width)
				return false;
			if (pic1.y + pic1.height < pic2.y)
				return false;
			
			return true;
		}
		
		private function spawnObject ()
		{
			spawnTimer += 0.016;  // 1 seg / 60 fps
			if (spawnTimer >= timeToSpawn)
			{
				var objectFunction : int = int (Random(0, 0));
				
				var posX : int = int (Random (spawnArea, 800 - spawnArea));
				var posY : int = int (Random (spawnArea, 600 - spawnArea));
				
				var newHab : Hability = new Hability(objectFunction, posX, posY, 25, 25);
				addChild(newHab);
				gameObjects.push (newHab);
				
				timeToSpawn = Random (timeToSpawn - rangeTimeSpawn, timeToSpawn + rangeTimeSpawn);
				spawnTimer = 0;
			}
		}
		
		function Random(min:Number, max:Number):Number {
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
	}

}