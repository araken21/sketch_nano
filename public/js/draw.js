'use strict';

$(function () {
  var $canvas = $('canvas');
  var $clear = $('.clear')
  var $in_text = $('#in_text')
  var canvas = $canvas[0];
  var width = canvas.width;
  var height = canvas.height;

  var context2d = canvas.getContext('2d'); //contextを取ってくる。背景
  var isDrawing = false;

  // 画面を真っ白にする
  context2d.fillStyle = '#fff';
  context2d.fillRect(0, 0, width, height);

  // マウスを押し始めた時
  $canvas.mousedown(function (e) {

    if ($in_text.val() != "" ) {
      return;
    }

    var x = e.originalEvent.layerX; // 行き先
    var y = e.originalEvent.layerY; // 行き先
    var $stroke = $('#stroke');
    var stroke = $stroke.val();
    context2d.lineWidth = stroke;
    var $pen_color = $('#pen_color');
    var pen_color = $pen_color.val();
    context2d.strokeStyle = pen_color; //htmlの中にJSで使える仕様が書かれている
    context2d.lineJoin = 'round'
    context2d.lineCap = 'round'
    context2d.beginPath();
    context2d.moveTo(x, y);
    isDrawing = true;
  });

  $clear.on("click",function(){
    $("#draw_canvas")[0].getContext('2d').clearRect(0,0,640,480);
  }
);

  // マウスを動かしているあいだ中
  $canvas.mousemove(function (e) {
    var x = e.originalEvent.layerX; // 行き先
    var y = e.originalEvent.layerY; // 行き先

    if ($in_text.val() != "" ) {
      return;
    }

    if (isDrawing) {
      context2d.lineCap = "round";
      context2d.lineTo(x, y);
      context2d.stroke();
    }
  });

  // マウスを離した時
  $canvas.mouseup(function (e) {
    isDrawing = false;

    if ($in_text.val() != "" ) {
      context2d.fillStyle = $('#pen_color').val()
      context2d.fillText($in_text.val(),
      e.originalEvent.layerX,
      e.originalEvent.layerY
    );}
  });

  // マウスがキャンバスの外に出た時時
  $canvas.mouseleave(function (e) {
    isDrawing = false;
  });

  // 保存
  $('button.save').click(function (e) {
    var dataUrl = canvas.toDataURL();
    var title = $('.drawbox input[name=title]').val();
    var adult = $('.drawbox input[name=adult]').prop("checked"); //cmd shift d


    $.post('/draw', {
      src: dataUrl,
      title: title,
      adult: adult,
    }, function (result) {
      alert('保存しました！');
      // 画面を真っ白にする
      context2d.fillStyle = '#FFF';
      context2d.fillRect(0, 0, width, height);
    });
  });
});
