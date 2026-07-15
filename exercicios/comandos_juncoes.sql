-- 1. Listar o nome, e-mail e CRM dos médicos.
SELECT p.nome, p.email, m.crm
FROM 
    Pessoa p
    INNER JOIN Medico m ON (p.cpf = m.cpf_pessoa);  

-- 2. Listar o nome, e-mail e senha dos pacientes.
SELECT p.nome, p.email, pa.senha
FROM Pessoa p
    INNER JOIN Paciente pa ON (p.cpf = pa.cpf_pessoa);

-- 3. Listar os CRM dos médicos e as descrições das suas respectivas especialidades.
SELECT m.crm, e.descricao
FROM 
    Medico m
    INNER JOIN MedicoEspecialidade me ON (m.cpf_pessoa = me.cpf_medico)
    INNER JOIN Especialidade e ON (me.id_especialidade = e.id);

-- 4. Listar o CRM de todos os médicos cardiologistas.
SELECT m.crm
FROM 
    Medico m
    INNER JOIN MedicoEspecialidade me ON (m.cpf_pessoa = me.cpf_medico)
    INNER JOIN Especialidade e ON (me.id_especialidade = e.id)
WHERE e.descricao = 'Cardiologia';

-- 5. Listar o nome, CPF, CRM e senha dos pacientes que também são médicos.
SELECT p.nome, p.cpf, m.crm, pa.senha
FROM 
    Pessoa p
    INNER JOIN Paciente pa ON (p.cpf = pa.cpf_pessoa)
    INNER JOIN Medico m ON (p.cpf = m.cpf_pessoa);

-- 6. Listar o nome dos médicos e as respectivas quantidades de consultas agendadas.
-- Alguns médicos podem não ter consultas.
SELECT
    p.nome,
    COUNT(a.dh_consulta) AS quantidade_consultas
FROM 
    Pessoa p
    INNER JOIN Medico m ON (p.cpf = m.cpf_pessoa)
    LEFT JOIN Agendamento a ON (m.cpf_pessoa = a.cpf_medico)
GROUP BY p.nome
ORDER BY p.nome;

-- 7. Listar as especialidades e a quantidade de médicos cadastrados nessa especialidade.
-- Algumas especialidades podem não possuir médicos.
SELECT
    e.descricao,
    COUNT(me.cpf_medico) AS quantidade_medicos
FROM 
    Especialidade e
    LEFT JOIN MedicoEspecialidade me ON (e.id = me.id_especialidade)
GROUP BY e.descricao
ORDER BY e.descricao;

-- 8. Listar os dados dos agendamentos exibindo:
-- (a) nome e e-mail do paciente,
-- (b) data/hora e valor da consulta,
-- (c) nome e CRM do médico.
SELECT
    pp.nome AS paciente,
    pp.email,
    a.dh_consulta,
    a.valor_consulta,
    pm.nome AS medico,
    m.crm
FROM 
    Agendamento a
    INNER JOIN Paciente pa ON (a.cpf_paciente = pa.cpf_pessoa)
    INNER JOIN Pessoa pp ON (pa.cpf_pessoa = pp.cpf)
    INNER JOIN Medico m ON (a.cpf_medico = m.cpf_pessoa)
    INNER JOIN Pessoa pm ON (m.cpf_pessoa = pm.cpf)
ORDER BY a.dh_consulta;

-- 9. Listar a data/hora das consultas agendadas para todos os cardiologistas cadastrados.
SELECT
    a.dh_consulta
FROM 
    Agendamento a
    INNER JOIN Medico m ON (a.cpf_medico = m.cpf_pessoa)
    INNER JOIN MedicoEspecialidade me ON (m.cpf_pessoa = me.cpf_medico)
    INNER JOIN Especialidade e ON (me.id_especialidade = e.id)
WHERE e.descricao = 'Cardiologia'
ORDER BY a.dh_consulta;

-- 10. Listar o nome e CRM dos médicos e a média das suas consultas
-- agendadas para o mês de dezembro de 2020.
SELECT
    p.nome,
    m.crm,
    AVG(a.valor_consulta) AS media_consultas
FROM 
    Medico m
    INNER JOIN Pessoa p ON (m.cpf_pessoa = p.cpf)
    LEFT JOIN Agendamento a ON (
        m.cpf_pessoa = a.cpf_medico 
        AND EXTRACT(MONTH FROM a.dh_consulta) = 12
        AND EXTRACT(YEAR FROM a.dh_consulta) = 2020
    )
GROUP BY p.nome, m.crm
ORDER BY p.nome;