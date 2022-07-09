import Felgo 3.0
import QtQuick 2.15

GameWindow {
  id: gameWindow
  property bool gameWon
  property bool splashFinished: false
  onSplashScreenFinished: { splashFinished = true}
  property int sodliersDestroyed
  onSodliersDestroyedChanged: {
    if(sodliersDestroyed > 30) {
      changeToGameOverScene(true)       //消灭30个敌人则进入胜利界面，可以自行修改数量
    }
  }

  activeScene: gameScene

  screenWidth: 960
  screenHeight: 640

  GameScene {                   //游戏界面
    id: gameScene
    visible: false
  }
  Scene {                       //游戏结束界面
    id: gameOverScene
    visible: false
    BackgroundImage
    {
        anchors.fill:parent
        source: "../assets/background/background2.jpg"
    }
    Text {
      anchors.centerIn: parent
      text: gameWon ? "You won\n   点击界面可以再来一次" : "You lost\n   点击屏幕可以再来一次"
      color: "red"
    }

    onVisibleChanged: {
      if(visible) {
        returnToGameSceneTimer.start()
      }
    }

    TapHandler{
        onTapped: {
            startScene.visible = false
            gameScene.visible = true
            gameOverScene.visible = false
        }
    }
  }// GameOverScene
  Scene                         //游戏开始界面
  {
     id:startScene
     visible:true
     BackgroundImage
     {
         anchors.fill:parent
         source: "../assets/background/background2.jpg"
     }

     Text {
       anchors.centerIn: parent
       text: "点击界面开始游戏"
       color: "red"
     }
     onVisibleChanged: {
       if(visible) {
        gotoToGameSceneTimer.start()
       }
     }

    TapHandler{
        onTapped:{
            startScene.visible = false
            gameScene.visible = true
            gameOverScene.visible = false
        }
     }
  }//GameStar
  function changeToGameOverScene(won) {
    gameWon = won
    gameOverScene.visible = true
    gameScene.visible = false
    sodliersDestroyed = 0
    entityManager.removeEntitiesByFilter(["pistolbullet","enemy","player"])

  }

}

