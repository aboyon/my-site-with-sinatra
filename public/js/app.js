$().ready(function(){

  var backgrounds = ['/img/music-equalizer.jpg', '/img/music-record-player.jpg', '/img/back-1.jpg', '/img/back-2.jpg','/img/scarface-red.jpg','/img/jamiroquai.jpg','/img/preparado-surfer.jpg'];

  var background = backgrounds[Math.floor(Math.random()*backgrounds.length)]

  $(document.body).css('background-image', 'url('+background+')');

});