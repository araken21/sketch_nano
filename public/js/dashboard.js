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
    if (likes <= 0) {
    　　　$(this).fadeOut(0);
    　　　$(this).parent().fadeOut(0);
		     $(this).parent().parent().remove().fadeOut("slow");
       	 $('#contents_main_box').freetile({
         	selector: '.post'
         	});
    }　　
  });
});

$(function() {
	$('#contents_main_box').freetile({
	selector: '.post'
	});
});

$(window).load(function(){
	$('#contents_main_box').freetile({
	selector: '.post'
	});
});

///ここは鬼門　　JSイベントタイミング
