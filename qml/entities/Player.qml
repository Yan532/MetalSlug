import Felgo 3.0
<<<<<<< HEAD
import QtQuick 2.0
=======
import QtQuick 2.15
>>>>>>> liaowanyu

EntityBase {
  id: player
  entityType: "player"
<<<<<<< HEAD
  width: image.width
  height: image.height
=======
  width: 50
  height: 50
>>>>>>> liaowanyu

  // add some aliases for easier access to those properties from outside
  property alias collider: collider
  property alias horizontalVelocity: collider.linearVelocity.x
<<<<<<< HEAD
  property alias body: image

  // the contacts property is used to determine if the player is in touch with any solid objects (like ground or platform), because in this case the player is walking, which enables the ability to jump. contacts > 0 --> walking state
  property int contacts: 0
  property int leftoright: 0
  property int up: 0
  // property binding to determine the state of the player like described above

  state: contacts > 0 ? "walking" : "jumping"
  onStateChanged: console.debug("player.state " + state)

  // here you could use a SpriteSquenceVPlay to animate your player
  AnimatedImage {
      id:image
      scale: 0.6
      source: "../../assets/player/player.png"
      rotation: 0
  }



  CircleCollider {
    id: collider
    radius: image.width/3
    x:radius/2
    y:radius/2 - 10
    // this collider must be dynamic because we are moving it by applying forces and impulses
    density: 0
    linearDamping: 1
    force: Qt.point(controller.xAxis*1000,0)
    rotation: 0
    // limit the horizontal velocity
    onLinearVelocityChanged: {
      if(linearVelocity.x > 100) linearVelocity.x = 100
      if(linearVelocity.x < -100) linearVelocity.x = -100
    }
  }
=======

  // the contacts property is used to determine if the player is in touch with any solid objects (like ground or platform), because in this case the player is walking, which enables the ability to jump. contacts > 0 --> walking state
  property int contacts: 0
  // property binding to determine the state of the player like described above
  state: contacts > 0 ? "walking" : "jumping"
  onStateChanged: console.debug("player.state " + state)




  Image{ x:30;
   id: image1;
   source: "/合金弹头/MetalSlug/assets/player/contral.png";
   visible: false}

  // here you could use a SpriteSquenceVPlay to animate your player
  MultiResolutionImage {

      SpriteSequence {
                  id: sequence;
                  width: 85;
                  height: 85;
                  scale: 0.5
                  interpolate: true;
                  running: false;
                  sprites: [
                      Sprite {
                          name: "left";
                          source: image1.source;
                          frameCount: 4;
                          frameY: image1.height/4;
                          frameWidth: image1.width/4;
                          frameHeight: image1.height/4;
                          frameRate: 10;
                          duration: 200

                      },
                      Sprite {
                          name: "right";
                          source: image1.source;
                          frameCount: 4;
                          frameY: image1.height/4*2;
                          frameWidth: image1.width/4;
                          frameHeight: image1.height/4;
                          frameRate: 10;
                          duration: 200

                      },
                      Sprite {
                          name: "down";
                          source: image1.source;
                          frameCount: 4;
                          frameWidth: image1.width/4;
                          frameHeight: image1.height/4;
                          frameRate: 10;
                          duration: 200

                      },


                      Sprite {
                          name: "up";
                          source: image1.source;
                          frameCount: 4;
                          frameY: image1.height/4*3;
                          frameWidth: image1.width/4;
                          frameHeight: image1.height/4;
                          frameRate: 10;
                          duration: 200

                      }
                  ]
              }
      focus: true;
              Keys.onPressed: {
                  switch(event.key)
                  {
                  case Qt.Key_Up:
                      sequence.y -= 5;
                      sequence.jumpTo("up");
                      sequence.running = true;
                      break;
                  case Qt.Key_Down:
                      sequence.y += 5;
                      sequence.jumpTo("down");
                      sequence.running = true;
                      break;
                  case Qt.Key_Left:
                      sequence.x -= 5;
                      sequence.jumpTo("left");
                      sequence.running = true;
                      break;
                  case Qt.Key_Right:
                      sequence.x += 5;
                      sequence.jumpTo("right");
                      sequence.running = true;
                      break;
                  default:
                      ;
                  }
              }
              Keys.onReleased: {
                  sequence.running = false;
              }


}

  BoxCollider {//矩形的物理实体
    id: collider
    height: parent.height
    width: 50
    anchors.horizontalCenter: parent.horizontalCenter
    bodyType: Body.Dynamic // this is the default value but I wanted to mention it ;)
    fixedRotation: true // we are running, not rolling...
    bullet: true // 精准
    sleepingAllowed: false
    // 用 TwoAxisController 的水平值作为力量移动玩家左右
    force: Qt.point(controller.xAxis*170*32,0)
    // 限制水平速度
    onLinearVelocityChanged: {
      if(linearVelocity.x > 170) linearVelocity.x = 170
      if(linearVelocity.x < -170) linearVelocity.x = -170
    }
  }

>>>>>>> liaowanyu
  // this timer is used to slow down the players horizontal movement. the linearDamping property of the collider works quite similar, but also in vertical direction, which we don't want to be slowed
  Timer {
    id: updateTimer
    // set this interval as high as possible to improve performance, but as low as needed so it still looks good
<<<<<<< HEAD
    interval:1
=======
    interval: 60
>>>>>>> liaowanyu
    running: true
    repeat: true
    onTriggered: {
      var xAxis = controller.xAxis;
<<<<<<< HEAD
      // if xAxis is 0 (no movementd command) we slow the player down until he stops
      if(xAxis === 0) {
=======
      // if xAxis is 0 (no movement command) we slow the player down until he stops
      if(xAxis == 0) {
>>>>>>> liaowanyu
        if(Math.abs(player.horizontalVelocity) > 10) player.horizontalVelocity /= 1.5
        else player.horizontalVelocity = 0
      }
    }
  }

  function jump() {
    console.debug("jump requested at player.state " + state)
    if(player.state == "walking") {
      console.debug("do the jump")
      // for the jump, we simply set the upwards velocity of the collider
<<<<<<< HEAD
      collider.linearVelocity.y = -300
=======
      collider.linearVelocity.y = -420
>>>>>>> liaowanyu
    }
  }
}

<<<<<<< HEAD
=======



>>>>>>> liaowanyu
