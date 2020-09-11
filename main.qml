import QtQuick 2.12
import QtGraphicalEffects 1.0
import SddmComponents 2.0

Rectangle {
  id: root

  width: 640
  height: 480

  color: "#e3e2df"

  Connections {
    target: sddm
    function onLoginSucceeded() {
      debugConsole.text += 'Success!\n';
    }
    function onLoginFailed() {
      debugCOnsole.text += 'Failed!\n';
      passwordEntry.text = '';
    }
  }

  Background {
    anchors.fill: parent
    source: 'sample.jpg'
    fillMode: Image.PreserveAspectCrop
  }

  // Debug console.
  Rectangle {
    y: 30
    width: 200
    height: 300
    color: '#80000000'
    Text {
      id: debugConsole
      anchors.fill: parent
      text: 'Debug console\n'
      color: 'white'
      font.pixelSize: 12
    }
  }

  Rectangle {
    id: menuBar

    x: 0
    y: 0
    width: root.width
    height: 30
    color: '#30f0f0f0'

    ComboBox {
      id: sessions

      width: 200
      height: parent.height

      model: sessionModel
      index: sessionModel.lastIndex

      borderWidth: 0
      color: 'transparent'
      arrowColor: 'transparent'

      font.pixelSize: 14
    }
  }

  Item {
    id: loginArea

    anchors.centerIn: root
    width: root.width * 0.6
    height: root.height * 0.6

    property var model: userModel
    property var currentUser: userModel.lastUser

    Rectangle {
      width: 1000
      height: 30
      color: 'red'
      Repeater {
        id: userModelData

        property var users: Object()

        model: loginArea.model
        // Dummy item for collect data.
        delegate: Text {
          visible: false
          text: ''
          font.pixelSize: 9
          Component.onCompleted: {
            userModelData.users[index] = {
              'name': name,
              'realName': realName,
              'icon': icon,
            };
            userModelData.usersChanged();
          }
        }
      }
    }
    Image {
      id: face
      source: userModelData.users[userModel.lastIndex].icon

      width: 100
      height: 100
    }

    Text {
      x: 120
      y: 10
      width: 100
      height: 30
      text: userModelData.users[userModel.lastIndex].name
    }

    TextField {
      id: userEntry

      x: 0
      y: 50
      width: 200
      height: 32
    }

    TextField {
      id: passwordEntry

      x: 0
      y: 100
      width: 200
      height: 32

      echoMode: TextInput.Password
    }

    Rectangle {
      x: 100
      y: 50
      width: 50
      height: 50

      color: "blue"
      MouseArea {
        anchors.fill: parent
        onClicked: {
          debugConsole.text += userEntry.text;
          sddm.login(userEntry.text, passwordEntry.text, session.index);
        }
      }
    }
  }
}
