(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){

document.addEventListener('DOMContentLoaded', function() {
  var paths = document.querySelectorAll('svg path');

  paths.forEach(function(path) {
      path.addEventListener('mouseenter', function() {
          var departement = this.getAttribute('class');
          const codeDepartement = departement?.substr(16, 18);
          if (codeDepartement) getOffersCount(codeDepartement);
      });
  
     path.addEventListener('click', function() {
        var departement = this.getAttribute('class');
        console.log(departement);
     });
  });
});

function getOffersCount(codeDepartement) {

  const url = `/departement/${codeDepartement}`
  fetch(url)
   .then(response =>  response.json())
   .then(data => {
    console.log(data)
    document.getElementById('num').textContent = 'Département n°' + codeDepartement + ':  ' + data.data.name ;
    document.getElementById('count').textContent = 'Nombre Offres: ' + data.data.count;

   })
   .catch(error => {
    console.error("Error:", error)
   })
}
},{}]},{},[1]);
