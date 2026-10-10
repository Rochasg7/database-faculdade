# Banco de Dados | Portal Estudantil e exercícios de SQL

Repositório da disciplina de **Banco de Dados** (UNIVÁS). Reúne a modelagem e a implementação em **MySQL** de um sistema acadêmico, o **Portal Estudantil**, além dos scripts SQL praticados ao longo das aulas.

## Trabalho principal: Portal Estudantil

Sistema acadêmico para universidades, para gerenciar com organização e segurança os dados de alunos, professores, cursos e matérias. Trabalho desenvolvido em equipe.

**Funcionalidades previstas no levantamento de requisitos** (`Trabalho02/Base do projeto 01.jpeg`):

- **Aluno:** matrícula em curso, pagamento de mensalidade, visualização das suas matérias e contato com a faculdade
- **Professor:** escolha e visualização das turmas, escolha das matérias que vai ministrar, registro de atividades e provas, de presença e de notas
- **Corpo docente:** emissão de boleto de pagamento e contato com funcionários
- **Secretaria:** registro de entrada na faculdade, montagem das turmas e atribuição de cargos

O script `Criacao Tabelas.sql` implementa o **núcleo** desses requisitos: usuários, alunos, professores, cursos, matérias e matrícula. Turmas, notas e presença, mensalidade e boleto, e as entidades `Cargos` e `Contratos` (previstas na folha de entidades, `Base do projeto 02.jpeg`) ficaram para uma próxima etapa.

### Modelo do banco

![Modelo entidade-relacionamento do Portal Estudantil](Trabalho02\TabelasMER.png)

| Tabela | Papel |
|---|---|
| `usuario` | Login, hash da senha e cargo de quem acessa o sistema |
| `aluno` | Dados do aluno, ligado a um `usuario` |
| `professor` | Dados do professor, ligado a um `usuario` |
| `curso` | Cursos oferecidos |
| `materia` | Matérias, com horário, sala e professor responsável |
| `matricula` | Matrícula de um aluno em um curso (N:N) |
| `professor_curso` | Tabela associativa entre professores e cursos (N:N) |
| `curso_materia` | Tabela associativa entre cursos e matérias (N:N) |

**Regras de negócio iniciais** (`Trabalho02/Base do projeto 02.jpeg`) e como o modelo as trata:

| Regra do levantamento | No modelo |
|---|---|
| Um curso precisa existir para o aluno ser matriculado nele | Atendida: `matricula.codCurso` é `NOT NULL` com chave estrangeira |
| Cada matrícula é vinculada a apenas um aluno | Atendida: `matricula.codAluno` é `NOT NULL` com chave estrangeira |
| Um professor pode ministrar mais de uma matéria | Atendida: várias linhas de `materia` podem apontar para o mesmo `codProfessor` |
| O aluno acessa apenas as matérias em que está inscrito | Por consulta: `matricula` → `curso_materia` → `materia`; o bloqueio de acesso é responsabilidade da aplicação |
| Um secretário realiza o cadastro dos alunos | Parcial: o cargo fica em `usuario.cargo` (texto livre); não há tabela de cargos nem controle de permissão |
| O número de alunos em um curso não pode exceder a capacidade máxima | Não modelada: `curso` não tem coluna de capacidade (exigiria também uma regra de validação, como um `TRIGGER`) |

**Decisões de modelagem e integridade**
- Chaves primárias `AUTO_INCREMENT` e chaves estrangeiras nomeadas em todas as tabelas
- Relacionamentos muitos-para-muitos resolvidos com tabelas associativas, com `UNIQUE` para impedir vínculos duplicados
- `UNIQUE` em login, CPF e matrícula, e relação 1:1 entre `usuario` e seu perfil (aluno ou professor)
- Senhas armazenadas como hash (`SHA2`), nunca como texto puro
- Exclusões pensadas para preservar histórico: apagar um usuário com perfil ou um curso com matrículas é bloqueado (`RESTRICT`); apagar um aluno remove apenas suas matrículas (`CASCADE`); apagar um professor mantém a matéria, sem responsável (`SET NULL`)

> O diagrama original do trabalho (`Trabalho02/Tabelas MER.jpeg`) mostra a primeira versão do modelo, em que `curso` guardava `codAluno`, `codProfessor` e `codMateria`. Na versão atual essas colunas foram removidas, porque duplicavam as tabelas associativas, e a matrícula do aluno ganhou tabela própria. O diagrama acima (`Trabalho02/MER-atualizado.png`) reflete o script `Criacao Tabelas.sql`.

Documentação do trabalho: [`Trabalho02/Modelo-relacionamento.pdf`](Trabalho02/Modelo-relacionamento.pdf)

### Consultas de exemplo

```sql
-- Alunos com seu login e cargo de acesso
SELECT a.nome AS aluno, u.login, u.cargo
FROM aluno a
INNER JOIN usuario u ON u.codUsuario = a.codUsuario;

-- Cursos, matérias e professor responsável por cada matéria
SELECT c.nome AS curso, m.nome AS materia, p.nome AS professor
FROM curso c
INNER JOIN curso_materia cm ON cm.codCurso = c.codCurso
INNER JOIN materia m        ON m.codMateria = cm.codMateria
LEFT JOIN  professor p      ON p.codProfessor = m.codProfessor;

-- Quantidade de alunos matriculados por curso
SELECT c.nome AS curso, COUNT(mt.codMatricula) AS total_matriculas
FROM curso c
LEFT JOIN matricula mt ON mt.codCurso = c.codCurso AND mt.situacao = 'Ativa'
GROUP BY c.codCurso, c.nome
ORDER BY total_matriculas DESC;
```

## Exercícios das aulas (`Comandos SQL/`)

Scripts de prática organizados por data de aula. Cada um recria o próprio schema, então pode ser executado quantas vezes quiser.

| Script | Assunto | Schema |
|---|---|---|
| `Aula 29-04.sql` | Chaves primárias e estrangeiras, `ALTER TABLE`, `CASCADE` | `chaves` |
| `Aula 30-04.sql` | Modelagem de uma marmitaria (7 tabelas) | `marmitaria` |
| `Aula 06-05.sql` | `INSERT`, `SELECT`, `UPDATE` e `DELETE` (**executar depois da Aula 30-04**) | `marmitaria` |
| `Aula 07-05.sql` | Modelagem de ordens de serviço (6 tabelas) | `ordens_servico` |
| `Aula 13-05.sql` | `WHERE`, `IN`, `BETWEEN`, `LIKE`, `ORDER BY` e apelidos (**executar depois da Aula 07-05**) | `ordens_servico` |
| `Aula 14-05.sql` | Escola: filtros, `JOIN` e `GROUP BY` | `escola` |

## Modelagem conceitual (`BRModelo/`)

Modelos feitos no **brModelo**, com os arquivos `.brM3` editáveis e as imagens exportadas em `BRModelo/Imagens/`. Entre eles, o modelo de uma livraria (livros, editoras, estoque, clientes, endereços e pedidos de compra) e exercícios de cardinalidade entre entidades.

## Como executar

1. Abra o **DBeaver** e conecte ao seu servidor **MySQL** (8 ou superior).
2. Abra `Trabalho02/Criacao Tabelas.sql` e execute o script inteiro (**Alt+X**). Ele recria o schema `portal_estudantil`, as tabelas, os dados de exemplo e as consultas.
3. Para os exercícios, execute os scripts de `Comandos SQL/` na ordem indicada na tabela acima.

> Os scripts usam `DROP SCHEMA IF EXISTS` para recriar os schemas do zero. Se você já tiver um schema com o mesmo nome (`portal_estudantil`, `chaves`, `marmitaria`, `ordens_servico` ou `escola`), ele será apagado.

## Estrutura

```
database-faculdade/
├── BRModelo/        modelos conceituais (.brM3) e imagens exportadas
├── Comandos SQL/    scripts SQL das aulas
├── Trabalho02/      Portal Estudantil: requisitos, MER, documentação e script de criação
└── README.md
```

## Tecnologias

SQL · MySQL · DBeaver · brModelo · Git · GitHub
