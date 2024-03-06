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
      li.innerHTML = `<h2>Cód. Exame: ${patient.id}</h2>

      
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
        <strong>Nome:</strong> ${patient.nome_medico} |
        <strong>CRM:</strong> ${patient.crm_medico} |
        <strong>CRM Estado:</strong> ${patient.crm_medico_estado} |
        <strong>Email:</strong> ${patient.email_medico}
      </div>
      <h3>Exame</h3>
      <div class='data-exam'> 
        <strong>Token do exame:</strong> ${patient.token_resultado_exame}
        <strong>Data do exame:</strong> ${patient.data_exame.toLocaleDateString('pt-BR')} |
        <strong>Tipo do exame:</strong> ${patient.tipo_exame} |
        <strong>Limites:</strong> ${patient.limites_tipo_exame} |
        <strong>Resultado:</strong> ${patient.resultado_tipo_exame}
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
