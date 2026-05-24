# 🐘 SQL do Zero – Apostila de Sintaxe SQL com PostgreSQL

Este repositório contém uma apostila prática e comentada para aprender SQL do zero, usando **PostgreSQL** como banco de dados e **DBeaver** como interface gráfica.

O foco não é decorar comandos — é **entender SQL como uma linguagem**, lendo queries quase como frases em português.

## ✨ O que você vai aprender

- Estrutura da linguagem SQL (`SELECT`, `FROM`, `WHERE`)
- Operadores de comparação (`=`, `<>`, `!=`, `>`, `<`, `>=`, `<=`)
- Trabalhar corretamente com `NULL`
- Filtros com `LIKE`, `ILIKE`, `NOT LIKE`
- Ordenação com `ORDER BY`
- Junção de tabelas com `JOIN`
- Data Quality básico: dados duplicados, inválidos e limpeza de texto
- Funções reais de mercado (`regexp_replace`)
- Debug de SQL com exercícios de "ache o erro"

## 👩‍💻 Público-alvo

Iniciantes absolutos em SQL: estudantes, pessoas em transição de carreira, aspirantes a dados, analytics ou engenharia de dados.

**Não é necessário saber programação.**

---

## 📁 Estrutura do Repositório

├── Apostila_SQL_Postgres_Modulo_1_ALUNO.sql      # Módulo 1 – exercícios para o aluno
├── Apostila_SQL_Postgres_Modulo_1_GABARITO.sql   # Módulo 1 – gabarito
├── Apostila_SQL_Postgres_Modulo_2_ALUNO.sql      # Módulo 2 – exercícios para o aluno
├── Apostila_SQL_Postgres_Modulo_2_GABARITO.sql   # Módulo 2 – gabarito
├── Apostila_SQL_Postgres_Modulo_3_ALUNO.sql      # Módulo 3 – exercícios para o aluno
├── Apostila_SQL_Postgres_Modulo_3_GABARITO.sql   # Módulo 3 – gabarito
├── Apostila_SQL_Postgres_Modulo_4_ALUNO.sql      # Módulo 4 – exercícios para o aluno
├── Apostila_SQL_Postgres_Modulo_4_GABARITO.sql   # Módulo 4 – gabarito
├── Apostila_SQL_Postgres_Modulo_5_ALUNO.sql      # Módulo 5 – exercícios para o aluno
├── Apostila_SQL_Postgres_Modulo_5_GABARITO.sql   # Módulo 5 – gabarito
├── Apostila_SQL_Postgres_Modulo_6_ALUNO.sql      # Módulo 6 – exercícios para o aluno
├── Apostila_SQL_Postgres_Modulo_6_GABARITO.sql   # Módulo 6 – gabarito
├── DDL_training_customers_orders.sql             # Script DDL para criar as tabelas de treino
├── customers.csv                                 # Dados de clientes para importar
├── orders.csv                                    # Dados de pedidos para importar
├── operadores_sql.md                             # Referência rápida de operadores SQL
└── README.md                                     # Este arquivo

O repositório está organizado em **6 módulos**, cada um com dois arquivos:
- `_ALUNO` — versão para praticar, com os exercícios em aberto
- `_GABARITO` — versão com as respostas, para consultar após tentar sozinho

> 💡 **Recomendado:** sempre tente resolver o arquivo `_ALUNO` antes de abrir o `_GABARITO`.

Para usar as apostilas, comece criando as tabelas com o script `DDL_training_customers_orders.sql` e importando os dados dos arquivos `.csv`. O arquivo `operadores_sql.md` serve como referência rápida durante os estudos.


> 🔄 **Compatibilidade:** As apostilas foram escritas e testadas no **PostgreSQL**, mas a grande maioria dos comandos é compatível com outros bancos relacionais. Você pode rodar os exercícios no **MySQL** ou no **SQL Server** com pequenas adaptações pontuais (como funções de texto ou tipos de dados específicos de cada banco).

---

## 🛠️ Instalação: PostgreSQL + DBeaver

Para usar a apostila você precisa de duas ferramentas:

1. **PostgreSQL** — o banco de dados
2. **DBeaver** — a interface visual para escrever e rodar SQL

Siga o guia abaixo para o seu sistema operacional.
Vídeos referência de como instalar: 
https://www.youtube.com/watch?v=0BOjD6H9Uos
https://www.youtube.com/watch?v=a78hxM4-99A&t=48s

Documento com tutorial de como instalar: 
https://docs.google.com/document/d/1JjOAYXbp74fo_RC6Rql5VcxmCt4Lyzn5/edit?usp=sharing&ouid=105841654205434278000&rtpof=true&sd=true
---

### 🍎 Instalação no macOS

#### Passo 1 — Instalar o PostgreSQL

A forma mais simples no Mac é usando o **Postgres.app**, um aplicativo nativo que não requer configurações extras.

1. Acesse [postgresapp.com](https://postgresapp.com)
2. Clique em **Download** e baixe a versão mais recente
3. Abra o arquivo `.dmg` baixado
4. Arraste o ícone do **Postgres** para a pasta **Applications**
5. Abra o **Postgres.app** pela pasta Applications ou pelo Spotlight (`Cmd + Espaço` → "Postgres")
6. Clique em **Initialize** para criar o banco de dados local
7. Clique em **Start** — os elefantes verdes indicam que o banco está rodando ✅

> 💡 **Informações padrão:**
> - Usuário: seu nome de usuário do macOS
> - Senha: nenhuma (deixe em branco)
> - Porta: `5432`
> - Host: `localhost`

---

#### Passo 2 — Instalar o DBeaver no macOS

1. Acesse [dbeaver.io/download](https://dbeaver.io/download/)
2. Baixe a versão **Community Edition** para macOS (`.dmg`)
3. Abra o arquivo `.dmg` e arraste o DBeaver para a pasta **Applications**
4. Abra o **DBeaver**
   - Se aparecer um aviso de segurança, vá em **Preferências do Sistema → Segurança e Privacidade** e clique em **Abrir mesmo assim**

---

#### Passo 3 — Conectar o DBeaver ao PostgreSQL (macOS)

1. Abra o DBeaver
2. Clique no ícone de **tomada com um "+"** (New Database Connection) no canto superior esquerdo
3. Na lista, escolha **PostgreSQL** e clique em **Next**
4. Preencha os campos:
   - **Host:** `localhost`
   - **Port:** `5432`
   - **Database:** `postgres`
   - **Username:** seu nome de usuário do macOS (ex: `joao`)
   - **Password:** deixe em branco
5. Clique em **Test Connection**
   - Na primeira vez, o DBeaver pode pedir para baixar o driver do PostgreSQL — clique em **Download** e aguarde
6. Se aparecer **"Connected"**, clique em **Finish** 🎉

---

### 🪟 Instalação no Windows

#### Passo 1 — Instalar o PostgreSQL

1. Acesse [postgresql.org/download/windows](https://www.postgresql.org/download/windows/)
2. Clique em **Download the installer** (link do EDB)
3. Baixe a versão mais recente para Windows (64-bit)
4. Execute o instalador (`.exe`) como **Administrador**
5. Durante a instalação, siga os passos:
   - **Installation Directory:** deixe o padrão e clique em Next
   - **Select Components:** mantenha tudo selecionado (PostgreSQL Server, pgAdmin, Stack Builder, Command Line Tools) e clique em Next
   - **Data Directory:** deixe o padrão e clique em Next
   - **Password:** defina uma senha para o usuário `postgres` — **anote essa senha, você vai precisar dela!** 🔑
   - **Port:** mantenha `5432` e clique em Next
   - **Locale:** deixe o padrão e clique em Next
6. Clique em **Next** até iniciar a instalação e aguarde
7. Na tela final, **desmarque** a opção "Launch Stack Builder" e clique em **Finish**

> ⚠️ **Importante:** Se esquecer a senha definida aqui, será necessário reinstalar o PostgreSQL. Guarde-a em local seguro.

---

#### Passo 2 — Instalar o DBeaver no Windows

1. Acesse [dbeaver.io/download](https://dbeaver.io/download/)
2. Baixe a versão **Community Edition** para Windows (`.exe`)
3. Execute o instalador e siga o assistente:
   - Aceite os termos de licença
   - Escolha **Install for all users** (recomendado) ou apenas para você
   - Deixe o diretório de instalação padrão
   - Clique em **Install** e aguarde
4. Ao final, clique em **Finish** — o DBeaver abrirá automaticamente

---

#### Passo 3 — Conectar o DBeaver ao PostgreSQL (Windows)

1. Abra o DBeaver
2. Clique no ícone de **tomada com um "+"** (New Database Connection) no canto superior esquerdo
3. Na lista, escolha **PostgreSQL** e clique em **Next**
4. Preencha os campos:
   - **Host:** `localhost`
   - **Port:** `5432`
   - **Database:** `postgres`
   - **Username:** `postgres`
   - **Password:** a senha que você definiu durante a instalação do PostgreSQL
5. Clique em **Test Connection**
   - Na primeira vez, o DBeaver pode pedir para baixar o driver do PostgreSQL — clique em **Download** e aguarde
6. Se aparecer **"Connected"**, clique em **Finish** 🎉

---

## 📖 Como usar a apostila

1. Abra o **DBeaver** e certifique-se de que a conexão com o PostgreSQL está ativa
2. Vá em **File → Open File** e abra o arquivo `apostila_sql.sql`  
   *(ou copie o conteúdo e cole em um novo script SQL no DBeaver)*
3. Execute **um bloco por vez**, seguindo a ordem da apostila
4. Leia os comentários antes de rodar cada query

> 💡 **Dica:** Para executar apenas um trecho, selecione o código desejado e pressione `Ctrl + Enter` (Windows) ou `Cmd + Enter` (Mac).

---

## 📚 Como estudar corretamente

- Leia os comentários em voz alta — isso ajuda a fixar a lógica
- Não execute tudo de uma vez; vá devagar, bloco por bloco
- Quando encontrar um erro, tente entendê-lo **antes** de corrigir
- Use os exercícios de "ache o erro" como treino real de debugging
- Não decore: **entenda a leitura da query**

---

## 🎯 Objetivo final

Ao terminar esta apostila, você será capaz de:

- Escrever queries SQL simples com confiança
- Entender e corrigir erros de sintaxe
- Usar SQL em ferramentas como Power BI, dbt, Looker ou Snowflake
- Avançar para conceitos como `GROUP BY`, `CASE WHEN` e SQL analítico

---

## 🚀 Próximos passos sugeridos

- **Módulo 1:** `GROUP BY`, `COUNT`, `SUM`
- **Módulo 2:** `LEFT JOIN` vs `INNER JOIN`
- **Módulo 3:** SQL para entrevistas técnicas
- **Módulo 4:** SQL aplicado a Data Quality

---

## 🤝 Contribuições

Sugestões, correções e melhorias são bem-vindas!  
Abra uma **Issue** ou envie um **Pull Request**.

---

## 👩‍🏫 Autora

Criado por alguém que acredita que **SQL se aprende entendendo a linguagem, não decorando funções**.
