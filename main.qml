import QtQuick 2.0
import QtQuick.Window 2.15
import QtMultimedia 5.15
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3



ApplicationWindow {
    id:root
    visible: true
    width: 640
    height: 480

    property int selectedIndex: -1
    property string letter: qsTr("Now playing")


    MediaPlayer {
        id: player;

        volume: volumeSlider.volume
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
        anchors.right: privious.left

        model: playlist;
        spacing: 5
        delegate: Rectangle{
            width: listview.width
            border.color: (model.index == playlist.currentIndex) ? "green" : "gray"
            height: 25

            Text {
                id: songName
                text: songUrl.text.replace(/.*\//,"")
            }

            Text {
                id: songUrl
                text: source
                visible: false
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
        anchors.horizontalCenter: songImage.horizontalCenter

        text:player.metaData.title == undefined || player.metaData.author == undefined
             ? listview.currentItem.songName.text
             :qsTr("%1 - %2").arg(player.metaData.author).arg(player.metaData.title)
    }

    Label {
        id: positionLabel

        anchors.right: progresstime.right
        anchors.bottom: progresstime.top


        // Текущее
        readonly property int minutes: Math.floor(player.position / 60000)
        readonly property int seconds: Math.round((player.position % 60000) / 1000)

        // Длительность в минута и секундах
        readonly property int durationMinutes: Math.floor(player.duration / 60000)
        readonly property int durationSeconds: Math.round((player.duration % 60000) / 1000)



        text: {
            var formatTime = function(date) {
                return Qt.formatTime(date, qsTr("mm:ss"))
            }
            var currentTime = formatTime(new Date(0, 0, 0, 0, minutes, seconds))
            var durationTime = formatTime(new Date(0, 0, 0, 0, durationMinutes, durationSeconds))
            return currentTime + "/" + durationTime
        }
    }

    Image {
        id: songImage

        height: parent.height-next.height-add.height-label.height-progresstime.height
        width: parent.width-listview.width

        anchors.bottom: label.top
        anchors.bottomMargin: 10
        anchors.right: changer.left
        anchors.left: listview.right
        anchors.leftMargin: 10

        source: (player.metaData.posterUrl !== undefined)? player.metaData.posterUrl :"qrc:/png-transparent-color-drawing-headphones-illustration-musical-note-game-photography-stage.png"
    }

    FileDialog{
        id:add_File

        nameFilters: ["Song files(*.mp3)"]
        selectMultiple: true

        onAccepted: {
            playlist.addItems(fileUrls);
        }
    }


    Button{
        id:add

        anchors.bottom: privious.top
        anchors.right: parent.horizontalCenter
        anchors.bottomMargin: 5


        onClicked: {
            add_File.open()
        }
    }
    Button{
        id:privious

        anchors.right: parent.horizontalCenter
        anchors.bottom: parent.bottom


        onClicked: {
            playlist.previous();
        }
    }

    Button{
        id:next

        anchors.right: songImage.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5

        onClicked: {
            playlist.next();
        }
    }

    Button{
        id:play

        anchors.left: privious.right
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom

        onClicked: {
            if(player.playbackState===MediaPlayer.PlayingState){
                player.pause()
                play.text = qsTr("play")
            }
            else{
                play.text = qsTr("pause")
                player.play()
            }
        }
    }

    Button{
        id:stop

        anchors.right: next.left
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        anchors.left: play.right
        anchors.leftMargin: 5

        onClicked: {
            player.stop();
        }
    }

    Button {
        id: changer

        property string language: Save.langugeLoad()

        icon.source: language=="en_US" ? "qrc:/united-states.png"
                                       : "qrc:/russia.png"
        icon.color: "transparent"

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5

        // При изменении текста, инициализируем установку перевода через С++ слой
        onClicked: {
            if(language=="en_US"){
                language="ru_RU"
                qmlTranslator.setTranslation(language)
            }
            else{
                language="en_US"
                qmlTranslator.setTranslation(language)
            }
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
        anchors.right: songImage.right

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
                if(progresstime.value==0 && root.visibility == Window.Hidden && (player.metaData.author == undefined || player.title == undefined))
                    systemTray.messege(letter,listview.currentItem.songName.text)
                else if(progresstime.value==0 && root.visibility == Window.Hidden)
                    systemTray.messege(letter,player.metaData.title + " " +player.metaData.author)
            }
        }

    }

    property bool quit: false

    Connections {
        target: systemTray
        onSignalShow: {
            root.show();
        }

        onSignalQuit: {
            quit = true
            close();
        }

        onSignalNext:{
            playlist.next();
        }

        onSignalPrevious:{
            playlist.previous()
        }

        onSignalIconActivated: {
            if(root.visibility == Window.Hidden) {
                root.show()
            } else {
                root.hide()
            }
        }
    }
    onClosing: {
        if(quit == false){
            close.accepted = false
            root.hide()
        } else {
            Save.languageSave(changer.language)
            Qt.quit()
        }
    }

    Connections {
        target: qmlTranslator   // был зарегистрирован в main.cpp
        onLanguageChanged: {    // при получении сигнала изменения языка
            retranslateUi()     // инициализируем перевод интерфейса
        }
    }

    // Функция перевода интерфейса
    function retranslateUi() {
        root.title= qsTr("MediaPlayer")
        if(player.playbackState===MediaPlayer.PlayingState){
            play.text = qsTr("pause")
        }
        else{
            play.text = qsTr("play")
        }
        stop.text = qsTr("stop")
        privious.text=qsTr("privious")
        next.text=qsTr("next")
        add.text=qsTr("add")
        systemTray.setTranslation()
        root.letter=qsTr("Now playing")
    }

    Component.onCompleted: {
        retranslateUi();
    }

}

