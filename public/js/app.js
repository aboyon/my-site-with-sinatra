$().ready(function(){

  var backgrounds = ['/img/back-1.jpg', '/img/back-2.jpg','/img/scarface-red.jpg','/img/jamiroquai.jpg'];

  var background = backgrounds[Math.floor(Math.random()*backgrounds.length)]

  $(document.body).css('background-image', 'url('+background+')');

});