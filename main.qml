import QtQuick 2.0
import QtQuick.Window 2.15
import QtMultimedia 5.15
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3


Window {
    id:root
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property int selectedIndex: -1


        MediaPlayer {
             id: player;
             volume: volumeSlider.volume
             source: url
             playlist: Playlist{
                 id:playlist
             }
         }

        ListView {
            id:listview
            width:parent.width/2
            height: parent.height
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            model: playlist;
            spacing: 5
             delegate: Rectangle{
                 width: listview.width
                 border.color: (model.index == root.selectedIndex) ? "red" : "gray"
                 height: 25
                 Text {
                     id: songUrl
                     text: source
                     visible: true
                 }
                 Text {
                     id: songname
                     text: sou
                 }
                 MouseArea{
                     id:delegatemousearea
                     anchors.fill:parent
                     onClicked: {
                         root.selectedIndex = model.index
                     }
                     onDoubleClicked: {
                         playlist.moveItem(root.selectedIndex,0)
                         playlist.previous()
                         player.play()
                     }
                 }
              }
         }

        Label{
            id:label
            anchors.bottom: progresstime.top
            anchors.left: add.right
            text: player.metaData.title + " " + player.metaData.albumArtist
        }
        Image {
            id: songImage
            height: parent.height-next.height-add.height-label.height-progresstime.height
            width: parent.width-listview.width
            anchors.bottom: label.top
            anchors.right: pause.right
            source: (player.metaData.posterUrl!=="undefind")?"qrc:/png-transparent-color-drawing-headphones-illustration-musical-note-game-photography-stage.png":player.metaData.posterUrl
}
         FileDialog{
             id:add_File
             nameFilters: ["Song files(*.mp3)"]
             onAccepted: {
                 playlist.addItem(fileUrl);
             }
         }

    Button{
        id:add
        text: "add"
        anchors.bottom: privious.top
        anchors.right: privious.right
        anchors.bottomMargin: 5
        onClicked: {
            add_File.open()
        }
    }
    Button{
        id:privious
        text:"privious"
        anchors.right: play.left
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5
        onClicked: {
            playlist.previous();
        }
    }

    Button{
        id:next
        text: "next"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5
        onClicked: {
            playlist.next();
        }
    }
    Button{
        id:play
        text: "play"
        anchors.right: pause.left
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        onClicked: {
            player.play();
        }
    }
    Button{
        id:pause
        text: "pause"
        anchors.right: next.left
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        onClicked: {
            player.pause();
        }
    }
    Slider {
        id: volumeSlider
        anchors.left: add.right
        anchors.bottom: add.bottom
        anchors.leftMargin: 5
        property real volume: QtMultimedia.convertVolume(volumeSlider.value,
                                                         QtMultimedia.LogarithmicVolumeScale,
                                                         QtMultimedia.LinearVolumeScale)
    }
    Slider{
        id:progresstime
        anchors.bottom: volumeSlider.top
        anchors.left: add.left
        anchors.right: next.right
        from: 0
        to: player.duration
        stepSize: 1000

        onPressedChanged: {
            if (!pressed && player.seekable)
            player.seek(progresstime.value)
        }
        Connections{
            target: player
            onPositionChanged:{
              progresstime.value=player.position
            }
        }

    }
     }

