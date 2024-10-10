
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