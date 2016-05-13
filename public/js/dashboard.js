'use strict'

$(function () {
  $('button.like').click(function (e) {
    var $clicked = $(this);
    var dataId   = $clicked.data('id');
    var likes    = $clicked.text();
    $.post('/api/like',{
      id: dataId
    });
    $clicked.text(parseInt(likes, 10) + 1);
  });
});




// function postList() {
//   $.post(
//       "http://konome.org/put.php",
//       {'name': $("#name").val(), 'prj': $("#prj").val()},
//       alert("登録しました")
//   );
//   getList();
// }
