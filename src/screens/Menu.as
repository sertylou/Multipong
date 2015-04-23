package screens 
{
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Menu extends Sprite 
	{
		var SurvivalMode : Button;
		var TimeMode : Button;
		
		public function Menu() 
		{
			super();
			
			var mBackGround : Image = new Image(Assets.getTexture ("menuBackgroundPic"));
			mBackGround.width = 800;
			mBackGround.height = 600;
			this.addChild(mBackGround);
		
			SurvivalMode = new Button(Assets.getTexture("SurvivalModeButton"));
			SurvivalMode.width = 200;
			SurvivalMode.height = 100;
			SurvivalMode.x = 100;
			SurvivalMode.y = 250;
			this.addChild(SurvivalMode);
			
			TimeMode = new Button(Assets.getTexture("TimeModeButton"));
			TimeMode.width = 200;
			TimeMode.height = 100;
			TimeMode.x = 500;
			TimeMode.y = 250;
			this.addChild(TimeMode);
			
			this.addEventListener(Event.TRIGGERED, buttonClick);
		}
		
		private function buttonClick (event:Event) : void
		{
			var buttonClicked : Button = event.target as Button;
			if ( (buttonClicked as Button) == SurvivalMode)
			{
				var gameScreen : GameScreen = new GameScreen();
				this.addChild(gameScreen);
				this.visible = false;
			}
		}
	}

}