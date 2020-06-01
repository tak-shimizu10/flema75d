// 商品削除のモーダル
$(function(){
  $('.item-main').on('click','.item-delete-btn',function(){
      $('.js-modal').fadeIn();
      return false;
  });
  $('.js-modal-close').on('click',function(){
      $('.js-modal').fadeOut();
      return false;
  });
});