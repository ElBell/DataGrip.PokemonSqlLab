# What is each pokemon's primary type?

SELECT pokemons.name,
       types.name
FROM
  pokemons
    INNER JOIN
  types ON primary_type = types.id;

 # What is Rufflet's secondary type?

SELECT pokemons.name,
       types.name
FROM
  pokemons
    INNER JOIN
  types ON secondary_type = types.id
WHERE pokemons.name = 'Rufflet';

# What are the names of the pokemon that belong to the trainer with trainerID 303?

SELECT pokemons.name,
       pokemon_trainer.trainerID
FROM
  pokemon_trainer
    INNER JOIN
  pokemons ON pokemon_trainer.pokemon_id = pokemons.id
WHERE trainerID = 303;

# How many pokemon have a secondary type Poison

SELECT COUNT(*) AS Poison_types
FROM
  pokemons
    INNER JOIN
  types ON types.id = pokemons.primary_type
WHERE types.name = 'Poison';

# What are all the primary types and how many pokemon have that type?

SELECT types.name AS type,
       COUNT(types.name) AS count
FROM
  types
    INNER JOIN
  pokemons ON pokemons.primary_type = types.id
GROUP BY types.name;

# How many pokemon at level 100 does each trainer with at least one level 100 pokemone have?

SELECT COUNT(*) AS Level_100s
FROM
  pokemon_trainer
WHERE pokelevel = 100
GROUP BY trainerID;

# How many pokemon only belong to one trainer and no other?

SELECT COUNT(*) AS 'total_count'
FROM (
       SELECT
         COUNT(*) AS 'pokemon_count'
       FROM
         pokemon_trainer
       GROUP BY pokemon_id
       HAVING COUNT(pokemon_id) = 1
     ) OnwnerCountTable;
