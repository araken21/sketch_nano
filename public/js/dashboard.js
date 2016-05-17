'use strict';

$(function () {
  $('#contents_main_box').freetile({selector: '.post'});
  $('input.like').click(function (e) {
    var $clicked = $(this);
    var $parent = $(this).parent();
    var dataId   = $clicked.data('id');
    var likes    = $parent.find('.like_num').html();

    $.post('/api/like', {id: parseInt(dataId, 10)},
        function (data) {
            var obj = JSON.parse(data);
            if (obj['status'] === 'delete') {
                $('.post[data-id=' + obj['id']  + ']').fadeOut('slow', function () {
                   $(this).remove();
                   $('#contents_main_box').freetile({
                     selector: '.post'
                   });
                });
            } else if (obj['status'] === 'update') {
                $('span[data-id=' + obj['id'] + ']').text(obj['likes']);
            }
        });
  });
});

$(window).load(function(){
	$('#contents_main_box').freetile({
	selector: '.post'
	});
});

///ここは鬼門　　JSイベントタイミング
