package screens 
{
	// Debugg imports
	import starling.text.TextField;
	import starling.utils.Color;
	
	import flash.media.Sound;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class GameScreen extends Sprite 
	{
		//************** ATRIBUTOS *********************************
		
		// Variables para el texto que sale en pantalla que nos sirve para
		// ver valores e identificar errores a modo de debugg
		public static var debugg:String = "";
		private var debuggText : TextField;
		
		// Pelotas en el juego
		private var balls : Vector.<Ball> = new <Ball>[];
		
		// Palas del jugador
		private var leftStick : Stick;
		private var rightStick : Stick;
		private var topStick : Stick;
		private var bottomStick : Stick;
		
		// Objetos que aparecen en el juego
		private var gameObjects : Vector.<Hability> = new <Hability>[];
		// Tiempo para spawnear un nuevo objeto
		private var timeToSpawn : Number = 5;
		// Tiempo base para spawnear (mirar la siguiente variable)
		private var initialTimeToSpawn : Number = 5;
		// Cantidad de segundos que puede variar el tiempo para spawnear objetos
		// es decir, cada vez que aparezca un nuevo objeto en la escena, se vuelve
		// a calcular "timeToSpawn", el tiempo que tiene que transcurrir para spawnear,
		// de esta forma el tiempo para generar objetos varia entre:
		// initialTimeToSpawn - rango y initialTimeToSpawn + rango
		private var rangeTimeSpawn : int = 2;
		// Temporizador que se incrementa cada frame y que se compara con timeToSpawn
		private var spawnTimer  : Number = 0;
		// Los objetos que se generan en la escena se pueden generar en el area comprimida por
		//  X (spawnArea, Width - spawnArea)
		//  Y (spawnArea, Height - spawnArea)
		// en otras palabras, spawnArea es el margen hasta el límite de la pantalla
		private var spawnArea : int = 150;
		
		// Tiempo para generar pelota nueva (este no varia)
		private var timeToSpawnBall : Number = 4;
		// Temporizador que se va incrementando
		private var ballSpawnerTime : Number = 5;
		
		//************* CONSTRUCTOR ****************************************
		
		public function GameScreen() 
		{
			super();
			// Dibujar palas
			drawScreen();
			
			// Devolver pelota al centro o eliminarla al salirse
			addEventListener(Event.ENTER_FRAME, devolverPelota);
			spawnBall();
			
			// comprobar colisiones entre las pelotas y otros
			addEventListener(Event.ENTER_FRAME, comprobarColisiones);
			// generar objetos en la escena
			//addEventListener(Event.ENTER_FRAME, spawnObject);
			// generar bolas en la escena
			//addEventListener(Event.ENTER_FRAME, spawnBall);
			// mostrar texto de debbugg en la escena (quitar al acabar el juego)
			addEventListener(Event.ENTER_FRAME, DebuggText);
		}
		
		//*************** SYSTEM FUNCTIONALITY **************************
		
		private function DebuggText () : void
		{
			// Texto para mostrar cosas
			removeChild(debuggText);
			debuggText = new TextField(800, 600, debugg, "Arial", 12, Color.RED);
			this.addChild(debuggText);
		}
		
		// dibujar palas
		private function drawScreen():void
		{
			
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
		
		//********** CONTROL PELOTA **************************
		
		// devolver pelota al centro de la pantalla si se sale
		private function devolverPelota (event:Event) : void
		{
			for (var i:int = 0; i < balls.length; ++i)
			{
				var ball : Ball = balls[i];
				if (ball.x < 0 || ball.x >= 800 || ball.y < 0 || ball.y >= 600)
				{
					ball.x = 400;
					ball.y = 300;
					//ball.Speed = 2;
				}
			}
		}
		
		// comprobar colisiones entre la pelota y lo demás
		private function comprobarColisiones (event:Event) : void
		{
			for (var i:int = 0; i < balls.length; ++i)
			{
				var ball : Ball = balls[i];
				
				// Si no está ya colisionando
				if (!ball.IsColliding())
				{
					// Si colisiona con la pala izquierda
					if (MyFunctions.imageCollision (leftStick, ball))
					{
						// Colisionar con ella
						ball.CollideWithStick (leftStick);
						continue;
					}
					
					if (MyFunctions.imageCollision (rightStick, ball))
					{
						ball.CollideWithStick (rightStick);
						continue;
					}
					
					if (MyFunctions.imageCollision (topStick, ball))
					{
						ball.CollideWithStick (topStick);
						continue;
					}
					
					if (MyFunctions.imageCollision (bottomStick, ball))
					{
						ball.CollideWithStick (bottomStick);
						continue;
					}
					
					// Comprobar colision con cada una de las otras pelotas
					var j : int = 0;
					
					for (j = 0; j < balls.length; ++j)
					{
						if (j != i && MyFunctions.imageCollision(balls[j], ball))
						{
							ball.CollideWith (balls[i]);
							balls[i].CollideWith (ball);
							continue;
						}
					}
						
					// Comprobar colision con los objetos
					for (j = 0; j < gameObjects.length; ++j)
					{
						if (MyFunctions.imageCollision(gameObjects[j], ball))
						{
							gameObjects[j].DoThing(ball);
							removeChild (gameObjects[j]);
							gameObjects.splice (j, 1);
						}
					}
				}
			}
		}
		
		// quitar pelota del juego si se sale
		private function quitarPelotas (event:Event) : void
		{
			for (var i:int = 0; i < balls.length; ++i)
			{
				var ball:Ball = balls[i];
				if (ball.x < 0 || ball.x > 800 || ball.y < 0 || ball.y > 600) 
				{
					balls.splice (i, 1);
					removeChild (ball);
				}
			}
		}
		
		//**************** SPAWNS *****************************
		
		private function spawnObject () : void
		{
			spawnTimer += 0.016;  // 1 seg / 60 fps
			if (timeToSpawn > 0){
				if (spawnTimer >= timeToSpawn)
				{
					var objectFunction : int = int (MyFunctions.Random(0, 1));
					
					var posX : int = int (MyFunctions.Random (spawnArea, 800 - spawnArea));
					var posY : int = int (MyFunctions.Random (spawnArea, 600 - spawnArea));
					
					var newHab : Hability = new Hability(objectFunction, posX, posY, 50, 50);
					addChild(newHab);
					gameObjects.push (newHab);
					
					timeToSpawn = MyFunctions.Random (initialTimeToSpawn - rangeTimeSpawn, initialTimeToSpawn + rangeTimeSpawn);
					spawnTimer = 0;
				}
			}
			else timeToSpawn = 5;
		}
		
		private function spawnBall () : void
		{
			ballSpawnerTime += 0.016;
			if (timeToSpawnBall > 0 && ballSpawnerTime >= timeToSpawnBall)
			{
				
				ballSpawnerTime = 0;
				
				var newBall : Ball = new Ball(400, 300, 25, 25, Assets.getTexture("BallPic"));
				addChild(newBall);
				balls.push (newBall);
			}
		}
		
		// *************************************************************************
		
		
	}

}