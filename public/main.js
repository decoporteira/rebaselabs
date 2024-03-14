const fragment = new DocumentFragment();
let url = '/tests';

function fetchExams(link) {
  fetch(link)
    .then(response => response.json())
    .then(data => {
      
      if (data.length == 0) {
        document.querySelector('h2').innerHTML = 'Nenhum exame encontrado';
      } else {
        data.forEach(function(patient) {
          patient.data_nascimento_paciente = new Date(patient.data_nascimento_paciente);
          patient.data_exame = new Date(patient.data_exame);
         
          const li = document.createElement('li');
          li.innerHTML = `<h2>Token do Exame: ${patient.token_resultado_exame}</h2>
          
          <h3>Paciente</h3>
          <div class='data-patient'> 
            <strong>Nome:</strong> ${patient.nome_paciente} | 
            <strong>Nascimento:</strong> ${patient.data_nascimento_paciente.toLocaleDateString('pt-BR')} | 
            <strong>Endereço:</strong> ${patient.endereco_paciente} | 
            <strong>Cidade:</strong> ${patient.cidade_paciente} | 
            <strong>Estado:</strong> ${patient.estado_paciente} 
          </div>
          <h3>Médico</h3>
          <div class='data-doctor'> 
            <strong>Nome:</strong> ${patient.doctor.nome_medico} |
            <strong>CRM:</strong> ${patient.doctor.crm_medico} |
            <strong>CRM Estado:</strong> ${patient.doctor.crm_medico_estado} |
            <strong>Email:</strong> ${patient.doctor.email_medico}
          </div>
          <h3>Exame</h3>
          <div class='data-exam'> 
            <strong>Token do exame:</strong> ${patient.token_resultado_exame}
            <strong>Data do exame:</strong> ${patient.data_exame.toLocaleDateString('pt-BR')} |
          </div>
          <h3>Resultados</h3>
          <div class='result-exam'> 
            <ul>
            <table>
  <thead>
    <tr>
      <th>Tipo de Exame</th>
      <th>Limites</th>
      <th>Resultado</th>
    </tr>
  </thead>
  <tbody>
    ${patient.tests.map(test => `
      <tr class='tr-exams'>
        <td><strong>${test.tipo_exame}</strong></td>
        <td>${test.limites_tipo_exame}</td>
        <td>${test.resultado_tipo_exame}</td>
      </tr>
    `).join('')}
  </tbody>
</table>
          </ul>
            
          </div>`;
          li.classList.add('item-exam');
          fragment.appendChild(li);
        });
      }
    })
    .then(() => {
      document.querySelector('ul').innerHTML = ''; 
      document.querySelector('ul').appendChild(fragment);
    })
    .catch(error => {
      console.error('Erro ao buscar dados:', error);
    });
}

fetchExams(url);

document.getElementById('searchForm').addEventListener('submit', function(event) {
  event.preventDefault();

  const query = document.getElementById('query').value;
  if (!query) {
    const searchUrl = '/tests';
    fetchExams(searchUrl);
  } else {
    const searchUrl = `/tests/${encodeURIComponent(query)}`;
    fetchExams(searchUrl);
  }
});
