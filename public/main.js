const fragment = new DocumentFragment();
const url = '/tests';

fetch(url).
  then((response) => response.json()).
  then((data) => {
    data.forEach(function(patient) {
      const li = document.createElement('li');
      li.textContent = `Id: ${patient.id} | Nome: ${patient.nome_paciente}`;
      li.classList.add('item-patient');
      fragment.appendChild(li);
    })
  }).
  then(() => {
    document.querySelector('ul').appendChild(fragment);
  }).
  catch(function(error) {
    console.log(error);
  });

