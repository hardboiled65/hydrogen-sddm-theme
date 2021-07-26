import QtQuick 2.12
import QtQuick.Layouts 1.12
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
      debugConsole.text += 'Failed!\n';
      passwordEntry.text = '';
    }
  }

  Background {
    anchors.fill: parent
    source: 'images/metal-texture.png'
    fillMode: Image.Tile
  }

  // Debug console.
  Rectangle {
    y: 30
    width: 200
    height: 300
    color: '#80000000'
    Text {
      text: root.width + 'x' + root.height
      color: 'white'
      font.pixelSize: 14
    }

    Text {
      id: debugConsole
      anchors.fill: parent
      anchors.topMargin: 14
      text: 'Debug console\n'
      color: 'white'
      font.pixelSize: 14
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
      width: 0
      height: 0
      color: 'red'
      Repeater {
        id: userModelData

        property var users: Object()

        model: loginArea.model
        // Dummy item for collect data.
        delegate: Text {
          visible: false
          text: ''
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

    Item {
      anchors.fill: parent

//      spacing: 16

      Face {
        id: face

        anchors.horizontalCenter: parent.horizontalCenter

        source: userModelData.users[userModel.lastIndex].icon

        width: root.height / 8.4375
        height: root.height / 8.4375
      }

      Rectangle {
        id: displayNameRect

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: face.bottom
        anchors.topMargin: 16

        width: displayName.implicitWidth + 30
        height: displayName.implicitHeight + 14
        radius: 25
        color: "#e3e2df"
        Text {
          id: displayName

          anchors.centerIn: parent
          text: this.realNameOrName(userModelData.users[userModel.lastIndex])

          function realNameOrName(user) {
            if (user.realName !== '') {
              return user.realName;
            } else {
              return user.name;
            }
          }
        }
      }

      QtObject {
        id: userEntry

        property string text: userModel.lastUser
      }

      TextField {
        id: passwordEntry

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: displayNameRect.bottom
        anchors.topMargin: 16

        width: 200
        height: 38

        echoMode: TextInput.Password

        onKeyPressed: {
          sddm.login(userEntry.text, passwordEntry.text, session.index);
        }
      }

      //===============================
      // System buttons
      //===============================
      RowLayout {
        id: systemButtons

        readonly property real systemButtonSize: root.height / 16.875

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        SystemButton {
          Layout.preferredWidth: systemButtons.systemButtonSize
          Layout.preferredHeight: systemButtons.systemButtonSize

          text: 'Suspend'
          source: ''
        }
        SystemButton {
          Layout.preferredWidth: systemButtons.systemButtonSize
          Layout.preferredHeight: systemButtons.systemButtonSize

          text: 'Restart'
          source: 'images/reboot.svg'
        }
      }
    }

    Rectangle {
      x: 100
      y: 50
      width: 50
      height: 50

      color: "blue"
      radius: 50
      MouseArea {
        anchors.fill: parent
        onClicked: {
          debugConsole.text += userEntry.text;
          sddm.login(userEntry.text, passwordEntry.text, session.index);
        }
      }
    }

    Rectangle {
      anchors.fill: parent

      color: '#20ff0000'
    }
  } // loginArea
}
