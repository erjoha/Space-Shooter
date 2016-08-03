package 
{

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getQualifiedClassName;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.MouseEvent;



	public class Main_alien extends MovieClip
	{
		//Declare variables 
		var vx:int;
		var vy:int;
		var velocity:uint;
		var score:uint;
		var collision:Boolean;
		var myTimer:Timer;
		var gamefinished:gameFinished;
		var helppage:helpPage;
		var frontpage:frontPage;
		var enemyalien:enemyAlien;
		var my_sound:SoundId = new SoundId();
		var my_soun:SoundIdd = new SoundIdd();
		var playerName:String;




		//------------------- 
		//Constructor 
		public function Main_alien()
		{
			init();
			addChild(frontpage);
		}


		//------------------- 
		//Inilializes game 
		public function init():void
		{
			//Initialize variables 
			vx = 0;
			vy = 0;
			velocity = 20;
			score = 0;
			collision = false;
			gamefinished = new gameFinished()  ;
			helppage = new helpPage();
			enemyalien = new enemyAlien()  ;
			frontpage = new frontPage();
			

			//Add event listeners 
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownPress);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpPress);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrameEvent);

			//addChild(frontpage);
			addChild(frontpage);
			frontpage.playbtn.addEventListener(MouseEvent.CLICK, onplaybtnClick);
			frontpage.helpbtn.addEventListener(MouseEvent.CLICK, onhelpbtnClick);
			
			
			

			//Listener for timer
			myTimer = new Timer(1000,0);
			myTimer.addEventListener(TimerEvent.TIMER, onTimerEvent);


			for (var i:int = 0; i < 10; i++)
			{
				enemyalien.x = Math.ceil(Math.random() * stage.stageWidth);
				//enemyalien.x = Math.ceil(Math.random() * stage.stageHeight);

			}
			frontpage.nameInput.restrict = "A-Ö" + "a-ö" + "1-9";
 			frontpage.nameInput.maxChars = 10;

		}
		function onplaybtnClick(e:MouseEvent):void
		{
		 playerName = String(frontpage.nameInput.text);
 		if(playerName.length > 4)
		
		


			{
			//removeChild(frontpage); and addChild(enemyalien); also play sound and start timer when game begin.
			removeChild(frontpage);
			myTimer.start();
			stage.addChild(enemyalien);
			var channel:SoundChannel = my_sound.play();
			stage.focus = stage; 
			//Type out the players "Player name"
			welcomePlayer.text = playerName;
			
		
			}
			
			else{
 			frontpage.nameOutput.text = "Type at least five letters!";
			}
		}
		function onhelpbtnClick(e:MouseEvent):void
		{
			//removeChild(frontpage); and addChild(helppage); 
			removeChild(frontpage);
			addChild(helppage);
			helppage.backbtn.addEventListener(MouseEvent.CLICK, onbackbtnClick);
			
		
		}


		public function onTimerEvent(e:TimerEvent):void
		{	
			//Shows the time
			timeDisplay.text = toFormattedTime(myTimer.currentCount);

			//How often enemys is going to enter the stage
			if (myTimer.currentCount % 1 == 0)
			{
				var fiende:enemyAlien = new enemyAlien  ;
				fiende.x = Math.ceil(Math.random() * stage.stageWidth);
				//hammpig.x = Math.ceil(Math.random() * stage.stageHeight);

				stage.addChild(fiende);

			}
		}

		//Timer is going to count both minutes and seconds
		public function toFormattedTime(time:Number):String
		{

			var minutes:int;
			var seconds:int;

			minutes = Math.floor(time / 60);
			seconds = Math.floor(time % 60);

			return toDoubleDigits(minutes) + ":" + toDoubleDigits(seconds);
		}


		public function toDoubleDigits(num:int):String
		{
			if (num < 10)
			{
				return "0" + num;

			}
			return String(num);
		}




		//------------------- 
		//Handles key down press 
		function onKeyDownPress(e:KeyboardEvent):void
		{
			//Checks which button was pressed 
			if (e.keyCode == Keyboard.LEFT)
			{
				vx =  -  velocity;//Moves player left 
			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				vx = velocity;//Moves player right 
			}
			else if (e.keyCode == Keyboard.UP)
			{
				vy =  -  velocity;//Moves player up 
			}
			else if (e.keyCode == Keyboard.DOWN)
			{
				vy = velocity;
			}
		}


		//------------------- 
		//Handles key release 
		function onKeyUpPress(e:KeyboardEvent):void
		{
			//Resets variables values depending on key pressed (to stop player) 
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT)
			{
				vx = 0;
			}
			else if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.UP)
			{
				vy = 0;
			}
			if (e.keyCode == Keyboard.SPACE)
			{
				var bullet:Bullet = new Bullet ();
				bullet.x = player.x;
				bullet.y = player.y - player.height / 2;

				stage.addChild(bullet);
				var channel:SoundChannel = my_soun.play();
				
			}

		}

		//------------------- 
		//Handles enter frame 
		function onEnterFrameEvent(e:Event):void
		{
			//Move the player (i.e. updates player position) 
			player.x +=  vx;
			player.y +=  vy;

			var playerHalfWidth:uint = player.width / 2;
			var playerHalfHeight:uint = player.height / 2;
			
			//Loop for checking through Children and add Bullet.
			for (var i:int = 0; i < stage.numChildren; i ++)
			{
				if (getQualifiedClassName(stage.getChildAt(i)) == "enemyAlien")
				{
					stage.getChildAt(i).y +=  5;

					for (var j:int = 0; j < stage.numChildren; j++)
					{
						if (getQualifiedClassName(stage.getChildAt(j)) == "Bullet")
						{
							if (stage.getChildAt(i).hitTestObject(stage.getChildAt(j)))
							{
								score++;
								//Shows the score
								messageDisplay.text = String(score);
								stage.removeChild(stage.getChildAt(i));

							}
						}
					}
				}
				else if (getQualifiedClassName(stage.getChildAt(i)) == "Bullet")
				{
					stage.getChildAt(i).y -=  5;
				}
			}
			
			
			


			//Stop player at stage edges 
			if ((player.x + playerHalfWidth) > stage.stageWidth)
			{
				player.x = stage.stageWidth - playerHalfWidth;
			}
			else if (player.x - playerHalfWidth < 0)
			{
				player.x = 0 + playerHalfWidth;
			}

			var timeLimit:int = 60;
			//Recalculates timer to minutes and compares to time limit for game 
			if (myTimer.currentCount >= 15)
			{
				gameOver();
				//Timer stop after game finished
				myTimer.stop()
				
			


			}
		}

		function gameOver():void
		{
		
			
			myTimer.stop();
		
			addChild(gamefinished);
			//Shows the players score
			gamefinished.scoreDisplay.text = String(score);
			gamefinished.restartbtn.addEventListener(MouseEvent.CLICK, onrestartbtnClick); 
		  


		}
		
		
		function onrestartbtnClick(e:MouseEvent):void
		{
			//removeChild(gamefinished);
			removeChild(gamefinished); 
			gamefinished.restartbtn.removeEventListener(MouseEvent.CLICK, onrestartbtnClick); 
			init();

		}

		function onbackbtnClick(e:MouseEvent):void
		{
			//removeChild(helppage); and addChild(frontpage);
			removeChild(helppage);
			addChild(frontpage);

	
		}

	}
}