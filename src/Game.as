package
{
	import screens.GameScreen;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Quad;
	
	public class Game extends Sprite
	{
		private var gameScreen : GameScreen;
		
		private var q:Quad;
		
		public function Game()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("starling framework initialized!");
			
			gameScreen = new GameScreen();
			this.addChild(gameScreen);
		}
	}
}