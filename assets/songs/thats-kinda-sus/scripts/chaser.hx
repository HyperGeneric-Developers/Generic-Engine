import flixel.text.FlxText;
import flixel.ui.FlxButton;

var sussidex;
var titlecard;
var canClick:Bool = false;
function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/thatskindasus_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 0;
    titlecard.y = 300;
	titlecard.scale.set(0.7, 0.7);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
}

function create() {
	sussidex = new FlxSprite();
    sussidex.loadGraphic(Paths.image("stages/sussys/sussidex"));
	sussidex.x = -200;
    sussidex.y = 320;
	sussidex.scale.set(0.6, 0.6);
    sussidex.cameras = [camHUD];
	sussidex.updateHitbox();
	sussidex.alpha = 0.3;
	add(sussidex);
}

function update(elapsed:Float){	
	if (mouseOverlaps(sussidex, camHUD) && FlxG.mouse.justPressed && canClick) {
			PlayState.loadSong("screweth", "normal", false, false);
			FlxG.switchState(new PlayState());
			trace('what the fuck');
	}
	if (mouseOverlaps(sussidex, camHUD)) {
		sussidex.alpha = 1;
		
	} else {sussidex.alpha = 0.3;}
}

function mouseOverlaps(sprite:FlxBasic, ?camera:FlxCamera) {
	var camToCheck:FlxCamera = camera ?? sprite.camera;
	var posthing:FlxPoint = FlxG.mouse.getWorldPosition(camToCheck);

	return posthing != null && FlxMath.inBounds(posthing.x, sprite.x, sprite.x + sprite.width) && FlxMath.inBounds(posthing.y, sprite.y, sprite.y + sprite.height);
}

function stepHit(curStep:Int) {
    if (curStep == 128) {
        FlxTween.tween(titlecard, {alpha: 1}, 0.8, {ease: FlxEase.quadInOut});
		FlxTween.tween(titlecard.scale, {x: 1.1, y: 1.1}, 0.8, {ease: FlxEase.quadInOut});
		FlxTween.tween(titlecard, { y: 100 }, 0.5, {ease: FlxEase.quadInOut});
		FlxTween.tween(sussidex, {x : 0}, 2, {ease: FlxEase.quadInOut});
		canClick = true;
	} else if (curStep == 158) {
		FlxTween.tween(titlecard, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
    }
}
