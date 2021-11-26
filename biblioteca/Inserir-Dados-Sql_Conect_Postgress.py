# HIGOR CAVALCANTE DOS ANJOS
#
# CREATE TABLE tab_produtos (
# codigo NUMERIC(10) PRIMARY KEY,
# preco NUMERIC(10,5),
# descricao VARCHAR (30)
# );

DB_HOST = "localhost"
DB_NAME = "postgres"
DB_USER = "postgres"
DB_PASS = "0000"

import psycopg2

conn = psycopg2.connect(dbname=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST)
cur = conn.cursor()
op = 1

while (op != 0):
    codigo = float(input("Digite o Codigo: "))
    preco = float(input("Valor unitario: "))
    descricao = input("Descricao do produto: ")
    cur.execute("INSERT INTO tab_produtos (codigo, preco, descricao) VALUES (%s, %s, %s)", (codigo, preco, descricao))
    conn.commit()

    op = int(input("0 - Sair, 1 - Cadastar produto "))

conn.close()

