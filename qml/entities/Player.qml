import Felgo 3.0
import QtQuick 2.15

EntityBase {
  id: player
  entityType: "player"
  width: 50
  height: 50

  // add some aliases for easier access to those properties from outside
  property alias collider: collider
  property alias horizontalVelocity: collider.linearVelocity.x
  property alias body: image
  property alias anim: sequence

  // the contacts property is used to determine if the player is in touch with any solid objects (like ground or platform), because in this case the player is walking, which enables the ability to jump. contacts > 0 --> walking state
  property int contacts: 0
  property int leftoright: 0
  property int up: 0
  // property binding to determine the state of the player like described above

  state: contacts > 0 ? "walking" : "jumping"
  onStateChanged: console.debug("player.state " + state)

  CircleCollider {
    id: collider
    radius: 25
    x:radius/2
    y:radius/2
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

  Image {
      id:image
      scale: 0.6
      source: "../../assets/player/contral.png"
      visible: false
  }

  // here you could use a SpriteSquenceVPlay to animate your player
  MultiResolutionImage {

      SpriteSequence {
                  id: sequence;
                  width: 85;
                  height: 85;
                  scale: 0.5
                  interpolate: true;
                  running: true;
                  sprites: [
                      Sprite {
                          name: "left";
                          source: image.source;
                          frameCount: 4;
                          frameY: image.height/4;
                          frameWidth: image.width/4;
                          frameHeight: image.height/4;
                          frameRate: 10;
                          duration: 200

                      },
                      Sprite {
                          name: "right";
                          source: image.source;
                          frameCount: 4;
                          frameY: image.height/4*2;
                          frameWidth: image.width/4;
                          frameHeight: image.height/4;
                          frameRate: 10;
                          duration: 200

                      },
                      Sprite {
                          name: "down";
                          source: image.source;
                          frameCount: 4;
                          frameWidth: image.width/4;
                          frameHeight: image.height/4;
                          frameRate: 10;
                          duration: 200

                      },


                      Sprite {
                          name: "up";
                          source: image.source;
                          frameCount: 4;
                          frameY: image.height/4*3;
                          frameWidth: image.width/4;
                          frameHeight: image.height/4;
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

  Timer {
    id: updateTimer
    // set this interval as high as possible to improve performance, but as low as needed so it still looks good
    interval:1
    running: true
    repeat: true
    onTriggered: {
      var xAxis = controller.xAxis;
      // if xAxis is 0 (no movementd command) we slow the player down until he stops
      if(xAxis === 0) {
      // if xAxis is 0 (no movement command) we slow the player down until he stops
      if(xAxis == 0) {
        if(Math.abs(player.horizontalVelocity) > 10) player.horizontalVelocity /= 1.5
        else player.horizontalVelocity = 0
        }
      }
    }
  }

  function jump() {
    console.debug("jump requested at player.state " + state)
    if(player.state == "walking") {
      console.debug("do the jump")
      // for the jump, we simply set the upwards velocity of the collider
      collider.linearVelocity.y = -300
         }
   }
}
