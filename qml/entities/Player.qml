import Felgo 3.0
import QtQuick 2.0

EntityBase {
  id: player
  entityType: "player"
  width: 50
  height: 50

  // add some aliases for easier access to those properties from outside
  // 添加一些别名以便于从外部访问这些属性
  property alias collider: collider
  property alias horizontalVelocity: collider.linearVelocity.x

  // the contacts property is used to determine if the player is in touch with any solid objects (like ground or platform), because in this case the player is walking, which enables the ability to jump. contacts > 0 --> walking state
  // contacts 属性用于确定玩家是否与任何固体物体（如地面或平台）接触，因为在这种情况下玩家正在行走，这使得能够跳跃。contacts > 0 --> 行走状态
  property int contacts: 0
  // property binding to determine the state of the player like described above
  // 属性绑定来确定播放器的状态，如上所述
  state: contacts > 0 ? "walking" : "jumping"
  onStateChanged: console.debug("player.state " + state)

  // here you could use a SpriteSquenceVPlay to animate your player
  // 在这里你可以使用 SpriteSquenceVPlay 为你的播放器设置动画
  MultiResolutionImage {
    source: "../../assets/player/player.png"
  }

  BoxCollider {
    id: collider
    height: parent.height
    width: 30
    anchors.horizontalCenter: parent.horizontalCenter
    // this collider must be dynamic because we are moving it by applying forces and impulses
    // 这个对撞机必须是动态的，因为我们通过施加力和冲量来移动它
    bodyType: Body.Dynamic // this is the default value but I wanted to mention it ;)
    // 这是默认值，但我想提一下 ;)
    fixedRotation: true // we are running, not rolling...
    bullet: true // for super accurate collision detection, use this sparingly, because it's quite performance greedy
    // 对于超精确的碰撞检测，请谨慎使用它，因为它对性能非常贪婪
    sleepingAllowed: false
    // apply the horizontal value of the TwoAxisController as force to move the player left and right
    // 应用 TwoAxisController 的水平值作为力量来左右移动玩家
    force: Qt.point(controller.xAxis*170*32,0)
    // limit the horizontal velocity
    // 限制水平速度
    onLinearVelocityChanged: {
      if(linearVelocity.x > 170) linearVelocity.x = 170
      if(linearVelocity.x < -170) linearVelocity.x = -170
    }
  }

  // this timer is used to slow down the players horizontal movement. the linearDamping property of the collider works quite similar, but also in vertical direction, which we don't want to be slowed
  // 此计时器用于减慢玩家的水平移动速度。对撞机的 linearDamping 属性的工作方式非常相似，但在垂直方向上也是如此，我们不想被减慢
  Timer {
    id: updateTimer
    // set this interval as high as possible to improve performance, but as low as needed so it still looks good
    // 将此间隔设置得尽可能高以提高性能，但根据需要设置得尽可能低，这样它仍然看起来不错
    interval: 60
    running: true
    repeat: true
    onTriggered: {
      var xAxis = controller.xAxis;
      // if xAxis is 0 (no movement command) we slow the player down until he stops
      // 如果 xAxis 为 0（无移动命令），我们会减慢玩家的速度直到他停止
      if(xAxis == 0) {
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
      // 对于跳跃，我们只需设置对撞机的向上速度
      collider.linearVelocity.y = -420
    }
  }
}

