def format_results(results, exam_types)

  formatted_results = results.map do |row|
    exam_types_for_exam = exam_types.select { |exam| exam['exam_id'] == row['id'] }
    {
      "token_resultado_exame": row["token_resultado_exame"],
      "id": row["id"],
      "data_exame": row["data_exame"],
      "cpf": row["cpf"],
      "nome_paciente": row["nome_paciente"],
      "email_paciente": row["email_paciente"],
      "data_nascimento_paciente": row["data_nascimento_paciente"],
      "endereco_paciente": row["endereco_paciente"],
      "cidade_paciente": row["cidade_paciente"],
      "estado_paciente": row["estado_paciente"],
      "doctor": {
        "nome_medico": row["nome_medico"],
        "crm_medico": row["crm_medico"],
        "crm_medico_estado": row["crm_medico_estado"],
        "email_medico": row["email_medico"]
      },
      "tests": exam_types_for_exam.map do |exam_row|
        {
          "tipo_exame": exam_row["tipo_exame"],
          "limites_tipo_exame": exam_row["limites_tipo_exame"],
          "resultado_tipo_exame": exam_row["resultado_tipo_exame"]
        }
      end
    }
  end
  formatted_results
end