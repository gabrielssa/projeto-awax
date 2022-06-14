### Questão 1

Mesmo usando inglês e colocando o texto em português, em alguns casos, o texto é reduzido. Provavelmente devido a similaridade dos idiomas.

### Questão 2

select title from best_films where to_tsvector('english',description) @@ to_tsquery('english', 'family & drama');

    ### Obtive 2 rows, belfest e coda.

### Questão 3

select title from best_films where to_tsvector('english',description) @@ to_tsquery('english', 'family <-> drama');

    ### Objetive 1 row, CODA

### Questão 4

O resultado é TRUE porque usando este operador &, estamos apenas selecionando um texto que possua estas palavras, não estamos especificando se estas palavras estão perto ou não uma das outras.


### Questão 5

select title from best_films where to_tsvector('english', description) @@ to_tsquery('english', 'fame<->about<->fortunes');

Retornou 1 row, mas este row não tem essas três palavras juntas. 

### Questão 6

### 6.1

select title from best_films where to_tsvector('english', description) @@ to_tsquery('english', 'fame<1>about<1>fortunes');

### 6.2

select title from best_films where to_tsvector('english', description) @@ to_tsquery('english', 'an<1>educational<1>future');

### Questão 7

SELECT phraseto_tsquery('english', 'an educational future');

neste caso, o artigo é removido e o vetor gerado é um 'educ' <-> 'futur'

### Questão 8


### 8.1
ALTER TABLE best_films ADD COLUMN description_ts TSVECTOR;

UPDATE best_films SET description_ts = to_tsvector('english', description);

UPDATE  best_films SET search_field = (to_tsvector('english', title) || to_tsvector('english', description));

### 8.2

CREATE INDEX best_films_search2_idx
ON best_films 
USING GIN (description_ts);

### 8.3

 SELECT title FROM best_films 
 WHERE description_ts @@ to_tsquery('english', 'family & drama')
 ORDER BY ts_rank(description_ts, to_tsquery('english', 'family & drama')) DESC;

 (retornou 2 rows)

 ### Questão 9

SELECT title, ts_rank(search_field, to_tsquery('english', 'family & drama')) AS rank_value 
FROM best_films 

"
 title        | rank_value 
--------------------+------------
 Belfast            |      1e-16
 CODA               |  0.0991041
 Being the Ricardos |      1e-20
 Don't Look Up      |      1e-20
 Drive My Car       |      1e-20
 Dune               |      1e-20
(6 rows)"





