const fragment = new DocumentFragment();
const url = '/tests';
const itemsPerPage = 10
let currentPage = 1;

fetch(url).
  then((response) => response.json()).
  then((data) => {
    data.forEach(function(patient) {
      patient.data_nascimento_paciente = new Date(patient.data_nascimento_paciente);
      patient.data_exame = new Date(patient.data_exame);
      const li = document.createElement('li');
      li.innerHTML = `<h2>Cód. Exame: ${patient.id}</h2
      
      <h3>Pacientes</h3>
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
      ${patient.tests.map(test => `<li>${test.tipo_exame} - Limites: ${test.limites_tipo_exame} - Resultado: ${test.resultado_tipo_exame}</li>`).join('')}
    </ul>
       
      </div>`
      li.classList.add('item-exam');
      fragment.appendChild(li);
    })
  }).
  then(() => {
    document.querySelector('ul').appendChild(fragment);
  }).
  catch(function(error) {
    console.log(error);
  });
