import funkin.options.type.Checkbox;
// TODO: make the options things work!!
var phant = Paths.font("PhantomMuff.ttf");
var text:String;
var wavy= new CustomShader("waterDistortion");
var timer = 0;
var totalTimer = FlxG.random.float(100, 1000);
var options=[];
var objects=[];
var option=0;

function create(){
	warnbg = new FlxSprite();
	warnbg.loadGraphic(Paths.image("menus/warningBG"));
	warnbg.scale.set(FlxG.width / warnbg.width, FlxG.height / warnbg.height);
	warnbg.scrollFactor.set();
	warnbg.updateHitbox();
	warnbg.shader = wavy;
	warnbg.alpha = 0.1;
	add(warnbg);

	wavy.strength = 1;

	warningTitle = new FlxText(0, 95, 920, "WARNING");
	warningTitle.setFormat(phant, 75, FlxColor.RED, "center");
	warningTitle.scrollFactor.set(0, 0);
	warningTitle.updateHitbox();
	warningTitle.screenCenter(0x01);
	add(warningTitle);

	warningText1 = new FlxText(0, 226, 1500, "This mod contains:");
	warningText1.setFormat(phant, 34, FlxColor.WHITE, "center");
	warningText1.scrollFactor.set(0, 0);
	warningText1.updateHitbox();
	warningText1.screenCenter(0x01);
	add(warningText1);

	warningEndText = new FlxText(0, 550, FlxG.width, "Press Enter to continue");
	warningEndText.setFormat(phant, 38, FlxColor.RED, "center");
	warningEndText.scrollFactor.set(0, 0);
	warningEndText.updateHitbox();
	warningEndText.screenCenter(0x01);
	add(warningEndText);

	optionsCamera = new FlxCamera();
	optionsCamera.zoom = 0.65;
	optionsCamera.bgColor = 0x00000000;
	FlxG.cameras.add(optionsCamera, false);

	// TODO: set these up in source lmao
	checkbox1=new Checkbox("Flashing Lights",""/*,"internal option name)"*/);
	checkbox2=new Checkbox("Camera Movement",""/*,"internal option name)"*/);
	checkbox3=new Checkbox("Option 3",""/*,"internal option name)"*/);
	checkbox4=new Checkbox("Option 4 brah",""/*,"internal option name)"*/);

	for(i in[checkbox1,checkbox2,checkbox3,checkbox4]){
		i.visible=false;
		i.camera=optionsCamera;
		//i.checked=false;//Check for option's saved value(?)
		add(i);
		options.push(i);
	}

	objects=options.concat([warningTitle,warningText1,warningEndText,warnbg]);

	warningTitle.y -= 100;
	warningText1.alpha = 0;
	warningEndText.y += 100;

	curWarnSwitch(0);
}

function postCreate() {
	CoolUtil.playMusic(Paths.music("warning pod ahead"));
	FlxG.sound.music.fadeIn(2, 0, 0.8);
}

var curWarn = 0;
function update(elapsed){
	warningText1.text = text;

	warningTitle.alpha = warningEndText.alpha;

	if(curWarn==1){
		var change=(controls.DOWN_P?1:0)-(controls.UP_P?1:0)/*-FlxG.mouse.wheel*/;
		if(change!=0)CoolUtil.playMenuSFX(0);
		option+=change;
		option=option%(options.length+1);
		if(option<0)option=options.length+1+option;//Decide if scrolling is enabled here
		for(i=>o in options)o.selected=option==i;
		if(option==options.length){
			warningEndText.color=0xFFFFFFFF;
			//FlxTween.cancelTweensOf(warningEndText);
			//FlxTween.tween(warningEndText,{"scale.x":1.05,"scale.y":1.05},.5,{ease:FlxEase.quartOut});
			warningEndText.scale.set(lerp(warningEndText.scale.x,1.05,.1),lerp(warningEndText.scale.y,1.05,.1));
		}else{
			warningEndText.color=0xFFFF0000;
			//FlxTween.tween(warningEndText,{"scale.x":1,"scale.y":1},.5,{ease:FlxEase.quartOut});
			warningEndText.scale.set(lerp(warningEndText.scale.x,1,.1),lerp(warningEndText.scale.y,1,.1));
			if(controls.ACCEPT){
				options[option].select();//This should automatically change the value if the option is setup correctly(if that's possible)
			}
		}
	}else{
		for(i=>o in options)o.selected=false;
		warningEndText.color=0xFFFF0000;
	}

	if (controls.ACCEPT&&(curWarn!=1||option==options.length)) {
		curWarn = FlxMath.wrap(curWarn + 1, 0, 4);
		FlxG.sound.play(Paths.sound("freeplay/scroll"));
		curWarnSwitch(curWarn);
	}

	if (controls.BACK && curWarn != 0) {
		curWarn = FlxMath.wrap(curWarn - 1, 0, 3);
		FlxG.sound.play(Paths.sound("freeplay/scroll"));
		curWarnSwitch(curWarn);
	}

	wavy?.time = (totalTimer += elapsed);
}

function curWarnSwitch(swap){
	switch (swap) {
		case 0: triggerMenu1();
		case 1: triggerMenu2();
		case 2: triggerMenu3();
		case 3: triggerMenuEnd();
	}
}

function triggerMenu1() {
	//option=0;
	text = "This mod contains:\n\nFlashing lights, Loud and/or triggering noises,\nMinor jumpscares, Copious amounts of camera shaking,\nand some amount of Copyrighted Material";
	for(o in objects)FlxTween.cancelTweensOf(o);
	FlxTween.tween(warningTitle, {y: 95}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningText1, {alpha: 1}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningText1, {y: 226}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningEndText, {alpha: 1, y: 550, "scale.x": 1, "scale.y": 1}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warnbg, {alpha: 0.15}, 0.5, {ease: FlxEase.quartIn});
	for(i=>o in options)FlxTween.tween(o, {x: (i % 2) == 0 ? -o.width - (FlxG.width * (1 - optionsCamera.zoom)) : (FlxG.width * (2 - optionsCamera.zoom)), y: 425 + (199 * 0.5)}, 0.8, {ease: FlxEase.quartOut, onComplete: _ -> {o.visible = false;}});
	warningEndText.text = "Press ACCEPT to continue";
}

function triggerMenu2() {
	text = "If you're sensitive to any of those,\nyou may turn them off or on below";
	for(o in objects)FlxTween.cancelTweensOf(o);
	FlxTween.tween(warningTitle, {y: 95 - 65}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningText1, {y: 226 - 110}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningEndText, {y: 550 + 86}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningEndText, {alpha: 1}, 0.5, {ease: FlxEase.quartIn});
	FlxTween.tween(warnbg, {alpha: 0.1}, 0.5, {ease: FlxEase.quartIn});
	for(i=>o in options){
		o.visible = true;
		o.setPosition((i % 2) == (controls.BACK?1:0) ? -o.width - (FlxG.width * (1 - optionsCamera.zoom)) : (FlxG.width * (2 - optionsCamera.zoom)), (269 * optionsCamera.zoom) + (143 * i));
		FlxTween.tween(o, {x: (FlxG.width - o.width) * 0.5}, 0.8, {ease: FlxEase.quartOut, startDelay: i * 0.125});
	}
	warningEndText.text = "Select this and press ACCEPT to continue, BACK to return";
}

function triggerMenu3() {
	//option=options.length-1;
	text = "With that done, press\nACCEPT to start playing!";
	for(o in objects)FlxTween.cancelTweensOf(o);
	FlxTween.tween(warningTitle, {y: warningTitle.y + 48}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningText1, {y: warningText1.y + 170}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warningEndText, {y: warningEndText.y - 86, "scale.x": 1, "scale.y": 1}, 1, {ease: FlxEase.quartOut});
	FlxTween.tween(warnbg, {alpha: 0}, 0.8, {ease: FlxEase.quartIn});
	FlxTween.tween(warningEndText, {alpha: 0}, 0.8, {ease: FlxEase.quartOut});
	for(i=>o in options)FlxTween.tween(o, {x: (i % 2) == 1 ? -o.width - (FlxG.width * (1 - optionsCamera.zoom)) : (FlxG.width * (2 - optionsCamera.zoom)), y: 401}, 0.8, {ease: FlxEase.quartOut, onComplete: _ -> {o.visible = false;}, startDelay: i * 0.015625/*(1÷64)*/});
}

function triggerMenuEnd() {
	FlxTween.tween(FlxG.sound.music, { pitch: -3, volume: 0.3 }, 0.8);
	FlxG.switchState(new ModState("SplashState"));
}