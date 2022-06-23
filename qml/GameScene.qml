import Felgo 3.0
import QtQuick 2.15
Scene {
  id: gameScene
  // the "logical size" - the scene content is auto-scaled to match the GameWindow size
  height:600
  width:600
 Image{
     source: "/合金弹头/MetalSlug/assets/background/+hd/layer1.jpg"
     width:600
     height: 600
     TapHandler
     {
         onTapped: anim.start()
     }
    SequentialAnimation
    {
        id:anim
        ScriptAction
        {

            script: {sequence.goalSprite="left"
            }
        }
//        NumberAnimation {
//            target: sequence
//            property: "x"
//            from: 400
//            to:480
//            duration:1200
//        }
        ScriptAction
        {

            script: {sequence.goalSprite="left";sequence.jumpTo(("left1"))
            }
        }
        ScriptAction
        {

            script: {sequence.goalSprite="left1";
               sequence.jumpTo(("mid"))}
            running: false
        }

    }
      SpriteSequence {
          id:sequence
          scale: 0.25
          anchors.horizontalCenter: parent.horizontalAlignment        
          width: 253
          height: 256
          goalSprite:""
       Sprite
       {
           name:"left"
           source: "/合金弹头/MetalSlug/assets/touxiang/touxiang.png"
           frameCount:2;
           frameWidth: 148
           frameHeight: 85
           frameX: 0
           frameY:0
      }
       Sprite
       {
           name:"left1"
           source: "/合金弹头/MetalSlug/assets/touxiang/touxiang.png"
           frameCount:3;//帧计数
           frameWidth: 148
           frameHeight: 85
           frameDuration: 200
           frameX: 0
           frameY: 0
}
       Sprite
       {
           name:"mid"
           source: "/合金弹头/MetalSlug/assets/touxiang/touxiang.png"
           frameCount:9;
           frameWidth: 148
           frameHeight: 85
//           frameRate: 5//控制动画速率
           frameDuration: 200
           frameX: 0
           frameY: 0
      }

}
 }
 }








