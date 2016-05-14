'use strict'

$(function () {
  $('input.like').click(function (e) {
    var $clicked = $(this);
    var $parent = $(this).parent();
    var dataId   = $clicked.data('id');
    var likes    = $parent.find('.like_num').html();
    $.post('/api/like',{
      id: parseInt(dataId, 10)
    });
    $parent.find('.like_num').html(parseInt(likes, 10) - 1);
    if (likes == 0) {
    　　　$(this).fadeOut(0);
         $(this).parent().parent().fadeOut(0);
    }　　
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
