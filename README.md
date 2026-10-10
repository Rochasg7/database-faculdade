# Banco de Dados | Portal Estudantil e exercícios de SQL

Repositório da disciplina de **Banco de Dados** (UNIVÁS). Reúne a modelagem e a implementação em **MySQL** de um sistema acadêmico, o **Portal Estudantil**, além dos scripts SQL praticados ao longo das aulas.

## Trabalho principal: Portal Estudantil

Sistema acadêmico para universidades, para gerenciar com organização e segurança os dados de alunos, professores, cursos e matérias. Trabalho desenvolvido em equipe.

**Funcionalidades previstas no levantamento de requisitos** (`Trabalho02/Base do projeto 01.jpeg`):

- **Aluno:** matrícula em curso, visualização das matérias e contato com a faculdade
- **Professor:** escolha e visualização de turmas, escolha das matérias que vai ministrar, registro de atividades, provas, presença e notas
- **Secretaria:** registro de entrada e saída de alunos, montagem das turmas e atribuição de cargos

### Modelo entidade-relacionamento

![Modelo do Portal Estudantil](Trabalho02/Tabelas%20MER.jpeg)

| Tabela | Papel |
|---|---|
| `usuario` | Login, senha e cargo de quem acessa o sistema |
| `aluno` | Dados do aluno, ligado a um `usuario` |
| `professor` | Dados do professor, ligado a um `usuario` |
| `curso` | Cursos oferecidos |
| `materia` | Matérias, com horário, sala e professor responsável |
| `professorCurso` | Tabela associativa entre professores e cursos (N:N) |
| `cursoMateria` | Tabela associativa entre cursos e matérias (N:N) |

**Decisões de modelagem**
- Chaves primárias em todas as tabelas e chaves estrangeiras para os relacionamentos
- Relacionamentos muitos-para-muitos resolvidos com tabelas associativas
- `ON DELETE CASCADE` e `ON UPDATE CASCADE` para manter a integridade referencial
- `usuario` separado de `aluno` e `professor`, de modo que o acesso ao sistema fica independente do cadastro de cada perfil

Documentação completa do modelo: [`Trabalho02/Modelo-relacionamento.pdf`](Trabalho02/Modelo-relacionamento.pdf)

### Consultas de exemplo

```sql
-- Alunos com seu login e cargo de acesso
SELECT a.nome AS aluno, u.login, u.cargo
FROM aluno a
INNER JOIN usuario u ON u.codUsuario = a.codUsuario;

-- Cursos, matérias e professor responsável por cada matéria
SELECT c.nome AS curso, m.nome AS materia, p.nome AS professor
FROM curso c
INNER JOIN cursoMateria cm ON cm.codCurso = c.codCurso
INNER JOIN materia m ON m.codMateria = cm.codMateria
INNER JOIN professor p ON p.codProfessor = m.codProfessor;
```

## Exercícios das aulas (`Comandos SQL/`)

Scripts de prática organizados por data de aula. Cobrem:

- **DDL:** `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`, chaves primárias e estrangeiras, `NOT NULL`, `DEFAULT` e comentários de coluna
- **DML:** `INSERT`, `UPDATE` e `DELETE`
- **Consultas:** `SELECT` com `WHERE`, `AND`, `IN`, `BETWEEN`, `LIKE`, `ORDER BY` (crescente e decrescente) e apelidos de colunas e tabelas (`AS`)
- **Cenários modelados:** ordens de serviço (clientes, técnicos, serviços), pedidos de marmitas (clientes, entregadores, itens do pedido) e uma escola (alunos, professores, cursos, matrículas)

## Modelagem conceitual (`BRModelo/`)

Modelos feitos no **brModelo**, com os arquivos `.brM3` editáveis e as imagens exportadas em `BRModelo/Imagens/`. Entre eles, o modelo de uma livraria (livros, editoras, estoque, clientes, endereços e pedidos de compra) e exercícios de cardinalidade entre entidades.

## Como executar

1. Abra o **DBeaver** e conecte ao seu servidor **MySQL**.
2. Execute `Trabalho02/Criacao Tabelas.sql`. Ele cria o schema `portal_estudantil`, as tabelas, as chaves estrangeiras e insere dados de exemplo. Antes de criar as tabelas, selecione `portal_estudantil` como schema ativo (ou adicione `USE portal_estudantil;` logo após a linha do `CREATE SCHEMA`).
3. Rode as consultas de exemplo acima ou os scripts de `Comandos SQL/`.

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