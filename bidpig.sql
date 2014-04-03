CREATE TYPE SEXO AS ENUM('Masculino', 'Feminino', 'Privado');

CREATE TYPE PAIS AS ENUM('Portugal', 'China', 'Espanha');

CREATE TYPE CATMSG AS ENUM('SIS', 'AUTO', 'BID', 'REPLY');

CREATE TYPE ESTADOLEILAO AS ENUM ('A decorrer', 'Em aprovação', 'Terminado', 'Interrompido');

CREATE TYPE ESTADOITEM AS ENUM('Em Leilão', 'Livre', 'Vendido');

CREATE TABLE Feedback (
	id SERIAL INTEGER PRIMARY KEY,
	
	UNIQUE(id)
);

CREATE TABLE Registado (
	id INTEGER PRIMARY KEY,
	username VARCHAR (13) NOT NULL,
	password VARCHAR (30) NOT NULL,
	email VARCHAR (355) NOT NULL,
	age INTEGER NOT NULL,
	pais PAIS NOT NULL,
	sexo SEXO NOT NULL,
	dataRegisto TIMESTAMP NOT NULL,
	dataUltimoLogin TIMESTAMP,
	
	UNIQUE(id,username,email),
	FOREIGN KEY(id)     REFERENCES Feedback(id)
);

CREATE TABLE Notificacao (
	id INTEGER PRIMARY KEY,
	conteudo VARCHAR (1000) NOT NULL,
	dataEnvio TIMESTAMP NOT NULL,
	dataRecepcao TIMESTAMP,
	marcada BOOLEAN NOT NULL,
	titulo VARCHAR(100) NOT NULL,
	vista BOOLEAN NOT NULL,
	destinatario INTEGER NOT NULL,

	UNIQUE(id),
	FOREIGN KEY(destinatario)     REFERENCES Registado(id)
);

CREATE TABLE Mensagem (
	id INTEGER PRIMARY KEY,
	remetente INTEGER NOT NULL,
	
	FOREIGN KEY(id)     REFERENCES Notificacao(id),
	FOREIGN KEY(remetente)     REFERENCES Registado(id)
);

CREATE TABLE Automatica (
	id INTEGER PRIMARY KEY,
	categoria CATMSG NOT NULL,
	
	UNIQUE(id),
	FOREIGN KEY(id)     REFERENCES Notificacao(id)
);

CREATE TABLE Noticia (
	id INTEGER PRIMARY KEY,
	autor INTEGER NOT NULL,
	titulo VARCHAR(100) NOT NULL,
	conteudo VARCHAR (1000) NOT NULL,
	
	UNIQUE(id),
	FOREIGN KEY(autor)     REFERENCES Registado(id)
);

CREATE TABLE Estado (
	id INTEGER PRIMARY KEY,
	nome ESTADOLEILAO NOT NULL,
	
	UNIQUE(id)
);

CREATE TABLE Leilao (
	id INTEGER PRIMARY KEY,
	autor INTEGER NOT NULL,
	titulo VARCHAR(100) NOT NULL,
	dataInicio TIMESTAMP NOT NULL,
	dataFim TIMESTAMP NOT NULL,
	dataSubmissao TIMESTAMP NOT NULL,
	valorMinimo INTEGER NOT NULL,
	conteudo VARCHAR (1000) NOT NULL,
	estado INTEGER NOT NULL,
	
	UNIQUE(id),
	FOREIGN KEY(id)     REFERENCES Feedback(id),
	FOREIGN KEY(estado)     REFERENCES Estado(id),
	FOREIGN KEY(autor)     REFERENCES Registado(id)
);

CREATE TABLE Comentario (
	id INTEGER PRIMARY KEY,
	data TIMESTAMP NOT NULL,
	conteudo VARCHAR (500) NOT NULL,
	idFeedback INTEGER NOT NULL
	
	UNIQUE(id),
	FOREIGN KEY(idFeedback)     REFERENCES Feedback(id)
);

CREATE TABLE CategoriaItem (
	id INTEGER PRIMARY KEY,
	ativa BOOLEAN NOT NULL,
	nome VARCHAR (15) NOT NULL,
	
	UNIQUE(id,nome)
);

CREATE TABLE Item (
	id INTEGER PRIMARY KEY,
	condicao VARCHAR (20) NOT NULL,
	dataAquisicao TIMESTAMP NOT NULL,
	descricao VARCHAR (700) NOT NULL,
	estado ESTADOITEM NOT NULL,
	nome VARCHAR (20) NOT NULL,
	numFotografias INTEGER NOT NULL,
	idCategoria INTEGER NOT NULL
	
	UNIQUE(id,nome),
	FOREIGN KEY(id)     REFERENCES Feedback(id),
	FOREIGN KEY(idCategoria)     REFERENCES CategoriaItem(id)
);

CREATE TABLE FavoritoLeilao (
	idLeilao INTEGER,
	idRegistado INTEGER,
	
	PRIMARY KEY(idLeilao,idRegistado),
	FOREIGN KEY(idLeilao)     REFERENCES Leilao(id),
	FOREIGN KEY(idRegistado)     REFERENCES Registado(id)
);

CREATE TABLE FavoritoItem (
	idItem INTEGER,
	idRegistado INTEGER,
	
	PRIMARY KEY(idItem,idRegistado),
	FOREIGN KEY(idItem)     REFERENCES Item(id),
	FOREIGN KEY(idRegistado)     REFERENCES Registado(id)
);

CREATE TABLE Fotografia (
	id INTEGER PRIMARY KEY,
	codigo INTEGER NOT NULL,
	
	UNIQUE(id,codigo)
);

CREATE TABLE FotografiaItem (
	idItem INTEGER NOT NULL,
	idFotografia INTEGER NOT NULL,
	
	PRIMARY KEY(idItem,idFotografia),
	FOREIGN KEY(idItem)     REFERENCES Item(id),
	FOREIGN KEY(idFotografia)     REFERENCES Fotografia(id),
);

CREATE TABLE FotografiaRegistado (
	idRegistado INTEGER NOT NULL,
	idFotografia INTEGER NOT NULL,
	
	PRIMARY KEY(idRegistado,idFotografia),
	FOREIGN KEY(idRegistado)     REFERENCES Registado(id),
	FOREIGN KEY(idFotografia)     REFERENCES Fotografia(id),
);

CREATE TABLE Avaliacao (
	idRegistado INTEGER NOT NULL,
	idFeedback INTEGER NOT NULL,
	
	PRIMARY KEY(idRegistado,idFeedback),
	FOREIGN KEY(idRegistado)     REFERENCES Registado(id),
	FOREIGN KEY(idFeedback)     REFERENCES Feedback(id),
);

CREATE TABLE PropAnt (
	idItem INTEGER NOT NULL,
	idRegistado INTEGER NOT NULL,
	dataInicioPropriedade TIMESTAMP NOT NULL,
	dataFimPropriedade TIMESTAMP NOT NULL,
	
	PRIMARY KEY(idItem,idRegistado),
	FOREIGN KEY(idItem)     REFERENCES Item(id),
	FOREIGN KEY(idRegistado)     REFERENCES Registado(id)
);

CREATE TABLE LeiAnt (
	idItem INTEGER NOT NULL,
	idLeilao INTEGER NOT NULL,
	
	PRIMARY KEY(idItem,idLeilao),
	FOREIGN KEY(idItem)     REFERENCES Item(id),
	FOREIGN KEY(idLeilao)     REFERENCES Leilao(id)
);

CREATE TABLE ItemLei (
	idItem INTEGER NOT NULL,
	idLeilao INTEGER NOT NULL,
	
	PRIMARY KEY(idItem,idLeilao),
	FOREIGN KEY(idItem)     REFERENCES Item(id),
	FOREIGN KEY(idLeilao)     REFERENCES Leilao(id)
);