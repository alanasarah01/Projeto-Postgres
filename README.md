# SQL do Zero – Apostila de Sintaxe SQL (PostgreSQL)

Este repositório contém uma **apostila prática e passo a passo para aprender a sintaxe do SQL**, usando **PostgreSQL**, com foco em:

- entender SQL como linguagem (não decorar comandos)
- ler queries em “português”
- evitar erros clássicos de sintaxe
- aplicar SQL em cenários reais (Data Quality + JOIN)

 **Público-alvo:**  
Iniciantes absolutos em SQL, estudantes, pessoas migrando para dados, analytics ou engenharia de dados.

---

## Conteúdo do Repositório

├── apostila_sql.sql # Apostila completa (copiar e rodar no editor SQL)
├── README.md # Este arquivo


A apostila está **100% em formato SQL comentado**, pensada para ser executada **linha por linha**.

---

## O que você vai aprender

- Estrutura da linguagem SQL (`SELECT`, `FROM`, `WHERE`)
- Operadores (`=`, `<>`, `!=`, `>`, `<`, `>=`, `<=`)
- Trabalhar corretamente com `NULL`
- Filtros com `LIKE`, `ILIKE`, `NOT LIKE`
- Ordenação (`ORDER BY`)
- Junção de tabelas (`JOIN`)
- Data Quality básico (dados duplicados, inválidos, limpeza de texto)
- Funções reais de mercado (`regexp_replace`)
- Debug de SQL com exercícios de **“ache o erro”**

---

##  Pré-requisitos

Você só precisa de duas coisas:

1. **PostgreSQL** (banco de dados)
2. **DBeaver** (interface gráfica para rodar SQL)

Não é necessário saber programação antes.

---

##  Instalação do PostgreSQL

###  macOS

**Opção recomendada:** Postgres.app  
1. Acesse: https://postgresapp.com  
2. Baixe e arraste para a pasta **Applications**
3. Abra o Postgres.app (ele inicia o banco automaticamente)
4. Pronto 🎉

> Usuário padrão geralmente é seu usuário do macOS  
> Porta padrão: `5432`

---

###  Windows

1. Acesse: https://www.postgresql.org/download/windows/
2. Baixe o instalador oficial
3. Durante a instalação:
   - Defina uma senha para o usuário `postgres`
   - Mantenha a porta `5432`
4. Finalize a instalação

⚠️ **Guarde a senha**, você vai precisar no DBeaver.

---

###  Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
Verifique se está rodando:

bash
Copy code
sudo systemctl status postgresql
--
## Instalação do DBeaver (todas as plataformas)

1. Acesse: https://dbeaver.io/download/  
2. Baixe a versão **Community**  
3. Instale normalmente seguindo o assistente do sistema operacional  

---

## Conectando o DBeaver ao PostgreSQL

1. Abra o **DBeaver**  
2. Clique em **New Database Connection**  
3. Escolha **PostgreSQL**  
4. Preencha os campos:
   - **Host:** localhost  
   - **Port:** 5432  
   - **Database:** postgres (ou outro, se preferir)  
   - **Username:** postgres (ou seu usuário)  
   - **Password:** a senha definida na instalação do PostgreSQL  
5. Clique em **Test Connection**  
6. Se a conexão funcionar, clique em **Finish**

---

## Como usar a apostila

1. Abra o arquivo `apostila_sql.sql`  
2. Copie todo o conteúdo  
3. Cole no editor SQL do DBeaver  
4. Execute **um bloco por vez**, seguindo a ordem da apostila  

### Dica importante
- Não execute tudo de uma vez  
- Leia os comentários com atenção  
- Rode as queries aos poucos, observando o resultado de cada uma  

---

## Como estudar corretamente (recomendado)

- Leia os comentários em voz alta  
- Tente entender o erro antes de corrigir  
- Use os exercícios de “ache o erro” como treino real  
- Não decore: **entenda a leitura da query**

---

## Objetivo final

Ao terminar esta apostila, você será capaz de:

- Escrever queries SQL simples sem medo  
- Entender e corrigir erros de sintaxe  
- Usar SQL em ferramentas como Power BI, dbt, Looker ou Snowflake  
- Avançar para conceitos como `GROUP BY`, `CASE WHEN` e SQL analítico  

---

## Próximos passos sugeridos

- Módulo 1: GROUP BY, COUNT, SUM  
- Módulo 2: LEFT JOIN vs INNER JOIN  
- Módulo 3: SQL para entrevistas  
- Módulo 4: SQL aplicado a Data Quality  

---

## Contribuições

Sugestões, correções e melhorias são bem-vindas.  
Abra uma **Issue** ou um **Pull Request**.

---

## Autor

Criado por alguém que acredita que **SQL se aprende entendendo a linguagem, não decorando funções**.
