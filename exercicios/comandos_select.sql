-- 1. Listar todos os dados de todas as pessoas cadastradas.
SELECT *
FROM Pessoa;

-- 2. Listar nome, e-mail e data de nascimento das pessoas cadastradas.
SELECT nome, email, data_nascimento
FROM Pessoa;

-- 3. Listar nome, e-mail e data de nascimento da 3ª à 8ª pessoa cadastrada.
SELECT nome, email, data_nascimento
FROM Pessoa
ORDER BY nome
OFFSET 2 LIMIT 6;

-- 4. Listar nome, e-mail e idade das pessoas cadastradas.
SELECT
    nome,
    email,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) AS idade
FROM Pessoa;

-- 5. Listar a quantidade de agendamentos.
SELECT COUNT(*) AS quantidade_agendamentos
FROM Agendamento;

-- 6. Listar a data/hora das consultas e os respectivos valores com desconto de 5%.
SELECT
    dh_consulta,
    'R$ ' || TO_CHAR(valor_consulta * 0.95, 'FM999999990.00') AS valor_com_desconto
FROM Agendamento;

-- 7. Listar nome, CPF e e-mail dos pacientes que não possuem plano de saúde.
SELECT
    p.nome,
    p.cpf,
    p.email
FROM Pessoa p, Paciente pa
WHERE 
    p.cpf = pa.cpf_pessoa
    AND pa.plano_saude = FALSE;

-- 8. Listar os dados dos agendamentos registrados para o mesmo mês da consulta.
SELECT *
FROM Agendamento
WHERE 
    EXTRACT(MONTH FROM dh_agendamento) =
    EXTRACT(MONTH FROM dh_consulta);

-- 9. Listar CPF, nome e e-mail dos pacientes que não possuem telefone.
SELECT
    p.cpf,
    p.nome,
    p.email
FROM Pessoa p, Paciente pa
WHERE 
    p.cpf = pa.cpf_pessoa
    AND p.telefone IS NULL;

-- 10. Listar a data das consultas cujo valor está entre R$ 50,00 e R$ 100,00.
SELECT dh_consulta
FROM Agendamento
WHERE valor_consulta BETWEEN 50.00 AND 100.00;

-- 11. Listar CPF, nome e e-mail dos pacientes que moram em "Natal".
SELECT
    p.cpf,
    p.nome,
    p.email
FROM Pessoa p, Paciente pa
WHERE 
    p.cpf = pa.cpf_pessoa
    AND p.endereco LIKE '%Natal%';

-- 12. Listar CPF, nome, e-mail e data de nascimento dos pacientes ordenados pela data de nascimento.
SELECT
    p.cpf,
    p.nome,
    p.email,
    p.data_nascimento
FROM Pessoa p, Paciente pa
WHERE p.cpf = pa.cpf_pessoa
ORDER BY p.data_nascimento;

-- 13. Listar a quantidade de pacientes que não possuem plano de saúde.
SELECT COUNT(*) AS quantidade
FROM Paciente
WHERE plano_saude = FALSE;

-- 14. Listar o maior e o menor valor das consultas agendadas para cada dia.
SELECT
    DATE(dh_consulta) AS data_consulta,
    MAX(valor_consulta) AS maior_valor,
    MIN(valor_consulta) AS menor_valor
FROM Agendamento
GROUP BY DATE(dh_consulta)
ORDER BY data_consulta;

-- 15. Listar a média dos valores das consultas agendadas para o mês de dezembro.
SELECT AVG(valor_consulta) AS media_valor
FROM Agendamento
WHERE EXTRACT(MONTH FROM dh_consulta) = 12;

-- 16. Listar nome e e-mail das pessoas que agendaram consulta para o dia do seu aniversário.
SELECT
    p.nome,
    p.email
FROM Pessoa p, Paciente pa, Agendamento a
WHERE 
    p.cpf = pa.cpf_pessoa
    AND pa.cpf_pessoa = a.cpf_paciente
    AND EXTRACT(DAY FROM p.data_nascimento) = EXTRACT(DAY FROM a.dh_consulta)
    AND EXTRACT(MONTH FROM p.data_nascimento) = EXTRACT(MONTH FROM a.dh_consulta);

-- 17. Listar o nome, e-mail, CPF dos médicos e suas respectivas especialidades.
SELECT
    p.nome,
    p.email,
    p.cpf,
    e.descricao AS especialidade
FROM Pessoa p, Medico m, MedicoEspecialidade me, Especialidade e
WHERE 
    p.cpf = m.cpf_pessoa
    AND m.cpf_pessoa = me.cpf_medico
    AND me.id_especialidade = e.id
ORDER BY p.nome, e.descricao;

-- 18. Listar a quantidade de consultas para cada médico.
SELECT
    p.nome,
    p.cpf,
    COUNT(a.dh_consulta) AS quantidade_consultas
FROM Pessoa p, Medico m, Agendamento a
WHERE 
    p.cpf = m.cpf_pessoa
    AND m.cpf_pessoa = a.cpf_medico
GROUP BY p.nome, p.cpf
ORDER BY p.nome;