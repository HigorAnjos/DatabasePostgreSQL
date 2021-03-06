CREATE TABLE Tab_Bibliotecarias
       (matricula NUMERIC(5) NOT NULL PRIMARY KEY, 
        nome VARCHAR(50) NOT NULL);
             
CREATE TABLE Tab_Unidades_Atendimento
	(codigo  NUMERIC(3) NOT NULL PRIMARY KEY, 
         nome VARCHAR(50) NOT NULL UNIQUE,
	 endereco VARCHAR(200) NOT NULL, 
   	 telefone NUMERIC(10) NOT NULL, 
         bibliotecaria_responsavel NUMERIC(5) NOT NULL UNIQUE,
         FOREIGN KEY (bibliotecaria_responsavel) REFERENCES Tab_Bibliotecarias(matricula));

CREATE TABLE Tab_Atendentes
       (matricula NUMERIC(5) NOT NULL PRIMARY KEY, 
        nome VARCHAR(50) NOT NULL, 
        unidade_atendimento NUMERIC(3) NOT NULL, 
        FOREIGN KEY (unidade_atendimento) REFERENCES Tab_Unidades_Atendimento (codigo));

CREATE TABLE Tab_Unidades_Academicas
       (codigo char(4) NOT NULL PRIMARY KEY, 
        nome VARCHAR(5) NOT NULL UNIQUE);

CREATE TABLE Tab_Cursos
       (codigo NUMERIC(3) NOT NULL PRIMARY KEY, 
        nome VARCHAR (50) NOT NULL UNIQUE,
	unidade_academica char(4) NOT NULL,
	FOREIGN KEY (unidade_academica) REFERENCES Tab_Unidades_Academicas(codigo));

CREATE TABLE Tab_Disciplinas
	(codigo char(7) NOT NULL PRIMARY KEY, 
         nome VARCHAR (50) NOT NULL);

CREATE TABLE Tab_Titulos
       (isbn NUMERIC(5) NOT NULL PRIMARY KEY, 
       nome_titulo VARCHAR (100) NOT NULL, 
       area_principal VARCHAR(100) NOT NULL, 
       assunto VARCHAR(100) NOT NULL, 
       editora VARCHAR(50) NOT NULL, 
       idioma char(1) NOT NULL CHECK (idioma in ('P','I','E')),
       prazo_emprestimo NUMERIC(2) NOT NULL,
       numero_max_renovacoes NUMERIC(2) NOT NULL,			
       tipo_titulo char(1) NOT NULL CHECK (tipo_titulo in ('L', 'P')),
       edicao NUMERIC(2) NULL,
       periodicidade char(15) NULL, 
       tipo_periodico char(1) NULL,
       CHECK (periodicidade in ('semanal', 'quinzenal', 'mensal', 'trimestral', 'quadrimestral', 'semestral', 'anual')), 
       CHECK (tipo_periodico in ('j', 'r','b')),
       CHECK ( (tipo_titulo = 'L' and edicao is NOT NULL and periodicidade is NULL and tipo_periodico is NULL) OR
               (tipo_titulo = 'P' and edicao is NULL and periodicidade is NOT NULL and tipo_periodico is NOT NULL)));

CREATE TABLE Tab_Titulos_Areas_Secundarias
       (isbn NUMERIC(5) NOT NULL, 
        area_secundaria VARCHAR(100) NOT NULL,
        PRIMARY KEY (isbn,area_secundaria),
        FOREIGN KEY (isbn) REFERENCES Tab_Titulos (isbn));

CREATE TABLE Tab_Autores_Titulos_Livros
       (isbn NUMERIC(5) NOT NULL, 
        autor VARCHAR(50) NOT NULL,
	PRIMARY KEY (isbn, autor),
        FOREIGN KEY (isbn) REFERENCES Tab_Titulos (isbn));

CREATE TABLE Tab_Usuarios
       (codigo NUMERIC(5) NOT NULL PRIMARY KEY, 
       nome VARCHAR (50) NOT NULL, 
       identidade char(12) NULL UNIQUE, 
       cpf char(14) NULL UNIQUE, 
       endereco VARCHAR(100) NOT NULL, 
       sexo char(1) NOT NULL, 
       data_nasc date NOT NULL, 
       estado_civil char(1) NOT NULL,
       CHECK (cpf is not null or identidade is not null),
       CHECK (sexo in ('m', 'f')), CHECK (estado_civil in ('c','s','d','v')));

CREATE TABLE Tab_Usuarios_Professores
       (codigo_usuario NUMERIC(5) NOT NULL PRIMARY KEY, 
        matricula NUMERIC(5) NOT NULL UNIQUE,
        unidade_academica char(4) NULL,
        FOREIGN KEY (codigo_usuario) REFERENCES Tab_Usuarios (codigo),
        FOREIGN KEY (unidade_academica) REFERENCES Tab_Unidades_Academicas(codigo));

CREATE TABLE Tab_Usuarios_Alunos
       (codigo_usuario NUMERIC(5) NOT NULL PRIMARY KEY,
        FOREIGN KEY (codigo_usuario) REFERENCES Tab_Usuarios (codigo));

CREATE TABLE Tab_Telefones_Usuarios
	(codigo_usuario  NUMERIC(5) NOT NULL, 
        telefone NUMERIC(10) NOT NULL,
        PRIMARY KEY(codigo_usuario, telefone),
        FOREIGN KEY(codigo_usuario) REFERENCES Tab_Usuarios (codigo));

CREATE TABLE Tab_Alunos_Cursos
       (codigo_usuario NUMERIC(5) NOT NULL, 
        codigo_curso NUMERIC(3) NOT NULL,
        matricula NUMERIC(5) NOT NULL UNIQUE,
        PRIMARY KEY (codigo_usuario, codigo_curso), 
        FOREIGN KEY (codigo_usuario) REFERENCES Tab_Usuarios_Alunos (codigo_usuario), 
        FOREIGN KEY (codigo_curso) REFERENCES Tab_Cursos (codigo));

CREATE TABLE Tab_Copias_Titulos
	(isbn_copia NUMERIC(5) NOT NULL, 
        numero_copia NUMERIC (5) NOT NULL, 
        unidade_atendimento NUMERIC(3) NOT NULL, 
	secao NUMERIC (4) NOT NULL, 
        estante NUMERIC(3) NOT NULL, 
        PRIMARY KEY (isbn_copia, numero_copia), 
	FOREIGN KEY (isbn_copia) REFERENCES Tab_Titulos (isbn), 
	FOREIGN KEY (unidade_atendimento) REFERENCES Tab_Unidades_Atendimento (codigo) );

CREATE TABLE Tab_Transacoes	
       (numero_transacao NUMERIC(9) NOT NULL PRIMARY KEY, 
        data_transacao date NOT NULL, 
	hora_transacao time NOT NULL, 
        atendente NUMERIC(5) NOT NULL, 
	FOREIGN KEY (atendente) REFERENCES Tab_Atendentes (matricula)); 

CREATE TABLE Tab_Emprestimos
	(numero_emprestimo NUMERIC(9) NOT NULL PRIMARY KEY, 
	 usuario NUMERIC (5) NOT NULL,
	FOREIGN KEY (numero_emprestimo) REFERENCES Tab_Transacoes (numero_transacao),
	FOREIGN KEY (usuario) REFERENCES Tab_Usuarios (codigo));

CREATE TABLE Tab_Devolucoes
	(numero_devolucao NUMERIC(9) NOT NULL PRIMARY KEY,
	 usuario NUMERIC (5) NOT NULL, 
	FOREIGN KEY (numero_devolucao) REFERENCES Tab_Transacoes (numero_transacao),
	FOREIGN KEY (usuario) REFERENCES Tab_Usuarios (codigo));

CREATE TABLE Tab_Reservas
	(numero_reserva NUMERIC(9) NOT NULL PRIMARY KEY,
 	 usuario NUMERIC (5) NOT NULL, 
	FOREIGN KEY (numero_reserva) REFERENCES Tab_Transacoes (numero_transacao),
	FOREIGN KEY (usuario) REFERENCES Tab_Usuarios (codigo));

CREATE TABLE Tab_Renovacoes
	(numero_renovacao NUMERIC(9) NOT NULL PRIMARY KEY,
  	 usuario NUMERIC (5) NOT NULL,
	FOREIGN KEY (numero_renovacao) REFERENCES Tab_Transacoes (numero_transacao),
	FOREIGN KEY (usuario) REFERENCES Tab_Usuarios_Professores (codigo_usuario));

CREATE TABLE Tab_Itens_Emprestimos
	(numero_emprestimo NUMERIC(9) NOT NULL, 
        numero_item NUMERIC(1) NOT NULL, 
	data_limite_devolucao date NOT NULL, 
        isbn_copia NUMERIC(5) NOT NULL, 
	numero_copia NUMERIC (5) NOT NULL,
	numero_devolucao NUMERIC(9) NULL,
	situacao_devolucao char(1) NULL,  
	multa_atraso_devolucao NUMERIC (7,2) NULL, 
        multa_dano_devolucao NUMERIC (7,2) NULL,
	CHECK (numero_item in (1, 2, 3)),
	CHECK (situacao_devolucao is null or situacao_devolucao in ('I', 'D')),
	CHECK ((numero_devolucao is NULL and situacao_devolucao is NULL and multa_atraso_devolucao is NULL and multa_dano_devolucao is NULL) or 
               (numero_devolucao is NOT NULL and situacao_devolucao is NOT NULL)), 
	PRIMARY KEY (numero_emprestimo, numero_item), 
	FOREIGN KEY (numero_emprestimo) REFERENCES Tab_Emprestimos (numero_emprestimo), 
	FOREIGN KEY (isbn_copia, numero_copia) REFERENCES Tab_Copias_Titulos (isbn_copia,numero_copia),
	FOREIGN KEY (numero_devolucao) REFERENCES Tab_Devolucoes (numero_devolucao));

CREATE TABLE Tab_Renovacoes_Itens_Emprestimos
	(numero_renovacao NUMERIC(9) NOT NULL,
	numero_emprestimo NUMERIC(9) NOT NULL, 
        numero_item_emprestimo NUMERIC(5) NOT NULL, 
	data_devolucao_renov date NOT NULL,
	PRIMARY KEY (numero_renovacao, numero_emprestimo, numero_item_emprestimo), 
	FOREIGN KEY (numero_renovacao) REFERENCES Tab_Renovacoes (numero_renovacao),
	FOREIGN KEY (numero_emprestimo, numero_item_emprestimo) REFERENCES 
		Tab_Itens_Emprestimos (numero_emprestimo, numero_item));

CREATE TABLE Tab_Reservas_Copias
	(numero_reserva NUMERIC(9) NOT NULL,
	isbn_copia NUMERIC(5) NOT NULL, 
        numero_copia NUMERIC(5) NOT NULL, 
	data_reserva date NOT NULL,
	PRIMARY KEY (numero_reserva, isbn_copia, numero_copia), 
	FOREIGN KEY (numero_reserva) REFERENCES Tab_Reservas (numero_reserva),
	FOREIGN KEY (isbn_copia, numero_copia) REFERENCES 
		Tab_Copias_Titulos (isbn_copia, numero_copia));

CREATE TABLE Tab_Professores_Disciplinas
	(professor NUMERIC(5) NOT NULL, 
         disciplina char(7) NOT NULL, 
	PRIMARY KEY (professor,disciplina), FOREIGN KEY (professor) REFERENCES Tab_Usuarios_Professores (codigo_usuario), 
	FOREIGN KEY (disciplina) REFERENCES Tab_Disciplinas (codigo));