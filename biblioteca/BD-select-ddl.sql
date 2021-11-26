1.
SELECT isbn, nome_titulo, editora, tipo_titulo
FROM tab_titulos
ORDER BY tipo_titulo, nome_titulo;

2.
SELECT tipo_titulo, nome_titulo, editora
FROM tab_titulos 
WHERE periodicidade = 'quinzenal'
ORDER BY tipo_titulo, nome_titulo;

3.
SELECT nome, usuario, count(*) "Qtd de empréstimos feitos:" FROM tab_emprestimos JOIN tab_usuarios ON usuario = codigo
GROUP BY nome, usuario HAVING count(*) > 20 ORDER BY "Qtd de empréstimos feitos:" DESC,nome ASC;

4.
SELECT u.nome, tab_atendentes.unidade_atendimento, emp.numero_emprestimo, T.atendente, T.data_transacao, tab_itens_emprestimos.numero_item, tab_itens_emprestimos.multa_dano_devolucao
FROM tab_usuarios u join tab_usuarios_alunos al on al.codigo_usuario = u.codigo
join tab_emprestimos emp on u.codigo = emp.usuario
join tab_transacoes T on T.numero_transacao = emp.numero_emprestimo
join tab_atendentes on tab_atendentes.matricula = T.atendente
join tab_devolucoes on tab_devolucoes.usuario = u.codigo
join tab_itens_emprestimos on tab_itens_emprestimos.numero_devolucao = tab_devolucoes.numero_devolucao;

5.
SELECT a.codigo_usuario, t.telefone
FROM tab_alunos_cursos a
JOIN tab_telefones_usuarios t ON a.codigo_usuario = t.codigo_usuario 
JOIN tab_cursos c ON codigo_curso = codigo
WHERE NOT EXISTS (SELECT e.usuario FROM tab_emprestimos e WHERE e.usuario = a.codigo_usuario)
AND c.nome = 'Ciência da Computação';

6.


7.
SELECT tab_unidades_atendimento.codigo
FROM tab_unidades_atendimento join tab_copias_titulos on tab_unidades_atendimento.codigo = tab_copias_titulos.unidade_atendimento
join tab_titulos on tab_copias_titulos.isbn_copia = tab_titulos.isbn
join tab_autores_titulos_livros on tab_autores_titulos_livros.isbn = tab_titulos.isbn
where tab_autores_titulos_livros.autor like 'Craig Larman' 
ORDER BY tab_unidades_atendimento.codigo, tab_titulos.nome_titulo, tab_copias_titulos.numero_copia;

8.
SELECT uni.nome, numero_copia
FROM tab_unidades_atendimento uni join tab_copias_titulos on uni.codigo = tab_copias_titulos.unidade_atendimento
WHERE tab_copias_titulos.numero_copia NOT IN (SELECT numero_item
                                  FROM tab_itens_emprestimos it
                                  WHERE tab_copias_titulos.numero_copia =  it.numero_copia)
ORDER BY uni.nome, numero_copia;



